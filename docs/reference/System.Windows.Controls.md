# System.Windows.Controls

Assembly: `System.Windows.dll`

| Type | Summary |
|---|---|
| [`CursorEventArgs`](#cursoreventargs) | Provides data about the Kinect hand cursor: its position, which hand drives it and how far the arm is extended. |

## CursorEventArgs

`class System.Windows.Controls.CursorEventArgs`

Provides data about the Kinect hand cursor: its position, which hand drives it and how far the arm is extended.

**Properties**

| | |
|---|---|
| `System.Double ArmExtent { get; }` | Gets how far the user's arm is extended toward the sensor. |
| `System.Windows.Input.Handedness Handedness { get; }` | Gets which hand drives the cursor. |
| `System.Windows.Input.UserInformation UserInformation { get; }` | Gets the user whose hand drives the cursor. |

**Methods**

| | |
|---|---|
| `System.Windows.Point GetPosition(System.Windows.UIElement relativeTo)` | Returns the cursor position relative to an element. |

