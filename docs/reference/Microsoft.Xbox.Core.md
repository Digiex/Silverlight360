# Microsoft.Xbox.Core

Assembly: `Microsoft.Xbox.Core.dll`

| Type | Summary |
|---|---|
| [`RuntimeExtensions`](#runtimeextensions) | Console-specific helpers for the Xbox 360 runtime. |

## RuntimeExtensions

`class Microsoft.Xbox.Core.RuntimeExtensions`

Console-specific helpers for the Xbox 360 runtime.

**Methods**

| | |
|---|---|
| `static System.Void SetThreadProcessorAffinity(System.Threading.Thread thread, System.Int32[] cpu)` | Restricts a managed thread to run on the specified hardware threads of the console's CPU. Use it to keep a background worker (decoding, parsing, networking) off the hardware thread that runs the UI. Forwards to the console runtime's `Thread.SetProcessorAffinity`, which validates the values. |

