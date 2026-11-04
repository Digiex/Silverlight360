#!/bin/bash
# Builds testlib.xex beside NativeLibrary.csproj with xsdk's toolchain and elf2xex, which needs --dll. In WSL:
#   bash native/build.sh
# XSDK is an xsdk checkout with elf2xex --dll, TOOLCHAIN the toolchain's prefix.
set -euo pipefail
cd "$(dirname "$0")"
XSDK=${XSDK:-$HOME/xsdk}
TOOLCHAIN=${TOOLCHAIN:-$HOME/xsdk-gcc/bin/powerpc-xsdk-elf-}

mkdir -p build
"${TOOLCHAIN}gcc" -mcpu=cell -fno-pic -std=gnu17 -O2 -ffreestanding -fno-asynchronous-unwind-tables \
	-fno-tree-loop-distribute-patterns -Wall -Wextra -Werror -c testlib.c -o build/testlib.o
"${TOOLCHAIN}gcc" -static -nostdlib -T testlib.ld -Wl,-Map,build/testlib.map -o build/testlib.elf build/testlib.o -lgcc
python3 "$XSDK/tools/elf2xex.py" --dll --base 8F000000 build/testlib.elf ../testlib.xex
echo "built $(realpath ../testlib.xex)"
