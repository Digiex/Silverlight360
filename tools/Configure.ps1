<#
.SYNOPSIS
Checks everything building and running Silverlight360 apps needs, and saves
where each one is for the other tools. Run it first.

.DESCRIPTION
Run it once after cloning, and again after installing something it reports
missing, or to update XboxNGen. It checks:

  For building (Build-XboxApp.ps1):
    MSBuild 14             Visual Studio 2015 or its Build Tools (-MsBuild)
    Silverlight 3          the Silverlight 3 tools and SDK: build targets and
                           reference assemblies
    Windows SDK 7.0A       the Silverlight build tasks use it
    Runtime profile        runtime\plex-2015, made from an extracted app with
                           New-RuntimeProfile.ps1 (-DonorApp makes it here)
  For running apps and native images:
    Python 3               python on PATH: XboxNGen's tools, the test server
                           and the extraction tools
    XboxNGen               its latest release (or -Tag), downloaded into
                           %LOCALAPPDATA%\Silverlight360\XboxNGen and checked
                           against the SHA-256 GitHub gives for it
    xenia-edge             found by XboxNGen's tools\Configure.ps1, which this
                           runs: -Xenia, the XENIA_EDGE environment variable,
                           the last configuration, xenia-edge\ beside this
                           repository or PATH; else it offers to download the
                           silverlight-build release xenia-edge needs
  Optional:
    xextool.exe            build dates in a runtime profile (-Xextool)
    7-Zip                  tools\extract_god_packages.py

The result goes to config.json at the repository's root (git ignores it),
which tools\Config.ps1 reads for the other tools. -Show prints it.

.EXAMPLE
.\tools\Configure.ps1

.EXAMPLE
.\tools\Configure.ps1 -DonorApp 'D:\apps\Plex v0.0.0.7'

Also makes the default runtime profile from an extracted Plex v0.0.0.7.
#>
param(
    # MSBuild.exe, when it isn't MSBuild 14's default install folder.
    [string]$MsBuild = '',
    # xenia_edge.exe, when it isn't found.
    [string]$Xenia = '',
    [string]$Xextool = '',
    # An extracted Xbox 360 Silverlight app (Plex v0.0.0.7) to make
    # runtime\plex-2015 from, when there's no profile there yet.
    [string]$DonorApp = '',
    # The XboxNGen release, such as v0.1.1; default: the latest.
    [string]$Tag = '',
    # Downloads xenia-edge's release without asking when no xenia-edge is found.
    [switch]$DownloadXenia,
    # Doesn't get XboxNGen or xenia-edge, for building alone.
    [switch]$SkipXboxNGen,
    # Asks nothing: no xenia-edge download unless -DownloadXenia.
    [switch]$NonInteractive,
    [switch]$Show
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$sdkRoot = Split-Path -Parent $PSScriptRoot
$parent = Split-Path -Parent $sdkRoot
$jsonFile = Join-Path $sdkRoot 'config.json'
$pf86 = ${env:ProgramFiles(x86)}

if ($Show) {
    if (-not (Test-Path -LiteralPath $jsonFile)) {
        throw 'Not configured yet: run .\tools\Configure.ps1.'
    }
    (Get-Content -LiteralPath $jsonFile -Raw | ConvertFrom-Json).PSObject.Properties |
        ForEach-Object { '{0,-16} {1}' -f $_.Name, $(if ($_.Value) { $_.Value } else { '(not set)' }) }
    return
}

$previous = if (Test-Path -LiteralPath $jsonFile) { Get-Content -LiteralPath $jsonFile -Raw | ConvertFrom-Json } else { $null }
$config = [ordered]@{}
$missing = @()

# The first of these paths that exists.
function First-Existing([string[]]$paths) {
    $paths | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -First 1
}

# Prints one line of the report; a required item that's missing is listed at the end.
function Report([string]$name, [string]$value, [string]$fix, [switch]$Required) {
    if ($value) {
        Write-Host ('{0,-18} {1}' -f $name, $value)
    } else {
        Write-Host ('{0,-18} {1}' -f $name, "missing: $fix") -ForegroundColor $(if ($Required) { 'Red' } else { 'Yellow' })
        if ($Required) {
            $script:missing += $name
        }
    }
}

# XboxNGen's releases (https://github.com/Digiex/Silverlight360-XboxNGen): Get-XboxNGenRelease [-Tag v0.1.1]
# downloads one into the cache, checks it against GitHub's SHA-256 and gives the extracted release's folder.
$XboxNGenCache = Join-Path $env:LOCALAPPDATA 'Silverlight360\XboxNGen'

# The XboxNGen tree: tools\ with the JIT, the host and the code cache module in their places beside it.
function Test-XboxNGenTree([string]$root) {
    $missing = @('tools\NGen-Package.ps1', 'tools\NGen-Platform.ps1', 'jit\xclrjit.dll', 'host\ngenhost.xex',
        'codecache\CLRCodeCachedll_0.xex') | Where-Object { -not (Test-Path -LiteralPath (Join-Path $root $_)) }
    return @($missing)
}

function Get-XboxNGenRelease([string]$Tag = '', [string]$Cache = $XboxNGenCache) {
    $repository = 'Digiex/Silverlight360-XboxNGen'
    $headers = @{ 'User-Agent' = 'Silverlight360'; Accept = 'application/vnd.github+json' }
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
    # The release's own files only: XboxNGen's Configure.ps1 puts a downloaded xenia-edge beside them.
    Get-ChildItem -LiteralPath $folder -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike 'xenia-edge*' } |
        Remove-Item -Recurse -Force
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

# Building.
$config.MsBuild = First-Existing @($MsBuild, $previous.MsBuild, "$pf86\MSBuild\14.0\Bin\MSBuild.exe")
Report 'MSBuild 14' $config.MsBuild 'install Visual Studio 2015 or its Build Tools, or pass -MsBuild <MSBuild.exe>' -Required
Report 'Silverlight 3' (First-Existing @("$pf86\MSBuild\Microsoft\Silverlight\v3.0\Microsoft.Silverlight.CSharp.targets")) `
    'install the Silverlight 3 tools (Microsoft.Silverlight.CSharp.targets)' -Required
Report 'Silverlight 3 SDK' (First-Existing @("$pf86\Reference Assemblies\Microsoft\Framework\Silverlight\v3.0\System.Windows.dll")) `
    'install the Silverlight 3 SDK (its reference assemblies)' -Required
$config.WindowsSdk = First-Existing @("$pf86\Microsoft SDKs\Windows\v7.0A")
Report 'Windows SDK 7.0A' $config.WindowsSdk 'install the Windows SDK 7.0A (it comes with Visual Studio 2010 and 2012)' -Required

$python = Get-Command python -ErrorAction SilentlyContinue
$config.Python = if ($python -and ((& $python.Source --version 2>&1) -match '^Python 3')) { $python.Source } else { '' }
Report 'Python 3' $config.Python 'install Python 3 and put python on PATH'

$xextool = if ($Xextool) { $Xextool } elseif ($previous.Xextool) { $previous.Xextool } else { 'xextool.exe' }
$found = Get-Command $xextool -ErrorAction SilentlyContinue
$config.Xextool = if ($found) { $found.Source } else { '' }
Report 'xextool' $config.Xextool 'optional: put xextool.exe on PATH or pass -Xextool, for build dates in runtime profiles'

$sevenZip = Get-Command 7z -ErrorAction SilentlyContinue
$config.SevenZip = First-Existing @($env:SEVEN_ZIP, $(if ($sevenZip) { $sevenZip.Source }), "$env:ProgramFiles\7-Zip\7z.exe")
Report '7-Zip' $config.SevenZip 'optional: install 7-Zip, for tools\extract_god_packages.py'

$profileDir = Join-Path $sdkRoot 'runtime\plex-2015'
if (-not (Test-Path -LiteralPath (Join-Path $profileDir 'package\default.xex')) -and $DonorApp) {
    $profileArgs = @{ DonorApp = $DonorApp; Output = $profileDir }
    if ($config.Xextool) {
        $profileArgs.Xextool = $config.Xextool
    }
    & (Join-Path $PSScriptRoot 'New-RuntimeProfile.ps1') @profileArgs
}
Report 'Runtime profile' (First-Existing @((Join-Path $profileDir 'package\default.xex'))) `
    'make it from an extracted Plex v0.0.0.7: pass -DonorApp <folder>, or run tools\New-RuntimeProfile.ps1 (docs\getting-started.md)' -Required

# XboxNGen, and xenia-edge through its Configure.ps1.
$config.XboxNGen = ''
$config.XboxNGenTag = ''
$config.Xenia = ''
if (-not $SkipXboxNGen) {
    try {
        $config.XboxNGen = Get-XboxNGenRelease -Tag $Tag
        $config.XboxNGenTag = Split-Path -Leaf (Split-Path -Parent $config.XboxNGen)
    } catch {
        Write-Warning "Couldn't get XboxNGen: $_"
    }
    Report 'XboxNGen' $config.XboxNGen 'check the connection to GitHub, then run Configure.ps1 again'

    if ($config.XboxNGen) {
        # The xenia-edge it's given; with none, its Configure.ps1 looks beside the release, then offers the download.
        $pathXenia = Get-Command xenia_edge.exe -ErrorAction SilentlyContinue
        $released = @(Get-ChildItem -LiteralPath "$parent\xenia-edge" -Filter xenia_edge.exe -Depth 1 -ErrorAction SilentlyContinue |
            ForEach-Object FullName)
        $knownXenia = First-Existing (@($Xenia, $env:XENIA_EDGE, $previous.Xenia) + $released + @(
            "$parent\xenia-edge\build\bin\Windows\Release\xenia_edge.exe",
            "$parent\..\xenia-edge\build\bin\Windows\Release\xenia_edge.exe",
            $(if ($pathXenia) { $pathXenia.Source })))
        $ngenArgs = @{ NonInteractive = $true; Silverlight360 = $sdkRoot }
        if ($knownXenia) {
            $ngenArgs.Xenia = $knownXenia
        } elseif ($DownloadXenia -or (-not $NonInteractive -and
                (Read-Host "No xenia-edge found. Download the silverlight-build release XboxNGen needs? (Y/n)") -notmatch '^n')) {
            $ngenArgs.DownloadXenia = $true
        }
        Write-Host "XboxNGen's Configure.ps1:"
        & (Join-Path $config.XboxNGen 'tools\Configure.ps1') @ngenArgs | ForEach-Object { "  $_" } | Write-Host
        $ngenConfig = Join-Path $config.XboxNGen 'config.json'
        if (Test-Path -LiteralPath $ngenConfig) {
            $config.Xenia = First-Existing @((Get-Content -LiteralPath $ngenConfig -Raw | ConvertFrom-Json).Xenia)
        }
    }
    Report 'xenia-edge' $config.Xenia 'run Configure.ps1 again and accept the download, or pass -Xenia <xenia_edge.exe>'
}

$config | ConvertTo-Json | Set-Content -LiteralPath $jsonFile -Encoding utf8
Write-Host ''
if ($missing) {
    Write-Warning "Not ready to build yet; missing: $($missing -join ', '). Get them as said above, then run .\tools\Configure.ps1 again."
} else {
    Write-Host "Ready to build. Saved in $jsonFile."
}
