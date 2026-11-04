using System;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows;
using System.Windows.Media.Imaging;

namespace XboxSdk.Samples
{
    /// <summary>
    /// Saves what the app shows as a file in its own folder (game:), for test
    /// scripts: Silverlight draws the root visual into a bitmap, as it draws
    /// the screen, and its pixels go to game:\&lt;name&gt;.argb a row at a time,
    /// four bytes each (alpha, red, green, blue; premultiplied), the format of
    /// Silverdash360's ui.screenshot. The log line "screenshot
    /// game:\&lt;name&gt;.argb &lt;width&gt;x&lt;height&gt;" gives the size. What
    /// Silverlight doesn't draw (the Guide, notifications, video the player
    /// shows itself) is missing. Under xenia the folder is writable only with
    /// --allow_game_relative_writes. Call it on the UI thread.
    /// </summary>
    public static class Screenshot
    {
        // xboxkrnl 0xD2: NTSTATUS NtCreateFile(PHANDLE, ACCESS_MASK, POBJECT_ATTRIBUTES,
        //   PIO_STATUS_BLOCK, PLARGE_INTEGER allocationSize, ULONG attributes,
        //   ULONG shareAccess, ULONG disposition, ULONG createOptions)
        [DllImport("xboxkrnl.exe", EntryPoint = "#210")]
        private static extern int NtCreateFile(out uint handle, uint access, uint objectAttributes, uint ioStatus,
                                               uint allocationSize, uint attributes, uint share, uint disposition,
                                               uint options);

        // 0xFF: NTSTATUS NtWriteFile(HANDLE, HANDLE event, PVOID apc, PVOID apcContext,
        //   PIO_STATUS_BLOCK, PVOID buffer, ULONG length, PLARGE_INTEGER offset)
        [DllImport("xboxkrnl.exe", EntryPoint = "#255")]
        private static extern int NtWriteFile(uint handle, uint ev, uint apc, uint apcContext, uint ioStatus,
                                              uint buffer, uint length, uint offset);

        // 0xCF: NTSTATUS NtClose(HANDLE)
        [DllImport("xboxkrnl.exe", EntryPoint = "#207")]
        private static extern int NtClose(uint handle);

        private const uint GenericWrite = 0x40000000, Synchronize = 0x00100000;
        private const uint FileAttributeNormal = 0x80, FileOverwriteIf = 5;
        private const uint FileSynchronousIoNonAlert = 0x20, FileNonDirectoryFile = 0x40;
        private const uint ObjCaseInsensitive = 0x40;

        /// <summary>Saves game:\&lt;name&gt;.argb; false (and a log line) when it couldn't.</summary>
        public static bool Save(string name)
        {
            string path = "game:\\" + name + ".argb";
            try
            {
                WriteableBitmap bitmap = new WriteableBitmap(Application.Current.RootVisual, null);
                int[] pixels = bitmap.Pixels;
                // An int's bytes in memory, the console being big-endian: alpha, red, green, blue.
                using (NativeBuffer data = new NativeBuffer(pixels.Length * 4))
                {
                    Buffer.BlockCopy(pixels, 0, data.Bytes, 0, pixels.Length * 4);
                    int status = Write(path, data);
                    if (status != 0)
                    {
                        DebugLog.WriteLine("screenshot " + path + " failed: status 0x" + status.ToString("X8"));
                        return false;
                    }
                }
                DebugLog.WriteLine("screenshot " + path + " " + bitmap.PixelWidth + "x" + bitmap.PixelHeight);
                return true;
            }
            catch (Exception e)
            {
                DebugLog.WriteLine("screenshot " + path + " failed: " + e.Message);
                return false;
            }
        }

        private static int Write(string path, NativeBuffer data)
        {
            byte[] name = Encoding.UTF8.GetBytes(path);
            // OBJECT_ATTRIBUTES {root, ANSI_STRING*, attributes} at 0, the ANSI_STRING {length, maximum,
            // buffer} at 12, the IO_STATUS_BLOCK at 20, the write offset (0) at 28, the name at 36.
            using (NativeBuffer call = new NativeBuffer(36 + name.Length + 1))
            {
                Buffer.BlockCopy(name, 0, call.Bytes, 36, name.Length);
                call.SetU32(4, call[12]);
                call.SetU32(8, ObjCaseInsensitive);
                call.SetU16(12, (ushort)name.Length);
                call.SetU16(14, (ushort)(name.Length + 1));
                call.SetU32(16, call[36]);
                uint handle;
                int status = NtCreateFile(out handle, GenericWrite | Synchronize, call[0], call[20], 0,
                                          FileAttributeNormal, 0, FileOverwriteIf,
                                          FileSynchronousIoNonAlert | FileNonDirectoryFile);
                if (status != 0)
                {
                    return status;
                }
                status = NtWriteFile(handle, 0, 0, 0, call[20], data.Address, (uint)data.Length, call[28]);
                NtClose(handle);
                return status;
            }
        }
    }
}
