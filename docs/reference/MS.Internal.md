# MS.Internal

Assembly: `System.Windows.dll`

| Type | Summary |
|---|---|
| [`HwndHost`](#hwndhost) | Infrastructure. Base class for an element that hosts a native window. Not for use by application code; the type is security critical. |

## HwndHost

`class MS.Internal.HwndHost`

Infrastructure. Base class for an element that hosts a native window. Not for use by application code; the type is security critical.

**Constructors**

| | |
|---|---|
| `HwndHost()` |  |

**Methods**

| | |
|---|---|
| `System.IntPtr BuildWindowCore(System.IntPtr hwndParent)` | When overridden in a derived class, creates the hosted native window. |
| `System.Void DestroyWindowCore(System.IntPtr hwnd)` | When overridden in a derived class, destroys the hosted native window. |

