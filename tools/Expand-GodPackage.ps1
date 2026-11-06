<#
.SYNOPSIS
Extracts the Games on Demand packages in app downloads into a folder each.

.DESCRIPTION
Each -Path is an app download (a .zip or .rar), a folder of them, or a
download already unpacked (a folder with no .zip or .rar in it). Every Games
on Demand package (content type 0x7000) found in it is extracted into
<Output>\<package title>, or <Output>\<package title> (<title ID>) when that
folder is taken. Other packages are skipped. A row for each package found,
and each download without one, is written as it's done.

Nothing needs installing: .NET unpacks a .zip and Windows' tar.exe a .rar
(Windows 11's opens RAR5 archives too). When tar.exe can't, the 7-Zip
tools\Configure.ps1 found is tried. Downloads are unpacked into a folder in
%TEMP%, which is removed after each.

A package is a disc image (SVOD) split into Data0000, Data0001... files in
the folder <header>.data beside its header. The block mapping follows
xenia's SvodContainerDevice.

.EXAMPLE
.\Expand-GodPackage.ps1 $env:USERPROFILE\Downloads\PlexApp_v0.0.1.7.zip -Output ..\apps
#>
param(
    [Parameter(Mandatory, Position = 0)] [string[]]$Path,
    [Parameter(Mandatory)] [string]$Output
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
if (-not ('Silverlight360.GodPackage' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Silverlight360 {
public sealed class GodPackage : IDisposable {
    static readonly byte[] MediaMagic = Encoding.ASCII.GetBytes("MICROSOFT*XBOX*MEDIA");
    const long Block = 0x800, HashBlock = 0x1000, BlocksPerL0 = 0x198, L0PerL1 = 0xA1C4;
    const long BlocksPerFile = 0x14388, MaxFileSize = 0xA290000;

    public uint ContentType, TitleId;
    public string Title, Layout;
    readonly bool egdf;
    readonly long startDataBlock, baseOffset, magic;
    readonly FileStream[] files;

    public GodPackage(string header) {
        byte[] h = new byte[0xB000];
        using (FileStream f = File.OpenRead(header)) ReadFully(f, h, 0, h.Length);
        ContentType = BE32(h, 0x344);
        TitleId = BE32(h, 0x360);
        string title = Encoding.BigEndianUnicode.GetString(h, 0x411, 0x80);
        Title = title.Split('\0')[0].Trim();
        uint count = BE32(h, 0x39D);
        egdf = (h[0x379 + 0x18] & 0x40) != 0;
        startDataBlock = h[0x379 + 0x1C] | h[0x379 + 0x1D] << 8 | h[0x379 + 0x1E] << 16;
        files = new FileStream[count];
        try {
            for (int i = 0; i < count; i++)
                files[i] = File.OpenRead(Path.Combine(header + ".data", string.Format("Data{0:D4}", i)));
            if (egdf) { Layout = "egdf"; baseOffset = 0; magic = 0x2000; }
            else if (IsMagic(0x12000)) { Layout = "xsf"; baseOffset = 0x10000; magic = 0x12000; }
            else if (count == 1 && IsMagic(0xD000)) { Layout = "single"; baseOffset = 0xB000; magic = 0xD000; }
            else { Layout = "multi"; baseOffset = 0; magic = 0x2000; }
            if (!IsMagic(magic)) throw new InvalidDataException("no media magic");
        } catch { Dispose(); throw; }
    }

    // Extracts every file and folder under dest, and gives the number of files.
    public int ExtractTo(string dest) {
        byte[] root = Read(0, magic + 0x14, 8);
        if (root.Length < 8) throw new InvalidDataException("short read");
        int count = 0;
        WalkDir(BitConverter.ToUInt32(root, 0), BitConverter.ToUInt32(root, 4), "", dest, ref count);
        return count;
    }

    void WalkDir(long block, long size, string path, string dest, ref int count) {
        byte[] data = ReadBlocks(block, size);
        HashSet<int> seen = new HashSet<int>();
        List<int> stack = new List<int> { 0 };
        while (stack.Count > 0) {
            int o = stack[stack.Count - 1];
            stack.RemoveAt(stack.Count - 1);
            if (seen.Contains(o) || o * 4 + 14 > data.Length) continue;
            seen.Add(o);
            int p = o * 4;
            int left = BitConverter.ToUInt16(data, p), right = BitConverter.ToUInt16(data, p + 2);
            if (left == 0xFFFF && right == 0xFFFF) continue;
            uint sector = BitConverter.ToUInt32(data, p + 4), length = BitConverter.ToUInt32(data, p + 8);
            byte attr = data[p + 12];
            int nameLength = Math.Min(data[p + 13], data.Length - (p + 14));
            StringBuilder name = new StringBuilder();
            for (int i = 0; i < nameLength; i++) {
                byte c = data[p + 14 + i];
                if (c < 0x20 || c > 0x7E || c == '/' || c == '\\') throw new InvalidDataException("bad entry name in " + path);
                name.Append((char)c);
            }
            string n = name.ToString();
            if (n == "." || n == "..") throw new InvalidDataException("bad entry name " + n);
            string full = path.Length > 0 ? path + "/" + n : n;
            string target = Path.Combine(dest, full.Replace('/', Path.DirectorySeparatorChar));
            if ((attr & 0x10) != 0) {
                Directory.CreateDirectory(target);
                if (length != 0) WalkDir(sector, length, full, dest, ref count);
            } else {
                Directory.CreateDirectory(Path.GetDirectoryName(target));
                using (FileStream f = File.Create(target)) {
                    long remaining = length, b = sector;
                    while (remaining > 0) {
                        long chunk = Math.Min(remaining, Block * 0x400);
                        byte[] bytes = ReadBlocks(b, chunk);
                        f.Write(bytes, 0, bytes.Length);
                        b += chunk / Block;
                        remaining -= chunk;
                    }
                }
                count++;
            }
            if (left != 0) stack.Add(left);
            if (right != 0) stack.Add(right);
        }
    }

    byte[] ReadBlocks(long block, long size) {
        MemoryStream output = new MemoryStream();
        while (output.Length < size) {
            long trueBlock = block - startDataBlock * 2;
            if (egdf) trueBlock += 2;
            long fileBlock = Mod(trueBlock, BlocksPerFile);
            long fileIndex = FloorDiv(trueBlock, BlocksPerFile);
            long l0 = fileBlock / BlocksPerL0 + 1;
            long offset = l0 * HashBlock + (l0 / L0PerL1 + 1) * HashBlock;
            if (Layout == "single") offset += baseOffset;
            long address = fileBlock * Block + offset;
            if (address >= MaxFileSize) {
                fileIndex++;
                address = address % MaxFileSize + 0x2000;
            }
            byte[] chunk = Read(fileIndex, address, (int)Math.Min(Block, size - output.Length));
            if (chunk.Length == 0) throw new InvalidDataException("short read");
            output.Write(chunk, 0, chunk.Length);
            block++;
        }
        return output.ToArray();
    }

    byte[] Read(long index, long offset, int size) {
        if (index < 0 || index >= files.Length) throw new InvalidDataException("block outside the data files");
        FileStream f = files[index];
        f.Position = offset;
        byte[] buffer = new byte[size];
        int read = ReadFully(f, buffer, 0, size);
        if (read < size) Array.Resize(ref buffer, read);
        return buffer;
    }

    bool IsMagic(long at) {
        byte[] b = Read(0, at, MediaMagic.Length);
        if (b.Length != MediaMagic.Length) return false;
        for (int i = 0; i < b.Length; i++) if (b[i] != MediaMagic[i]) return false;
        return true;
    }

    static int ReadFully(Stream s, byte[] buffer, int at, int size) {
        int total = 0, n;
        while (total < size && (n = s.Read(buffer, at + total, size - total)) > 0) total += n;
        return total;
    }
    static uint BE32(byte[] b, int at) {
        return (uint)(b[at] << 24 | b[at + 1] << 16 | b[at + 2] << 8 | b[at + 3]);
    }
    static long Mod(long a, long b) { long r = a % b; return r < 0 ? r + b : r; }
    static long FloorDiv(long a, long b) { return (a - Mod(a, b)) / b; }

    public void Dispose() {
        foreach (FileStream f in files) if (f != null) f.Dispose();
    }
}
}
'@
}

# Package headers: a file whose sibling folder is <file>.data and that starts like an STFS package.
function Find-PackageHeader([string]$Root) {
    foreach ($file in [IO.Directory]::GetFiles($Root)) {
        if (-not [IO.Directory]::Exists("$file.data")) { continue }
        $magic = New-Object byte[] 4
        $stream = [IO.File]::OpenRead($file)
        try { $read = $stream.Read($magic, 0, 4) } finally { $stream.Dispose() }
        if ($read -eq 4 -and [Text.Encoding]::ASCII.GetString($magic) -in 'LIVE', 'PIRS', 'CON ') { $file }
    }
    foreach ($dir in [IO.Directory]::GetDirectories($Root)) { Find-PackageHeader $dir }
}

function Get-SafeName([string]$Name) {
    $Name = ($Name -replace '[<>:"/\\|?*\x00-\x1f]', '_').Trim(' ', '.')
    if ($Name) { $Name } else { 'Unknown' }
}

function Expand-Download([string]$Archive, [string]$Into) {
    if ($Archive -match '\.zip$') {
        [IO.Compression.ZipFile]::ExtractToDirectory($Archive, $Into)
        return
    }
    New-Item -ItemType Directory $Into | Out-Null
    & "$env:SystemRoot\System32\tar.exe" -xf $Archive -C $Into 2>$null
    if ($LASTEXITCODE -eq 0) { return }
    $sevenZip = & (Join-Path $PSScriptRoot 'Config.ps1') SevenZip -Optional
    if (-not $sevenZip) { throw "tar.exe can't unpack it: install 7-Zip and run tools\Configure.ps1 again" }
    & $sevenZip x -y "-o$Into" $Archive | Out-Null
    if ($LASTEXITCODE) { throw "7-Zip can't unpack it (exit $LASTEXITCODE)" }
}

function Expand-Packages([string]$Root, [string]$Download, [string]$Fallback) {
    $found = $false
    foreach ($header in Find-PackageHeader $Root) {
        $found = $true
        $row = [pscustomobject]@{ Download = $Download; TitleId = '?'; Result = '' }
        $package = $null
        try {
            $package = New-Object Silverlight360.GodPackage $header
            $row.TitleId = '{0:X8}' -f $package.TitleId
            if ($package.ContentType -ne 0x7000) {
                $row.Result = 'skipped, content type {0:X}' -f $package.ContentType
                continue
            }
            $name = Get-SafeName $(if ($package.Title) { $package.Title } else { $Fallback })
            $dest = Join-Path $Output $name
            if (Test-Path -LiteralPath $dest) { $dest = Join-Path $Output ('{0} ({1:X8})' -f $name, $package.TitleId) }
            $count = $package.ExtractTo($dest)
            $row.Result = '{0} -> {1} ({2} files, {3} layout)' -f $package.Title, (Split-Path -Leaf $dest), $count, $package.Layout
        } catch {
            $e = $_.Exception
            if ($e.InnerException) { $e = $e.InnerException }
            $row.Result = "failed: $($e.Message)"
        } finally {
            if ($package) { $package.Dispose() }
            $row
        }
    }
    if (-not $found) { [pscustomobject]@{ Download = $Download; TitleId = '-'; Result = 'no packages found' } }
}

New-Item -ItemType Directory $Output -Force | Out-Null
$Output = (Resolve-Path -LiteralPath $Output).Path
foreach ($item in $Path) {
    $item = (Resolve-Path -LiteralPath $item).Path
    $downloads = if (Test-Path -LiteralPath $item -PathType Leaf) { , $item } else {
        [string[]]$all = [IO.Directory]::GetFiles($item) | Where-Object { $_ -match '\.(zip|rar)$' }
        if ($all) { [Array]::Sort($all, [StringComparer]::Ordinal) }
        $all
    }
    if (-not $downloads) {
        Expand-Packages $item (Split-Path -Leaf $item) (Split-Path -Leaf $item)
        continue
    }
    foreach ($download in $downloads) {
        $leaf = Split-Path -Leaf $download
        $stage = Join-Path ([IO.Path]::GetTempPath()) "Expand-GodPackage-$([guid]::NewGuid().ToString('N'))"
        try {
            Expand-Download $download $stage
            Expand-Packages $stage $leaf ([IO.Path]::GetFileNameWithoutExtension($leaf))
        } catch {
            [pscustomobject]@{ Download = $leaf; TitleId = '-'; Result = "couldn't unpack: $($_.Exception.Message)" }
        } finally {
            if (Test-Path -LiteralPath $stage) { Remove-Item -LiteralPath $stage -Recurse -Force }
        }
    }
}
