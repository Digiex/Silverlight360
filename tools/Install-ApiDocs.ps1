<#
.SYNOPSIS
Installs IntelliSense documentation into a runtime profile.

.DESCRIPTION
Visual Studio shows IntelliSense text for a referenced assembly from an
<Assembly>.xml file next to it. This writes one for every assembly in the
profile's reference folder. Text comes from the SDK's own documentation
(docs\api\*.xml) first, then from documentation files already installed on
this machine for the APIs the Xbox platform shares with them: the Silverlight
3 and 4 SDKs, the .NET Framework reference assemblies and XNA Game Studio 4.

The installed files are copied into the profile only, which stays local like
the rest of the profile.

.EXAMPLE
.\Install-ApiDocs.ps1 -RuntimeProfile ..\runtime\plex-2015
#>
param(
    [string]$RuntimeProfile = (Join-Path (Split-Path -Parent $PSScriptRoot) 'runtime\plex-2015'),
    [string]$MissingReport = ''
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'ApiModel.ps1')

$reference = Join-Path (Resolve-Path -LiteralPath $RuntimeProfile).Path 'reference'
if (-not (Test-Path -LiteralPath $reference)) {
    throw "No reference folder in $RuntimeProfile. Make the profile with New-RuntimeProfile.ps1 first."
}

$own = [XboxSdk.DocIndex]::new()
$own.AddDirectory((Join-Path (Split-Path -Parent $PSScriptRoot) 'docs\api'))

# Installed documentation, most specific first.
$pf86 = ${env:ProgramFiles(x86)}
$installedDirs = @(
    "$pf86\Reference Assemblies\Microsoft\Framework\Silverlight\v3.0",
    "$pf86\Microsoft SDKs\Silverlight\v3.0\Libraries\Client",
    "$pf86\Reference Assemblies\Microsoft\Framework\Silverlight\v4.0",
    "$pf86\Microsoft SDKs\Silverlight\v4.0\Libraries\Client",
    "$pf86\Microsoft XNA\XNA Game Studio\v4.0\References\Windows\x86",
    "$pf86\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.8",
    "$pf86\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0"
)
$installed = [XboxSdk.DocIndex]::new()
foreach ($dir in $installedDirs) {
    if (Test-Path -LiteralPath $dir) {
        $installed.AddDirectory($dir)
        # .NET Framework keeps language folders next to the English files.
        $en = Join-Path $dir 'en'
        if (Test-Path -LiteralPath $en) { $installed.AddDirectory($en) }
    }
}
'SDK documentation: {0} members; installed documentation: {1} members' -f $own.Count, $installed.Count

$missing = [System.Collections.Generic.List[string]]::new()
foreach ($dll in Get-ChildItem -LiteralPath $reference -Filter *.dll) {
    $out = Join-Path $reference ($dll.BaseName + '.xml')
    $r = [XboxSdk.ApiDocs]::Build($dll.FullName, $own, $installed, $out)
    $documented = $r.Own + $r.Installed + $r.Pattern
    '{0,-42} {1,5} of {2,5} documented ({3} SDK, {4} installed, {5} by pattern)' -f $dll.Name, $documented, $r.Total, $r.Own, $r.Installed, $r.Pattern
    foreach ($id in $r.Missing) { $missing.Add("$($dll.BaseName)`t$id") }
}
if ($MissingReport) {
    $missing | Set-Content -LiteralPath $MissingReport -Encoding utf8
    "Undocumented members: $MissingReport"
}
