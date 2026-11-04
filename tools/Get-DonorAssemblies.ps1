<#
.SYNOPSIS
Lists the assemblies the extracted apps carry that the donor app doesn't.

.DESCRIPTION
Reads every app folder under -Root except the donor's (and other Plex
versions) and records, for each IL assembly the donor has no file of, its
name, its builds (assembly and file version, and the apps carrying each),
its public key token, whether it is only a reference assembly (every body
InternalCall or a stub of 2 bytes or less) and the apps carrying it. Native
images without IL are listed too.
docs\donor-assemblies.md was made with it.

.EXAMPLE
.\Get-DonorAssemblies.ps1 -Root <folder of extracted apps> -OutJson .\docs\donor-assemblies.json
#>
param(
    [Parameter(Mandatory)] [string]$Root,
    [Parameter(Mandatory)] [string]$OutJson,
    # The donor app's folder name under -Root.
    [string]$Donor = 'Plex v0.0.0.7'
)
$skip = '^(Plex v0\.0\.1\.7|PlexTU|Plex)$'
function Identity([string]$path) {
    $fs = [IO.File]::OpenRead($path)
    try {
        $pe = [System.Reflection.PortableExecutable.PEReader]::new($fs)
        if (-not $pe.HasMetadata) { return $null }
        $md = [System.Reflection.Metadata.PEReaderExtensions]::GetMetadataReader($pe)
        if (-not $md.IsAssembly) { return $null }
        $a = $md.GetAssemblyDefinition()
        $key = $md.GetBlobBytes($a.PublicKey)
        $token = ''
        if ($key.Length) {
            $h = [Security.Cryptography.SHA1]::HashData($key)
            $token = (($h[($h.Length - 1)..($h.Length - 8)]) | ForEach-Object { $_.ToString('x2') }) -join ''
        }
        # A reference assembly: every method body is InternalCall or a stub of at most 2 bytes of IL.
        $bodies = 0; $real = 0
        foreach ($mh in $md.MethodDefinitions) {
            $m = $md.GetMethodDefinition($mh)
            if ($m.RelativeVirtualAddress -eq 0) { continue }
            $bodies++
            $b = [System.Reflection.Metadata.PEReaderExtensions]::GetMethodBody($pe, $m.RelativeVirtualAddress)
            if ($b.Size -gt 2) { $real++ }
        }
        $fv = [Diagnostics.FileVersionInfo]::GetVersionInfo($path).FileVersion
        [pscustomobject]@{ Name = $md.GetString($a.Name); Version = "$($a.Version)"; Token = $token; FileVersion = $fv
            Methods = $bodies; Stub = ($bodies -gt 0 -and $real -eq 0) }
    } catch { $null } finally { $fs.Dispose() }
}
$donorNames = @{}
Get-ChildItem (Join-Path $Root $Donor) -Filter *.dll | ForEach-Object {
    $donorNames[($_.BaseName -replace '\.ni$', '')] = 1
}
$found = @{}
foreach ($app in Get-ChildItem $Root -Directory) {
    if ($app.Name -match $skip -or $app.Name -eq $Donor) { continue }
    $dlls = Get-ChildItem $app.FullName -Filter *.dll
    $il = @{}
    foreach ($f in $dlls | Where-Object { $_.Name -notmatch '\.ni\.dll$' }) {
        $id = Identity $f.FullName
        if (-not $id) { continue }
        $il[$f.BaseName] = 1
        if ($donorNames.ContainsKey($f.BaseName)) { continue }
        $k = "$($id.Name)|IL"
        if (-not $found[$k]) { $found[$k] = [pscustomobject]@{ Name = $id.Name; Kind = 'IL'; Versions = @{}; Token = $id.Token; Stub = $id.Stub; Apps = @() } }
        $v = "$($id.Version)|$($id.FileVersion)"
        if (-not $found[$k].Versions[$v]) { $found[$k].Versions[$v] = @() }
        $found[$k].Versions[$v] += $app.Name
        $found[$k].Apps += $app.Name
        if (-not $id.Stub) { $found[$k].Stub = $false }
    }
    foreach ($f in $dlls | Where-Object { $_.Name -match '\.ni\.dll$' }) {
        $base = $f.Name -replace '\.ni\.dll$', ''
        if ($il.ContainsKey($base) -or $donorNames.ContainsKey($base)) { continue }
        $k = "$base|NI"
        if (-not $found[$k]) { $found[$k] = [pscustomobject]@{ Name = $base; Kind = 'NI only'; Versions = @{}; Token = ''; Stub = $false; Apps = @() } }
        $found[$k].Apps += $app.Name
    }
}
$rows = $found.Values | ForEach-Object {
    $builds = foreach ($v in $_.Versions.GetEnumerator()) {
        $a, $f = $v.Key -split '\|', 2
        [pscustomobject]@{ Version = $a; FileVersion = $f; Apps = @($v.Value | Sort-Object) }
    }
    [pscustomobject]@{ Name = $_.Name; Kind = $_.Kind; Builds = @($builds | Sort-Object { [version]$_.Version }, { $f = $_.FileVersion -replace ' .*', ''; if ($f -as [version]) { [version]$f } else { [version]'0.0' } })
        Token = $_.Token; Stub = $_.Stub; Apps = @($_.Apps | Sort-Object) }
} | Sort-Object Name
$rows | ConvertTo-Json -Depth 4 | Set-Content -Encoding utf8 $OutJson
"$(@($rows).Count) assemblies"
