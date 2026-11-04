/* Lays testlib out for xsdk's elf2xex --dll, as xsdk's src/xsdk.ld lays out a title: read-only, code and writable data
   each on their own 64 KB pages. */
OUTPUT_FORMAT("elf32-powerpc")
OUTPUT_ARCH(powerpc:common)
ENTRY(testlib_entry)

SECTIONS
{
	/* Clear of the title (0x82000000) and the runtime's modules. Under xenia-edge the last of those ends at 0x8B860000,
	   but a console (2.0.17559) running a Silverlight app has 0x8A000000, 0x8C000000 and 0x8E000000 taken: XexLoadImage
	   answers STATUS_CONFLICTING_ADDRESSES there, and loads at 0x8D000000 and 0x8F000000. elf2xex --base must say
	   the same. */
	. = 0x8F000000 + 0x1000;
	.rdata : {
		*(.rodata .rodata.* .sdata2 .sdata2.* .sbss2 .sbss2.*)
	}

	. = ALIGN(0x10000);
	.text : {
		*(.text .text.*)
	}

	. = ALIGN(0x10000);
	.data : {
		*(.data .data.* .sdata .sdata.*)
	}
	.bss : {
		*(.sbss .sbss.* .bss .bss.* COMMON)
	}

	.xsdk.exports 0 : {
		KEEP(*(.xsdk.exports))
	}

	/DISCARD/ : {
		*(.comment .note.* .gnu.attributes .eh_frame)
	}
}
