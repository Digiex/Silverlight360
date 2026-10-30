# Loads ApiModel.cs and ApiDocs.cs once per session.
if (-not ('XboxSdk.Api' -as [type])) {
    Add-Type -AssemblyName System.Reflection.Metadata, System.Collections.Immutable, System.Xml.Linq
    Add-Type -Path (Join-Path $PSScriptRoot 'ApiModel.cs'), (Join-Path $PSScriptRoot 'ApiDocs.cs')
}
