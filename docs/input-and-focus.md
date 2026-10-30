# Input and focus

## Controller events

The Xbox runtime adds controller events to every `UIElement` (`System.Windows`, namespace `System.Windows.Input`):

| Event | Arguments |
|---|---|
| `GamePadButtonDown`, `GamePadButtonUp` | `GamePadButtonEventArgs.Button`: A, B, X, Y, the D-pad directions, the shoulders, Start, Back, and the stick clicks. |
| `GamePadThumbStickMoved` | `Side` (left or right), `XPosition` and `YPosition`. Each runs from -1 to 1; Y is positive up. |
| `GamePadTriggerMoved` | `Side`, `Position` from 0 (released) to 1 (fully pulled). |
| `MediaCommand` | `MediaCommandEventArgs.MediaCommand`: play, pause, fast forward and the rest, from a media remote. |

They are **routed events**: raised on the element with focus, then bubbling up through its parents, like `KeyDown`. Set `e.Handled = true` to stop one. The guide button never reaches apps.

```csharp
GamePadButtonDown += delegate(object sender, GamePadButtonEventArgs e)
{
    if (e.Button == GamePadButton.Y)
    {
        ShowDetails();
        e.Handled = true;
    }
};
```

`GamePadButtonDownEvent` and `GamePadButtonUpEvent` are also exposed as `RoutedEvent`s, for `AddHandler(..., handledEventsToo: true)`. The stick and trigger events aren't.

`samples\ui\GamepadInput` shows every event live.

## Focus

**With nothing focused, no element gets controller input.** A `UserControl` isn't focusable by default, so either set `IsTabStop = true` on it and call `Focus()`, or focus a control, in `Loaded` or `OnNavigatedTo`:

```csharp
Loaded += delegate { FirstTile.Focus(); };
```

After a navigation, focus from `Dispatcher.BeginInvoke` so the page is in the tree first.

### What the runtime does on its own

- **A clicks the focused `Button`.** Start and the remote's play/pause command do too, and the event is marked handled. `Click` arguments are an `InputModalityRoutedEventArgs`; its `InputModality` says whether the click came from the controller, voice, a Kinect gesture, a remote, the keyboard or the mouse.
- **The D-pad doesn't move focus between plain controls.** In testing, pressing the D-pad over a `Grid` of `Button`s left focus where it was.
- **`PivotItem` does move focus.** With `AutoGridNav` (on by default), a `PivotItem` moves focus through the `Grid` it contains with the D-pad, and the `Pivot` changes items with the shoulder buttons. `ContinuousList` pages with the shoulder buttons and D-pad. See [Xbox controls](controls.md).

### Moving focus yourself

For layouts outside a `Pivot`, the samples include `samples\Common\DirectionalFocus.cs`. Turn it on for a panel and the D-pad and left stick move focus to the nearest focusable control in that direction:

```xml
<UserControl xmlns:sdk="clr-namespace:XboxSdk.Samples" ...>
  <Grid sdk:DirectionalFocus.IsEnabled="True">
    ...buttons...
  </Grid>
</UserControl>
```

It considers every visible, enabled control with `IsTabStop` set among the panel's descendants. It picks the closest one in the pressed direction, preferring ones lined up with the current control. Disabled controls and `IsTabStop="False"` ones are skipped. Add the file to your project with `<Compile Include="...\Common\DirectionalFocus.cs" />`. `samples\ui\FocusNavigation` shows it on a grid with a wide tile, a disabled one and one that isn't a tab stop.

### Showing focus

TV users only know where they are from the focus visual, so make it obvious: a filled background, a frame, a slight zoom. Every sample's `Button` template has a `FocusStates` group with a green fill or frame in `Focused`.

## The Legend

`Legend` (`Microsoft.Xbox.Controls`) shows what A, B, X and Y do. It reads attached properties from the focused element, or its nearest ancestor that has them:

```xml
<Button Content="Watch list"
        xbox:Legend.AButtonText="open" xbox:Legend.XButtonText="clear list" />
...
<xbox:Legend HorizontalAlignment="Right" VerticalAlignment="Bottom" />
```

The attached properties can only be set on a `Button`, `Pivot`, `ContinuousList`, `XboxApplicationFrame`, `Rune` or `NuiScrollViewer`. Setting them on anything else throws. The Legend hides itself while the user is using Kinect gestures.

## Media remotes

A media remote's buttons arrive as `MediaCommand` events on the focused element. `MediaTransport` handles them itself. For your own player, handle `UIElement.MediaCommand` and switch on `e.MediaCommand`.

## Kinect and speech

Kinect gestures drive a hand cursor that arrives as mouse events: hovering a `Button` focuses it, and holding the hover clicks it. Speech commands (`VuiBar`, `VuiCommand`, `VuiGrammar`) need a Kinect sensor. Neither has been tested; xenia has no Kinect.
