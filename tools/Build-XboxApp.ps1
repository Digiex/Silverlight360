<#
.SYNOPSIS
Builds a Silverlight project into an Xbox 360 app package.

.DESCRIPTION
Runs MSBuild 14 on a project that imports msbuild\XboxSilverlight.targets.
The package lands in the project's bin\<Configuration>\xbox folder; point an
emulator such as xenia at its default.xex.

With -AppOnly it writes the app's own files alone, to bin\<Configuration>\app,
for handing the app out: the runtime and the framework assemblies are
Microsoft's and the donor app's, and whoever installs the app lays its files
over the package folder of a runtime profile of their own.

.EXAMPLE
.\Build-XboxApp.ps1 -Project ..\samples\HelloXbox\HelloXbox.csproj

.EXAMPLE
.\Build-XboxApp.ps1 -Project ..\samples\HelloXbox\HelloXbox.csproj -AppOnly
#>
param(
    [Parameter(Mandatory)] [string]$Project,
    [ValidateSet('Debug', 'Release')] [string]$Configuration = 'Release',
    [string]$RuntimeProfile = '',
    # The app's own files alone, without the runtime (XboxAppOnly).
    [switch]$AppOnly,
    [string]$MsBuildPath = "${env:ProgramFiles(x86)}\MSBuild\14.0\Bin\MSBuild.exe"
)

$ErrorActionPreference = 'Stop'
$sdkRoot = Split-Path -Parent $PSScriptRoot
$required = @{
    'MSBuild 14 (Visual Studio 2015 build tools)' = $MsBuildPath
    'Silverlight 3 build targets' = "${env:ProgramFiles(x86)}\MSBuild\Microsoft\Silverlight\v3.0\Microsoft.Silverlight.CSharp.targets"
    'Windows SDK 7.0A' = "${env:ProgramFiles(x86)}\Microsoft SDKs\Windows\v7.0A"
}
foreach ($entry in $required.GetEnumerator()) {
    if (-not (Test-Path -LiteralPath $entry.Value)) {
        throw "$($entry.Key) isn't installed: $($entry.Value). See README.md."
    }
}

$buildArgs = @(
    (Resolve-Path -LiteralPath $Project).Path,
    '/t:Rebuild',
    "/p:Configuration=$Configuration",
    "/p:TargetPlatformSdkPath=${env:ProgramFiles(x86)}\Microsoft SDKs\Windows\v7.0A",
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
