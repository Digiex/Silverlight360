# System.Windows

Assembly: `System.Windows.dll`

| Type | Summary |
|---|---|
| [`CurrentHoverProgressToPathDataConverter`](#currenthoverprogresstopathdataconverter) | Converts a hover progress value (0 to 1) into an arc geometry, for drawing a circular hover-progress indicator in a button template. |

## CurrentHoverProgressToPathDataConverter

`class System.Windows.CurrentHoverProgressToPathDataConverter`

Converts a hover progress value (0 to 1) into an arc geometry, for drawing a circular hover-progress indicator in a button template.

Bind a `Path`'s Data to `Button.CurrentHoverProgress` through this converter and pass the circle radius as the ConverterParameter. The arc starts at (radius, 0) and sweeps clockwise around (0,0); a progress of 1 is a full circle. ConvertBack is not supported.

**Constructors**

| | |
|---|---|
| `CurrentHoverProgressToPathDataConverter()` |  |

**Methods**

| | |
|---|---|
| `System.Object Convert(System.Object value, System.Type targetType, System.Object parameter, System.Globalization.CultureInfo culture)` |  |
| `System.Object ConvertBack(System.Object value, System.Type targetType, System.Object parameter, System.Globalization.CultureInfo culture)` |  |

