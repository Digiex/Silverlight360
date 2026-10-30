<#
.SYNOPSIS
Runs a built app in xenia, presses controller buttons, takes screenshots.

.DESCRIPTION
Starts xenia with the package's default.xex and its keyboard input driver,
then at given times presses buttons (sent as key messages to the xenia
window only, so nothing reaches other windows), saves screenshots of the
window and stops xenia. The log is kept, so a script can check for crashes
or missing exports afterwards.

Buttons and the keys xenia's keyboard driver maps them to:
  A numpad 5   B numpad 0   (rebound here: the defaults ; and ' depend on
                            the keyboard layout)
  X L   Y P   Start X   Back Z
  DPadUp/Down/Left/Right  numpad 8/2/4/6 (rebound here; xenia's default is
                          Shift+WASD, and Shift can't be sent to one window)
  LeftStickUp/Down/Left/Right  W S A D
  LeftShoulder 1  RightShoulder 3  LeftTrigger Q  RightTrigger E

.EXAMPLE
.\Test-XboxApp.ps1 -Xex ..\samples\ui\FocusNavigation\bin\Release\xbox\default.xex `
    -Steps '8:shot','9:DPadRight','10:DPadDown','11:A','12:shot' -Seconds 15 -Output $env:TEMP\focus
#>
param(
    [Parameter(Mandatory)] [string]$Xex,
    [Parameter(Mandatory)] [string]$Output,
    # "<second>:<button>" presses a button, "<second>:shot" saves a screenshot.
    [string[]]$Steps = @('20:shot'),
    [int]$Seconds = 30,
    # xenia_edge.exe: this, else the XENIA_EDGE environment variable, else PATH.
    [string]$Xenia = $env:XENIA_EDGE,
    [string[]]$ExtraArgs = @()
)

$ErrorActionPreference = 'Stop'
if (-not $Xenia) {
    $found = Get-Command xenia_edge.exe -ErrorAction SilentlyContinue
    if (-not $found) {
        throw 'xenia_edge.exe not found. Pass -Xenia, set XENIA_EDGE to its path or put it on PATH.'
    }
    $Xenia = $found.Source
}
Add-Type -AssemblyName System.Drawing
if (-not ('XboxSdk.Win' -as [type])) {
    Add-Type @"
using System;
using System.Runtime.InteropServices;
namespace XboxSdk {
public static class Win {
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left, Top, Right, Bottom; }
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr hdc, uint flags);
  [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr h, uint msg, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern uint MapVirtualKey(uint code, uint type);
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr parent, EnumProc f, IntPtr l);
  // Posts a key press to the window and its children; xenia reads keys from
  // whichever one has its input handler.
  public static void Press(IntPtr top, uint vk) {
    uint scan = MapVirtualKey(vk, 0);
    IntPtr down = (IntPtr)(1 | (scan << 16));
    IntPtr up = (IntPtr)(1 | (scan << 16) | (1u << 30) | (1u << 31));
    PostMessage(top, 0x100, (IntPtr)vk, down);
    EnumChildWindows(top, delegate(IntPtr h, IntPtr l) { PostMessage(h, 0x100, (IntPtr)vk, down); return true; }, IntPtr.Zero);
    System.Threading.Thread.Sleep(120);
    PostMessage(top, 0x101, (IntPtr)vk, up);
    EnumChildWindows(top, delegate(IntPtr h, IntPtr l) { PostMessage(h, 0x101, (IntPtr)vk, up); return true; }, IntPtr.Zero);
  }
}
}
"@
}

$keys = @{
    A = 0x65; B = 0x60; X = [int][char]'L'; Y = [int][char]'P'; Start = [int][char]'X'; Back = [int][char]'Z'
    DPadUp = 0x68; DPadDown = 0x62; DPadLeft = 0x64; DPadRight = 0x66
    LeftStickUp = [int][char]'W'; LeftStickDown = [int][char]'S'; LeftStickLeft = [int][char]'A'; LeftStickRight = [int][char]'D'
    LeftShoulder = [int][char]'1'; RightShoulder = [int][char]'3'; LeftTrigger = [int][char]'Q'; RightTrigger = [int][char]'E'
}

New-Item -ItemType Directory -Force -Path $Output | Out-Null
$log = Join-Path $Output 'xenia.log'
$xexPath = (Resolve-Path -LiteralPath $Xex).Path
$dpad = @('--keybind_dpad_up=0x68', '--keybind_dpad_down=0x62', '--keybind_dpad_left=0x64', '--keybind_dpad_right=0x66',
          '--keybind_a=0x65', '--keybind_b=0x60')
$arguments = @("--log_file=`"$log`"", '--log_level=2', '--flush_log=true', '--hid=keyboard') + $dpad + $ExtraArgs + @("`"$xexPath`"")
$process = Start-Process -FilePath $Xenia -ArgumentList $arguments -PassThru

$plan = foreach ($s in $Steps) {
    $at, $what = $s -split ':', 2
    [pscustomobject]@{ At = [double]$at; What = $what }
}
$started = Get-Date
foreach ($step in ($plan | Sort-Object At)) {
    $wait = $step.At - ((Get-Date) - $started).TotalSeconds
    if ($wait -gt 0) { Start-Sleep -Milliseconds ([int]($wait * 1000)) }
    $process.Refresh()
    $window = $process.MainWindowHandle
    if ($process.HasExited -or $window -eq [IntPtr]::Zero) { Write-Warning "xenia isn't running at $($step.At)s"; break }
    if ($step.What -eq 'shot') {
        $r = New-Object XboxSdk.Win+RECT
        [void][XboxSdk.Win]::GetWindowRect($window, [ref]$r)
        $bmp = New-Object System.Drawing.Bitmap ($r.Right - $r.Left), ($r.Bottom - $r.Top)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $hdc = $g.GetHdc(); [void][XboxSdk.Win]::PrintWindow($window, $hdc, 2); $g.ReleaseHdc($hdc)
        $file = Join-Path $Output ('shot-{0:00.0}s.png' -f $step.At)
        $bmp.Save($file, [System.Drawing.Imaging.ImageFormat]::Png)
        $g.Dispose(); $bmp.Dispose()
        "screenshot $file"
    } elseif ($keys.ContainsKey($step.What)) {
        [XboxSdk.Win]::Press($window, [uint32]$keys[$step.What])
        "pressed $($step.What) at $($step.At)s"
    } else {
        Write-Warning "unknown step $($step.What)"
    }
}
$left = $Seconds - ((Get-Date) - $started).TotalSeconds
if ($left -gt 0) { Start-Sleep -Milliseconds ([int]($left * 1000)) }
if (-not $process.HasExited) { Stop-Process -Id $process.Id -Force }

$text = Get-Content -LiteralPath $log -Raw -ErrorAction SilentlyContinue
$frames = [regex]::Matches($text, 'f:(\d+)') | Select-Object -Last 1
[pscustomobject]@{
    LastFrame = if ($frames) { [int]$frames.Groups[1].Value } else { 0 }
    Crashed = $text -match 'CRASH DUMP'
    MissingExports = @([regex]::Matches($text, 'undefined extern call to \w+ (\w+)') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
    Log = $log
}
