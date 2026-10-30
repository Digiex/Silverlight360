"""Extracts every Games on Demand package in the app archives.

usage: extract_god_packages.py <archive dir> <output dir> <staging dir>

7-Zip is found through the SEVEN_ZIP environment variable, PATH or its
default install folder. Each archive is unpacked with it into the staging
dir, every GOD package
(content type 0x7000) in it is extracted into <output>/<package title>, and
the staging copy is removed. Other packages are skipped. The SVOD block
mapping follows xenia's SvodContainerDevice.
"""
import os
import re
import shutil
import struct
import subprocess
import sys

MEDIA_MAGIC = b"MICROSOFT*XBOX*MEDIA"
BLOCK = 0x800
HASH_BLOCK = 0x1000
BLOCKS_PER_L0 = 0x198
L0_PER_L1 = 0xA1C4
BLOCKS_PER_FILE = 0x14388
MAX_FILE_SIZE = 0xA290000


class God:
    def __init__(self, header_path):
        with open(header_path, "rb") as f:
            h = f.read(0xB000)
        self.content_type = struct.unpack_from(">I", h, 0x344)[0]
        self.title_id = struct.unpack_from(">I", h, 0x360)[0]
        self.title = h[0x411:0x411 + 0x80].decode("utf-16-be", "ignore")
        self.title = self.title.split("\0")[0].strip()
        self.data_file_count = struct.unpack_from(">I", h, 0x39D)[0]
        desc = h[0x379:0x379 + 0x24]
        self.egdf = bool(desc[0x18] & 0x40)
        self.start_data_block = desc[0x1C] | desc[0x1D] << 8 | desc[0x1E] << 16
        data_dir = header_path + ".data"
        self.files = [open(os.path.join(data_dir, "Data%04d" % i), "rb")
                      for i in range(self.data_file_count)]
        self._set_layout()

    def _read_raw(self, index, offset, size):
        f = self.files[index]
        f.seek(offset)
        return f.read(size)

    def _set_layout(self):
        if self.egdf:
            self.layout, self.base, self.magic = "egdf", 0, 0x2000
        elif self._read_raw(0, 0x12000, 20) == MEDIA_MAGIC:
            self.layout, self.base, self.magic = "xsf", 0x10000, 0x12000
        elif (self.data_file_count == 1 and
              self._read_raw(0, 0xD000, 20) == MEDIA_MAGIC):
            self.layout, self.base, self.magic = "single", 0xB000, 0xD000
        else:
            self.layout, self.base, self.magic = "multi", 0, 0x2000
        if self._read_raw(0, self.magic, 20) != MEDIA_MAGIC:
            raise ValueError("no media magic")

    def block_to_offset(self, block):
        true_block = block - self.start_data_block * 2
        if self.layout == "egdf":
            true_block += 2
        file_block = true_block % BLOCKS_PER_FILE
        file_index = true_block // BLOCKS_PER_FILE
        l0 = file_block // BLOCKS_PER_L0 + 1
        offset = l0 * HASH_BLOCK + (l0 // L0_PER_L1 + 1) * HASH_BLOCK
        if self.layout == "single":
            offset += self.base
        address = file_block * BLOCK + offset
        if address >= MAX_FILE_SIZE:
            file_index += 1
            address = address % MAX_FILE_SIZE + 0x2000
        return file_index, address

    def read(self, block, size):
        out = bytearray()
        while len(out) < size:
            index, address = self.block_to_offset(block)
            chunk = self._read_raw(index, address, min(BLOCK, size - len(out)))
            if not chunk:
                raise ValueError("short read")
            out += chunk
            block += 1
        return bytes(out)

    def walk(self):
        root, size = struct.unpack_from("<II", self._read_raw(0, self.magic + 0x14, 8))
        yield from self._walk_dir(root, size, "")

    def _walk_dir(self, block, size, path):
        data = self.read(block, size)
        seen, stack = set(), [0]
        while stack:
            o = stack.pop()
            if o in seen or o * 4 + 14 > len(data):
                continue
            seen.add(o)
            p = o * 4
            left, right, sector, length, attr, nlen = struct.unpack_from(
                "<HHIIBB", data, p)
            if left == 0xFFFF and right == 0xFFFF:
                continue
            name = data[p + 14:p + 14 + nlen].decode("ascii")
            if not name.isprintable() or "/" in name or "\\" in name:
                raise ValueError("bad entry name %r" % name)
            full = path + "/" + name if path else name
            if attr & 0x10:
                yield full, None, None
                if length:
                    yield from self._walk_dir(sector, length, full)
            else:
                yield full, sector, length
            if left:
                stack.append(left)
            if right:
                stack.append(right)

    def close(self):
        for f in self.files:
            f.close()


def sanitize(name):
    name = re.sub(r'[<>:"/\\|?*\x00-\x1f]', "_", name).strip(" .")
    return name or "Unknown"


def find_headers(root):
    for dirpath, _, files in os.walk(root):
        for f in files:
            p = os.path.join(dirpath, f)
            if os.path.isdir(p + ".data"):
                with open(p, "rb") as fh:
                    if fh.read(4) in (b"LIVE", b"PIRS", b"CON "):
                        yield p


def find_seven_zip():
    candidates = [os.environ.get("SEVEN_ZIP"), shutil.which("7z")]
    if os.environ.get("ProgramFiles"):
        candidates.append(os.path.join(os.environ["ProgramFiles"], "7-Zip", "7z.exe"))
    for c in candidates:
        if c and os.path.isfile(c):
            return c
    sys.exit("7-Zip not found: set SEVEN_ZIP to 7z.exe or put it on PATH")


def main():
    src, out_root, staging = sys.argv[1:4]
    seven_zip = find_seven_zip()
    report = []
    for archive in sorted(os.listdir(src)):
        if not archive.lower().endswith((".zip", ".rar")):
            continue
        stage = os.path.join(staging, "stage")
        shutil.rmtree(stage, ignore_errors=True)
        r = subprocess.run([seven_zip, "x", "-y", "-o" + stage,
                            os.path.join(src, archive)], capture_output=True)
        if r.returncode:
            report.append((archive, "-", "archive failed to unpack"))
            continue
        found = False
        for header in find_headers(stage):
            god = None
            try:
                god = God(header)
                if god.content_type != 0x7000:
                    report.append((archive, "%08X" % god.title_id,
                                   "skipped, content type %X" % god.content_type))
                    continue
                found = True
                name = sanitize(god.title or os.path.splitext(archive)[0])
                dest = os.path.join(out_root, name)
                if os.path.exists(dest):
                    dest = os.path.join(out_root, "%s (%08X)" % (name, god.title_id))
                count = 0
                for path, sector, length in god.walk():
                    target = os.path.join(dest, *path.split("/"))
                    if sector is None:
                        os.makedirs(target, exist_ok=True)
                        continue
                    os.makedirs(os.path.dirname(target), exist_ok=True)
                    with open(target, "wb") as f:
                        remaining, block = length, sector
                        while remaining:
                            n = min(remaining, 0x800 * 0x400)
                            f.write(god.read(block, n))
                            block += n // BLOCK
                            remaining -= n
                    count += 1
                report.append((archive, "%08X" % god.title_id,
                               "%s -> %s (%d files, %s layout)" % (
                                   god.title, os.path.basename(dest), count, god.layout)))
            except Exception as e:  # noqa: BLE001 - report and keep going
                report.append((archive, "?", "failed: %s" % e))
            finally:
                if god:
                    god.close()
        if not found and not any(r[0] == archive for r in report):
            report.append((archive, "-", "no packages found"))
        shutil.rmtree(stage, ignore_errors=True)
        print(report[-1] if report else archive, flush=True)
    with open(os.path.join(staging, "extract_report.txt"), "w", encoding="utf-8") as f:
        for row in report:
            f.write("\t".join(row) + "\n")


if __name__ == "__main__":
    main()
