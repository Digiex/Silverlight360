<#
.SYNOPSIS
Makes native images (.ni.dll) for a built app with XboxNGen, so its code runs
compiled instead of through the runtime's IL interpreter.

.DESCRIPTION
Uses XboxNGen (https://github.com/Digiex/Silverlight360-XboxNGen): a JIT for
the Xbox 360 Silverlight runtime, and the scripts that run the runtime's own
zapper in xenia-edge to compile an app's assemblies with it.

Downloads the latest XboxNGen release (or -Tag) into -Cache, checks the zip
against the SHA-256 digest GitHub gives for it, and reuses it on later runs.
-XboxNGen uses a local XboxNGen checkout with its JIT, host and code cache
module built instead.

Then compiles, in the package folder (or a copy of it, -Output):
  - with -Platform, first the platform assemblies (System, System.Windows,
    Microsoft.Xbox ...): our images replace the profile's, from 0x96200000 up;
  - the app's own assemblies, the AppManifest.xaml parts that have no native
    image yet (or -Assemblies), one xenia-edge run each, from 0x95000000 up
    (with -Platform: all of them again, after the platform's).

Needs xenia-edge from the silverlight-build branch of jessenic/xenia-edge: by
default its release silverlight-build-20261105 (xenia_edge_windows.zip),
extracted to xenia-edge\ beside this repository. -Xenia, else the XENIA_EDGE
environment variable, else xenia_edge.exe in that folder (or one folder down),
else xenia-edge\build\bin\Windows\Release\xenia_edge.exe beside this repository
or beside its parent folder, else xenia_edge.exe on PATH. And Python 3, which
XboxNGen's tools run.

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
    # The XboxNGen release, such as v0.1.0; default: the latest.
    [string]$Tag = '',
    # A local XboxNGen checkout to use instead of a release (its jit, host and codecache built).
    [string]$XboxNGen = '',
    [string]$Cache = (Join-Path $env:LOCALAPPDATA 'Silverlight360\XboxNGen'),
    # xenia_edge.exe: this, else XENIA_EDGE, else beside this repository, else PATH.
    [string]$Xenia = '',
    # The first app image's load address, without -Platform.
    [string]$BaseAddress = '95000000',
    # Each xenia-edge run's time limit; a run that stops logging ends sooner.
    [int]$Seconds = 3000
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$sdkRoot = Split-Path -Parent $PSScriptRoot
$repository = 'Digiex/Silverlight360-XboxNGen'

# The XboxNGen tree: tools\ with the JIT, the host and the code cache module in their places beside it.
function Test-XboxNGenTree([string]$root) {
    $missing = @('tools\NGen-Package.ps1', 'tools\NGen-Platform.ps1', 'jit\xclrjit.dll', 'host\ngenhost.xex',
        'codecache\CLRCodeCachedll_0.xex') | Where-Object { -not (Test-Path -LiteralPath (Join-Path $root $_)) }
    return @($missing)
}

function Get-XboxNGenRelease {
    $headers = @{ 'User-Agent' = 'Silverlight360-NGen-XboxApp'; Accept = 'application/vnd.github+json' }
    function Save-Asset($asset, [string]$file) {
        Invoke-WebRequest $asset.browser_download_url -OutFile $file -UserAgent $headers['User-Agent'] -UseBasicParsing
    }
    $which = if ($Tag) { "tags/$Tag" } else { 'latest' }
    $release = $null
    try {
        $release = Invoke-RestMethod "https://api.github.com/repos/$repository/releases/$which" -Headers $headers
    } catch {
        # Offline: the release asked for, else the newest one in the cache.
        $cached = Get-ChildItem -LiteralPath $Cache -Directory -ErrorAction SilentlyContinue |
            Where-Object { (-not $Tag -or $_.Name -eq $Tag) -and (Test-Path (Join-Path $_.FullName 'release.json')) } |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if (-not $cached) {
            throw "Can't get XboxNGen's release ($which) from GitHub and none is cached in ${Cache}: $_"
        }
        Write-Warning "Can't get XboxNGen's release from GitHub ($($_.Exception.Message)); using the cached $($cached.Name)."
        return (Get-Content (Join-Path $cached.FullName 'release.json') -Raw | ConvertFrom-Json).Root
    }

    $zip = $release.assets | Where-Object { $_.name -like 'XboxNGen-*.zip' } | Select-Object -First 1
    if (-not $zip) { throw "XboxNGen $($release.tag_name) has no XboxNGen-*.zip with built binaries; build XboxNGen and use -XboxNGen." }
    # The checksums the release gives: GitHub's digest of the asset, and a checksum file if one is attached.
    $expected = @()
    if ($zip.digest -match '^sha256:([0-9a-f]{64})$') { $expected += $Matches[1] }
    foreach ($sums in $release.assets | Where-Object { $_.name -match '^(SHA256SUMS.*|.*\.sha256)$' }) {
        $file = [IO.Path]::GetTempFileName()
        Save-Asset $sums $file
        $text = [IO.File]::ReadAllText($file)
        Remove-Item -LiteralPath $file -Force
        foreach ($line in $text -split "`n") {
            if ($line -match '^([0-9a-fA-F]{64})\s+\*?(\S+)?' -and (-not $Matches[2] -or $Matches[2] -eq $zip.name)) {
                $expected += $Matches[1].ToLowerInvariant()
            }
        }
    }
    $expected = @($expected | Sort-Object -Unique)
    if ($expected.Count -gt 1) { throw "XboxNGen $($release.tag_name)'s checksums for $($zip.name) disagree: $($expected -join ', ')" }

    $folder = Join-Path $Cache $release.tag_name
    $record = Join-Path $folder 'release.json'
    if (Test-Path -LiteralPath $record) {
        $previous = Get-Content $record -Raw | ConvertFrom-Json
        if ((-not $expected -or $previous.Sha256 -eq $expected[0]) -and -not (Test-XboxNGenTree $previous.Root)) {
            Write-Host "XboxNGen $($release.tag_name), cached in $folder"
            return $previous.Root
        }
    }

    Write-Host "Downloading XboxNGen $($release.tag_name): $($zip.browser_download_url)"
    New-Item -ItemType Directory -Force -Path $Cache | Out-Null
    $download = Join-Path $Cache "download-$($zip.name)"
    Save-Asset $zip $download
    $actual = (Get-FileHash -LiteralPath $download -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($expected) {
        if ($actual -ne $expected[0]) {
            Remove-Item -LiteralPath $download -Force
            throw "$($zip.name)'s SHA-256 is $actual, the release says $($expected[0])"
        }
        Write-Host "  SHA-256 $actual, as the release gives"
    } else {
        Write-Warning "XboxNGen $($release.tag_name) gives no checksum for $($zip.name); its SHA-256 is $actual."
    }
    if (Test-Path -LiteralPath $folder) { Remove-Item -LiteralPath $folder -Recurse -Force }
    Expand-Archive -LiteralPath $download -DestinationPath $folder
    Remove-Item -LiteralPath $download -Force
    Get-ChildItem -LiteralPath $folder -Recurse -File | Unblock-File
    $tools = Get-ChildItem -LiteralPath $folder -Recurse -Filter 'NGen-Package.ps1' | Select-Object -First 1
    if (-not $tools) { throw "$($zip.name) has no tools\NGen-Package.ps1" }
    $root = Split-Path -Parent $tools.DirectoryName
    $missing = Test-XboxNGenTree $root
    if ($missing) { throw "$($zip.name) lacks $($missing -join ', ')" }
    [pscustomobject]@{ Tag = $release.tag_name; Asset = $zip.name; Sha256 = $actual; Root = $root } |
        ConvertTo-Json | Set-Content -LiteralPath $record -Encoding utf8
    return $root
}

# XboxNGen.
if ($XboxNGen) {
    $ngenRoot = (Resolve-Path -LiteralPath $XboxNGen).Path
    $missing = Test-XboxNGenTree $ngenRoot
    if ($missing) { throw "$ngenRoot lacks $($missing -join ', '): build its jit, host and codecache (its README.md says how)." }
    Write-Host "XboxNGen from $ngenRoot"
} else {
    $ngenRoot = Get-XboxNGenRelease
}

# xenia-edge, found as XboxNGen's tools\Configure.ps1 finds it.
if (-not $Xenia) { $Xenia = $env:XENIA_EDGE }
if (-not $Xenia) {
    $parent = Split-Path -Parent $sdkRoot
    # The silverlight-build release extracted to xenia-edge\ (at its top or one folder down), else a build of the branch.
    $released = @(Get-ChildItem -LiteralPath "$parent\xenia-edge" -Filter xenia_edge.exe -Depth 1 -ErrorAction SilentlyContinue |
        ForEach-Object FullName)
    $Xenia = @($released + "$parent\xenia-edge\build\bin\Windows\Release\xenia_edge.exe", "$parent\..\xenia-edge\build\bin\Windows\Release\xenia_edge.exe") |
        Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
}
if (-not $Xenia) {
    $found = Get-Command xenia_edge.exe -ErrorAction SilentlyContinue
    if (-not $found) {
        throw 'xenia_edge.exe not found. Extract xenia_edge_windows.zip from https://github.com/jessenic/xenia-edge/releases/tag/silverlight-build-20261105 to xenia-edge\ beside this repository, or pass -Xenia, set XENIA_EDGE to its path or put it on PATH.'
    }
    $Xenia = $found.Source
}
$Xenia = (Resolve-Path -LiteralPath $Xenia).Path
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python -or -not ((& python --version 2>&1) -match '^Python 3')) { throw "XboxNGen's tools need Python 3 as python on PATH." }
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
