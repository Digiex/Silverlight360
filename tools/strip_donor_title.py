"""Takes the donor app's title out of a runtime profile's default.xex.

usage: strip_donor_title.py <default.xex>

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
"""
import hashlib
import struct
import sys

MAGIC = b"XEX2"
RESOURCE_INFO = 0x000002FF
FILE_FORMAT_INFO = 0x000003FF
EXECUTION_INFO = 0x00040006
EXECUTION_INFO_SIZE = 0x18
RESOURCE_ENTRY = 0x10
# In the security info.
LOAD_ADDRESS = 0x110
HEADER_DIGEST = 0x164
DIGESTED_FROM = 0x17C
SIGNED_FROM = 8
NO_COMPRESSION = 0
BASIC_COMPRESSION = 1


def header_digest(data, security, image):
    sha = hashlib.sha1()
    sha.update(data[security + DIGESTED_FROM:image])
    sha.update(data[:security + SIGNED_FROM])
    return sha.digest()


def headers(data):
    count = struct.unpack_from(">I", data, 20)[0]
    return [struct.unpack_from(">II", data, 24 + 8 * i) for i in range(count)]


def image_offset(data, image, file_format, address, load_address):
    """Where an address in the image is in the file."""
    encryption, compression = struct.unpack_from(">HH", data, file_format + 4)
    if encryption != 0:
        raise ValueError("the image is encrypted")
    at = address - load_address
    if compression == NO_COMPRESSION:
        return image + at
    if compression != BASIC_COMPRESSION:
        raise ValueError("the image is compressed")
    size = struct.unpack_from(">I", data, file_format)[0]
    stored = image
    loaded = 0
    for offset in range(file_format + 8, file_format + size, 8):
        data_size, zero_size = struct.unpack_from(">II", data, offset)
        if loaded <= at < loaded + data_size:
            return stored + at - loaded
        stored += data_size
        loaded += data_size + zero_size
    raise ValueError("%#x isn't stored in the image" % address)


def strip(data):
    """The executable without the title, and the title ID; None when it declares none."""
    data = bytearray(data)
    magic, _, image, _, security, count = struct.unpack_from(">4sIIIII", data, 0)
    if magic != MAGIC:
        raise ValueError("not an XEX2 executable")
    if bytes(data[security + HEADER_DIGEST:security + HEADER_DIGEST + 20]) != header_digest(data, security, image):
        raise ValueError("the header digest doesn't match the header")
    entries = headers(data)
    found = dict(entries)
    if EXECUTION_INFO not in found:
        return None
    execution_info = found[EXECUTION_INFO]
    title_id = struct.unpack_from(">I", data, execution_info + 12)[0]

    # The title's resource, out of the directory and the image.
    if RESOURCE_INFO in found:
        resources = found[RESOURCE_INFO]
        size = struct.unpack_from(">I", data, resources)[0]
        load_address = struct.unpack_from(">I", data, security + LOAD_ADDRESS)[0]
        name = b"%08X" % title_id
        kept = []
        for offset in range(resources + 4, resources + size, RESOURCE_ENTRY):
            entry = bytes(data[offset:offset + RESOURCE_ENTRY])
            if entry[:8] != name:
                kept.append(entry)
                continue
            address, length = struct.unpack_from(">II", entry, 8)
            start = image_offset(data, image, found[FILE_FORMAT_INFO], address, load_address)
            if image_offset(data, image, found[FILE_FORMAT_INFO], address + length - 1, load_address) != start + length - 1:
                raise ValueError("the title's resource isn't stored in one piece")
            data[start:start + length] = bytes(length)
        data[resources + 4:resources + size] = b"".join(kept) + bytes(size - 4 - RESOURCE_ENTRY * len(kept))
        struct.pack_into(">I", data, resources, 4 + RESOURCE_ENTRY * len(kept))

    # The execution info, out of the header directory.
    data[execution_info:execution_info + EXECUTION_INFO_SIZE] = bytes(EXECUTION_INFO_SIZE)
    kept = [e for e in entries if e[0] != EXECUTION_INFO]
    struct.pack_into(">I", data, 20, len(kept))
    for i, (key, value) in enumerate(kept):
        struct.pack_into(">II", data, 24 + 8 * i, key, value)
    data[24 + 8 * len(kept):24 + 8 * count] = bytes(8 * (count - len(kept)))

    data[security + HEADER_DIGEST:security + HEADER_DIGEST + 20] = header_digest(data, security, image)
    return bytes(data), title_id


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    path = sys.argv[1]
    with open(path, "rb") as f:
        stripped = strip(f.read())
    if stripped is None:
        print("%s declares no title" % path)
        return
    data, title_id = stripped
    with open(path, "wb") as f:
        f.write(data)
    print("Took title %08X out of %s" % (title_id, path))


if __name__ == "__main__":
    main()
