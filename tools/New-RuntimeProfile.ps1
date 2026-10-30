<#
.SYNOPSIS
Builds a runtime profile from an extracted Xbox 360 Silverlight app.

.DESCRIPTION
Every Xbox 360 Silverlight app ships its own copy of the platform: the
XamlHost executable (default.xex), the CLR (xcoreclr.dll), the Silverlight
core (agcore.dll, npctrl.dll), the framework assemblies with their Xenon
native images, fonts, sounds and speech data. This script copies that
platform out of a donor app, leaves the donor's own code and assets behind,
and writes:

  <Output>\package    files every app package starts from
  <Output>\reference  the framework IL assemblies apps compile against
  <Output>\profile.json  where it came from and what it contains

The donor's binaries are Microsoft's and the app publisher's. A profile is
for local development only; don't redistribute it.

.EXAMPLE
.\New-RuntimeProfile.ps1 -DonorApp '<extracted Plex v0.0.0.7>' -Output ..\runtime\plex-2015
#>
param(
    [Parameter(Mandatory)] [string]$DonorApp,
    [Parameter(Mandatory)] [string]$Output,
    # xextool.exe, from PATH when not given. Only used to record the native
    # modules' build dates in profile.json.
    [string]$Xextool = 'xextool.exe'
)

$ErrorActionPreference = 'Stop'
$hasXextool = [bool](Get-Command $Xextool -ErrorAction SilentlyContinue)
if (-not $hasXextool) {
    Write-Warning 'xextool not found, so profile.json gets no build dates. Pass -Xextool or put xextool.exe on PATH.'
}
$DonorApp = (Resolve-Path -LiteralPath $DonorApp).Path

# The shared platform. Everything else in a donor app is its own.
$nativeModules = 'default.xex', 'xcoreclr.dll', 'agcore.dll', 'npctrl.dll', 'captions.dll'
$frameworkAssemblies = @(
    'mscorlib', 'System', 'System.Core', 'System.Net', 'System.Xml', 'System.Xml.Linq',
    'System.Windows', 'System.Windows.RuntimeHost', 'System.Windows.Controls.Navigation',
    'System.Windows.Interactivity', 'Microsoft.Xbox', 'Microsoft.Xbox.Core',
    'Microsoft.Xbox.Services', 'Microsoft.Xbox.Storage', 'Microsoft.Web.Media.SmoothStreaming'
)
# Native images whose file names are shortened.
$nativeImageNames = @{
    'System.Windows.Controls.Navigation' = 'SW.Controls.Navigation.ni.dll'
    'Microsoft.Web.Media.SmoothStreaming' = 'MWM.SmoothStreaming.ni.dll'
}
$platformPatterns = 'Microsoft.Xbox.*.resources', '*.ttf', 'nuisp*', 'NuiIdentity.bin.be', 'Database.xmplr'
$platformFolders = 'Config', 'SystemSounds'

if (Test-Path -LiteralPath $Output) {
    Remove-Item -LiteralPath $Output -Recurse -Force
}
$package = New-Item -ItemType Directory -Force -Path (Join-Path $Output 'package')
$reference = New-Item -ItemType Directory -Force -Path (Join-Path $Output 'reference')

function Copy-FromDonor([string]$name, [string]$destination) {
    $source = Join-Path $DonorApp $name
    if (-not (Test-Path -LiteralPath $source)) { return $false }
    Copy-Item -LiteralPath $source -Destination $destination -Recurse -Force
    return $true
}

foreach ($module in $nativeModules) {
    if (-not (Copy-FromDonor $module $package)) {
        throw "The donor has no $module, so it isn't a Silverlight app: $DonorApp"
    }
}

$assemblies = @()
foreach ($name in $frameworkAssemblies) {
    if (-not (Copy-FromDonor "$name.dll" $package)) {
        Write-Warning "The donor has no $name.dll; apps built on this profile can't use it."
        continue
    }
    Copy-Item -LiteralPath (Join-Path $DonorApp "$name.dll") -Destination $reference
    $nativeImage = if ($nativeImageNames.ContainsKey($name)) { $nativeImageNames[$name] } else { "$name.ni.dll" }
    $hasNativeImage = Copy-FromDonor $nativeImage $package
    $file = Get-Item -LiteralPath (Join-Path $DonorApp "$name.dll")
    $assemblies += [ordered]@{
        Name = $name
        AssemblyVersion = [Reflection.AssemblyName]::GetAssemblyName($file.FullName).Version.ToString()
        FileVersion = $file.VersionInfo.FileVersion
        NativeImage = if ($hasNativeImage) { $nativeImage } else { $null }
    }
}

foreach ($pattern in $platformPatterns) {
    Get-ChildItem -LiteralPath $DonorApp -Filter $pattern -File | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $package
    }
}
foreach ($folder in $platformFolders) {
    [void](Copy-FromDonor $folder $package)
}

function Get-XexSummary([string]$path) {
    $text = if ($hasXextool) { & $Xextool -l $path 2>$null | Out-String } else { '' }
    [ordered]@{
        File = Split-Path -Leaf $path
        Built = if ($text -match 'Filetime:\s+([0-9A-F]{8})') {
            [DateTimeOffset]::FromUnixTimeSeconds([Convert]::ToUInt32($Matches[1], 16)).UtcDateTime.ToString('yyyy-MM-dd')
        } else { $null }
        KernelImport = if ($text -match 'xboxkrnl\.exe\s+v([0-9.]+)') { $Matches[1] } else { $null }
        TitleId = if ($text -match 'Title Id:\s+([0-9A-F]{8})') { $Matches[1] } else { $null }
    }
}

$profile = [ordered]@{
    Donor = Split-Path -Leaf $DonorApp
    Created = (Get-Date).ToString('s')
    Native = @($nativeModules | ForEach-Object { Get-XexSummary (Join-Path $DonorApp $_) })
    Assemblies = $assemblies
}
$profile | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $Output 'profile.json') -Encoding utf8

$fileCount = (Get-ChildItem -LiteralPath $package -Recurse -File).Count
Write-Output "Runtime profile from $($profile.Donor): $fileCount package files, $($assemblies.Count) reference assemblies -> $Output"

# IntelliSense: <Assembly>.xml next to each reference assembly.
& (Join-Path $PSScriptRoot 'Install-ApiDocs.ps1') -RuntimeProfile $Output
