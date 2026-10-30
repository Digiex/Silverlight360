using System;
using System.Runtime.InteropServices;
using System.Security;

namespace NativeProbe
{
    /// <summary>
    /// Calls into the console's kernel (xboxkrnl.exe) and system library
    /// (xam.xex). Xbox modules export by ordinal only, so the entry point is
    /// "#" and the ordinal, the way the platform's own assemblies import from
    /// agcore.dll and npctrl.dll.
    /// </summary>
    internal static class NativeMethods
    {
        // xam ordinal 0x282: DWORD XamGetSystemVersion()
        [DllImport("xam.xex", EntryPoint = "#642")]
        public static extern uint XamGetSystemVersion();

        // xam ordinal 0x3CB: DWORD XGetAVPack()
        [DllImport("xam.xex", EntryPoint = "#971")]
        public static extern uint XGetAVPack();

        // xam ordinal 0x3CD: DWORD XGetLanguage()
        [DllImport("xam.xex", EntryPoint = "#973")]
        public static extern uint XGetLanguage();

        // xboxkrnl ordinal 0x66: UCHAR KeGetCurrentProcessType()
        [DllImport("xboxkrnl.exe", EntryPoint = "#102")]
        public static extern byte KeGetCurrentProcessType();

        // xboxkrnl ordinal 0x84: VOID KeQuerySystemTime(PLARGE_INTEGER)
        [DllImport("xboxkrnl.exe", EntryPoint = "#132")]
        public static extern void KeQuerySystemTime(out long fileTime);

        // xam ordinal 0x227: DWORD XamUserGetSigninInfo(DWORD userIndex,
        //   DWORD flags, XUSER_SIGNIN_INFO*), a 0x28-byte structure
        [DllImport("xam.xex", EntryPoint = "#551")]
        public static extern uint XamUserGetSigninInfo(uint userIndex, uint flags, uint info);

        // The same export with the module named without its extension.
        [DllImport("xam", EntryPoint = "#642")]
        public static extern uint XamGetSystemVersionShortName();
    }

    /// <summary>The same call made from code marked security critical.</summary>
    internal static class CriticalNativeMethods
    {
        [DllImport("xam.xex", EntryPoint = "#642")]
        private static extern uint XamGetSystemVersion();

        [SecurityCritical]
        public static uint GetSystemVersion()
        {
            return XamGetSystemVersion();
        }
    }
}
