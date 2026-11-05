<#
.SYNOPSIS
Makes native images (.ni.dll) for a built app with XboxNGen, so its code runs
compiled instead of through the runtime's IL interpreter.

.DESCRIPTION
Uses XboxNGen (https://github.com/Digiex/Silverlight360-XboxNGen): a JIT for
the Xbox 360 Silverlight runtime, and the scripts that run the runtime's own
zapper in xenia-edge to compile an app's assemblies with it.

Uses the XboxNGen release and the xenia-edge tools\Configure.ps1 set up (run
it first; run it again for a newer XboxNGen). -XboxNGen uses a local XboxNGen
checkout with its JIT, host and code cache module built instead, and -Xenia
another xenia_edge.exe.

Then compiles, in the package folder (or a copy of it, -Output):
  - with -Platform, first the platform assemblies (System, System.Windows,
    Microsoft.Xbox ...): our images replace the profile's, from 0x96200000 up;
  - the app's own assemblies, the AppManifest.xaml parts that have no native
    image yet (or -Assemblies), one xenia-edge run each, from 0x95000000 up
    (with -Platform: all of them again, after the platform's).

xenia-edge has to be the silverlight-build branch of jessenic/xenia-edge, which
Configure.ps1 downloads when it finds none. XboxNGen releases before its tools
were PowerShell (v0.1.1 and older) also need Python 3.7 or later as python.

The images are unsigned: they run in xenia-edge and on a console that runs
unsigned code, not on a stock retail console. Run one xenia-edge at a time.

.EXAMPLE
.\NGen-XboxApp.ps1 -Package ..\samples\HelloXbox\bin\Release\xbox

.EXAMPLE
.\NGen-XboxApp.ps1 -Package ..\samples\ui\XboxControls\bin\Release\xbox -Platform -Output $env:TEMP\XboxControls-ngen

.EXAMPLE
.\NGen-XboxApp.ps1 -Package ..\samples\HelloXbox\bin\Release\xbox -XboxNGen C:\src\Silverlight360-XboxNGen
#>
param(
    # The built package: bin\<Configuration>\xbox, or any app folder with a default.xex and an AppManifest.xaml.
    [Parameter(Mandatory)] [string]$Package,
    # Assembly simple names to compile; default: the AppManifest.xaml parts that have no native image yet.
    [string[]]$Assemblies = @(),
    # Also compile the platform assemblies, replacing the profile's native images of them with ours.
    [switch]$Platform,
    # Compile in a copy of the package made here (replacing what is there), leaving the package as it is.
    [string]$Output = '',
    # A local XboxNGen checkout to use instead of the configured release (its jit, host and codecache built).
    [string]$XboxNGen = '',
    # xenia_edge.exe, instead of the configured one.
    [string]$Xenia = '',
    # The first app image's load address, without -Platform.
    [string]$BaseAddress = '95000000',
    # Each xenia-edge run's time limit; a run that stops logging ends sooner.
    [int]$Seconds = 3000
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$config = Join-Path $PSScriptRoot 'Config.ps1'

# XboxNGen: the configured release, else a checkout.
if ($XboxNGen) {
    $ngenRoot = (Resolve-Path -LiteralPath $XboxNGen).Path
} else {
    $ngenRoot = & $config XboxNGen -Optional
    if (-not $ngenRoot -or -not (Test-Path -LiteralPath $ngenRoot)) {
        throw 'XboxNGen hasn''t been downloaded: run .\tools\Configure.ps1 first.'
    }
}
$missing = @('tools\NGen-Package.ps1', 'tools\NGen-Platform.ps1', 'jit\xclrjit.dll', 'host\ngenhost.xex',
    'codecache\CLRCodeCachedll_0.xex') | Where-Object { -not (Test-Path -LiteralPath (Join-Path $ngenRoot $_)) }
if ($missing) {
    throw "$ngenRoot lacks $($missing -join ', '): $(if ($XboxNGen) { 'build its jit, host and codecache (its README.md says how)' } else { 'run .\tools\Configure.ps1 again' })."
}
Write-Host "XboxNGen $(if ($XboxNGen) { 'from' } else { (& $config XboxNGenTag -Optional) + ',' }) $ngenRoot"

# xenia-edge: the configured one, which XboxNGen's Configure.ps1 found or downloaded.
if (-not $Xenia) {
    $Xenia = & $config Xenia
}
$Xenia = (Resolve-Path -LiteralPath $Xenia).Path
# XboxNGen v0.1.1 and older wrap each image with Python; later ones with PowerShell.
if (Test-Path -LiteralPath (Join-Path $ngenRoot 'tools\pe2nixex.py')) {
    $python = Get-Command python -ErrorAction SilentlyContinue
    if (-not $python -or -not ((& python --version 2>&1 | Out-String) -match 'Python 3\.([7-9]|\d\d)')) {
        throw "This XboxNGen release needs Python 3.7 or later as python on PATH: run .\tools\Configure.ps1 for a newer one."
    }
}
if (Get-Process xenia_edge -ErrorAction SilentlyContinue) {
    throw 'xenia-edge is already running: run one at a time (two at once can stop one with "Overflowed stackpoints!").'
}

# The package.
$Package = (Resolve-Path -LiteralPath $Package).Path
foreach ($file in 'default.xex', 'AppManifest.xaml', 'xcoreclr.dll', 'mscorlib.ni.dll') {
    if (-not (Test-Path -LiteralPath (Join-Path $Package $file))) {
        throw "$Package has no ${file}: give a whole package (bin\<Configuration>\xbox), not an -AppOnly build."
    }
}
if ($Output) {
    if (Test-Path -LiteralPath $Output) { Remove-Item -LiteralPath $Output -Recurse -Force }
    Copy-Item -LiteralPath $Package -Destination $Output -Recurse
    $Package = (Resolve-Path -LiteralPath $Output).Path
}

# xcoreclr's shorter file names for some images (XboxNGen's NGen-Package.ps1).
$aliases = @{ 'System.Windows.Controls.Navigation' = 'SW.Controls.Navigation'; 'Microsoft.Web.Media.SmoothStreaming' = 'MWM.SmoothStreaming';
    'Microsoft.Xna.Framework' = 'MXF' }
function Image-Path([string]$name) {
    Join-Path $Package "$(if ($aliases.ContainsKey($name)) { $aliases[$name] } else { $name }).ni.dll"
}

# XboxNGen's scripts find xenia-edge through XENIA_EDGE before their own config.json.
$savedXenia = $env:XENIA_EDGE
$env:XENIA_EDGE = $Xenia
$compiled = @()
$failed = @()
try {
    $next = $BaseAddress
    if ($Platform) {
        # The platform in the order XboxNGen's NGen-Platform.ps1 compiles it, dependencies first. Each assembly's slot
        # is twice the size of the profile's image of it, which is set aside for that before ours replaces it.
        $platformNames = @('System', 'System.Core', 'System.Xml', 'System.Net', 'System.Windows',
            'System.Windows.RuntimeHost', 'System.Xml.Linq', 'System.Windows.Interactivity',
            'System.Windows.Controls.Navigation', 'Microsoft.Web.Media.SmoothStreaming', 'Microsoft.Xbox.Core',
            'Microsoft.Xbox', 'Microsoft.Xbox.Services', 'Microsoft.Xbox.Storage')
        $present = @($platformNames | Where-Object { Test-Path -LiteralPath (Join-Path $Package "$_.dll") })
        $reference = Join-Path $env:TEMP 'silverlight360-ngen-reference'
        if (Test-Path -LiteralPath $reference) { Remove-Item -LiteralPath $reference -Recurse -Force }
        New-Item -ItemType Directory -Path $reference | Out-Null
        foreach ($name in $present) {
            $image = Image-Path $name
            if (Test-Path -LiteralPath $image) { Move-Item -LiteralPath $image -Destination $reference }
        }
        # The app's images made against the profile's platform images are made again against ours.
        [xml]$manifest = Get-Content -LiteralPath (Join-Path $Package 'AppManifest.xaml')
        foreach ($part in $manifest.Deployment.'Deployment.Parts'.AssemblyPart) {
            $image = Image-Path ([IO.Path]::GetFileNameWithoutExtension($part.Source))
            if (Test-Path -LiteralPath $image) { Remove-Item -LiteralPath $image -Force }
        }
        Write-Host "== Platform: $($present -join ', ')"
        # NGen-Platform.ps1 writes each compile's lines to the host and returns the next free load address.
        $next = $null
        & (Join-Path $ngenRoot 'tools\NGen-Platform.ps1') -Package $Package -Assemblies $present -Reference $reference -Seconds $Seconds 6>&1 2>&1 |
            ForEach-Object {
                if ("$_" -match '^[0-9A-F]{8}$') { $next = "$_" }
                elseif ("$_" -notmatch '^xclrjit: compiled ') { Write-Host "   $_" }
            }
        if (-not $next) { throw "XboxNGen's NGen-Platform.ps1 gave no load address for the app's images." }
        foreach ($name in $present) {
            if (Test-Path -LiteralPath (Image-Path $name)) { $compiled += $name } else { $failed += $name }
        }
    }

    if (-not $Assemblies) {
        [xml]$manifest = Get-Content -LiteralPath (Join-Path $Package 'AppManifest.xaml')
        # Parts with a file and no image yet: a manifest can list platform assemblies, which have one already.
        $Assemblies = @($manifest.Deployment.'Deployment.Parts'.AssemblyPart | ForEach-Object { [IO.Path]::GetFileNameWithoutExtension($_.Source) } |
            Where-Object { (Test-Path -LiteralPath (Join-Path $Package "$_.dll")) -and -not (Test-Path -LiteralPath (Image-Path $_)) })
    }
    # One run per assembly: an image the zapper has just written beside a dependency breaks the next compile.
    [uint64]$base = [Convert]::ToUInt64($next, 16)
    foreach ($name in $Assemblies) {
        $hex = $base.ToString('X8')
        Write-Host "== $name at $hex"
        & (Join-Path $ngenRoot 'tools\NGen-Package.ps1') -Package $Package -Assemblies @($name) -BaseAddress $hex -Seconds $Seconds -Xenia $Xenia 6>&1 2>&1 |
            Where-Object { "$_" -notmatch '^xclrjit: compiled ' } | ForEach-Object { Write-Host "   $_" }
        $image = Image-Path $name
        if (Test-Path -LiteralPath $image) {
            $compiled += $name
            # The next image goes past this one with room to spare, at least 4 MB on.
            [uint64]$slot = [Math]::Max(0x400000, ((Get-Item -LiteralPath $image).Length * 2 + 0xFFFFF) -band 0xFFF00000)
            $base += $slot
        } else {
            $failed += $name
        }
    }
} finally {
    $env:XENIA_EDGE = $savedXenia
}

if ($compiled) {
    Write-Host "Native images for $($compiled -join ', ') in $Package"
} elseif (-not $failed) {
    Write-Host "Nothing to compile in ${Package}: every assembly has a native image."
}
if ($failed) {
    Write-Warning "No native image for $($failed -join ', '): those run interpreted."
    exit 1
}
