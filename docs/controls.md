# Xbox controls

`Microsoft.Xbox.dll` has the controls the dashboard-style apps are built from. Use them with `xmlns:xbox="clr-namespace:Microsoft.Xbox.Controls;assembly=Microsoft.Xbox"` and a `Microsoft.Xbox` reference. The [API reference](reference/Microsoft.Xbox.Controls.md) documents every member; this page covers what you need to get them working.

Their default styles come from the platform's theme. Some colors assume a light background (the Pivot headers are dark grey), so override templates where they don't fit.

## Pivot

Sections side by side, one shown at a time, with the neighbours peeking in at the edges. The shoulder buttons switch sections.

```xml
<xbox:Pivot x:Name="Sections">
  <xbox:Pivot.HeaderTemplate>
    <DataTemplate>
      <TextBlock Text="{Binding}" FontSize="32" Foreground="#FFEBEBEB" />
    </DataTemplate>
  </xbox:Pivot.HeaderTemplate>
  <xbox:PivotItem Header="browse">
    <Grid>...buttons in rows and columns...</Grid>
  </xbox:PivotItem>
  <xbox:PivotItem Header="search">...</xbox:PivotItem>
</xbox:Pivot>
```

- **D-pad focus inside a section:** each `PivotItem` moves it through the `Grid` it contains with the D-pad (`AutoGridNav`, on by default). Give it a `Grid` with the controls in rows and columns.
- **Focus when switching:** focus the first control yourself in `SelectionChanged`.
- **Lazy loading:** `LoadingPivotItem` and `UnloadingPivotItem` are raised for items within two positions of the selection, so you can load section content on demand.
- **Only one per page:** a `Pivot` contains a `SwipeViewer`, and only one `SwipeViewer` can be active at a time. Don't put two `Pivot`s, or a `Pivot` and a `ContinuousList`, on one page.

Samples: `samples\ui\XboxControls`, and `samples\apps\CatalogBrowser`, which builds its sections in code.

## Rune

Text entry made for the TV: a strip of characters the user scrolls through with the D-pad and picks with A. X deletes and Y closes. It shows as a popup while `IsOpen` is true.

```xml
<xbox:Rune x:Name="SearchRune" EmptyTextString="search for something" />
```

```csharp
SearchRune.IsOpen = true;
SearchRune.Focus();
SearchRune.TextChanged += delegate { Search(SearchRune.Text); };
```

A Rune also accepts text typed on a SmartGlass companion device. Under xenia the SmartGlass keyboard calls are missing, which only shows up in the log; typing with the controller works.

## Legend

The A/B/X/Y hints at the bottom of the screen. See [Input and focus](input-and-focus.md#the-legend).

## MediaTransport

The Xbox video player's chrome: a transport bar, timeline, status and busy indicator, wired to a player. See [Media](media.md).

- **Set `MediaAssetId` before playback.** Every command reports it, and commands throw `InvalidOperationException` without it.
- **Needs GamerServices**, for its screen-saver control; use it inside an `XboxApplicationFrame`.

## ContinuousList

A horizontally paged list for long rows of items. It pages with the shoulder buttons, the D-pad, the remote's previous/next or a swipe, and raises `ItemsInViewChanged`. It contains a `SwipeViewer`, so the one-per-page rule applies.

## Transitions

Page transitions and staggered element animations: see [App model](app-model.md#transitions).

## Speech: VuiBar and VuiCommand

Voice commands need a Kinect sensor, which xenia doesn't have, so none of this has been tested. From the code:

1. `XboxApplicationFrame`'s template hosts the one `VuiBar`; creating a second one throws.
2. Build a `VuiGrammar` whose phrases' semantic values match each `VuiCommand.SemanticValue`, call `LoadGrammar`, add the commands, then `StartRecognition`. Grammars can't be loaded while recognition is running.
3. Setting `Localization.Culture` unloads every grammar, the app's included; load them again afterwards.

## Kinect-only controls

`NuiTimeline` scrubbing, `SwipeViewer`, `DepthPIP` and Rune gestures respond to the Kinect hand cursor. Without a sensor they still show, and the controller works with them.
