<#
.SYNOPSIS
Checks the SDK's own documentation files against the runtime profile's API.

.DESCRIPTION
For each docs\api\*.xml (or the -Path given), reports members that don't
exist, parameter names that don't match, missing summaries or returns, and
cref links that don't resolve. Exits with 1 when there are problems.

.EXAMPLE
.\Test-ApiDocs.ps1 -Path ..\docs\api\Microsoft.Xbox.Controls.xml
#>
param(
    [string[]]$Path = @(),
    [string]$RuntimeProfile = (Join-Path (Split-Path -Parent $PSScriptRoot) 'runtime\plex-2015')
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'ApiModel.ps1')
if (-not $Path) {
    $Path = (Get-ChildItem (Join-Path (Split-Path -Parent $PSScriptRoot) 'docs\api') -Filter *.xml).FullName
}
[string[]]$assemblies = (Get-ChildItem (Join-Path $RuntimeProfile 'reference') -Filter *.dll).FullName
$failed = $false
foreach ($p in $Path) {
    $problems = [XboxSdk.ApiDocs]::Validate((Resolve-Path -LiteralPath $p).Path, $assemblies)
    if ($problems.Count) {
        $failed = $true
        "$p`: $($problems.Count) problems"
        $problems | ForEach-Object { "  $_" }
    } else {
        "$p`: OK"
    }
}
if ($failed) { exit 1 }
