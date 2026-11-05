<#
.SYNOPSIS
Gives one of the settings tools\Configure.ps1 saved in config.json at the
repository's root, for the other tools.

.DESCRIPTION
Stops with "run tools\Configure.ps1" when there's no config.json or the
setting isn't in it, unless -Optional, which gives '' instead.

Settings: MsBuild (MSBuild.exe), WindowsSdk (the Windows SDK 7.0A folder),
Python (python.exe), Xenia (xenia_edge.exe), XboxNGen (the extracted XboxNGen
release's folder), XboxNGenTag (its tag), Xextool (xextool.exe), SevenZip
(7z.exe).

.EXAMPLE
$msbuild = & (Join-Path $PSScriptRoot 'Config.ps1') MsBuild
#>
param(
    [Parameter(Mandatory)]
    [ValidateSet('MsBuild', 'WindowsSdk', 'Python', 'Xenia', 'XboxNGen', 'XboxNGenTag', 'Xextool', 'SevenZip')]
    [string]$Name,
    # Gives '' instead of stopping when the setting isn't there.
    [switch]$Optional
)

$file = Join-Path (Split-Path -Parent $PSScriptRoot) 'config.json'
$value = $null
if (Test-Path -LiteralPath $file) {
    $value = (Get-Content -LiteralPath $file -Raw | ConvertFrom-Json).$Name
}
if ($value) {
    return $value
}
if ($Optional) {
    return ''
}
if (-not (Test-Path -LiteralPath $file)) {
    throw 'Silverlight360 isn''t configured yet: run .\tools\Configure.ps1 first.'
}
throw "$Name isn't configured: run .\tools\Configure.ps1, which says what's missing and how to get it."
