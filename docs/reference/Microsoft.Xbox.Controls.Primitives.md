# Microsoft.Xbox.Controls.Primitives

Assembly: `Microsoft.Xbox.dll`

| Type | Summary |
|---|---|
| [`DepthPIP`](#depthpip) | Shows the Kinect camera feed in a small picture-in-picture rectangle so users can see how the sensor sees them. |
| [`LegendButton`](#legendbutton) | One entry in a [`Legend`](Microsoft.Xbox.Controls.md#legend): a controller button glyph and its caption. |
| [`NuiGearshift`](#nuigearshift) | The Kinect scrub handle ("gearshift") drawn on the [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline). |
| [`NuiTimelineBar`](#nuitimelinebar) | A bar whose filled portion represents a progress fraction; used inside the [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline) template. |
| [`NuiTimelinePanel`](#nuitimelinepanel) | A panel that positions [`NuiTimelineMarker`](Microsoft.Xbox.Controls.md#nuitimelinemarker) children horizontally by time, using the enclosing [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline) to convert times to pixels. |
| [`PivotHeaderItem`](#pivotheaderitem) | The container for one header in a [`PivotHeadersControl`](Microsoft.Xbox.Controls.Primitives.md#pivotheaderscontrol). |
| [`PivotHeadersControl`](#pivotheaderscontrol) | The header row of a [`Pivot`](Microsoft.Xbox.Controls.md#pivot). Headers scroll so the selected header comes first, and can wrap around when looping is enabled. |
| [`ResolutionNormalizingPanel`](#resolutionnormalizingpanel) | A panel that lays out its children at a fixed logical height and scales them to the panel's actual size, so content designed for one resolution looks the same at 720p and 1080p. |
| [`SignalStrength`](#signalstrength) | A signal-strength indicator that switches between the visual states `None`, `Low`, `Medium`, `High` and `Full` (group `SignalStrengthStates`). |
| [`TipsManager`](#tipsmanager) | Shows Kinect tips and the wave-to-engage progress in the [`Feedback`](Microsoft.Xbox.Controls.md#feedback) strip. |
| [`VirtualizingGrid`](#virtualizinggrid) | The paging items panel of [`ContinuousList`](Microsoft.Xbox.Controls.md#continuouslist). It places item containers into a `Grid` column by column and only keeps the columns around the visible page realized. |
| [`VuiCommandPresenter`](#vuicommandpresenter) | Displays one [`VuiCommand`](Microsoft.Xbox.Controls.md#vuicommand) on the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar). |
| [`VuiMeter`](#vuimeter) | The animated microphone level meter on the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar). |

## DepthPIP

`class Microsoft.Xbox.Controls.Primitives.DepthPIP`

Shows the Kinect camera feed in a small picture-in-picture rectangle so users can see how the sensor sees them.

The template part `NuiCameraRectangle` (a `Rectangle`) is filled with a video brush whose source is the Kinect camera. The control is visible only while it is enabled and the Kinect sensor reports that it is ready; it collapses itself otherwise. Used by [`Feedback`](Microsoft.Xbox.Controls.md#feedback).

**Constructors**

| | |
|---|---|
| `DepthPIP()` |  |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |

## LegendButton

`class Microsoft.Xbox.Controls.Primitives.LegendButton`

One entry in a [`Legend`](Microsoft.Xbox.Controls.md#legend): a controller button glyph and its caption.

Visual states `Active` (shown) and `Inactive` (hidden). When the caption of a visible entry changes, the entry briefly goes to `Inactive` and back so the change animates.

**Constructors**

| | |
|---|---|
| `LegendButton()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean ButtonVisible { get; set; }` | Gets or sets whether the entry is shown. |
| `System.String ButtonText { get; set; }` | Gets or sets the caption shown next to the button glyph. |
| `System.Windows.Input.GamePadButton ButtonType { get; set; }` | Gets or sets which controller button this entry describes. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty ButtonTextProperty` |  |
| `static System.Windows.DependencyProperty ButtonTypeProperty` |  |
| `static System.Windows.DependencyProperty ButtonVisibleProperty` |  |

## NuiGearshift

`class Microsoft.Xbox.Controls.Primitives.NuiGearshift`

The Kinect scrub handle ("gearshift") drawn on the [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline).

The timeline drives this control from the native scrub tracker; apps do not normally use it directly. Template part: `GearshiftHandle`. Visual state groups: `TrackStates` (`TrackHidden`, `TrackElastic` while the user is within the dead zone, `TrackExpanded` once committed) and `HandednessStates` (`HandednessLeft`/`HandednessRight`).

**Constructors**

| | |
|---|---|
| `NuiGearshift()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean IsLeftHand { get; set; }` | Gets or sets whether the user is scrubbing with the left hand, which mirrors the handle. |
| `System.Boolean IsSeeking { get; set; }` | Gets or sets whether a scrub is in progress. |
| `System.Double DesiredCommitExpanderHeight { get; set; }` | Gets or sets the target height of the commit track that the expander animates toward. |
| `System.Double GearshiftHandleOffset { get; set; }` | Gets or sets how far the handle is pulled along the track. |
| `System.Double InterpolatedCommitExpanderHeight { get; set; }` | Gets or sets the current, animated height of the commit track. |
| `System.Double InterpolatedCommitExpanderProgress { get; set; }` | Gets or sets the progress, from 0 to 1, of the animation between the elastic and expanded track states. |
| `System.Double InverseCancelProgress { get; set; }` | Gets or sets one minus the dead-zone progress, used by the template to fade the handle as the user moves toward cancelling. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |
| `System.Void UpdateProgress(System.Single deadZoneProgress, System.Single commitProgress)` | Updates the handle and track from the current scrub gesture progress. |
| `System.Windows.FrameworkElement GetHandle()` | Gets the handle element from the template. |
| `System.Windows.Point GetHandleScreenPosition()` | Gets the center of the handle in root-visual coordinates. [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline) passes this point to the native scrub tracker so the gesture starts where the handle is drawn. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty GearshiftHandleOffsetProperty` |  |
| `static System.Windows.DependencyProperty InterpolatedCommitExpanderHeightProperty` |  |
| `static System.Windows.DependencyProperty InterpolatedCommitExpanderProgressProperty` |  |
| `static System.Windows.DependencyProperty InverseCancelProgressProperty` |  |

## NuiTimelineBar

`class Microsoft.Xbox.Controls.Primitives.NuiTimelineBar`

A bar whose filled portion represents a progress fraction; used inside the [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline) template.

**Constructors**

| | |
|---|---|
| `NuiTimelineBar()` |  |

**Properties**

| | |
|---|---|
| `System.Double Progress { get; set; }` | Gets or sets the filled fraction of the bar. |
| `System.Double ProgressWidth { get; }` | Gets the width of the filled portion. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty ProgressProperty` |  |
| `static System.Windows.DependencyProperty ProgressWidthProperty` |  |

## NuiTimelinePanel

`class Microsoft.Xbox.Controls.Primitives.NuiTimelinePanel`

A panel that positions [`NuiTimelineMarker`](Microsoft.Xbox.Controls.md#nuitimelinemarker) children horizontally by time, using the enclosing [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline) to convert times to pixels.

The panel finds the nearest [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline) ancestor on first arrange and binds [`NuiTimelinePanel.TimelineStartPosition`](Microsoft.Xbox.Controls.Primitives.md#nuitimelinepanel) and [`NuiTimelinePanel.TimelineEndPosition`](Microsoft.Xbox.Controls.Primitives.md#nuitimelinepanel) to it. Markers are arranged at their start time with their desired width and the panel height, and [`NuiTimelineMarker.DurationWidth`](Microsoft.Xbox.Controls.md#nuitimelinemarker) is set. Markers that extend past the timeline are collapsed (or trimmed if [`NuiTimelineMarker.IsClamped`](Microsoft.Xbox.Controls.md#nuitimelinemarker)). Other children fill the panel. The panel reports a desired size of zero.

**Constructors**

| | |
|---|---|
| `NuiTimelinePanel()` |  |

**Properties**

| | |
|---|---|
| `System.TimeSpan TimelineEndPosition { get; set; }` | Gets or sets the time at the panel's right edge. |
| `System.TimeSpan TimelineStartPosition { get; set; }` | Gets or sets the time at the panel's left edge. |

**Methods**

| | |
|---|---|
| `System.Windows.Size ArrangeOverride(System.Windows.Size finalSize)` |  |
| `System.Windows.Size MeasureOverride(System.Windows.Size availableSize)` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty TimelineEndPositionProperty` |  |
| `static System.Windows.DependencyProperty TimelineStartPositionProperty` |  |

## PivotHeaderItem

`class Microsoft.Xbox.Controls.Primitives.PivotHeaderItem`

The container for one header in a [`PivotHeadersControl`](Microsoft.Xbox.Controls.Primitives.md#pivotheaderscontrol).

Template part `HeaderButton` (a `Button`); clicking it selects the corresponding pivot page. Visual states (group `SelectionStates`), in priority order: `Focused`, `Selected`, `MouseOver`, `Unselected`.

**Constructors**

| | |
|---|---|
| `PivotHeaderItem()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean IsSelected { get; set; }` | Gets or sets whether this header belongs to the selected pivot page. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |
| `System.Void OnGotFocus(System.Windows.RoutedEventArgs e)` | Switches to the `Focused` visual state when the header itself receives focus. |
| `System.Void OnLostFocus(System.Windows.RoutedEventArgs e)` | Leaves the `Focused` visual state when the header itself loses focus. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty IsSelectedProperty` |  |

## PivotHeadersControl

`class Microsoft.Xbox.Controls.Primitives.PivotHeadersControl`

The header row of a [`Pivot`](Microsoft.Xbox.Controls.md#pivot). Headers scroll so the selected header comes first, and can wrap around when looping is enabled.

Used by the [`Pivot`](Microsoft.Xbox.Controls.md#pivot) template as `HeadersListElement`. Items are wrapped in [`PivotHeaderItem`](Microsoft.Xbox.Controls.Primitives.md#pivotheaderitem) containers. When looping, a mirror image of the trailing headers is drawn to the left of the first one.

**Constructors**

| | |
|---|---|
| `PivotHeadersControl()` |  |

**Properties**

| | |
|---|---|
| `System.Int32 VisualFirstIndex { get; set; }` | Gets or sets the index of the header drawn in the leftmost position. |

**Methods**

| | |
|---|---|
| `System.Void ClearContainerForItemOverride(System.Windows.DependencyObject element, System.Object item)` | Detaches a header container from this control and stops tracking the header's size. |
| `System.Void OnApplyTemplate()` |  |
| `System.Void OnItemsChanged(System.Collections.Specialized.NotifyCollectionChangedEventArgs e)` | Re-lays out the headers after the item collection changes, or resets the selection and first index when it becomes empty. |
| `System.Void PrepareContainerForItemOverride(System.Windows.DependencyObject element, System.Object item)` | Attaches a header container to this control, sets its selection state and starts tracking the header's size for layout. |
| `System.Void SetLoopingEnabled(System.Boolean looping)` | Turns wrap-around header layout on or off. |
| `System.Windows.Size ArrangeOverride(System.Windows.Size finalSize)` |  |
| `System.Windows.Size MeasureOverride(System.Windows.Size availableSize)` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty VisualFirstIndexProperty` |  |

## ResolutionNormalizingPanel

`class Microsoft.Xbox.Controls.Primitives.ResolutionNormalizingPanel`

A panel that lays out its children at a fixed logical height and scales them to the panel's actual size, so content designed for one resolution looks the same at 720p and 1080p.

Children are measured and arranged at [`ResolutionNormalizingPanel.NormalizedHeight`](Microsoft.Xbox.Controls.Primitives.md#resolutionnormalizingpanel) by a width that keeps the panel's aspect ratio, and then given a `ScaleTransform` equal to the actual height divided by the normalized height. This replaces any non-scale `RenderTransform` on the children. With unconstrained available size, the panel sizes itself to the screen width and to the normalized height scaled from a 720-line reference.

**Constructors**

| | |
|---|---|
| `ResolutionNormalizingPanel()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean IsNormalizingEnabled { get; set; }` | Gets or sets whether children are scaled. |
| `System.Double NormalizedHeight { get; set; }` | Gets or sets the logical height at which children are laid out. |

**Methods**

| | |
|---|---|
| `System.Windows.Size ArrangeOverride(System.Windows.Size finalSize)` |  |
| `System.Windows.Size MeasureOverride(System.Windows.Size availableSize)` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty IsNormalizingEnabledProperty` |  |
| `static System.Windows.DependencyProperty NormalizedHeightProperty` |  |

## SignalStrength

`class Microsoft.Xbox.Controls.Primitives.SignalStrength`

A signal-strength indicator that switches between the visual states `None`, `Low`, `Medium`, `High` and `Full` (group `SignalStrengthStates`).

**Constructors**

| | |
|---|---|
| `SignalStrength()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.SignalStrengthMode SignalStrengthMode { get; set; }` | Gets or sets the level to display. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty SignalStrengthModeProperty` |  |

## TipsManager

`class Microsoft.Xbox.Controls.Primitives.TipsManager`

Shows Kinect tips and the wave-to-engage progress in the [`Feedback`](Microsoft.Xbox.Controls.md#feedback) strip.

While loaded, the control listens to the Kinect sensor: it shows a warming-up tip while the sensor starts, an identifying tip and a welcome message (with the user's gamertag when known) when a user engages, and the left- or right-hand wave progress. If the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) is enabled and recognizing, a voice tip is shown every 30 seconds. Most tips fade after 10 seconds.

Visual state groups: `VisualTipStates` (`EmptyTip`, `WaveTip`, `WelcomeTip`, `VuiTip`, `IdentifyingTip`, `KinectWarmingUpTip`) and `WaveStates` (`NoWave`, `LeftWave`, `RightWave`). The text properties are set by the control from its localized strings and are refreshed when [`Localization.Culture`](Microsoft.Xbox.Controls.md#localization) changes, so values you assign may be overwritten.

**Constructors**

| | |
|---|---|
| `TipsManager()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean WaveOnlyMode { get; set; }` | Gets or sets whether only the wave-progress indicators are shown, with no tip text. |
| `System.String IdentifyingTipText { get; set; }` | Gets or sets the text shown while Kinect is identifying the engaged user. |
| `System.String KinectStartingUpTipText { get; set; }` | Gets or sets the text shown while the Kinect sensor is starting up. |
| `System.String VuiTipText { get; set; }` | Gets or sets the text of the tip that tells users they can use voice commands. |
| `System.String WaveTipText { get; set; }` | Gets or sets the text of the tip that tells users how to engage by waving. |
| `System.String WelcomeTipText { get; set; }` | Gets or sets the text of the welcome tip currently displayed. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty IdentifyingTipTextProperty` |  |
| `static System.Windows.DependencyProperty KinectStartingUpTipTextProperty` |  |
| `static System.Windows.DependencyProperty VuiTipTextProperty` |  |
| `static System.Windows.DependencyProperty WaveOnlyModeProperty` |  |
| `static System.Windows.DependencyProperty WaveTipTextProperty` |  |
| `static System.Windows.DependencyProperty WelcomeTipTextProperty` |  |

## VirtualizingGrid

`class Microsoft.Xbox.Controls.Primitives.VirtualizingGrid`

The paging items panel of [`ContinuousList`](Microsoft.Xbox.Controls.md#continuouslist). It places item containers into a `Grid` column by column and only keeps the columns around the visible page realized.

Use it only as the items panel of a [`ContinuousList`](Microsoft.Xbox.Controls.md#continuouslist); it reports paging and visible items back to that list. Items fill the grid's rows top to bottom, then move to the next column. Page changes animate with a 0.5-second ease-out slide. Directional focus moves between the realized items; moving focus past the edge of the page pages the list.

**Constructors**

| | |
|---|---|
| `VirtualizingGrid()` |  |

**Properties**

| | |
|---|---|
| `System.Windows.Controls.Grid Grid { get; set; }` | Gets or sets the grid into which item containers are placed. Column definitions are generated by the panel; any you define are removed. A grid without row definitions gets one. Assigning a new grid discards the realized containers and resets the panel to the first page. |

**Methods**

| | |
|---|---|
| `System.Boolean IsItemInViewport(System.Int32 index)` | Determines whether the item at an index is realized and inside the list's view area. |
| `System.Void OnItemsChanged(System.Object sender, System.Windows.Controls.Primitives.ItemsChangedEventArgs e)` | Removes or resets realized containers when items are removed, replaced or the collection is reset. If the focused container is removed, focus moves to the owning [`ContinuousList`](Microsoft.Xbox.Controls.md#continuouslist) and is restored to an item after the next layout. |
| `System.Windows.Size ArrangeOverride(System.Windows.Size finalSize)` |  |
| `System.Windows.Size MeasureOverride(System.Windows.Size availableSize)` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty GridProperty` |  |

## VuiCommandPresenter

`class Microsoft.Xbox.Controls.Primitives.VuiCommandPresenter`

Displays one [`VuiCommand`](Microsoft.Xbox.Controls.md#vuicommand) on the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar).

Visual states (group `States`): `Executable` or `NotExecutable` depending on [`VuiCommand.CanExecute`](Microsoft.Xbox.Controls.md#vuicommand), and `Selected` when the command is recognized. If the template defines a storyboard named `SelectedStoryboard`, the bar waits for it to finish before running the command.

**Constructors**

| | |
|---|---|
| `VuiCommandPresenter()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.VuiCommand VuiCommand { get; set; }` | Gets or sets the command to display. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty VuiCommandProperty` |  |

## VuiMeter

`class Microsoft.Xbox.Controls.Primitives.VuiMeter`

The animated microphone level meter on the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar).

Each `Rectangle` in the template part `RectangleParent` is scaled vertically to random heights. While the voice bar is visible the heights are drawn from the active range when speech sound is detected and from the inactive range otherwise; when the bar hides the bars settle to [`VuiMeter.InactiveMin`](Microsoft.Xbox.Controls.Primitives.md#vuimeter). Each animation lasts a base time plus a scale time multiplied by the target height. The meter requires [`VuiBar.Current`](Microsoft.Xbox.Controls.md#vuibar).

**Constructors**

| | |
|---|---|
| `VuiMeter()` |  |

**Properties**

| | |
|---|---|
| `System.Double ActiveMax { get; set; }` | Gets or sets the largest vertical scale used while sound is detected. |
| `System.Double ActiveMin { get; set; }` | Gets or sets the smallest vertical scale used while sound is detected. |
| `System.Double InactiveMax { get; set; }` | Gets or sets the largest vertical scale used while no sound is detected. |
| `System.Double InactiveMin { get; set; }` | Gets or sets the smallest vertical scale used while no sound is detected, and the resting scale when the bar is hidden. |
| `System.TimeSpan ActiveDurationBase { get; set; }` | Gets or sets the fixed part of each animation's duration while sound is detected. |
| `System.TimeSpan ActiveDurationScale { get; set; }` | Gets or sets the part of each animation's duration that is multiplied by the target scale while sound is detected. |
| `System.TimeSpan InactiveDurationBase { get; set; }` | Gets or sets the fixed part of each animation's duration while no sound is detected. |
| `System.TimeSpan InactiveDurationScale { get; set; }` | Gets or sets the part of each animation's duration that is multiplied by the target scale while no sound is detected. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty ActiveDurationBaseProperty` |  |
| `static System.Windows.DependencyProperty ActiveDurationScaleProperty` |  |
| `static System.Windows.DependencyProperty ActiveMaxProperty` |  |
| `static System.Windows.DependencyProperty ActiveMinProperty` |  |
| `static System.Windows.DependencyProperty InactiveDurationBaseProperty` |  |
| `static System.Windows.DependencyProperty InactiveDurationScaleProperty` |  |
| `static System.Windows.DependencyProperty InactiveMaxProperty` |  |
| `static System.Windows.DependencyProperty InactiveMinProperty` |  |

