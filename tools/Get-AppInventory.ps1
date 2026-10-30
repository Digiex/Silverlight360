<#
.SYNOPSIS
Lists the platform versions in a folder of extracted Xbox 360 apps.

.DESCRIPTION
Reads every app folder under -Root: the build dates of the native modules
(through xextool), the managed assemblies' versions and the AppManifest
entry point. Writes the table to -OutJson and prints the Silverlight apps.
docs\runtime-inventory.md was made with it.

.EXAMPLE
.\Get-AppInventory.ps1 -Root <folder of extracted apps> -OutJson $env:TEMP\inventory.json
#>
param(
    [Parameter(Mandatory)] [string]$Root,
    [Parameter(Mandatory)] [string]$OutJson,
    # xextool.exe, from PATH when not given.
    [string]$Xextool = 'xextool.exe'
)
$ErrorActionPreference = 'Continue'
if (-not (Get-Command $Xextool -ErrorAction SilentlyContinue)) {
    throw "xextool not found. Pass -Xextool or put xextool.exe on PATH."
}

function Get-XexInfo($path) {
  if (-not (Test-Path -LiteralPath $path)) { return $null }
  $text = & $Xextool -l $path 2>$null | Out-String
  $time = if ($text -match 'Filetime:\s+([0-9A-F]{8})') { [Convert]::ToUInt32($Matches[1], 16) } else { 0 }
  $krnl = if ($text -match 'xboxkrnl\.exe\s+v([0-9.]+)') { $Matches[1] } else { '' }
  [pscustomobject]@{
    Built = if ($time) { [DateTimeOffset]::FromUnixTimeSeconds($time).UtcDateTime.ToString('yyyy-MM-dd') } else { '' }
    Sdk = $krnl
    Size = (Get-Item -LiteralPath $path).Length
  }
}

function Get-AsmVersion($path) {
  if (-not (Test-Path -LiteralPath $path)) { return '' }
  try { return [System.Reflection.AssemblyName]::GetAssemblyName($path).Version.ToString() } catch { return 'native/unknown' }
}

$rows = foreach ($dir in Get-ChildItem -LiteralPath $Root -Directory) {
  $d = $dir.FullName
  $isSilverlight = Test-Path -LiteralPath (Join-Path $d 'agcore.dll')
  $hostXex = Get-XexInfo (Join-Path $d 'default.xex')
  $clr = Get-XexInfo (Join-Path $d 'xcoreclr.dll')
  $ag = Get-XexInfo (Join-Path $d 'agcore.dll')
  $np = Get-XexInfo (Join-Path $d 'npctrl.dll')
  $dlls = Get-ChildItem -LiteralPath $d -Filter *.dll -File | Where-Object { $_.Name -notlike '*.ni.dll' }
  $managed = @{}
  foreach ($f in $dlls) {
    $v = Get-AsmVersion $f.FullName
    if ($v -and $v -ne 'native/unknown') { $managed[$f.BaseName] = $v }
  }
  $manifest = Join-Path $d 'AppManifest.xaml'
  $entry = ''; $runtime = ''
  if (Test-Path -LiteralPath $manifest) {
    $m = Get-Content -LiteralPath $manifest -Raw
    if ($m -match 'EntryPointAssembly="([^"]+)"') { $entry = $Matches[1] }
    if ($m -match 'RuntimeVersion="([^"]+)"') { $runtime = $Matches[1] }
  }
  [pscustomobject]@{
    App = $dir.Name
    Silverlight = $isSilverlight
    HostBuilt = $hostXex.Built; HostSdk = $hostXex.Sdk
    ClrBuilt = $clr.Built; ClrSize = $clr.Size
    AgCoreBuilt = $ag.Built; NpCtrlBuilt = $np.Built
    Runtime = $runtime; Entry = $entry
    Xaps = (Get-ChildItem -LiteralPath $d -Filter *.xap -File | ForEach-Object Name) -join ','
    NativeImages = (Get-ChildItem -LiteralPath $d -Filter *.ni.dll -File).Count
    Libraries = ($managed.GetEnumerator() | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Value)" }) -join ';'
  }
}
$rows | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $OutJson -Encoding utf8
$rows | Where-Object Silverlight | Sort-Object ClrBuilt, HostSdk | Format-Table App, HostSdk, HostBuilt, ClrBuilt, ClrSize, AgCoreBuilt, NativeImages, Entry -AutoSize | Out-String -Width 250

