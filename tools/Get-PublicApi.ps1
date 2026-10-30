<#
.SYNOPSIS
Lists the public API of assemblies with their documentation comment IDs.

.DESCRIPTION
Writes one <Assembly>.api.jsonl per assembly: a JSON object per line for
every public type and member, with its documentation ID, kind, signature and
parameter names. With -Baseline, only what the baseline assembly of the same
name lacks is written (the Xbox additions to a Silverlight assembly).

.EXAMPLE
.\Get-PublicApi.ps1 -Assembly ..\runtime\plex-2015\reference\Microsoft.Xbox.dll -Output ..\docs\api
#>
param(
    [Parameter(Mandatory)] [string[]]$Assembly,
    [Parameter(Mandatory)] [string]$Output,
    [string]$Baseline = ''
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'ApiModel.ps1')
New-Item -ItemType Directory -Force -Path $Output | Out-Null
foreach ($path in $Assembly) {
    $file = Get-Item -LiteralPath $path
    $members = [XboxSdk.Api]::Read($file.FullName)
    if ($Baseline) {
        $basePath = Join-Path $Baseline $file.Name
        if (Test-Path -LiteralPath $basePath) {
            $known = [System.Collections.Generic.HashSet[string]]::new()
            foreach ($m in [XboxSdk.Api]::Read((Get-Item -LiteralPath $basePath).FullName)) { [void]$known.Add($m.Id) }
            $members = [System.Collections.Generic.List[XboxSdk.ApiMember]]@($members | Where-Object { -not $known.Contains($_.Id) })
        }
    }
    $out = Join-Path $Output ($file.BaseName + '.api.jsonl')
    [XboxSdk.Api]::WriteJsonLines($members, $out)
    '{0}: {1} public types and members' -f $file.Name, @($members).Count
}
