/* A DLL for the NativeLibrary sample: exports whose results the app can check, one through a pointer it passes. */
#include <stdint.h>

/* An export record for elf2xex --dll: the ordinal, then the address, in a section that isn't loaded, as xsdk's import
   records are (xsdk tools/gen_imports.py). */
#define TESTLIB_EXPORT(ordinal, function) \
	__asm__("\t.section .xsdk.exports, \"\"\n\t.long " #ordinal "\n\t.long " #function "\n\t.previous")

#define TESTLIB_VERSION 0x7E570001u

/* The library's read-only data, so the image starts with it after the headers: elf2xex takes the first section's page
   for the base the ELF was linked at, and refuses an image whose code comes first, a page later. */
__attribute__((used)) static const char testlib_name[] = "testlib";

/* In .bss, so the library's writable page is mapped and kept between calls. */
static uint32_t calls;

uint32_t testlib_version(void)
{
	calls++;
	return TESTLIB_VERSION;
}

uint32_t testlib_add(uint32_t a, uint32_t b)
{
	calls++;
	return a + b;
}

uint64_t testlib_add64(uint64_t a, uint64_t b)
{
	calls++;
	return a + b;
}

/* Returns the sum of the bytes, then overwrites each with its index plus seed. */
uint32_t testlib_sum_and_fill(uint8_t *bytes, uint32_t count, uint32_t seed)
{
	calls++;
	uint32_t sum = 0;
	for (uint32_t i = 0; i < count; i++) {
		sum += bytes[i];
		bytes[i] = (uint8_t)(i + seed);
	}
	return sum;
}

uint32_t testlib_calls(void)
{
	return calls;
}

/* The loader calls a DLL's entry point as DllMain (xenia:src/xenia/kernel/kernel_state.cc:783); nothing to set up. */
uint32_t testlib_entry(void *module, uint32_t reason, void *reserved)
{
	(void)module;
	(void)reason;
	(void)reserved;
	return 1;
}

TESTLIB_EXPORT(1, testlib_version);
TESTLIB_EXPORT(2, testlib_add);
TESTLIB_EXPORT(3, testlib_add64);
TESTLIB_EXPORT(4, testlib_sum_and_fill);
TESTLIB_EXPORT(5, testlib_calls);
