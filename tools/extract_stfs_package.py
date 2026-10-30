"""Extracts an STFS package (CON/LIVE/PIRS), such as a title update.

usage: extract_stfs_package.py <package> <output dir>

Follows xenia's StfsContainerDevice: the file table and every file are
chains of 0x1000-byte blocks, linked through level 0 hash tables that sit
between the data blocks.
"""
import os
import struct
import sys

BLOCK = 0x1000
PER_LEVEL = (0xAA, 0x70E4, 0x4AF768)
END_OF_CHAIN = 0xFFFFFF


def u24le(b):
    return b[0] | b[1] << 8 | b[2] << 16


class Stfs:
    def __init__(self, path):
        self.data = open(path, "rb").read()
        d = self.data
        if d[:4] not in (b"CON ", b"LIVE", b"PIRS"):
            raise ValueError("not an STFS package")
        self.content_type = struct.unpack_from(">I", d, 0x344)[0]
        self.title_id = struct.unpack_from(">I", d, 0x360)[0]
        self.header_size = struct.unpack_from(">I", d, 0x340)[0]
        self.base = (self.header_size + BLOCK - 1) & ~(BLOCK - 1)
        desc = d[0x379:0x379 + 0x24]
        flags = desc[2]
        self.read_only = bool(flags & 1)
        self.root_active = bool(flags & 2)
        self.table_blocks = struct.unpack_from("<H", desc, 3)[0]
        self.table_start = u24le(desc[5:8])
        self.total_blocks = struct.unpack_from(">I", desc, 0x1C)[0]
        self.per_table = 1 if self.read_only else 2
        self.step0 = PER_LEVEL[0] + self.per_table
        self.step1 = PER_LEVEL[1] + (PER_LEVEL[0] + 1) * self.per_table

    def block_to_offset(self, index):
        block = index
        for base in PER_LEVEL:
            block += ((index + base) // base) * self.per_table
            if index < base:
                break
        return self.base + (block << 12)

    def hash_block_number(self, index, level):
        if level == 2:
            return self.step1
        if index < PER_LEVEL[level]:
            return 0 if level == 0 else (self.step0 if level == 1 else self.step1)
        steps = (self.step0, self.step1)
        block = (index // PER_LEVEL[level]) * steps[level]
        if level == 0:
            block += ((index // PER_LEVEL[1]) + 1) * self.per_table
            if index < PER_LEVEL[1]:
                return block
        return block + self.per_table

    def next_block(self, index):
        # Walk down from the highest hash level so a writable package's
        # active (primary or secondary) table is used at each level.
        levels = 0
        while levels < 3 and self.total_blocks >= PER_LEVEL[levels]:
            levels += 1
        secondary = BLOCK if (self.root_active and not self.read_only) else 0
        if self.read_only:
            levels, secondary = 0, 0
        for level in range(levels, 0, -1):
            off = self.base + (self.hash_block_number(index, level) << 12) + secondary
            record = (index // PER_LEVEL[level - 1]) % PER_LEVEL[0]
            info = struct.unpack_from(">I", self.data, off + record * 0x18 + 0x14)[0]
            secondary = BLOCK if info & 0x40000000 else 0
        off = self.base + (self.hash_block_number(index, 0) << 12) + secondary
        record = index % PER_LEVEL[0]
        info = struct.unpack_from(">I", self.data, off + record * 0x18 + 0x14)[0]
        return info & 0xFFFFFF

    def read_chain(self, start, length):
        out = bytearray()
        index = start
        while len(out) < length and index != END_OF_CHAIN:
            off = self.block_to_offset(index)
            out += self.data[off:off + min(BLOCK, length - len(out))]
            index = self.next_block(index)
        if len(out) != length:
            raise ValueError("chain ended %d bytes short" % (length - len(out)))
        return bytes(out)

    def entries(self):
        table = self.read_chain(self.table_start, self.table_blocks * BLOCK)
        result = []
        for i in range(0, len(table), 0x40):
            e = table[i:i + 0x40]
            flags = e[0x28]
            name_length = flags & 0x3F
            if not name_length:
                continue
            result.append({
                "index": i // 0x40,
                "name": e[:name_length].decode("cp1252"),
                "directory": bool(flags & 0x80),
                "start": u24le(e[0x2F:0x32]),
                "parent": struct.unpack_from(">H", e, 0x32)[0],
                "length": struct.unpack_from(">I", e, 0x34)[0],
            })
        return result


def main():
    package, out = sys.argv[1], sys.argv[2]
    stfs = Stfs(package)
    entries = stfs.entries()
    by_index = {e["index"]: e for e in entries}

    def path_of(e):
        parts = [e["name"]]
        while e["parent"] != 0xFFFF:
            e = by_index[e["parent"]]
            parts.append(e["name"])
        return os.path.join(out, *reversed(parts))

    for e in entries:
        target = path_of(e)
        if e["directory"]:
            os.makedirs(target, exist_ok=True)
            continue
        os.makedirs(os.path.dirname(target), exist_ok=True)
        with open(target, "wb") as f:
            f.write(stfs.read_chain(e["start"], e["length"]))
        print("%9d  %s" % (e["length"], os.path.relpath(target, out)))
    print("title %08X, content type %08X, %d entries" % (
        stfs.title_id, stfs.content_type, len(entries)))


if __name__ == "__main__":
    main()
