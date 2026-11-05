<#
.SYNOPSIS
Builds a Silverlight project into an Xbox 360 app package, with native images
for the app's code.

.DESCRIPTION
Runs MSBuild (the one tools\Configure.ps1 found) on a project that imports
msbuild\XboxSilverlight.targets.
The package lands in the project's bin\<Configuration>\xbox folder; point an
emulator such as xenia at its default.xex.

Then it makes native images for the app's assemblies in the package with
XboxNGen (NGen-XboxApp.ps1; -NGenPlatform for the platform's too), so the
app's code runs compiled instead of interpreted. They are unsigned: they run
in xenia-edge and on consoles that run unsigned code only. -NoNGen skips
them, leaving the app's code to the runtime's interpreter, as a stock retail
console needs.

With -AppOnly it writes the app's own files alone, to bin\<Configuration>\app,
for handing the app out: the runtime and the framework assemblies are
Microsoft's and the donor app's, and whoever installs the app lays its files
over the package folder of a runtime profile of their own. Its native images
are made in the whole package first (bin\<Configuration>\xbox, which stays),
and then copied beside the app's assemblies. They only load over a package
of the same donor app as the profile's, which the build says; -NoNGen leaves
them out for any other.

Uses what tools\Configure.ps1 found: run it first.

.EXAMPLE
.\Build-XboxApp.ps1 -Project ..\samples\HelloXbox\HelloXbox.csproj

.EXAMPLE
.\Build-XboxApp.ps1 -Project ..\samples\HelloXbox\HelloXbox.csproj -NoNGen

.EXAMPLE
.\Build-XboxApp.ps1 -Project ..\samples\HelloXbox\HelloXbox.csproj -AppOnly
#>
param(
    [Parameter(Mandatory)] [string]$Project,
    [ValidateSet('Debug', 'Release')] [string]$Configuration = 'Release',
    [string]$RuntimeProfile = '',
    # The app's own files alone, without the runtime (XboxAppOnly), with
    # their native images.
    [switch]$AppOnly,
    # Leaves out the native images (NGen-XboxApp.ps1): the app's code is
    # interpreted.
    [switch]$NoNGen,
    # The default, kept for scripts that pass it: -NGen:$false is -NoNGen.
    [switch]$NGen,
    # The platform assemblies' native images too, replacing the profile's.
    [switch]$NGenPlatform,
    # A local XboxNGen checkout instead of the configured release.
    [string]$XboxNGen = '',
    # MSBuild.exe, instead of the one tools\Configure.ps1 found.
    [string]$MsBuildPath = ''
)

$ErrorActionPreference = 'Stop'
if ($AppOnly -and $NGenPlatform) {
    throw '-AppOnly can''t be used with -NGenPlatform: the app''s images would be compiled against new images of the platform, which the app files leave out.'
}
$ngen = -not $NoNGen -and -not ($PSBoundParameters.ContainsKey('NGen') -and -not $NGen)

# What tools\Configure.ps1 found.
$config = Join-Path $PSScriptRoot 'Config.ps1'
if (-not $MsBuildPath) {
    $MsBuildPath = & $config MsBuild
}
if (-not (Test-Path -LiteralPath $MsBuildPath)) {
    throw "$MsBuildPath isn't there any more: run .\tools\Configure.ps1 again."
}
# What the native images need, checked before building rather than after.
if ($ngen) {
    if (-not $XboxNGen -and -not (& $config XboxNGen -Optional)) {
        throw 'XboxNGen isn''t configured: run .\tools\Configure.ps1, or build with -NoNGen for no native images.'
    }
    if (-not (& $config Xenia -Optional)) {
        throw 'xenia-edge isn''t configured: run .\tools\Configure.ps1, or build with -NoNGen for no native images.'
    }
    if (Get-Process xenia_edge -ErrorAction SilentlyContinue) {
        throw 'xenia-edge is running, and making native images runs another (one at a time): close it, or build with -NoNGen.'
    }
}

$projectPath = (Resolve-Path -LiteralPath $Project).Path
$output = Join-Path (Split-Path -Parent $projectPath) "bin\$Configuration"

# Runs MSBuild on the project with these targets and properties.
function Invoke-Build([string]$target, [string[]]$properties) {
    $buildArgs = @(
        $projectPath,
        "/t:$target",
        "/p:Configuration=$Configuration",
        '/v:minimal',
        '/nologo'
    ) + ($properties | ForEach-Object { "/p:$_" })
    if ($RuntimeProfile) {
        $buildArgs += "/p:XboxRuntimeProfile=$((Resolve-Path -LiteralPath $RuntimeProfile).Path)\"
    }
    & $MsBuildPath @buildArgs
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

# The whole package, with its native images unless -NoNGen. An -AppOnly build
# without them needs no whole package.
if ($AppOnly -and -not $ngen) {
    Invoke-Build 'Rebuild' @('XboxAppOnly=true')
    return
}
Invoke-Build 'Rebuild' @()
if ($ngen) {
    try {
        & (Join-Path $PSScriptRoot 'NGen-XboxApp.ps1') -Package (Join-Path $output 'xbox') -Platform:$NGenPlatform -XboxNGen $XboxNGen
    } catch {
        Write-Host "The package is built, without native images; -NoNGen builds without trying." -ForegroundColor Yellow
        throw
    }
}
if (-not $AppOnly) {
    return
}

# The app's own files, packaged again from the same compile (an image only
# loads with the exact assembly it was made from, and a build compiles again
# when, say, a generated file is rewritten), and their images.
Invoke-Build 'ResolveReferences;XboxPackage' @('XboxAppOnly=true')
$appDir = Join-Path $output 'app'
$images = @()
foreach ($assembly in Get-ChildItem -LiteralPath $appDir -Filter *.dll | Where-Object { $_.Name -notlike '*.ni.dll' }) {
    $image = Join-Path $output "xbox\$($assembly.BaseName).ni.dll"
    if (-not (Test-Path -LiteralPath $image)) {
        continue
    }
    $built = Join-Path $output "xbox\$($assembly.Name)"
    if ((Get-FileHash -LiteralPath $assembly.FullName).Hash -ne (Get-FileHash -LiteralPath $built).Hash) {
        throw "$($assembly.Name) in $appDir isn't the one its image was made from: build again."
    }
    Copy-Item -LiteralPath $image -Destination $appDir
    $images += Split-Path -Leaf $image
}
$profileDir = if ($RuntimeProfile) { $RuntimeProfile } else { Join-Path (Split-Path -Parent $PSScriptRoot) 'runtime\plex-2015' }
$profileFile = Join-Path $profileDir 'profile.json'
$donor = if (Test-Path -LiteralPath $profileFile) { (Get-Content -LiteralPath $profileFile -Raw | ConvertFrom-Json).Donor } else { '' }
if (-not $donor) {
    $donor = "the profile's donor app ($profileDir)"
}
Write-Host "Native images in the app files: $($images -join ', ')"
Write-Host ("They only load over a package made from $donor, as this build's runtime profile was. To hand the " +
    "app out for any other, build with -NoNGen instead.") -ForegroundColor Yellow
