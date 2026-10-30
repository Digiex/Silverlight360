# Native code

App code can call the console's kernel and system library directly with `DllImport`; `samples\NativeProbe` does. Xbox modules export by ordinal only, so name the module and give the ordinal as `#<decimal ordinal>`, the way the platform's own assemblies import from `agcore.dll` and `npctrl.dll`:

```csharp
using System.Runtime.InteropServices;

static class NativeMethods
{
    // xam ordinal 0x282: DWORD XamGetSystemVersion()
    [DllImport("xam.xex", EntryPoint = "#642")]
    public static extern uint XamGetSystemVersion();

    // xboxkrnl ordinal 0x84: VOID KeQuerySystemTime(PLARGE_INTEGER)
    [DllImport("xboxkrnl.exe", EntryPoint = "#132")]
    public static extern void KeQuerySystemTime(out long fileTime);
}
```

What the probe found under xenia-edge:

- **No special permission needed:** plain app code may call these, with no `[SecurityCritical]` or other attribute.
- **Module names:** `xam.xex` (or `xam`) and `xboxkrnl.exe` both resolve.
- **Data layout:** the process is big-endian PowerPC, so integers, `out`/`ref` parameters and pointers are already in the layout the kernel expects. Pointers are 32-bit.
- **A wrong entry point doesn't throw.** A name instead of an ordinal, or a wrong ordinal, becomes a call through a null pointer, and XamlHost quits. Take ordinals from xenia's `src/xenia/kernel/xam/xam_table.inc` and `src/xenia/kernel/xboxkrnl/xboxkrnl_table.inc`.

## Structures and pointers

Many kernel and XAM calls take structures, or fill a buffer with structures that point into the same buffer (enumerators, profile settings, achievements). `Marshal.AllocHGlobal` isn't public on this runtime, but a pinned array is:

```csharp
byte[] bytes = new byte[0x28];
GCHandle pin = GCHandle.Alloc(bytes, GCHandleType.Pinned);
try
{
    uint address = (uint)pin.AddrOfPinnedObject().ToInt32();
    // 0x227: DWORD XamUserGetSigninInfo(DWORD userIndex, DWORD flags, XUSER_SIGNIN_INFO*)
    if (XamUserGetSigninInfo(0, 0, address) == 0)
    {
        ulong xuid = (ulong)BigEndian.U32(bytes, 0) << 32 | BigEndian.U32(bytes, 4);
    }
}
finally
{
    pin.Free();
}
```

with the pointer parameter declared as `uint`. What the probes found:

- **Addresses are guest addresses.** `AddrOfPinnedObject` gives the address the kernel sees, and a pointer the kernel writes into the buffer can be turned back into an offset by subtracting it.
- **Fields are big-endian**, so read and write them byte by byte rather than with `BitConverter`.
- **`unsafe` code works too**, with `<AllowUnsafeBlocks>true</AllowUnsafeBlocks>`: `fixed`, `stackalloc` and pointer casts to `uint` all run.
- **64-bit arguments** such as XUIDs pass as `ulong`.
- **Keep arrays pinned only for the call.** A pinned array stops the garbage collector from compacting around it.
- **A wrong parameter list doesn't throw.** A missing parameter shifts the rest, and the native side writes through whatever lands in a pointer's place: under xenia-edge that's a host crash. `XamUserGetXUID`, for one, takes a type mask before the XUID pointer. Check signatures against xenia's `*_entry` functions.

`samples\Common\NativeBuffer.cs` wraps this pattern, with big-endian readers and writers and lookups for the strings and pointers in returned buffers.

## How the platform reaches native code

The framework itself calls native code in these ways:

1. **`agcore.dll` by ordinal:** `System.Windows`' `MS.Internal.XcpImports`, for UI, media, DRM and downloads.
2. **`npctrl.dll` by ordinal:** `Microsoft.Xbox` classes (`VuiManager`, `Kinect`, `Companion`, `MediaTransport`, `MediaCapabilities`, `DeviceDiscovery`, ...) and `System.Windows`' output protection.
3. **XamlHost extensions by name:** `DllImport("Net"|"STORAGE"|"AUDIO"|"MEDIA"|..., EntryPoint = "Name")`. XamlHost registers a table of named functions per extension at startup. Gamer services go through one of them, `Net!GamerServices_DispatchCommand_Entrypoint`, which takes a command number.
4. **`xadvertising.xex` by ordinal:** the advertising SDK.
5. **The CLR's internal calls** into `xcoreclr.dll`.

App code could call the XamlHost extensions the same way, but that hasn't been tried; their signatures have to be read from the decompiled `Microsoft.Xbox.*` assemblies.
