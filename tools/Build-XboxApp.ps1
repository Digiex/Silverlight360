<#
.SYNOPSIS
Builds a Silverlight project into an Xbox 360 app package, with native images
for the app's code.

.DESCRIPTION
Runs MSBuild 14 on a project that imports msbuild\XboxSilverlight.targets.
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
over the package folder of a runtime profile of their own. That has no native
images: making them runs the whole package.

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
    # The app's own files alone, without the runtime (XboxAppOnly), and so
    # without native images.
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
    throw '-NGenPlatform needs the whole package, not -AppOnly: native images are made by running it.'
}
$ngen = -not $NoNGen -and -not $AppOnly -and -not ($PSBoundParameters.ContainsKey('NGen') -and -not $NGen)

# What tools\Configure.ps1 found.
$config = Join-Path $PSScriptRoot 'Config.ps1'
if (-not $MsBuildPath) {
    $MsBuildPath = & $config MsBuild
}
$windowsSdk = & $config WindowsSdk
foreach ($path in $MsBuildPath, $windowsSdk) {
    if (-not (Test-Path -LiteralPath $path)) {
        throw "$path isn't there any more: run .\tools\Configure.ps1 again."
    }
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

$buildArgs = @(
    (Resolve-Path -LiteralPath $Project).Path,
    '/t:Rebuild',
    "/p:Configuration=$Configuration",
    "/p:TargetPlatformSdkPath=$windowsSdk",
    '/v:minimal',
    '/nologo'
)
if ($AppOnly) {
    $buildArgs += '/p:XboxAppOnly=true'
}
if ($RuntimeProfile) {
    $buildArgs += "/p:XboxRuntimeProfile=$((Resolve-Path -LiteralPath $RuntimeProfile).Path)\"
}
& $MsBuildPath @buildArgs
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

if ($ngen) {
    $package = Join-Path (Split-Path -Parent (Resolve-Path -LiteralPath $Project).Path) "bin\$Configuration\xbox"
    try {
        & (Join-Path $PSScriptRoot 'NGen-XboxApp.ps1') -Package $package -Platform:$NGenPlatform -XboxNGen $XboxNGen
    } catch {
        Write-Host "The package is built, without native images; -NoNGen builds without trying." -ForegroundColor Yellow
        throw
    }
}
