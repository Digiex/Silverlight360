<#
.SYNOPSIS
Takes the donor app's title out of a runtime profile's default.xex.

.DESCRIPTION
A donor's default.xex declares the donor's title: its title ID, version and
media ID (the execution info header), and it carries the title's own
resource, named after the title ID, with the title's name, tile and presence
strings. A package built on it runs as the donor's title, so a console
signed in to LIVE offers the donor's title updates, and the console shows
the donor's name. Without the execution info the executable declares no
title, as homebrew executables don't, and the console runs it as its own
dashboard title (FFFE07D1).

The file is changed in place:

- the execution info's entry leaves the header directory;
- the title's resource leaves the resource directory, and its bytes in the
  image are zeroed;
- the header digest is computed again: SHA-1 over the header from the end of
  the security info's fixed part to the image, then from the start of the
  file to the security info's signature.

The image's page digests aren't computed again. Donor executables decrypted
for development already don't match theirs, and consoles that run them don't
check them. Only an image that's neither encrypted nor compressed beyond
zero runs (basic compression) can be changed. Running it on a stripped file
changes nothing.

.EXAMPLE
.\Remove-DonorTitle.ps1 ..\runtime\plex-2015\package\default.xex
#>
param(
    [Parameter(Mandatory)] [string]$Xex
)

$ErrorActionPreference = 'Stop'
$ResourceInfo = 0x000002FF
$FileFormatInfo = 0x000003FF
$ExecutionInfo = 0x00040006
$ExecutionInfoSize = 0x18
$ResourceEntry = 0x10
# In the security info.
$LoadAddress = 0x110
$HeaderDigest = 0x164
$DigestedFrom = 0x17C
$SignedFrom = 8

function Get-BE32([byte[]]$data, [int]$at) {
    [uint32]$data[$at] * 0x1000000 + [uint32]$data[$at + 1] * 0x10000 + [uint32]$data[$at + 2] * 0x100 + [uint32]$data[$at + 3]
}
function Get-BE16([byte[]]$data, [int]$at) {
    [int]$data[$at] * 0x100 + [int]$data[$at + 1]
}
function Set-BE32([byte[]]$data, [int]$at, [uint32]$value) {
    $data[$at] = [byte](($value -shr 24) -band 0xFF)
    $data[$at + 1] = [byte](($value -shr 16) -band 0xFF)
    $data[$at + 2] = [byte](($value -shr 8) -band 0xFF)
    $data[$at + 3] = [byte]($value -band 0xFF)
}
function Clear-Bytes([byte[]]$data, [int]$at, [int]$count) {
    [Array]::Clear($data, $at, $count)
}

# SHA-1 over the header from the end of the security info's fixed part to the image, then from the start of the file
# to the security info's signature.
function Get-HeaderDigest([byte[]]$data, [int]$security, [int]$image) {
    $sha = [Security.Cryptography.SHA1]::Create()
    try {
        [void]$sha.TransformBlock($data, $security + $DigestedFrom, $image - $security - $DigestedFrom, $null, 0)
        [void]$sha.TransformFinalBlock($data, 0, $security + $SignedFrom)
        , $sha.Hash
    } finally { $sha.Dispose() }
}

# Where an address in the image is in the file.
function Get-ImageOffset([byte[]]$data, [int]$image, [int]$fileFormat, [uint32]$address, [uint32]$loadAddress) {
    $encryption = Get-BE16 $data ($fileFormat + 4)
    $compression = Get-BE16 $data ($fileFormat + 6)
    if ($encryption -ne 0) { throw 'the image is encrypted' }
    $at = [long]$address - $loadAddress
    if ($compression -eq 0) { return $image + $at }
    if ($compression -ne 1) { throw 'the image is compressed' }
    $size = Get-BE32 $data $fileFormat
    $stored = [long]$image
    $loaded = [long]0
    for ($offset = $fileFormat + 8; $offset -lt $fileFormat + $size; $offset += 8) {
        $dataSize = Get-BE32 $data $offset
        $zeroSize = Get-BE32 $data ($offset + 4)
        if ($loaded -le $at -and $at -lt $loaded + $dataSize) { return $stored + $at - $loaded }
        $stored += $dataSize
        $loaded += $dataSize + $zeroSize
    }
    throw ('0x{0:x} isn''t stored in the image' -f $address)
}

$path = (Resolve-Path -LiteralPath $Xex).Path
$data = [IO.File]::ReadAllBytes($path)
if ([Text.Encoding]::ASCII.GetString($data, 0, 4) -ne 'XEX2') { throw "$path isn't an XEX2 executable" }
$image = [int](Get-BE32 $data 8)
$security = [int](Get-BE32 $data 16)
$count = [int](Get-BE32 $data 20)
$stored = [byte[]]$data[($security + $HeaderDigest)..($security + $HeaderDigest + 19)]
if ([BitConverter]::ToString($stored) -ne [BitConverter]::ToString((Get-HeaderDigest $data $security $image))) {
    throw "${path}: the header digest doesn't match the header"
}
$entries = @(for ($i = 0; $i -lt $count; $i++) { , @((Get-BE32 $data (24 + 8 * $i)), (Get-BE32 $data (28 + 8 * $i))) })
$found = @{}
# A value is a header's offset in the file, or the header's value itself for the small ones (an address, say).
foreach ($entry in $entries) { $found[[uint32]$entry[0]] = [long]$entry[1] }
if (-not $found.ContainsKey([uint32]$ExecutionInfo)) {
    "$Xex declares no title"
    return
}
$executionInfoAt = [int]$found[[uint32]$ExecutionInfo]
$titleId = Get-BE32 $data ($executionInfoAt + 12)

# The title's resource, out of the directory and the image.
if ($found.ContainsKey([uint32]$ResourceInfo)) {
    $resources = [int]$found[[uint32]$ResourceInfo]
    $fileFormat = [int]$found[[uint32]$FileFormatInfo]
    $size = [int](Get-BE32 $data $resources)
    $loadAddress = Get-BE32 $data ($security + $LoadAddress)
    $name = '{0:X8}' -f $titleId
    $kept = New-Object Collections.Generic.List[byte[]]
    for ($offset = $resources + 4; $offset -lt $resources + $size; $offset += $ResourceEntry) {
        $entry = [byte[]]$data[$offset..($offset + $ResourceEntry - 1)]
        if ([Text.Encoding]::ASCII.GetString($entry, 0, 8) -ne $name) {
            $kept.Add($entry)
            continue
        }
        $address = Get-BE32 $entry 8
        $length = [int](Get-BE32 $entry 12)
        $start = Get-ImageOffset $data $image $fileFormat $address $loadAddress
        $last = Get-ImageOffset $data $image $fileFormat ($address + $length - 1) $loadAddress
        if ($last -ne $start + $length - 1) { throw "${path}: the title's resource isn't stored in one piece" }
        Clear-Bytes $data ([int]$start) $length
    }
    Clear-Bytes $data ($resources + 4) ($size - 4)
    for ($i = 0; $i -lt $kept.Count; $i++) { [Array]::Copy($kept[$i], 0, $data, $resources + 4 + $ResourceEntry * $i, $ResourceEntry) }
    Set-BE32 $data $resources (4 + $ResourceEntry * $kept.Count)
}

# The execution info, out of the header directory.
Clear-Bytes $data $executionInfoAt $ExecutionInfoSize
$keptEntries = @($entries | Where-Object { $_[0] -ne $ExecutionInfo })
Set-BE32 $data 20 $keptEntries.Count
for ($i = 0; $i -lt $keptEntries.Count; $i++) {
    Set-BE32 $data (24 + 8 * $i) $keptEntries[$i][0]
    Set-BE32 $data (28 + 8 * $i) $keptEntries[$i][1]
}
Clear-Bytes $data (24 + 8 * $keptEntries.Count) (8 * ($count - $keptEntries.Count))

[Array]::Copy((Get-HeaderDigest $data $security $image), 0, $data, $security + $HeaderDigest, 20)
[IO.File]::WriteAllBytes($path, $data)
'Took title {0:X8} out of {1}' -f $titleId, $Xex
