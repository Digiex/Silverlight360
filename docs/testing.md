# Testing in xenia

`tools\Test-XboxApp.ps1` runs a built app in xenia, presses controller buttons at set times, takes screenshots of the xenia window and checks the log:

```powershell
.\tools\Test-XboxApp.ps1 -Xex .\samples\ui\FocusNavigation\bin\Release\xbox\default.xex `
    -Output $env:TEMP\focus-test `
    -Steps '14:shot','15:DPadRight','16:DPadDown','17:A','18:shot' -Seconds 20
```

Each step is `<second>:<button>` or `<second>:shot`. At the end it prints:

| | |
|---|---|
| `LastFrame` | The last frame number in the log. A low number means the app stalled. |
| `Crashed` | Whether the guest crashed. |
| `MissingExports` | Kernel or XAM functions the app called that xenia doesn't implement. |
| `Log` | The path to the full log. |

Buttons are sent as key messages to the xenia window only, so nothing reaches other windows. xenia runs with its keyboard input driver, and the D-pad, A and B are rebound to numpad keys. xenia's defaults for those need Shift or depend on the keyboard layout, which can't be sent to one window.

| Button | Key | Button | Key |
|---|---|---|---|
| A | numpad 5 | DPadUp/Down/Left/Right | numpad 8/2/4/6 |
| B | numpad 0 | LeftStickUp/Down/Left/Right | W/S/A/D |
| X | L | LeftShoulder, RightShoulder | 1, 3 |
| Y | P | LeftTrigger, RightTrigger | Q, E |
| Start | X | Back | Z |

Apps need about 12 seconds to show their first page in xenia. Start pressing buttons after that.

The script runs the `xenia_edge.exe` given with `-Xenia`, else the one in the `XENIA_EDGE` environment variable, else the one on `PATH`. `-ExtraArgs` passes more xenia options.

To test an app that reads the console's content (packages, saves) against a known set, give xenia a content folder of its own rather than changing yours:

```powershell
.\tools\Test-XboxApp.ps1 -Xex $xex -Output $env:TEMP\run -ExtraArgs "--content_root=$env:TEMP\testcontent"
```

The folder has the console's layout, `<XUID>\<title ID>\<content type>\<package>`, with common content under XUID `0000000000000000`. Copy the profile's folder in too, or the app runs with nobody signed in.

## Debug output

`System.Diagnostics.Debug.WriteLine`, `Debugger.Log` and `Console.WriteLine` don't throw, but their output goes nowhere: the CLR only passes debug output to an attached managed debugger. To log from C#, call the kernel's `DbgPrint` instead. `samples\Common\DebugLog.cs` wraps it:

```csharp
DebugLog.WriteLine("Loaded {0} items", items.Count);
```

xenia writes each line to its log as `(DbgPrint) Loaded 12 items`; a development kit shows it in its debug output. The text is passed as an argument to a `%s` format, so a `%` in it is printed as is. HelloXbox logs its start this way, and MediaPlayer logs every state change and failure.
