using System;
using System.Globalization;
using System.Runtime.InteropServices;

namespace XboxSdk.Samples
{
    /// <summary>
    /// Writes debug output through the kernel's DbgPrint. Debug.WriteLine,
    /// Debugger.Log and Console write nowhere on the console: the CLR only
    /// passes debug output on to an attached managed debugger. DbgPrint shows
    /// up in xenia's log as "(DbgPrint) ..." and on a development kit in its
    /// debug output.
    /// </summary>
    public static class DebugLog
    {
        // xboxkrnl ordinal 3: ULONG DbgPrint(PCSZ format, ...)
        [DllImport("xboxkrnl.exe", EntryPoint = "#3", CharSet = CharSet.Ansi)]
        private static extern int DbgPrint(string format, string text);

        public static void WriteLine(string text)
        {
            // The text goes in as an argument, so a % in it is printed as is.
            DbgPrint("%s\n", text ?? "");
        }

        public static void WriteLine(string format, params object[] args)
        {
            WriteLine(string.Format(CultureInfo.InvariantCulture, format, args));
        }
    }
}
