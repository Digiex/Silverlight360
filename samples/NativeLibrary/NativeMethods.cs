using System;
using System.Runtime.InteropServices;

namespace NativeLibrary
{
    /// <summary>
    /// The kernel's module loader, to check the module the CLR loaded and look
    /// its exports up by ordinal (ordinals from xenia's
    /// src/xenia/kernel/xboxkrnl/xboxkrnl_table.inc).
    /// </summary>
    internal static class Kernel
    {
        // XexLoadImage's flags: a DLL (0x8) of the title's process (0x1), as the CLR loads testlib (xcoreclr.dll
        // 0x84F1FC40). Without 0x1 a title asks for a system process's module, which the kernel refuses with
        // STATUS_ACCESS_DENIED (xboxkrnl 2.0.17559, 0x80078F40).
        public const uint LoadDll = 0x00000009;

        // xboxkrnl ordinal 0x195: NTSTATUS XexGetModuleHandle(PCSZ name, HANDLE* module)
        [DllImport("xboxkrnl.exe", EntryPoint = "#405", CharSet = CharSet.Ansi)]
        public static extern int XexGetModuleHandle(string name, out uint module);

        // xboxkrnl ordinal 0x197: NTSTATUS XexGetProcedureAddress(HANDLE module, DWORD ordinal, PVOID* address)
        [DllImport("xboxkrnl.exe", EntryPoint = "#407")]
        public static extern int XexGetProcedureAddress(uint module, uint ordinal, out uint address);

        // xboxkrnl ordinal 0x199: NTSTATUS XexLoadImage(PCSZ name, DWORD flags, DWORD minVersion, HANDLE* module)
        [DllImport("xboxkrnl.exe", EntryPoint = "#409", CharSet = CharSet.Ansi)]
        public static extern int XexLoadImage(string name, uint flags, uint minVersion, out uint module);
    }

    /// <summary>
    /// testlib.xex's exports (native\testlib.c), by the ordinals it gives
    /// them. The CLR loads the module from the package folder, beside
    /// default.xex, at the first call; under xenia-edge that's
    /// \Device\Package_0\testlib.xex.
    /// </summary>
    internal static class TestLib
    {
        public const string Module = "testlib.xex";
        // The path the CLR loads it by: GAME:\ before a bare name (xcoreclr.dll 0x84F1FB5C). Asked for by that path, a
        // console's kernel hands back the module the CLR loaded.
        public const string Path = @"GAME:\" + Module;
        // TESTLIB_VERSION in native\testlib.c.
        public const uint ExpectedVersion = 0x7E570001;

        [DllImport(Module, EntryPoint = "#1")]
        public static extern uint Version();

        [DllImport(Module, EntryPoint = "#2")]
        public static extern uint Add(uint a, uint b);

        [DllImport(Module, EntryPoint = "#3")]
        public static extern ulong Add64(ulong a, ulong b);

        // bytes is a guest address, as from NativeBuffer.
        [DllImport(Module, EntryPoint = "#4")]
        public static extern uint SumAndFill(uint bytes, uint count, uint seed);

        [DllImport(Module, EntryPoint = "#5")]
        public static extern uint Calls();
    }
}
