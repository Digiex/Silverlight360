# Microsoft.Xbox.Controls

Assembly: `Microsoft.Xbox.dll`

| Type | Summary |
|---|---|
| [`BooleanToVisibilityConverter`](#booleantovisibilityconverter) | Value converter that maps a `Boolean` (or nullable Boolean) to `Visibility`. |
| [`ChapterMarker`](#chaptermarker) | A snappable point marker that marks a chapter on the timeline. |
| [`ContinuousList`](#continuouslist) | A horizontally paged list for the 10-foot UI. Items are laid out in columns and the user pages left and right with the shoulder buttons, the D-pad, the remote's previous/next keys or a Kinect swipe. |
| [`ContinuousListItem`](#continuouslistitem) | The item container used by [`ContinuousList`](Microsoft.Xbox.Controls.md#continuouslist). |
| [`CultureChangedEventArgs`](#culturechangedeventargs) | Provides data for the [`Localization.CultureChanged`](Microsoft.Xbox.Controls.md#localization) event. |
| [`Feedback`](#feedback) | The standard bottom-of-screen feedback strip: the controller [`Legend`](Microsoft.Xbox.Controls.md#legend), Kinect tips and wave progress, and the Kinect depth camera picture-in-picture. |
| [`GamePadButtonToImageSourceConverter`](#gamepadbuttontoimagesourceconverter) | Value converter that turns a [`GamePadButton`](System.Windows.Input.md#gamepadbutton) value into the built-in button glyph image used by the controller legend. |
| [`IMediaElementAdapter`](#imediaelementadapter) | Abstracts a media player so that [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport) can drive it. |
| [`ItemsInViewChangedEventArgs`](#itemsinviewchangedeventargs) | Provides data for the `ItemsInViewChanged` event of [`ContinuousList`](Microsoft.Xbox.Controls.md#continuouslist). |
| [`LeftButtonMode`](#leftbuttonmode) | Selects which button appears on the left side of the [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport) overlay. |
| [`Legend`](#legend) | Shows the controller button legend (A, B, X, Y and their meanings) for the element that currently has focus. |
| [`Localization`](#localization) | Holds the culture used by the Xbox controls for their built-in strings and speech language, and exposes the console's language and locale settings. |
| [`MarkerEventArgs`](#markereventargs) | Provides data for the marker events of [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport) and [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline). |
| [`MediaElementAdapterState`](#mediaelementadapterstate) | The playback states reported by an [`IMediaElementAdapter`](Microsoft.Xbox.Controls.md#imediaelementadapter). |
| [`MediaTransport`](#mediatransport) | Full-screen video playback chrome for Xbox: an overlay with a NUI timeline, a controller transport bar, status text, a busy indicator and an optional custom control panel, wired to a media player. |
| [`NuiScrollViewer`](#nuiscrollviewer) | A vertically scrolling content area designed for both the controller and the Kinect hand cursor. |
| [`NuiTimeline`](#nuitimeline) | The media timeline used by [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport): a progress bar with markers, position text, a preview thumbnail and a Kinect "gearshift" handle for scrubbing. |
| [`NuiTimelineMarker`](#nuitimelinemarker) | Base class for items placed on a [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline) at a point or over a span of time. |
| [`PeekCompletedEventArgs`](#peekcompletedeventargs) | Provides data for the [`SwipeViewer.PeekCompleted`](Microsoft.Xbox.Controls.md#swipeviewer) event. |
| [`PeekProgressChangedEventArgs`](#peekprogresschangedeventargs) | Provides data for the [`SwipeViewer.PeekProgressChanged`](Microsoft.Xbox.Controls.md#swipeviewer) event. |
| [`PeekStartedEventArgs`](#peekstartedeventargs) | Provides data for the [`SwipeViewer.PeekStarted`](Microsoft.Xbox.Controls.md#swipeviewer) event. |
| [`Pivot`](#pivot) | A horizontally swiping tab control: a row of headers above a set of [`PivotItem`](Microsoft.Xbox.Controls.md#pivotitem) pages, with neighbouring pages peeking in from the sides. |
| [`PivotItem`](#pivotitem) | A page in a [`Pivot`](Microsoft.Xbox.Controls.md#pivot). |
| [`PivotItemEventArgs`](#pivotitemeventargs) | Provides data for the [`Pivot.LoadingPivotItem`](Microsoft.Xbox.Controls.md#pivot) and [`Pivot.UnloadingPivotItem`](Microsoft.Xbox.Controls.md#pivot) events. |
| [`PlayRate`](#playrate) | Playback rates used by [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport). Negative values rewind, positive values above 1 fast forward; the numeric value is the speed multiplier. |
| [`PlayRateChangedEventArgs`](#playratechangedeventargs) | Provides data for the `PlayRateChanged` event of [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport). |
| [`Rune`](#rune) | A single-line text entry control built for the TV: a strip of character tiles the user picks from with the controller or a Kinect hand gesture, with the entered text shown above. |
| [`RuneCursor`](#runecursor) | The Kinect hand cursor shown by a [`Rune`](Microsoft.Xbox.Controls.md#rune) while the user is selecting characters by gesture. |
| [`RuneTile`](#runetile) | One character tile in a [`Rune`](Microsoft.Xbox.Controls.md#rune). |
| [`ScrubbingCompletedEventArgs`](#scrubbingcompletedeventargs) | Provides data for the [`NuiTimeline.ScrubbingCompleted`](Microsoft.Xbox.Controls.md#nuitimeline) event. |
| [`ScrubbingEventArgs`](#scrubbingeventargs) | Provides data for the [`NuiTimeline.ScrubbingStarted`](Microsoft.Xbox.Controls.md#nuitimeline) and [`NuiTimeline.Scrubbing`](Microsoft.Xbox.Controls.md#nuitimeline) events. |
| [`SeekExecutedEventArgs`](#seekexecutedeventargs) | Provides data for the [`MediaTransport.SeekExecuted`](Microsoft.Xbox.Controls.md#mediatransport) event. |
| [`SignalStrengthMode`](#signalstrengthmode) | The signal-strength level shown by [`SignalStrength`](Microsoft.Xbox.Controls.Primitives.md#signalstrength) on the media timeline. |
| [`SwipeActivationZone`](#swipeactivationzone) | Identifies a side of the screen for swipe gestures. |
| [`SwipeCompletedEventArgs`](#swipecompletedeventargs) | Provides data for the [`SwipeViewer.SwipeCompleted`](Microsoft.Xbox.Controls.md#swipeviewer) event. |
| [`SwipeEventArgs`](#swipeeventargs) | Base class for [`SwipeViewer`](Microsoft.Xbox.Controls.md#swipeviewer) event data: which user and which side. |
| [`SwipeFailedEventArgs`](#swipefailedeventargs) | Provides data for the [`SwipeViewer.SwipeFailed`](Microsoft.Xbox.Controls.md#swipeviewer) event. |
| [`SwipeProgressChangedEventArgs`](#swipeprogresschangedeventargs) | Provides data for the [`SwipeViewer.SwipeProgressChanged`](Microsoft.Xbox.Controls.md#swipeviewer) event. |
| [`SwipeReadyEventArgs`](#swipereadyeventargs) | Provides data for the [`SwipeViewer.SwipeReady`](Microsoft.Xbox.Controls.md#swipeviewer) event. |
| [`SwipeVelocityChangedEventArgs`](#swipevelocitychangedeventargs) | Provides data for the [`SwipeViewer.SwipeVelocityChanged`](Microsoft.Xbox.Controls.md#swipeviewer) event. |
| [`SwipeViewer`](#swipeviewer) | Detects Kinect left and right swipe gestures and exposes their progress as events, properties and visual states. |
| [`ThumbnailRequestEventArgs`](#thumbnailrequesteventargs) | Provides data for the [`MediaTransport.ThumbnailRequest`](Microsoft.Xbox.Controls.md#mediatransport) event. |
| [`TimelineRangeMarker`](#timelinerangemarker) | A clamped, non-snappable marker that covers the span between [`TimelineRangeMarker.MinimumPosition`](Microsoft.Xbox.Controls.md#timelinerangemarker) and [`TimelineRangeMarker.MaximumPosition`](Microsoft.Xbox.Controls.md#timelinerangemarker). |
| [`TimespanToStringConverter`](#timespantostringconverter) | Value converter that formats a `TimeSpan` as a playback time string. |
| [`TransportBar`](#transportbar) | The horizontal row of [`TransportBarButton`](Microsoft.Xbox.Controls.md#transportbarbutton) controls shown at the bottom of [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport). |
| [`TransportBarButton`](#transportbarbutton) | A button in a [`TransportBar`](Microsoft.Xbox.Controls.md#transportbar). |
| [`VuiActiveListeningChangedEventArgs`](#vuiactivelisteningchangedeventargs) | Provides data for the [`VuiBar.ActiveListeningChanged`](Microsoft.Xbox.Controls.md#vuibar) event. |
| [`VuiBar`](#vuibar) | The voice user interface (VUI) bar: Kinect speech recognition for the app and the on-screen bar that lists the commands the user can say. |
| [`VuiBarVisibilityState`](#vuibarvisibilitystate) | How the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) is displayed. |
| [`VuiBarVisibilityStateChangedEventArgs`](#vuibarvisibilitystatechangedeventargs) | Provides data for the `VisibilityStateChanged` event of [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar). |
| [`VuiCommand`](#vuicommand) | A command the user can trigger by voice through the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar). |
| [`VuiCommandExecutedEventArgs`](#vuicommandexecutedeventargs) | Provides data for the [`VuiCommand.Executed`](Microsoft.Xbox.Controls.md#vuicommand) event. It carries no additional information. |
| [`VuiCommandNotRecognizedEventArgs`](#vuicommandnotrecognizedeventargs) | Provides data for the [`VuiBar.VuiCommandNotRecognized`](Microsoft.Xbox.Controls.md#vuibar) event. |
| [`VuiCommandNotRecognizedReason`](#vuicommandnotrecognizedreason) | Explains why [`VuiBar.VuiCommandNotRecognized`](Microsoft.Xbox.Controls.md#vuibar) was raised. |
| [`VuiCommands`](#vuicommands) | Predefined, localized voice commands for common actions. |
| [`VuiConfirmation`](#vuiconfirmation) | Specifies whether a [`VuiCommand`](Microsoft.Xbox.Controls.md#vuicommand) must be confirmed before it runs. |
| [`VuiDisambiguationSlot`](#vuidisambiguationslot) | A label used by the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) to let the user pick one of several commands that matched the same phrase. |
| [`VuiGrammar`](#vuigrammar) | A set of spoken phrases, each mapped to a semantic value, that can be loaded into the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) recognizer. |
| [`VuiPersistence`](#vuipersistence) | Specifies whether the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) keeps actively listening after a command executes. |
| [`XboxApplicationFrame`](#xboxapplicationframe) | The navigation frame to use as the root of an Xbox Silverlight app. It hosts pages, plays page transitions and contains the app's [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar). |
| [`XboxApplicationPage`](#xboxapplicationpage) | A `Page` preconfigured with Z-order navigation transitions so that pages layer correctly while [`XboxApplicationFrame`](Microsoft.Xbox.Controls.md#xboxapplicationframe) animates between them. |

## BooleanToVisibilityConverter

`class Microsoft.Xbox.Controls.BooleanToVisibilityConverter`

Value converter that maps a `Boolean` (or nullable Boolean) to `Visibility`.

`true` converts to `Visibility.Visible`; `false`, `null` and non-Boolean values convert to `Visibility.Collapsed`. Pass a converter parameter of `"True"` to invert the mapping. `ConvertBack` performs the reverse mapping and honors the same parameter.

**Constructors**

| | |
|---|---|
| `BooleanToVisibilityConverter()` |  |

**Methods**

| | |
|---|---|
| `System.Object Convert(System.Object value, System.Type targetType, System.Object parameter, System.Globalization.CultureInfo culture)` |  |
| `System.Object ConvertBack(System.Object value, System.Type targetType, System.Object parameter, System.Globalization.CultureInfo culture)` |  |

## ChapterMarker

`class Microsoft.Xbox.Controls.ChapterMarker`

A snappable point marker that marks a chapter on the timeline.

Chapter markers in [`MediaTransport.Markers`](Microsoft.Xbox.Controls.md#mediatransport) are used by the skip back/forward commands and as snap points while scrubbing.

**Constructors**

| | |
|---|---|
| `ChapterMarker()` |  |
| `ChapterMarker(System.TimeSpan time)` | Initializes a new chapter marker at the given time. |

## ContinuousList

`class Microsoft.Xbox.Controls.ContinuousList`

A horizontally paged list for the 10-foot UI. Items are laid out in columns and the user pages left and right with the shoulder buttons, the D-pad, the remote's previous/next keys or a Kinect swipe.

Items are wrapped in [`ContinuousListItem`](Microsoft.Xbox.Controls.md#continuouslistitem) containers and arranged by a [`VirtualizingGrid`](Microsoft.Xbox.Controls.Primitives.md#virtualizinggrid) items panel (the default template). The number of rows comes from the row definitions of the panel's [`VirtualizingGrid.Grid`](Microsoft.Xbox.Controls.Primitives.md#virtualizinggrid); columns are created as needed.

The template contains a [`SwipeViewer`](Microsoft.Xbox.Controls.md#swipeviewer) named `SwipeElement`, so the list responds to Kinect swipes. Only one [`SwipeViewer`](Microsoft.Xbox.Controls.md#swipeviewer) can be active at a time, so do not show two swipe-enabled controls (for example a [`ContinuousList`](Microsoft.Xbox.Controls.md#continuouslist) and a [`Pivot`](Microsoft.Xbox.Controls.md#pivot)) on the same page.

Raises `ItemsInViewChanged` whenever the set of fully visible items changes. During page transitions in an [`XboxApplicationFrame`](Microsoft.Xbox.Controls.md#xboxapplicationframe) the item area is clipped to the screen.

**Constructors**

| | |
|---|---|
| `ContinuousList()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean CanGoToNextPage { get; }` | Gets whether there is a page to the right of the current one. |
| `System.Boolean CanGoToPreviousPage { get; }` | Gets whether there is a page to the left of the current one. |
| `System.Boolean IsCascadeAnimationEnabled { get; set; }` | Gets or sets whether items animate in one column after another when the list is loaded or its items source changes. |
| `System.Collections.ObjectModel.ReadOnlyCollection<System.Object> ItemsInView { get; }` | Gets the items that are currently inside the view area. |
| `System.Double PageAlignment { get; set; }` | Gets or sets the horizontal offset, in pixels, at which the first column of a page is placed. The space between this offset and the left edge of [`ContinuousList.ViewMargin`](Microsoft.Xbox.Controls.md#continuouslist) is where the previous page peeks in. |
| `System.TimeSpan CascadeAnimationBeginTime { get; set; }` | Gets or sets the delay before the cascade animation starts. |
| `System.Windows.Thickness ViewMargin { get; set; }` | Gets or sets the margins that define the visible area used to decide whether an item is in view. Items that fall outside this area are considered off-page; they affect paging, [`ContinuousList.ItemsInView`](Microsoft.Xbox.Controls.md#continuouslist) and the items reported by `ItemsInViewChanged`. |

**Methods**

| | |
|---|---|
| `System.Boolean BringIntoView(System.Int32 index)` | Scrolls the list so that the item at the given index is on the current page. Throws `ArgumentOutOfRangeException` if `index` is outside the item range. If the list has focus, focus moves into the new page after it is laid out. |
| `System.Boolean GoToNextPage()` | Animates the list one page to the right. Unlike user-initiated paging, this does not move focus unless focus is already inside the list. |
| `System.Boolean GoToPreviousPage()` | Animates the list one page to the left. Unlike user-initiated paging, this does not move focus unless focus is already inside the list. |
| `System.Void OnApplyTemplate()` |  |
| `System.Void OnItemsChanged(System.Collections.Specialized.NotifyCollectionChangedEventArgs e)` | Forwards item collection changes to the paging panel so it can keep the current page and focus stable. Unlike most items controls, this override does not call the base implementation. |
| `System.Windows.DependencyObject GetContainerForItemOverride()` | Creates the [`ContinuousListItem`](Microsoft.Xbox.Controls.md#continuouslistitem) that wraps a data item. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xbox.Controls.ItemsInViewChangedEventArgs> ItemsInViewChanged` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty CascadeAnimationBeginTimeProperty` |  |
| `static System.Windows.DependencyProperty IsCascadeAnimationEnabledProperty` |  |
| `static System.Windows.DependencyProperty PageAlignmentProperty` |  |
| `static System.Windows.DependencyProperty ViewMarginProperty` |  |

## ContinuousListItem

`class Microsoft.Xbox.Controls.ContinuousListItem`

The item container used by [`ContinuousList`](Microsoft.Xbox.Controls.md#continuouslist).

The template can define the visual states `Center`, `Left` and `Right` in the `Position States` group; the control starts in `Center` when its template is applied. You can also place [`ContinuousListItem`](Microsoft.Xbox.Controls.md#continuouslistitem) objects directly in the list's `Items`.

**Constructors**

| | |
|---|---|
| `ContinuousListItem()` |  |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |

## CultureChangedEventArgs

`class Microsoft.Xbox.Controls.CultureChangedEventArgs`

Provides data for the [`Localization.CultureChanged`](Microsoft.Xbox.Controls.md#localization) event.

**Properties**

| | |
|---|---|
| `System.Globalization.CultureInfo Culture { get; }` | Gets the culture that is now in effect. |

## Feedback

`class Microsoft.Xbox.Controls.Feedback`

The standard bottom-of-screen feedback strip: the controller [`Legend`](Microsoft.Xbox.Controls.md#legend), Kinect tips and wave progress, and the Kinect depth camera picture-in-picture.

The template must contain a [`Legend`](Microsoft.Xbox.Controls.md#legend) named `LegendPart`, a [`TipsManager`](Microsoft.Xbox.Controls.Primitives.md#tipsmanager) named `TipsManagerPart` and a [`DepthPIP`](Microsoft.Xbox.Controls.Primitives.md#depthpip) named `DepthPIPPart`; a missing part throws `InvalidOperationException` when the template is applied. The tips and depth view react to the Kinect sensor and do nothing visible without one.

**Constructors**

| | |
|---|---|
| `Feedback()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean IsDepthPIPEnabled { get; set; }` | Gets or sets whether the Kinect depth camera picture-in-picture is enabled. Setting [`Feedback.IsWaveOnly`](Microsoft.Xbox.Controls.md#feedback) to `true` sets this property to `false`. |
| `System.Boolean IsWaveOnly { get; set; }` | Gets or sets whether the strip shows only the Kinect wave-progress indicators. When `true`, the legend is disabled, the depth view is disabled and tip text is suppressed; when set back to `false` the legend and depth view are re-enabled. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty IsDepthPIPEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsWaveOnlyProperty` |  |

## GamePadButtonToImageSourceConverter

`class Microsoft.Xbox.Controls.GamePadButtonToImageSourceConverter`

Value converter that turns a [`GamePadButton`](System.Windows.Input.md#gamepadbutton) value into the built-in button glyph image used by the controller legend.

Only `A`, `B`, `X` and `Y` are supported; any other button throws `InvalidOperationException`. The result is a `BitmapImage` loaded from the Microsoft.Xbox assembly resources. `ConvertBack` is not supported and always throws.

**Constructors**

| | |
|---|---|
| `GamePadButtonToImageSourceConverter()` |  |

**Methods**

| | |
|---|---|
| `System.Object Convert(System.Object value, System.Type targetType, System.Object parameter, System.Globalization.CultureInfo culture)` |  |
| `System.Object ConvertBack(System.Object value, System.Type targetType, System.Object parameter, System.Globalization.CultureInfo culture)` |  |

## IMediaElementAdapter

`interface Microsoft.Xbox.Controls.IMediaElementAdapter`

Abstracts a media player so that [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport) can drive it.

[`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport) has built-in adapters for `MediaElement` and the Smooth Streaming `SmoothStreamingMediaElement`. Implement this interface to use a different player, and assign the instance to [`MediaTransport.MediaElement`](Microsoft.Xbox.Controls.md#mediatransport); the transport polls the adapter about every 100 ms and calls its methods from the UI thread. Adapters you supply are not disposed by the transport.

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.MediaElementAdapterState CurrentState { get; }` | Gets the player's current state. |
| `System.Boolean CanPause { get; }` | Gets whether the media can be paused. |
| `System.Boolean CanSeek { get; }` | Gets whether the media supports seeking. |
| `System.Boolean IsLive { get; }` | Gets whether the content is a live stream. |
| `System.Double BufferingProgress { get; }` | Gets how much of the buffer has been filled. |
| `System.Double DownloadOffset { get; }` | Gets the offset of the downloaded range within the content. |
| `System.Double DownloadProgress { get; }` | Gets how much of the content has been downloaded. |
| `System.TimeSpan Duration { get; }` | Gets the length of the timeline. |
| `System.TimeSpan MaxPosition { get; }` | Gets the latest position the user is allowed to seek to. |
| `System.TimeSpan MinPosition { get; }` | Gets the earliest position the user is allowed to seek to. |
| `System.TimeSpan Position { get; }` | Gets the current playback position. |
| `System.TimeSpan StartPosition { get; }` | Gets the media time that corresponds to the left end of the timeline. |

**Methods**

| | |
|---|---|
| `System.Void Pause()` | Pauses playback. |
| `System.Void Play()` | Starts or resumes playback. |
| `System.Void Seek(System.TimeSpan position)` | Moves playback to a new position. |
| `System.Void SeekToLive()` | Moves playback to the live edge of a live stream. Only called when [`IMediaElementAdapter.IsLive`](Microsoft.Xbox.Controls.md#imediaelementadapter) and [`IMediaElementAdapter.CanSeek`](Microsoft.Xbox.Controls.md#imediaelementadapter) are `true`. |
| `System.Void SetStretch(System.Windows.Media.Stretch stretch)` | Changes how the video is scaled to fit the display area. |
| `System.Void Stop()` | Stops playback. |

**Events**

| | |
|---|---|
| `event System.EventHandler BufferingProgressChanged` |  |
| `event System.EventHandler CurrentStateChanged` |  |
| `event System.EventHandler DownloadProgressChanged` |  |

## ItemsInViewChangedEventArgs

`class Microsoft.Xbox.Controls.ItemsInViewChangedEventArgs`

Provides data for the `ItemsInViewChanged` event of [`ContinuousList`](Microsoft.Xbox.Controls.md#continuouslist).

**Properties**

| | |
|---|---|
| `System.Collections.IList AddedItems { get; }` | Gets the items that came into view. |
| `System.Collections.IList RemovedItems { get; }` | Gets the items that left the view. |

## LeftButtonMode

`enum Microsoft.Xbox.Controls.LeftButtonMode`

Selects which button appears on the left side of the [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport) overlay.

**Values**

| | |
|---|---|
| `Back` | Show a Back button that raises [`MediaTransport.Back`](Microsoft.Xbox.Controls.md#mediatransport). This is the default. |
| `Stop` | Show a Stop button that executes the Stop media command. |

## Legend

`class Microsoft.Xbox.Controls.Legend`

Shows the controller button legend (A, B, X, Y and their meanings) for the element that currently has focus.

Set the attached properties (`AButtonText`, `BButtonText`, `XButtonText`, `YButtonText`) on a control. When focus moves, the legend walks up the visual tree from the focused element and, for each button, uses the text from the nearest supported ancestor that defines it. Buttons with no text (or an empty string) are hidden.

The attached properties can only be set on a `Button`, [`Pivot`](Microsoft.Xbox.Controls.md#pivot), [`ContinuousList`](Microsoft.Xbox.Controls.md#continuouslist), [`XboxApplicationFrame`](Microsoft.Xbox.Controls.md#xboxapplicationframe), [`Rune`](Microsoft.Xbox.Controls.md#rune) or [`NuiScrollViewer`](Microsoft.Xbox.Controls.md#nuiscrollviewer) (or a subclass); setting them on any other type throws `InvalidOperationException`.

The legend is visible only while the current input modality is the controller and the control is enabled; it collapses itself when the user switches to Kinect gestures. It is normally used through [`Feedback`](Microsoft.Xbox.Controls.md#feedback).

**Constructors**

| | |
|---|---|
| `Legend()` |  |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |
| `static System.String GetAButtonText(System.Object obj)` | Gets the A-button legend text set on an element. |
| `static System.String GetBButtonText(System.Object obj)` | Gets the B-button legend text set on an element. |
| `static System.String GetXButtonText(System.Object obj)` | Gets the X-button legend text set on an element. |
| `static System.String GetYButtonText(System.Object obj)` | Gets the Y-button legend text set on an element. |
| `static System.Void SetAButtonText(System.Windows.DependencyObject obj, System.String value)` | Sets the A-button legend text shown while focus is on or inside an element. |
| `static System.Void SetBButtonText(System.Windows.DependencyObject obj, System.String value)` | Sets the B-button legend text shown while focus is on or inside an element. |
| `static System.Void SetXButtonText(System.Windows.DependencyObject obj, System.String value)` | Sets the X-button legend text shown while focus is on or inside an element. |
| `static System.Void SetYButtonText(System.Windows.DependencyObject obj, System.String value)` | Sets the Y-button legend text shown while focus is on or inside an element. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty AButtonTextProperty` | Identifies the `AButtonText` attached property, the legend text for the A button. |
| `static System.Windows.DependencyProperty BButtonTextProperty` | Identifies the `BButtonText` attached property, the legend text for the B button. |
| `static System.Windows.DependencyProperty XButtonTextProperty` | Identifies the `XButtonText` attached property, the legend text for the X button. |
| `static System.Windows.DependencyProperty YButtonTextProperty` | Identifies the `YButtonText` attached property, the legend text for the Y button. |

## Localization

`class Microsoft.Xbox.Controls.Localization`

Holds the culture used by the Xbox controls for their built-in strings and speech language, and exposes the console's language and locale settings.

At startup the culture is chosen from the engaged user's profile if one is available, otherwise from the console language and locale settings. Controls such as [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport), [`Rune`](Microsoft.Xbox.Controls.md#rune), [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) and the tips shown by [`Feedback`](Microsoft.Xbox.Controls.md#feedback) refresh their text when the culture changes. The `XC_LANGUAGE_*` and `XC_LOCALE_*` constants are the values returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization) and [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization).

**Properties**

| | |
|---|---|
| `static System.Globalization.CultureInfo Culture { get; set; }` | Gets or sets the culture the Xbox controls use for their own text and for speech recognition. Setting a new culture updates the controls' resource strings and raises [`Localization.CultureChanged`](Microsoft.Xbox.Controls.md#localization). If a [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) exists, it stops recognition, switches the speech language (when the culture is supported) and unloads every loaded [`VuiGrammar`](Microsoft.Xbox.Controls.md#vuigrammar), including ones loaded by the app; reload your grammars and call [`VuiBar.StartRecognition`](Microsoft.Xbox.Controls.md#vuibar) again after the change. |

**Methods**

| | |
|---|---|
| `static System.Int32 GetConsoleLanguage()` | Reads the console's display language setting. Calls native ordinal 1500 in npctrl.dll. |
| `static System.Int32 GetConsoleLocale()` | Reads the console's locale (country/region) setting. Calls native ordinal 1501 in npctrl.dll. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xbox.Controls.CultureChangedEventArgs> CultureChanged` |  |

**Fields**

| | |
|---|---|
| `const System.Int32 XC_LANGUAGE_BNORWEGIAN` | Console language value 15: Norwegian (Bokmål). Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_DUTCH` | Console language value 16: Dutch. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_ENGLISH` | Console language value 1: English. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_FRENCH` | Console language value 4: French. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_GERMAN` | Console language value 3: German. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_ITALIAN` | Console language value 6: Italian. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_JAPANESE` | Console language value 2: Japanese. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_KOREAN` | Console language value 7: Korean. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_POLISH` | Console language value 11: Polish. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_PORTUGUESE` | Console language value 9: Portuguese. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_RUSSIAN` | Console language value 12: Russian. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_SCHINESE` | Console language value 17: Simplified Chinese. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_SCHINESE_DEPRECATED` | Console language value 10: Simplified Chinese (deprecated value; see also XC_LANGUAGE_SCHINESE). Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_SPANISH` | Console language value 5: Spanish. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_SWEDISH` | Console language value 13: Swedish. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_TCHINESE` | Console language value 8: Traditional Chinese. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_TURKISH` | Console language value 14: Turkish. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LANGUAGE_UNKNOWN` | Console language value 0: an unknown or unreadable language. Returned by [`Localization.GetConsoleLanguage`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_ARGENTINA` | Console locale value 40: Argentina. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_AUSTRALIA` | Console locale value 1: Australia. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_AUSTRIA` | Console locale value 2: Austria. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_BELGIUM` | Console locale value 3: Belgium. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_BRAZIL` | Console locale value 4: Brazil. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_CANADA` | Console locale value 5: Canada. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_CHILE` | Console locale value 6: Chile. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_CHINA` | Console locale value 7: China. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_COLOMBIA` | Console locale value 8: Colombia. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_CZECH_REPUBLIC` | Console locale value 9: Czech Republic. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_DENMARK` | Console locale value 10: Denmark. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_FINLAND` | Console locale value 11: Finland. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_FRANCE` | Console locale value 12: France. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_GERMANY` | Console locale value 13: Germany. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_GREAT_BRITAIN` | Console locale value 35: the United Kingdom. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_GREECE` | Console locale value 14: Greece. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_HONG_KONG` | Console locale value 15: Hong Kong. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_HUNGARY` | Console locale value 16: Hungary. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_INDIA` | Console locale value 17: India. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_IRELAND` | Console locale value 18: Ireland. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_ISRAEL` | Console locale value 42: Israel. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_ITALY` | Console locale value 19: Italy. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_JAPAN` | Console locale value 20: Japan. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_KOREA` | Console locale value 21: Korea. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_MEXICO` | Console locale value 22: Mexico. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_NETHERLANDS` | Console locale value 23: the Netherlands. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_NEW_ZEALAND` | Console locale value 24: New Zealand. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_NORWAY` | Console locale value 25: Norway. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_POLAND` | Console locale value 26: Poland. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_PORTUGAL` | Console locale value 27: Portugal. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_RUSSIAN_FEDERATION` | Console locale value 37: Russia. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_SAUDI_ARABIA` | Console locale value 41: Saudi Arabia. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_SINGAPORE` | Console locale value 28: Singapore. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_SLOVAK_REPUBLIC` | Console locale value 29: Slovakia. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_SOUTH_AFRICA` | Console locale value 30: South Africa. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_SPAIN` | Console locale value 31: Spain. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_SWEDEN` | Console locale value 32: Sweden. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_SWITZERLAND` | Console locale value 33: Switzerland. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_TAIWAN` | Console locale value 34: Taiwan. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_TURKEY` | Console locale value 39: Turkey. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_UNITED_ARAB_EMIRATES` | Console locale value 43: the United Arab Emirates. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_UNITED_STATES` | Console locale value 36: the United States. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_UNKNOWN` | Console locale value 0: an unknown or unreadable locale. Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |
| `const System.Int32 XC_LOCALE_WORLD_WIDE` | Console locale value 38: no specific country (worldwide). Returned by [`Localization.GetConsoleLocale`](Microsoft.Xbox.Controls.md#localization). |

## MarkerEventArgs

`class Microsoft.Xbox.Controls.MarkerEventArgs`

Provides data for the marker events of [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport) and [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline).

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.NuiTimelineMarker Marker { get; }` | Gets the marker that was entered or exited. |
| `System.TimeSpan TimelinePosition { get; }` | Gets the timeline position at which the marker boundary was crossed (the marker's start or end time). This property is protected; it is visible only to classes that derive from [`MarkerEventArgs`](Microsoft.Xbox.Controls.md#markereventargs). |

## MediaElementAdapterState

`enum Microsoft.Xbox.Controls.MediaElementAdapterState`

The playback states reported by an [`IMediaElementAdapter`](Microsoft.Xbox.Controls.md#imediaelementadapter).

**Values**

| | |
|---|---|
| `Busy` | The player is buffering, acquiring a license or otherwise not ready to play; the transport shows its busy indicator. |
| `Closed` | No media is open, or media is still opening. |
| `Paused` | Playback is paused. |
| `Playing` | Media is playing. |
| `Stopped` | Playback is stopped. |

## MediaTransport

`class Microsoft.Xbox.Controls.MediaTransport`

Full-screen video playback chrome for Xbox: an overlay with a NUI timeline, a controller transport bar, status text, a busy indicator and an optional custom control panel, wired to a media player.

Put a `MediaElement`, a Smooth Streaming `SmoothStreamingMediaElement` or your own [`IMediaElementAdapter`](Microsoft.Xbox.Controls.md#imediaelementadapter) in `Content` (it is assigned to [`MediaTransport.MediaElement`](Microsoft.Xbox.Controls.md#mediatransport) automatically), or set [`MediaTransport.MediaElement`](Microsoft.Xbox.Controls.md#mediatransport) directly. While loaded, the transport polls the player every 100 ms and updates [`MediaTransport.Position`](Microsoft.Xbox.Controls.md#mediatransport), [`MediaTransport.Duration`](Microsoft.Xbox.Controls.md#mediatransport), the seekable range, [`MediaTransport.PlayRate`](Microsoft.Xbox.Controls.md#mediatransport), [`MediaTransport.IsBusy`](Microsoft.Xbox.Controls.md#mediatransport) and the automatic button states.

Input: A, Start, Enter or the D-pad show the transport bar with focus on Play/Pause; the triggers rewind and fast forward; the shoulder buttons skip to the previous/next chapter marker; B hides the bar, panel or overlay, and raises [`MediaTransport.Back`](Microsoft.Xbox.Controls.md#mediatransport) when nothing is left to hide; the Back button always raises [`MediaTransport.Back`](Microsoft.Xbox.Controls.md#mediatransport). Remote media keys are routed through [`MediaTransport.ExecuteMediaCommand`](Microsoft.Xbox.Controls.md#mediatransport). With Kinect, an engaged user sees the overlay and can scrub the timeline with the hand gesture handled by [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline).

Fast forward and rewind are emulated: the player is paused and the timeline position advances at the selected [`PlayRate`](Microsoft.Xbox.Controls.md#playrate); the player is seeked to the previewed position when the user plays or pauses.

Side effects while loaded and enabled: the console is told that video is playing (native ordinal 602) so the dashboard treats the app as a media app; the media state (position, duration, rate, capabilities and [`MediaTransport.MediaAssetId`](Microsoft.Xbox.Controls.md#mediatransport)) is reported for companion devices (native ordinal 600); the screen saver is suppressed during playback when [`MediaTransport.IsScreenSaverAutoDisabled`](Microsoft.Xbox.Controls.md#mediatransport) is set (requires GamerServices to be initialized, which [`XboxApplicationFrame`](Microsoft.Xbox.Controls.md#xboxapplicationframe) does); and play, pause, stop, skip and scrub actions are reported to the media usage service.

Important: the usage reporting requires [`MediaTransport.MediaAssetId`](Microsoft.Xbox.Controls.md#mediatransport). Play, Pause, Stop, skip, scrubbing, Back and rate changes throw `InvalidOperationException` if it is `null` or empty, so set it before playback starts.

**Constructors**

| | |
|---|---|
| `MediaTransport()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.LeftButtonMode LeftButtonMode { get; set; }` | Gets or sets which button is shown on the left of the overlay. |
| `Microsoft.Xbox.Controls.NuiTimeline NuiTimeline { get; }` | Gets the [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline) template part named `NuiTimeline`. |
| `Microsoft.Xbox.Controls.PlayRate PlayRate { get; }` | Gets the current playback rate. Changes raise `PlayRateChanged` and update the play/pause button and voice commands. |
| `Microsoft.Xbox.Controls.SignalStrengthMode SignalStrengthMode { get; set; }` | Gets or sets the signal-strength indicator shown on the timeline. |
| `Microsoft.Xbox.Controls.TransportBar TransportBar { get; }` | Gets the [`TransportBar`](Microsoft.Xbox.Controls.md#transportbar) template part named `TransportBar`. |
| `System.Boolean AutoShowCustomControlPanelWithVuiBar { get; set; }` | Gets or sets whether the custom control panel is shown, and the transport bar hidden, while the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) is visible. While the voice bar is shown the panel's bottom margin is raised so it sits above the bar; the margin and transport bar are restored when the voice bar hides. |
| `System.Boolean IsAutoDisengageEnabled { get; set; }` | Gets or sets whether the engaged Kinect user is automatically disengaged during playback. When enabled, the user is force-disengaged 10 seconds after the overlay was last shown if the media is still playing, so the hand cursor does not stay over the video. |
| `System.Boolean IsBusy { get; }` | Gets whether the player is busy (buffering, opening a license and so on). |
| `System.Boolean IsCustomControlPanelEnabled { get; set; }` | Gets or sets whether the custom control panel is used. When enabled, the panel is shown together with the transport bar and the overlay, the D-pad up/down keys open the transport bar, and the panel can be shown with [`MediaTransport.ShowCustomControlPanel`](Microsoft.Xbox.Controls.md#mediatransport). Disabling it hides the panel. |
| `System.Boolean IsCustomControlPanelVisible { get; }` | Gets whether the custom control panel is visible. |
| `System.Boolean IsDisplayModeEnabled { get; set; }` | Gets or sets whether the Display command (cycle the video stretch mode) is available. |
| `System.Boolean IsDisplayModeVisible { get; set; }` | Gets or sets whether the Display Mode button is shown in the transport bar. |
| `System.Boolean IsFastForwardEnabled { get; set; }` | Gets or sets whether the Fast Forward command is available. Once you set this property it no longer follows the player. It also controls the Fast Forward and Faster voice commands. |
| `System.Boolean IsFastForwardVisible { get; set; }` | Gets or sets whether the Fast Forward button is shown in the transport bar. |
| `System.Boolean IsInfoEnabled { get; set; }` | Gets or sets whether the Info command (toggle the overlay) is available. |
| `System.Boolean IsInfoVisible { get; set; }` | Gets or sets whether the Info button is shown in the transport bar. |
| `System.Boolean IsLiveEnabled { get; set; }` | Gets or sets whether the Live command (jump to the live edge) is available. Once you set this property it no longer follows the player. |
| `System.Boolean IsLiveVisible { get; set; }` | Gets or sets whether the Live button is shown in the transport bar. |
| `System.Boolean IsNuiActive { get; }` | Gets whether the Kinect (NUI) controls are active. |
| `System.Boolean IsOverlayVisible { get; }` | Gets whether the overlay (timeline, Back/Stop and Play/Pause buttons) is visible. Raises `IsOverlayVisibleChanged` when it changes. |
| `System.Boolean IsPlayCountUsageEnabled { get; set; }` | Gets or sets whether media usage events are uploaded to the usage service. Even when disabled, the transport still requires [`MediaTransport.MediaAssetId`](Microsoft.Xbox.Controls.md#mediatransport) for its usage bookkeeping. |
| `System.Boolean IsPlayPauseEnabled { get; set; }` | Gets or sets whether the Play and Pause commands are available. Once you set this property it no longer follows the player. It also controls the Play/Pause voice commands and is reported to companion devices. |
| `System.Boolean IsPlayPauseVisible { get; set; }` | Gets or sets whether the Play and Pause buttons are shown. |
| `System.Boolean IsProgressBarEnabled { get; set; }` | Gets or sets whether the timeline shows the playback progress bar. |
| `System.Boolean IsRewindEnabled { get; set; }` | Gets or sets whether the Rewind command is available. Once you set this property it no longer follows the player. It also controls the Rewind and Slower voice commands. |
| `System.Boolean IsRewindVisible { get; set; }` | Gets or sets whether the Rewind button is shown in the transport bar. |
| `System.Boolean IsScreenSaverAutoDisabled { get; set; }` | Gets or sets whether the console screen saver is suppressed while media plays. The screen saver is turned off while the transport is enabled, in the live tree and playing at normal speed, and restored otherwise. This uses `Guide.IsScreenSaverEnabled` and does nothing unless GamerServices has been initialized (as [`XboxApplicationFrame`](Microsoft.Xbox.Controls.md#xboxapplicationframe) does). |
| `System.Boolean IsScrubbing { get; }` | Gets whether the user is currently scrubbing the timeline. |
| `System.Boolean IsScrubbingAllowed { get; }` | Gets whether timeline scrubbing is possible right now. |
| `System.Boolean IsScrubbingEnabled { get; set; }` | Gets or sets whether the user may scrub the timeline with Kinect. Scrubbing is actually possible only when [`MediaTransport.IsScrubbingAllowed`](Microsoft.Xbox.Controls.md#mediatransport) is `true`. |
| `System.Boolean IsSkipBackEnabled { get; set; }` | Gets or sets whether the Skip Back (previous chapter) command is available. Once you set this property it no longer follows the player. |
| `System.Boolean IsSkipBackVisible { get; set; }` | Gets or sets whether the Skip Back button is shown in the transport bar. |
| `System.Boolean IsSkipForwardEnabled { get; set; }` | Gets or sets whether the Skip Forward (next chapter) command is available. Once you set this property it no longer follows the player. |
| `System.Boolean IsSkipForwardVisible { get; set; }` | Gets or sets whether the Skip Forward button is shown in the transport bar. |
| `System.Boolean IsStatusVisible { get; }` | Gets whether the status area is visible. |
| `System.Boolean IsStopEnabled { get; set; }` | Gets or sets whether the Stop command is available. Once you set this property it no longer follows the player state. It also controls the Stop voice command. |
| `System.Boolean IsStopVisible { get; set; }` | Gets or sets whether the Stop button is shown in the transport bar. |
| `System.Boolean IsThumbnailEnabled { get; set; }` | Gets or sets whether the timeline shows a preview thumbnail while scrubbing, fast forwarding or rewinding. Provide the thumbnail through [`MediaTransport.ThumbnailContent`](Microsoft.Xbox.Controls.md#mediatransport), typically in response to [`MediaTransport.ThumbnailRequest`](Microsoft.Xbox.Controls.md#mediatransport). |
| `System.Boolean IsTransportBarVisible { get; }` | Gets whether the controller transport bar is visible. The bar hides itself when the user switches to Kinect gestures. |
| `System.Collections.ObjectModel.ObservableCollection<Microsoft.Xbox.Controls.NuiTimelineMarker> Markers { get; }` | Gets the collection of markers displayed on the timeline. Add [`ChapterMarker`](Microsoft.Xbox.Controls.md#chaptermarker) objects to enable chapter skipping with the shoulder buttons and snapping while scrubbing. The transport raises [`MediaTransport.MarkerEntered`](Microsoft.Xbox.Controls.md#mediatransport) and [`MediaTransport.MarkerExited`](Microsoft.Xbox.Controls.md#mediatransport) as playback crosses markers. |
| `System.Collections.ObjectModel.ObservableCollection<Microsoft.Xbox.Controls.TransportBarButton> TransportBarButtons { get; }` | Gets the buttons displayed in the transport bar. When the transport loads, it inserts its built-in buttons at the front of the collection (Play, Pause, Skip Back, Rewind, Stop, Fast Forward, Skip Forward, Live, Info and Display Mode) and removes them again when it unloads or the culture changes. Add your own buttons after them. |
| `System.Double StatusContentWidth { get; }` | Gets the width available to the status area. |
| `System.Double ThumbnailAspectRatio { get; set; }` | Gets or sets the width-to-height ratio of the preview thumbnail. Once you set this property it no longer follows the control size. |
| `System.Object CustomControlPanelContent { get; set; }` | Gets or sets app-defined content shown in the custom control panel above the transport bar. The panel is used only when [`MediaTransport.IsCustomControlPanelEnabled`](Microsoft.Xbox.Controls.md#mediatransport) is `true`. Focusable controls in it can be reached from the transport bar with the D-pad; if the content is replaced while it has focus, focus moves to its first focusable child or back to the transport. |
| `System.Object LowerOverlayContent { get; set; }` | Gets or sets app-defined content placed in the lower part of the overlay. |
| `System.Object MediaElement { get; set; }` | Gets or sets the player that the transport controls. Setting `Content` to one of the supported types sets this property for you. Adapters created internally for the built-in player types are disposed when the player is replaced; adapters you supply are not. The property is cleared when the transport is unloaded. |
| `System.Object StatusContent { get; set; }` | Gets or sets the content of the status area shown above the transport bar. The transport writes its own status text here (for example the play rate) when media commands run while the overlay is visible. |
| `System.Object ThumbnailContent { get; set; }` | Gets or sets the content shown in the timeline's preview thumbnail. Update it from a [`MediaTransport.ThumbnailRequest`](Microsoft.Xbox.Controls.md#mediatransport) handler. |
| `System.Object UpperOverlayContent { get; set; }` | Gets or sets app-defined content placed in the upper part of the overlay. |
| `System.String EndPositionText { get; }` | Gets the formatted end position shown on the timeline. |
| `System.String MediaAssetId { get; set; }` | Gets or sets an identifier for the content being played, used for usage reporting and companion-device media state. Set this before playback starts: the transport's play, pause, stop, skip, scrub and Back handling throw `InvalidOperationException` when it is missing. Assigning a value reports a play event for the new asset and an end event for the previous one. IDs of 256 UTF-8 bytes or more are not passed to companion devices. |
| `System.String PositionText { get; }` | Gets the formatted current position shown on the timeline. |
| `System.TimeSpan Duration { get; set; }` | Gets or sets the length of the timeline. Once you set this property the transport stops updating it from the player. |
| `System.TimeSpan EndPosition { get; }` | Gets the media time shown at the right end of the timeline. |
| `System.TimeSpan MaximumPosition { get; set; }` | Gets or sets the latest position the user can seek or scrub to. Once you set this property the transport stops updating it from the player. Companion seek requests outside the minimum/maximum range are ignored. |
| `System.TimeSpan MinimumPosition { get; set; }` | Gets or sets the earliest position the user can seek or scrub to. Once you set this property the transport stops updating it from the player. Fast forward and rewind stop at this bound. |
| `System.TimeSpan Position { get; }` | Gets the current playback position. Changes update [`MediaTransport.PositionText`](Microsoft.Xbox.Controls.md#mediatransport), raise [`MediaTransport.MarkerEntered`](Microsoft.Xbox.Controls.md#mediatransport)/[`MediaTransport.MarkerExited`](Microsoft.Xbox.Controls.md#mediatransport) as markers are crossed, and raise [`MediaTransport.ThumbnailRequest`](Microsoft.Xbox.Controls.md#mediatransport) while the timeline thumbnail is visible. Use [`MediaTransport.Seek`](Microsoft.Xbox.Controls.md#mediatransport) to change the position. |
| `System.TimeSpan StartPosition { get; set; }` | Gets or sets the media time shown at the left end of the timeline. Once you set this property the transport stops updating it from the player. [`MediaTransport.EndPosition`](Microsoft.Xbox.Controls.md#mediatransport) is recalculated. |
| `System.Windows.Controls.ProgressBar BusyProgressBar { get; }` | Gets the progress bar template part named `BusyProgressBar` that is shown while the player is buffering. |
| `System.Windows.Data.IValueConverter EndPositionConverter { get; set; }` | Gets or sets the converter that turns [`MediaTransport.EndPosition`](Microsoft.Xbox.Controls.md#mediatransport) into [`MediaTransport.EndPositionText`](Microsoft.Xbox.Controls.md#mediatransport). |
| `System.Windows.Data.IValueConverter PositionConverter { get; set; }` | Gets or sets the converter that turns [`MediaTransport.Position`](Microsoft.Xbox.Controls.md#mediatransport) into [`MediaTransport.PositionText`](Microsoft.Xbox.Controls.md#mediatransport). |
| `System.Windows.DataTemplate CustomControlPanelContentTemplate { get; set; }` | Gets or sets the data template used to display [`MediaTransport.CustomControlPanelContent`](Microsoft.Xbox.Controls.md#mediatransport). |
| `System.Windows.Media.Stretch Stretch { get; }` | Gets the current video stretch mode. |
| `System.Windows.Media.Transform CustomControlPanelRenderTransform { get; set; }` | Gets or sets a render transform applied to the custom control panel. |
| `System.Windows.Point CustomControlPanelRenderTransformOrigin { get; set; }` | Gets or sets the origin of [`MediaTransport.CustomControlPanelRenderTransform`](Microsoft.Xbox.Controls.md#mediatransport), in relative coordinates. |
| `System.Windows.Style ProgressRangeMarkerStyle { get; set; }` | Gets or sets the style of the timeline bar that marks playback progress. |
| `System.Windows.Style SeekableRangeMarkerStyle { get; set; }` | Gets or sets the style of the timeline bar that marks the seekable range. |
| `System.Windows.Style TransportBarButtonStyle { get; set; }` | Gets or sets a style for the transport bar buttons. |

**Methods**

| | |
|---|---|
| `System.Void AddDefaultVuiBarCommands()` | Adds the standard media voice commands to the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar). Adds Play, Pause and Stop to [`VuiBar.PrimaryCommands`](Microsoft.Xbox.Controls.md#vuibar) and Fast Forward, Rewind, Slower and Faster to [`VuiBar.SecondaryCommands`](Microsoft.Xbox.Controls.md#vuibar), skipping any already present. The transport handles these commands while it is loaded and enables or disables them to match its state. Throws `InvalidOperationException` if no [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) exists. |
| `System.Void ExecuteMediaCommand(System.Windows.Media.MediaCommand command)` | Carries out a media command as if the user had pressed the corresponding button. Commands whose `Is…Enabled` property is `false` are ignored. After a command runs, the overlay is shown with a status message, [`MediaTransport.MediaCommandExecuted`](Microsoft.Xbox.Controls.md#mediatransport) is raised and the media state is reported to companion devices. Fast forward and rewind step through the [`PlayRate`](Microsoft.Xbox.Controls.md#playrate) values (2x up to 128x) on each call. PreviousTrack and NextTrack seek to the previous/next [`ChapterMarker`](Microsoft.Xbox.Controls.md#chaptermarker) (or the start/end of the seekable range) and play. Play, Pause, Stop and skip commands require [`MediaTransport.MediaAssetId`](Microsoft.Xbox.Controls.md#mediatransport). |
| `System.Void HideCustomControlPanel()` | Hides the custom control panel, if [`MediaTransport.IsCustomControlPanelEnabled`](Microsoft.Xbox.Controls.md#mediatransport) is `true`. |
| `System.Void HideOverlay()` | Hides the overlay and cancels any keep-visible request. Also hides the status area unless it was shown with auto-hide disabled. |
| `System.Void HideStatus()` | Hides the status area and cancels any keep-visible request. |
| `System.Void HideTransportBar()` | Hides the transport bar and cancels any keep-visible request from [`MediaTransport.ShowTransportBar`](Microsoft.Xbox.Controls.md#mediatransport). If focus was in the bar, it moves to the transport itself. |
| `System.Void OnApplyTemplate()` |  |
| `System.Void OnContentChanged(System.Object oldContent, System.Object newContent)` | Called when `Content` changes; assigns supported player objects to [`MediaTransport.MediaElement`](Microsoft.Xbox.Controls.md#mediatransport). |
| `System.Void RemoveDefaultVuiBarCommands()` | Removes the standard media voice commands added by [`MediaTransport.AddDefaultVuiBarCommands`](Microsoft.Xbox.Controls.md#mediatransport) from the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar). Throws `InvalidOperationException` if no [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) exists. Call it when leaving the playback page so the commands do not stay on the voice bar. |
| `System.Void Seek(System.TimeSpan newPosition)` | Seeks the player to a new position. Does nothing if there is no player, the media is closed, the player cannot seek, or it is already at that position. Cancels any fast forward or rewind and raises [`MediaTransport.SeekExecuted`](Microsoft.Xbox.Controls.md#mediatransport). |
| `System.Void SeekToLive()` | Seeks a live stream to its live edge and starts playing. Does nothing unless the player is open, can seek and reports live content. Raises [`MediaTransport.SeekExecuted`](Microsoft.Xbox.Controls.md#mediatransport) with [`SeekExecutedEventArgs.IsToLive`](Microsoft.Xbox.Controls.md#seekexecutedeventargs) set. |
| `System.Void ShowCustomControlPanel(System.Boolean autoHide)` | Shows the custom control panel, if [`MediaTransport.IsCustomControlPanelEnabled`](Microsoft.Xbox.Controls.md#mediatransport) is `true`. |
| `System.Void ShowOverlay(System.Boolean autoHide)` | Shows the overlay with the timeline and buttons. Also restarts the 10-second Kinect auto-disengage timer (see [`MediaTransport.IsAutoDisengageEnabled`](Microsoft.Xbox.Controls.md#mediatransport)). |
| `System.Void ShowStatus()` | Shows the status area with its current [`MediaTransport.StatusContent`](Microsoft.Xbox.Controls.md#mediatransport), hiding it again after 5 seconds. |
| `System.Void ShowStatus(System.Boolean autoHide)` | Shows the status area with its current [`MediaTransport.StatusContent`](Microsoft.Xbox.Controls.md#mediatransport). |
| `System.Void ShowStatus(System.String statusText)` | Sets [`MediaTransport.StatusContent`](Microsoft.Xbox.Controls.md#mediatransport) to a message and shows it for 5 seconds. |
| `System.Void ShowStatus(System.String statusText, System.Boolean autoHide)` | Sets [`MediaTransport.StatusContent`](Microsoft.Xbox.Controls.md#mediatransport) to a message and shows it. |
| `System.Void ShowTransportBar(System.Boolean autoHide)` | Shows the controller transport bar. |

**Events**

| | |
|---|---|
| `event System.EventHandler Back` | Occurs when the user asks to leave playback: the Back button on the overlay or controller, or B when nothing is left to hide. Typically handled by navigating back. A usage stop event is reported first, which requires [`MediaTransport.MediaAssetId`](Microsoft.Xbox.Controls.md#mediatransport). |
| `event System.EventHandler IsCustomControlPanelEnabledChanged` |  |
| `event System.EventHandler IsCustomControlPanelVisibleChanged` |  |
| `event System.EventHandler IsOverlayVisibleChanged` |  |
| `event System.EventHandler IsStatusVisibleChanged` |  |
| `event System.EventHandler IsTransportBarVisibleChanged` |  |
| `event System.EventHandler Stop` | Occurs after the Stop command has stopped the player. |
| `event System.EventHandler<Microsoft.Xbox.Controls.MarkerEventArgs> MarkerEntered` | Occurs when playback reaches the start of a marker in [`MediaTransport.Markers`](Microsoft.Xbox.Controls.md#mediatransport). Markers with zero duration raise this event immediately followed by [`MediaTransport.MarkerExited`](Microsoft.Xbox.Controls.md#mediatransport). Events are raised when crossing markers in either direction; replacing the collection does not raise events for the starting position. |
| `event System.EventHandler<Microsoft.Xbox.Controls.MarkerEventArgs> MarkerExited` | Occurs when playback leaves a marker in [`MediaTransport.Markers`](Microsoft.Xbox.Controls.md#mediatransport). |
| `event System.EventHandler<Microsoft.Xbox.Controls.PlayRateChangedEventArgs> PlayRateChanged` |  |
| `event System.EventHandler<Microsoft.Xbox.Controls.SeekExecutedEventArgs> SeekExecuted` | Occurs after the transport has seeked the player, including seeks to the live edge. |
| `event System.EventHandler<Microsoft.Xbox.Controls.ThumbnailRequestEventArgs> ThumbnailRequest` | Occurs when the position changes while the timeline thumbnail is visible (during scrubbing, fast forward or rewind). Update [`MediaTransport.ThumbnailContent`](Microsoft.Xbox.Controls.md#mediatransport) with an image for the requested position. The event can be raised many times per second. |
| `event System.EventHandler<System.Windows.Media.MediaCommandEventArgs> MediaCommandExecuted` | Occurs after a media command has been carried out by [`MediaTransport.ExecuteMediaCommand`](Microsoft.Xbox.Controls.md#mediatransport). The event data contains the command actually run; a toggle is reported as Play or Pause. Commands that were disabled do not raise the event. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty AutoShowCustomControlPanelWithVuiBarProperty` |  |
| `static System.Windows.DependencyProperty CustomControlPanelContentProperty` |  |
| `static System.Windows.DependencyProperty CustomControlPanelContentTemplateProperty` |  |
| `static System.Windows.DependencyProperty CustomControlPanelRenderTransformOriginProperty` |  |
| `static System.Windows.DependencyProperty CustomControlPanelRenderTransformProperty` |  |
| `static System.Windows.DependencyProperty DurationProperty` |  |
| `static System.Windows.DependencyProperty EndPositionConverterProperty` |  |
| `static System.Windows.DependencyProperty EndPositionProperty` |  |
| `static System.Windows.DependencyProperty EndPositionTextProperty` |  |
| `static System.Windows.DependencyProperty IsAutoDisengageEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsBusyProperty` |  |
| `static System.Windows.DependencyProperty IsCustomControlPanelEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsCustomControlPanelVisibleProperty` |  |
| `static System.Windows.DependencyProperty IsDisplayModeEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsDisplayModeVisibleProperty` |  |
| `static System.Windows.DependencyProperty IsFastForwardEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsFastForwardVisibleProperty` |  |
| `static System.Windows.DependencyProperty IsInfoEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsInfoVisibleProperty` |  |
| `static System.Windows.DependencyProperty IsLiveEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsLiveVisibleProperty` |  |
| `static System.Windows.DependencyProperty IsNuiActiveProperty` |  |
| `static System.Windows.DependencyProperty IsOverlayVisibleProperty` |  |
| `static System.Windows.DependencyProperty IsPlayCountUsageEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsPlayPauseEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsPlayPauseVisibleProperty` |  |
| `static System.Windows.DependencyProperty IsProgressBarEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsRewindEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsRewindVisibleProperty` |  |
| `static System.Windows.DependencyProperty IsScreenSaverAutoDisabledProperty` |  |
| `static System.Windows.DependencyProperty IsScrubbingAllowedProperty` |  |
| `static System.Windows.DependencyProperty IsScrubbingEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsScrubbingProperty` |  |
| `static System.Windows.DependencyProperty IsSkipBackEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsSkipBackVisibleProperty` |  |
| `static System.Windows.DependencyProperty IsSkipForwardEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsSkipForwardVisibleProperty` |  |
| `static System.Windows.DependencyProperty IsStatusVisibleProperty` |  |
| `static System.Windows.DependencyProperty IsStopEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsStopVisibleProperty` |  |
| `static System.Windows.DependencyProperty IsThumbnailEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsTransportBarVisibleProperty` |  |
| `static System.Windows.DependencyProperty LeftButtonModeProperty` |  |
| `static System.Windows.DependencyProperty LowerOverlayContentProperty` |  |
| `static System.Windows.DependencyProperty MarkersProperty` |  |
| `static System.Windows.DependencyProperty MaximumPositionProperty` |  |
| `static System.Windows.DependencyProperty MediaAssetIdProperty` |  |
| `static System.Windows.DependencyProperty MediaElementProperty` |  |
| `static System.Windows.DependencyProperty MinimumPositionProperty` |  |
| `static System.Windows.DependencyProperty PlayRateProperty` |  |
| `static System.Windows.DependencyProperty PositionConverterProperty` |  |
| `static System.Windows.DependencyProperty PositionProperty` |  |
| `static System.Windows.DependencyProperty PositionTextProperty` |  |
| `static System.Windows.DependencyProperty ProgressRangeMarkerStyleProperty` |  |
| `static System.Windows.DependencyProperty SeekableRangeMarkerStyleProperty` |  |
| `static System.Windows.DependencyProperty SignalStrengthModeProperty` |  |
| `static System.Windows.DependencyProperty StartPositionProperty` |  |
| `static System.Windows.DependencyProperty StatusContentProperty` |  |
| `static System.Windows.DependencyProperty StatusContentWidthProperty` |  |
| `static System.Windows.DependencyProperty StretchProperty` |  |
| `static System.Windows.DependencyProperty ThumbnailAspectRatioProperty` |  |
| `static System.Windows.DependencyProperty ThumbnailContentProperty` |  |
| `static System.Windows.DependencyProperty TransportBarButtonStyleProperty` |  |
| `static System.Windows.DependencyProperty TransportBarButtonsProperty` |  |
| `static System.Windows.DependencyProperty UpperOverlayContentProperty` |  |

## NuiScrollViewer

`class Microsoft.Xbox.Controls.NuiScrollViewer`

A vertically scrolling content area designed for both the controller and the Kinect hand cursor.

With the controller, holding D-pad up/down or pushing the left stick past 75% scrolls smoothly, starting slowly and accelerating. The key press is marked handled only when there is room to scroll in that direction, so focus can leave the viewer at the ends.

With Kinect, hovering the hand cursor over the viewer for 300 ms gives it focus, and while the cursor is over the upper three eighths or lower three eighths of the viewer the content scrolls up or down. Template parts: `ScrollViewer` (`ScrollViewer`) and `Cursor` (Grid); visual state groups for scrolling up/down, cursor and focus.

It is a supported host for the [`Legend`](Microsoft.Xbox.Controls.md#legend) attached properties.

**Constructors**

| | |
|---|---|
| `NuiScrollViewer()` |  |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |

## NuiTimeline

`class Microsoft.Xbox.Controls.NuiTimeline`

The media timeline used by [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport): a progress bar with markers, position text, a preview thumbnail and a Kinect "gearshift" handle for scrubbing.

While loaded, the timeline creates a native scrub tracker (npctrl.dll ordinals 500–510) that follows the engaged Kinect user's hand on the gearshift handle. Dragging the handle zooms the timeline in, moves [`NuiTimeline.Position`](Microsoft.Xbox.Controls.md#nuitimeline), snaps to snappable markers once the user commits, and raises [`NuiTimeline.ScrubbingStarted`](Microsoft.Xbox.Controls.md#nuitimeline), [`NuiTimeline.Scrubbing`](Microsoft.Xbox.Controls.md#nuitimeline) and [`NuiTimeline.ScrubbingCompleted`](Microsoft.Xbox.Controls.md#nuitimeline). Scrubbing only happens while [`NuiTimeline.IsScrubbingEnabled`](Microsoft.Xbox.Controls.md#nuitimeline) is `true`, so it needs a Kinect sensor and an engaged user.

Template parts: `TimelineBarPanel` (Panel), `TimelinePositionPanel` (Panel) and `Gearshift` ([`NuiGearshift`](Microsoft.Xbox.Controls.Primitives.md#nuigearshift)). Visual state groups: `ZoomStates` (ZoomedIn/ZoomedOut), `ThumbnailVisibilityStates` and `GearshiftVisibiltyStates`.

The many read-only `Interpolated…`, `…Offset…` and `…Width` properties are layout values computed for the template; apps normally only set the position range, [`NuiTimeline.Markers`](Microsoft.Xbox.Controls.md#nuitimeline) and the content properties.

**Constructors**

| | |
|---|---|
| `NuiTimeline()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean IsPreviewing { get; set; }` | Gets or sets whether the timeline is showing a preview position, as during fast forward or rewind. |
| `System.Boolean IsProgressBarEnabled { get; set; }` | Gets or sets whether the playback progress bar is shown. |
| `System.Boolean IsScrubbing { get; }` | Gets whether the user is currently scrubbing. |
| `System.Boolean IsScrubbingEnabled { get; set; }` | Gets or sets whether Kinect scrubbing is enabled and the gearshift handle is shown. Turning it off during a scrub completes the scrub. |
| `System.Boolean IsThumbnailEnabled { get; set; }` | Gets or sets whether the preview thumbnail may be shown. |
| `System.Boolean IsThumbnailVisible { get; }` | Gets whether the preview thumbnail is currently shown. |
| `System.Boolean IsThumbnailWidthPrimaryAxis { get; set; }` | Gets or sets whether the thumbnail size limits apply to its width (`true`) or its height (`false`). |
| `System.Collections.ObjectModel.ObservableCollection<Microsoft.Xbox.Controls.NuiTimelineMarker> Markers { get; set; }` | Gets or sets the markers drawn on the timeline. Markers whose [`NuiTimelineMarker.IsSnappable`](Microsoft.Xbox.Controls.md#nuitimelinemarker) is `true` are passed to the scrub tracker as chapter points. Changes to the collection are tracked. |
| `System.Double InterpolatedTimelineZoomOffsetX { get; }` | Gets the horizontal offset of the timeline bar at the current point of the zoom animation. |
| `System.Double InterpolatedTimelineZoomOffsetY { get; }` | Gets the vertical offset of the timeline bar at the current point of the zoom animation. |
| `System.Double InterpolatedTimelineZoomProgress { get; set; }` | Gets or sets how far the zoom animation has progressed, from 0 (zoomed out) to 1 (zoomed in). |
| `System.Double InterpolatedTimelineZoomWidth { get; }` | Gets the width of the timeline bar at the current point of the zoom animation. |
| `System.Double MaximumThumbnailSize { get; set; }` | Gets or sets the size of the thumbnail along its primary axis when the user has fully committed to a scrub. |
| `System.Double MinimumThumbnailSize { get; set; }` | Gets or sets the size of the thumbnail along its primary axis before the user commits to a scrub. |
| `System.Double PositionProgress { get; }` | Gets the position as a fraction of the timeline. |
| `System.Double ThumbnailAspectRatio { get; set; }` | Gets or sets the width-to-height ratio of the preview thumbnail. |
| `System.Double ThumbnailContentHeight { get; }` | Gets the current height of the preview thumbnail. |
| `System.Double ThumbnailContentWidth { get; }` | Gets the current width of the preview thumbnail. |
| `System.Double TimelineBaseWidth { get; }` | Gets the width of the timeline when it is not zoomed. |
| `System.Double TimelinePositionPanelOffsetX { get; }` | Gets the horizontal offset that centers the position panel over the current position. |
| `System.Object PositionContent { get; set; }` | Gets or sets content shown above the current position on the timeline. |
| `System.Object ThumbnailContent { get; set; }` | Gets or sets the content of the preview thumbnail. |
| `System.Object TimelineLeftContent { get; set; }` | Gets or sets content shown at the left end of the timeline (the current position text in [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport)). |
| `System.Object TimelineRightContent { get; set; }` | Gets or sets content shown at the right end of the timeline (the signal-strength indicator and end time in [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport)). |
| `System.TimeSpan Duration { get; set; }` | Gets or sets the length of the timeline. The amount of time covered by the zoomed-in timeline while scrubbing grows with the duration (11 minutes per started hour). |
| `System.TimeSpan EndPosition { get; }` | Gets the media time at the right end of the timeline. |
| `System.TimeSpan MaximumPosition { get; set; }` | Gets or sets the latest position that scrubbing and chapter skipping can reach. |
| `System.TimeSpan MinimumPosition { get; set; }` | Gets or sets the earliest position that scrubbing and chapter skipping can reach. |
| `System.TimeSpan Position { get; set; }` | Gets or sets the current position shown on the timeline. |
| `System.TimeSpan StartPosition { get; set; }` | Gets or sets the media time at the left end of the timeline. |
| `System.Windows.Style ProgressRangeMarkerStyle { get; set; }` | Gets or sets the style of the bar that marks playback progress. |
| `System.Windows.Style SeekableRangeMarkerStyle { get; set; }` | Gets or sets the style of the bar that marks the seekable range. |

**Methods**

| | |
|---|---|
| `System.TimeSpan GetSeekBackPosition()` | Gets the position of the previous chapter point before the current position. |
| `System.TimeSpan GetSeekForwardPosition()` | Gets the position of the next chapter point after the current position. |
| `System.Void OnApplyTemplate()` |  |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xbox.Controls.MarkerEventArgs> MarkerEntered` | Declared for markers entered on the timeline. In this version [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline) does not raise this event; handle [`MediaTransport.MarkerEntered`](Microsoft.Xbox.Controls.md#mediatransport) instead. |
| `event System.EventHandler<Microsoft.Xbox.Controls.MarkerEventArgs> MarkerExited` | Declared for markers exited on the timeline. In this version [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline) does not raise this event; handle [`MediaTransport.MarkerExited`](Microsoft.Xbox.Controls.md#mediatransport) instead. |
| `event System.EventHandler<Microsoft.Xbox.Controls.ScrubbingCompletedEventArgs> ScrubbingCompleted` | Occurs when the scrub gesture ends. Check [`ScrubbingCompletedEventArgs.Cancelled`](Microsoft.Xbox.Controls.md#scrubbingcompletedeventargs): the scrub counts as cancelled if the user released before committing (commit progress under 10%). [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport) seeks the player only for scrubs that were not cancelled. |
| `event System.EventHandler<Microsoft.Xbox.Controls.ScrubbingEventArgs> Scrubbing` | Occurs repeatedly while the user scrubs, after [`NuiTimeline.Position`](Microsoft.Xbox.Controls.md#nuitimeline) has been updated. |
| `event System.EventHandler<Microsoft.Xbox.Controls.ScrubbingEventArgs> ScrubbingStarted` | Occurs when the user starts a Kinect scrub gesture. [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport) pauses playback in response. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty DurationProperty` |  |
| `static System.Windows.DependencyProperty EndPositionProperty` |  |
| `static System.Windows.DependencyProperty InterpolatedTimelineZoomOffsetXProperty` |  |
| `static System.Windows.DependencyProperty InterpolatedTimelineZoomOffsetYProperty` |  |
| `static System.Windows.DependencyProperty InterpolatedTimelineZoomProgressProperty` |  |
| `static System.Windows.DependencyProperty InterpolatedTimelineZoomWidthProperty` |  |
| `static System.Windows.DependencyProperty IsPreviewingProperty` |  |
| `static System.Windows.DependencyProperty IsProgressBarEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsScrubbingEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsScrubbingProperty` |  |
| `static System.Windows.DependencyProperty IsThumbnailEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsThumbnailVisibleProperty` |  |
| `static System.Windows.DependencyProperty IsThumbnailWidthPrimaryAxisProperty` |  |
| `static System.Windows.DependencyProperty MarkersProperty` |  |
| `static System.Windows.DependencyProperty MaximumPositionProperty` |  |
| `static System.Windows.DependencyProperty MaximumThumbnailSizeProperty` |  |
| `static System.Windows.DependencyProperty MinimumPositionProperty` |  |
| `static System.Windows.DependencyProperty MinimumThumbnailSizeProperty` |  |
| `static System.Windows.DependencyProperty PositionContentProperty` |  |
| `static System.Windows.DependencyProperty PositionProgressProperty` |  |
| `static System.Windows.DependencyProperty PositionProperty` |  |
| `static System.Windows.DependencyProperty ProgressRangeMarkerStyleProperty` |  |
| `static System.Windows.DependencyProperty SeekableRangeMarkerStyleProperty` |  |
| `static System.Windows.DependencyProperty StartPositionProperty` |  |
| `static System.Windows.DependencyProperty ThumbnailAspectRatioProperty` |  |
| `static System.Windows.DependencyProperty ThumbnailContentHeightProperty` |  |
| `static System.Windows.DependencyProperty ThumbnailContentProperty` |  |
| `static System.Windows.DependencyProperty ThumbnailContentWidthProperty` |  |
| `static System.Windows.DependencyProperty TimelineBaseWidthProperty` |  |
| `static System.Windows.DependencyProperty TimelineLeftContentProperty` |  |
| `static System.Windows.DependencyProperty TimelinePositionPanelOffsetXProperty` |  |
| `static System.Windows.DependencyProperty TimelineRightContentProperty` |  |

## NuiTimelineMarker

`class Microsoft.Xbox.Controls.NuiTimelineMarker`

Base class for items placed on a [`NuiTimeline`](Microsoft.Xbox.Controls.md#nuitimeline) at a point or over a span of time.

Markers are positioned by [`NuiTimelinePanel`](Microsoft.Xbox.Controls.Primitives.md#nuitimelinepanel). Markers outside the visible timeline range are collapsed. Use [`ChapterMarker`](Microsoft.Xbox.Controls.md#chaptermarker) for chapter points and [`TimelineRangeMarker`](Microsoft.Xbox.Controls.md#timelinerangemarker) for ranges, or derive your own styled marker.

**Constructors**

| | |
|---|---|
| `NuiTimelineMarker()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean IsClamped { get; set; }` | Gets or sets whether the marker's span is trimmed to the visible timeline range instead of being hidden when it extends past either end. |
| `System.Boolean IsSnappable { get; set; }` | Gets or sets whether the marker acts as a chapter point. Snappable markers are the targets for skip back/forward and the snap points while scrubbing. |
| `System.Double DurationWidth { get; }` | Gets the on-screen width, in pixels, that corresponds to [`NuiTimelineMarker.Duration`](Microsoft.Xbox.Controls.md#nuitimelinemarker). |
| `System.TimeSpan Duration { get; set; }` | Gets or sets how long the marker lasts. Point markers raise their entered and exited events together. |
| `System.TimeSpan Time { get; set; }` | Gets or sets the media time at which the marker starts. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty DurationProperty` |  |
| `static System.Windows.DependencyProperty DurationWidthProperty` |  |
| `static System.Windows.DependencyProperty IsClampedProperty` |  |
| `static System.Windows.DependencyProperty IsSnappableProperty` |  |
| `static System.Windows.DependencyProperty TimeProperty` |  |

## PeekCompletedEventArgs

`class Microsoft.Xbox.Controls.PeekCompletedEventArgs`

Provides data for the [`SwipeViewer.PeekCompleted`](Microsoft.Xbox.Controls.md#swipeviewer) event.

## PeekProgressChangedEventArgs

`class Microsoft.Xbox.Controls.PeekProgressChangedEventArgs`

Provides data for the [`SwipeViewer.PeekProgressChanged`](Microsoft.Xbox.Controls.md#swipeviewer) event.

**Properties**

| | |
|---|---|
| `System.Double PeekProgress { get; }` | Gets the new peek progress, from 0 (not peeking) to 1 (fully peeking). |

## PeekStartedEventArgs

`class Microsoft.Xbox.Controls.PeekStartedEventArgs`

Provides data for the [`SwipeViewer.PeekStarted`](Microsoft.Xbox.Controls.md#swipeviewer) event.

## Pivot

`class Microsoft.Xbox.Controls.Pivot`

A horizontally swiping tab control: a row of headers above a set of [`PivotItem`](Microsoft.Xbox.Controls.md#pivotitem) pages, with neighbouring pages peeking in from the sides.

Items are wrapped in [`PivotItem`](Microsoft.Xbox.Controls.md#pivotitem) containers (or you can add [`PivotItem`](Microsoft.Xbox.Controls.md#pivotitem) objects directly). The user changes pages with the shoulder buttons, D-pad left/right, the remote's previous/next keys, a Kinect swipe or by selecting a header. D-pad up moves focus to the headers; D-pad down or A on a header moves focus back into the selected page. Inside each page, directional focus moves through the page's top-level `Grid` (see [`PivotItem.AutoGridNav`](Microsoft.Xbox.Controls.md#pivotitem)).

To limit memory use, pages within two positions of the selection are reported as loaded and pages further away as unloaded through [`Pivot.LoadingPivotItem`](Microsoft.Xbox.Controls.md#pivot) and [`Pivot.UnloadingPivotItem`](Microsoft.Xbox.Controls.md#pivot); use these to create and release expensive page content.

Each page's [`PivotItem.VuiCommand`](Microsoft.Xbox.Controls.md#pivotitem) is registered with [`VuiBar.Current`](Microsoft.Xbox.Controls.md#vuibar) while the pivot is loaded; saying it selects and focuses that page. The selected page's command is disabled.

Template parts: `LayoutRoot`, `HeadersListElement` ([`PivotHeadersControl`](Microsoft.Xbox.Controls.Primitives.md#pivotheaderscontrol)), `PivotItemPresenter` (ItemsPresenter) and `SwipeElement` ([`SwipeViewer`](Microsoft.Xbox.Controls.md#swipeviewer)). Because the template contains a [`SwipeViewer`](Microsoft.Xbox.Controls.md#swipeviewer), only one swipe-enabled control can be shown per page.

**Constructors**

| | |
|---|---|
| `Pivot()` |  |

**Properties**

| | |
|---|---|
| `System.Int32 SelectedIndex { get; set; }` | Gets or sets the index of the selected page. Setting an index outside the item range throws `ArgumentOutOfRangeException` (the previous value is restored). Changing the selection animates to the new page and raises [`Pivot.SelectionChanged`](Microsoft.Xbox.Controls.md#pivot). |
| `System.Object SelectedItem { get; set; }` | Gets or sets the selected item. Setting an object that is not in `Items`, or `null` while there are items, throws `ArgumentException` and the previous value is restored. |
| `System.Windows.Data.Binding VuiCommandBinding { get; set; }` | Gets or sets the binding used to fill [`PivotItem.VuiCommand`](Microsoft.Xbox.Controls.md#pivotitem) when the pivot generates containers for data items. Only applies to items that are not [`PivotItem`](Microsoft.Xbox.Controls.md#pivotitem) objects themselves. Setting the property re-applies the binding to existing containers. |
| `System.Windows.DataTemplate HeaderTemplate { get; set; }` | Gets or sets the data template used to display each item's [`PivotItem.Header`](Microsoft.Xbox.Controls.md#pivotitem). |
| `System.Windows.Thickness HeaderPadding { get; set; }` | Gets or sets the padding applied around the header row. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |
| `System.Void OnItemsChanged(System.Collections.Specialized.NotifyCollectionChangedEventArgs e)` | Keeps the selection, headers, page loading and voice commands consistent when items are added or removed. If the selected item is removed, the item at the same index (or the nearest one) becomes selected; if all items are removed, the selection is cleared. |
| `System.Void OnLoadingPivotItem(Microsoft.Xbox.Controls.PivotItem item)` | Raises [`Pivot.LoadingPivotItem`](Microsoft.Xbox.Controls.md#pivot). Override in a derived class to load page content; call the base method to keep the event and visibility handling. |
| `System.Void OnSelectionChanged(System.Windows.Controls.SelectionChangedEventArgs e)` | Raises [`Pivot.SelectionChanged`](Microsoft.Xbox.Controls.md#pivot). |
| `System.Void OnUnloadingPivotItem(Microsoft.Xbox.Controls.PivotItem item)` | Raises [`Pivot.UnloadingPivotItem`](Microsoft.Xbox.Controls.md#pivot). |
| `System.Void PrepareContainerForItemOverride(System.Windows.DependencyObject element, System.Object item)` | Prepares a [`PivotItem`](Microsoft.Xbox.Controls.md#pivotitem) container, applies [`Pivot.VuiCommandBinding`](Microsoft.Xbox.Controls.md#pivot) and registers the page voice commands. |
| `System.Windows.Size ArrangeOverride(System.Windows.Size finalSize)` |  |
| `System.Windows.Size MeasureOverride(System.Windows.Size availableSize)` |  |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xbox.Controls.PivotItemEventArgs> LoadingPivotItem` | Occurs when a page comes within loading range of the selected page (the selection and up to two pages on either side). Use this to create or populate the page's content on demand. A page that was collapsed is made visible before the event is raised. |
| `event System.EventHandler<Microsoft.Xbox.Controls.PivotItemEventArgs> UnloadingPivotItem` | Occurs when a page moves out of loading range of the selected page. Use this to release content created in [`Pivot.LoadingPivotItem`](Microsoft.Xbox.Controls.md#pivot). |
| `event System.Windows.Controls.SelectionChangedEventHandler SelectionChanged` | Occurs when the selected page changes. The event data lists the previous item in `RemovedItems` and the new item in `AddedItems`. It is raised before the page animation finishes. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty HeaderPaddingProperty` |  |
| `static System.Windows.DependencyProperty HeaderTemplateProperty` |  |
| `static System.Windows.DependencyProperty SelectedIndexProperty` |  |
| `static System.Windows.DependencyProperty SelectedItemProperty` |  |

## PivotItem

`class Microsoft.Xbox.Controls.PivotItem`

A page in a [`Pivot`](Microsoft.Xbox.Controls.md#pivot).

Visual states (group `Position States`): `Center`, `Left`, `LeftPeeking`, `Right` and `RightPeeking`. Template parts: `RootElement`, `BackgroundElement` and `ContentPresenterElement`. When the page itself receives focus, focus is forwarded into its content.

**Constructors**

| | |
|---|---|
| `PivotItem()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.VuiCommand VuiCommand { get; set; }` | Gets or sets a voice command that selects this page. The command needs a [`VuiCommand.SemanticValue`](Microsoft.Xbox.Controls.md#vuicommand), [`VuiCommand.DisplayText`](Microsoft.Xbox.Controls.md#vuicommand) and a phrase in a loaded [`VuiGrammar`](Microsoft.Xbox.Controls.md#vuigrammar). The owning [`Pivot`](Microsoft.Xbox.Controls.md#pivot) registers it with the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) while loaded and disables it while the page is selected. |
| `System.Boolean AutoGridNav { get; set; }` | Gets or sets whether directional (D-pad) focus navigation is set up automatically for the page's top-level grid. When `true`, the first `Grid` found under the page's content presenter gets grid-based focus navigation. When `false`, only a grid you have marked with `GridFocusHelper.IsFocusTarget` is used. |
| `System.Object Header { get; set; }` | Gets or sets the content shown in the pivot's header row for this page. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |
| `System.Void OnContentChanged(System.Object oldContent, System.Object newContent)` | Re-creates the page's grid focus navigation when its content changes. |
| `System.Windows.Size ArrangeOverride(System.Windows.Size finalSize)` |  |
| `System.Windows.Size MeasureOverride(System.Windows.Size availableSize)` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty AutoGridNavProperty` |  |
| `static System.Windows.DependencyProperty HeaderProperty` |  |
| `static System.Windows.DependencyProperty VuiCommandProperty` |  |

## PivotItemEventArgs

`class Microsoft.Xbox.Controls.PivotItemEventArgs`

Provides data for the [`Pivot.LoadingPivotItem`](Microsoft.Xbox.Controls.md#pivot) and [`Pivot.UnloadingPivotItem`](Microsoft.Xbox.Controls.md#pivot) events.

**Constructors**

| | |
|---|---|
| `PivotItemEventArgs()` |  |
| `PivotItemEventArgs(Microsoft.Xbox.Controls.PivotItem item)` | Initializes a new instance for the given page. |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.PivotItem Item { get; }` | Gets the page being loaded or unloaded. |

## PlayRate

`enum Microsoft.Xbox.Controls.PlayRate`

Playback rates used by [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport). Negative values rewind, positive values above 1 fast forward; the numeric value is the speed multiplier.

**Values**

| | |
|---|---|
| `FastForward128X` | Fast forward at 128 times normal speed. |
| `FastForward16X` | Fast forward at 16 times normal speed. |
| `FastForward2X` | Fast forward at twice normal speed. This is the first step when the user starts fast forwarding. |
| `FastForward32X` | Fast forward at 32 times normal speed. |
| `FastForward4X` | Fast forward at 4 times normal speed. |
| `FastForward64X` | Fast forward at 64 times normal speed. |
| `FastForward8X` | Fast forward at 8 times normal speed. |
| `MaxFastForward` | The fastest fast-forward rate (same as [`PlayRate.FastForward128X`](Microsoft.Xbox.Controls.md#playrate)). |
| `MaxRewind` | The fastest rewind rate (same as [`PlayRate.Rewind128X`](Microsoft.Xbox.Controls.md#playrate)). |
| `NotPlaying` | Not playing: paused, stopped, closed or buffering. |
| `Playing` | Playing at normal speed. |
| `Rewind128X` | Rewind at 128 times normal speed. |
| `Rewind16X` | Rewind at 16 times normal speed. |
| `Rewind2X` | Rewind at twice normal speed. This is the first step when the user starts rewinding. |
| `Rewind32X` | Rewind at 32 times normal speed. |
| `Rewind4X` | Rewind at 4 times normal speed. |
| `Rewind64X` | Rewind at 64 times normal speed. |
| `Rewind8X` | Rewind at 8 times normal speed. |

## PlayRateChangedEventArgs

`class Microsoft.Xbox.Controls.PlayRateChangedEventArgs`

Provides data for the `PlayRateChanged` event of [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport).

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.PlayRate PlayRate { get; }` | Gets the new play rate. |

## Rune

`class Microsoft.Xbox.Controls.Rune`

A single-line text entry control built for the TV: a strip of character tiles the user picks from with the controller or a Kinect hand gesture, with the entered text shown above.

Controller: D-pad moves across the tiles, A enters a character, X deletes the last character, the shoulder buttons (or the remote's previous/next keys) jump between letter groups, and Y closes the control when [`Rune.IsCloseable`](Microsoft.Xbox.Controls.md#rune) is `true`. Kinect: the user hovers over the strip to zoom it and then completes an engagement gesture on a tile to enter it (see [`RuneTile`](Microsoft.Xbox.Controls.md#runetile) and [`RuneCursor`](Microsoft.Xbox.Controls.md#runecursor)). Tiles switch between letter, extended-letter and number/symbol sets.

While a [`Rune`](Microsoft.Xbox.Controls.md#rune) has focus it also accepts text from a chatpad and from a companion-device keyboard, and keeps the companion keyboard in sync. It sets its own A, B, X and Y [`Legend`](Microsoft.Xbox.Controls.md#legend) texts. Native calls go to npctrl.dll ordinals 700–702.

The tiles are enabled only while [`Rune.IsOpen`](Microsoft.Xbox.Controls.md#rune) is `true`; open it to let the user type. The control raises a `TextChanged` event when [`Rune.Text`](Microsoft.Xbox.Controls.md#rune) changes.

**Constructors**

| | |
|---|---|
| `Rune()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean IsCloseable { get; set; }` | Gets or sets whether the user can close the control with the Y button. |
| `System.Boolean IsOpen { get; set; }` | Gets or sets whether the character strip is open for input. While closed the tiles are disabled and the control is not a tab stop; if focus was inside, it moves to the template's `FocusSafeHarbor` element. Setting `false` raises [`Rune.Closed`](Microsoft.Xbox.Controls.md#rune). |
| `System.String EmptyTextString { get; set; }` | Gets or sets the placeholder shown when [`Rune.Text`](Microsoft.Xbox.Controls.md#rune) is empty. |
| `System.String Text { get; set; }` | Gets or sets the entered text. Changes raise `TextChanged`. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |
| `System.Void OnGotFocus(System.Windows.RoutedEventArgs e)` | Forwards focus to the first focusable element of the control when the control itself receives focus, and connects chatpad and companion keyboard input to this instance. |
| `System.Void OnLostFocus(System.Windows.RoutedEventArgs e)` | Disconnects chatpad and companion keyboard input when focus leaves the control. |

**Events**

| | |
|---|---|
| `event System.EventHandler Closed` | Occurs when [`Rune.IsOpen`](Microsoft.Xbox.Controls.md#rune) becomes `false`, either because the user pressed Y or because the app closed it. |
| `event System.EventHandler<System.Windows.Controls.TextChangedEventArgs> TextChanged` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty EmptyTextStringProperty` |  |
| `static System.Windows.DependencyProperty IsCloseableProperty` |  |
| `static System.Windows.DependencyProperty IsOpenProperty` |  |
| `static System.Windows.DependencyProperty TextProperty` |  |

## RuneCursor

`class Microsoft.Xbox.Controls.RuneCursor`

The Kinect hand cursor shown by a [`Rune`](Microsoft.Xbox.Controls.md#rune) while the user is selecting characters by gesture.

Created and positioned by the [`Rune`](Microsoft.Xbox.Controls.md#rune) in a popup; it cannot be created by apps. Template parts: `LeftHand`, `RightHand`, `EngagingChevron` and `DisengagingChevron`. It scales with the screen height relative to 720 lines.

**Properties**

| | |
|---|---|
| `System.Boolean IsDisengaging { get; set; }` | Gets or sets whether the user is disengaging from a tile (the cursor shows its disengaging chevron). |
| `System.Boolean IsEngaging { get; set; }` | Gets or sets whether the user is engaging a tile (the cursor shows its engaging chevron). |
| `System.Boolean IsLeftHanded { get; set; }` | Gets or sets whether the cursor shows the left-hand image. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty IsDisengagingProperty` |  |
| `static System.Windows.DependencyProperty IsEngagingProperty` |  |
| `static System.Windows.DependencyProperty IsLeftHandedProperty` |  |

## RuneTile

`class Microsoft.Xbox.Controls.RuneTile`

One character tile in a [`Rune`](Microsoft.Xbox.Controls.md#rune).

Tiles are created by the [`Rune`](Microsoft.Xbox.Controls.md#rune); apps cannot create them. A tile is activated by clicking its `GlyphButton` template part, by pressing A or Start while it has focus, or when the Kinect engagement gesture brings [`RuneTile.EngagementProgress`](Microsoft.Xbox.Controls.md#runetile) to 1. Visual state groups: `CommonStates`, `EngagingStates` (`Idle`, `Prompting`, `Engaging`, `Disengaging`), `FocusStates` and `ControllerFocusStates`.

**Properties**

| | |
|---|---|
| `System.Double EngagementProgress { get; set; }` | Gets or sets how far the Kinect engagement gesture on this tile has progressed, from 0 to 1. While engaging, the glyph moves up by up to 75 pixels. Reaching 1 plays the select sound and raises [`RuneTile.Activated`](Microsoft.Xbox.Controls.md#runetile). |
| `System.String RuneText { get; set; }` | Gets or sets the text the tile enters: a character, a space, or a backspace. |
| `System.Windows.Media.Transform GlyphTransform { get; set; }` | Gets or sets the transform applied to the tile's glyph. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |
| `System.Void OnGotFocus(System.Windows.RoutedEventArgs e)` | Puts the tile and its glyph button in the focused state and plays the focus sound when the tile itself receives focus. |
| `System.Void OnLostFocus(System.Windows.RoutedEventArgs e)` | Clears the focused state of the tile and its glyph button when the tile itself loses focus. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xbox.Input.RuneTileActivationEventArgs> Activated` | Occurs when the tile is selected; the event data contains [`RuneTile.RuneText`](Microsoft.Xbox.Controls.md#runetile). |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty EngagementProgressProperty` |  |
| `static System.Windows.DependencyProperty GlyphTransformProperty` |  |
| `static System.Windows.DependencyProperty RuneTextProperty` |  |

## ScrubbingCompletedEventArgs

`class Microsoft.Xbox.Controls.ScrubbingCompletedEventArgs`

Provides data for the [`NuiTimeline.ScrubbingCompleted`](Microsoft.Xbox.Controls.md#nuitimeline) event.

**Properties**

| | |
|---|---|
| `System.Boolean Cancelled { get; }` | Gets whether the scrub was cancelled. |

## ScrubbingEventArgs

`class Microsoft.Xbox.Controls.ScrubbingEventArgs`

Provides data for the [`NuiTimeline.ScrubbingStarted`](Microsoft.Xbox.Controls.md#nuitimeline) and [`NuiTimeline.Scrubbing`](Microsoft.Xbox.Controls.md#nuitimeline) events.

**Properties**

| | |
|---|---|
| `System.TimeSpan Position { get; }` | Gets the timeline position at the time of the event. |

## SeekExecutedEventArgs

`class Microsoft.Xbox.Controls.SeekExecutedEventArgs`

Provides data for the [`MediaTransport.SeekExecuted`](Microsoft.Xbox.Controls.md#mediatransport) event.

**Properties**

| | |
|---|---|
| `System.Boolean IsToLive { get; }` | Gets whether the seek was to the live edge of a live stream. |
| `System.TimeSpan EndPosition { get; }` | Gets the position the player was asked to seek to. |
| `System.TimeSpan StartPosition { get; }` | Gets the position before the seek. |

## SignalStrengthMode

`enum Microsoft.Xbox.Controls.SignalStrengthMode`

The signal-strength level shown by [`SignalStrength`](Microsoft.Xbox.Controls.Primitives.md#signalstrength) on the media timeline.

**Values**

| | |
|---|---|
| `Full` | Full signal strength. |
| `High` | High signal strength. |
| `Low` | Low signal strength. |
| `Medium` | Medium signal strength. |
| `None` | No signal indicator (the default). |

## SwipeActivationZone

`enum Microsoft.Xbox.Controls.SwipeActivationZone`

Identifies a side of the screen for swipe gestures.

**Values**

| | |
|---|---|
| `LeftSide` | The left activation zone. A swipe here moves content to the previous page. |
| `RightSide` | The right activation zone. A swipe here moves content to the next page. |

## SwipeCompletedEventArgs

`class Microsoft.Xbox.Controls.SwipeCompletedEventArgs`

Provides data for the [`SwipeViewer.SwipeCompleted`](Microsoft.Xbox.Controls.md#swipeviewer) event.

## SwipeEventArgs

`class Microsoft.Xbox.Controls.SwipeEventArgs`

Base class for [`SwipeViewer`](Microsoft.Xbox.Controls.md#swipeviewer) event data: which user and which side.

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.SwipeActivationZone Zone { get; }` | Gets the side on which the gesture happened. |
| `System.Int32 UserID { get; }` | Gets the player index of the engaged Kinect user who made the gesture. |

## SwipeFailedEventArgs

`class Microsoft.Xbox.Controls.SwipeFailedEventArgs`

Provides data for the [`SwipeViewer.SwipeFailed`](Microsoft.Xbox.Controls.md#swipeviewer) event.

## SwipeProgressChangedEventArgs

`class Microsoft.Xbox.Controls.SwipeProgressChangedEventArgs`

Provides data for the [`SwipeViewer.SwipeProgressChanged`](Microsoft.Xbox.Controls.md#swipeviewer) event.

**Properties**

| | |
|---|---|
| `System.Double SwipeProgress { get; }` | Gets the new swipe progress, from 0 to 1. |

## SwipeReadyEventArgs

`class Microsoft.Xbox.Controls.SwipeReadyEventArgs`

Provides data for the [`SwipeViewer.SwipeReady`](Microsoft.Xbox.Controls.md#swipeviewer) event.

## SwipeVelocityChangedEventArgs

`class Microsoft.Xbox.Controls.SwipeVelocityChangedEventArgs`

Provides data for the [`SwipeViewer.SwipeVelocityChanged`](Microsoft.Xbox.Controls.md#swipeviewer) event.

**Properties**

| | |
|---|---|
| `System.Double Velocity { get; }` | Gets the swipe velocity reported by the gesture system. |
| `System.Int32 UserID { get; }` | Gets the player index of the engaged Kinect user. |

## SwipeViewer

`class Microsoft.Xbox.Controls.SwipeViewer`

Detects Kinect left and right swipe gestures and exposes their progress as events, properties and visual states.

The gesture is recognized by the console (npctrl.dll ordinals 300–305); the viewer configures two activation zones and receives callbacks on the UI thread. Without a Kinect sensor or an engaged user, no events are raised.

Only one [`SwipeViewer`](Microsoft.Xbox.Controls.md#swipeviewer) can be active at a time. A viewer becomes active when it is loaded, enabled and (inside an [`XboxApplicationFrame`](Microsoft.Xbox.Controls.md#xboxapplicationframe)) on the current page; activating a second one throws `InvalidOperationException`. [`Pivot`](Microsoft.Xbox.Controls.md#pivot) and [`ContinuousList`](Microsoft.Xbox.Controls.md#continuouslist) each contain one, so don't place two such controls on the same page, and disable a viewer (`IsEnabled = false`) before showing another.

Sequence: [`SwipeViewer.PeekStarted`](Microsoft.Xbox.Controls.md#swipeviewer), then [`SwipeViewer.PeekProgressChanged`](Microsoft.Xbox.Controls.md#swipeviewer) as the hand moves into a zone, [`SwipeViewer.PeekCompleted`](Microsoft.Xbox.Controls.md#swipeviewer) at full peek, [`SwipeViewer.SwipeReady`](Microsoft.Xbox.Controls.md#swipeviewer), and finally [`SwipeViewer.SwipeCompleted`](Microsoft.Xbox.Controls.md#swipeviewer) or [`SwipeViewer.SwipeFailed`](Microsoft.Xbox.Controls.md#swipeviewer). Visual states: `LeftNormal`/`LeftPeeking`/`LeftSwiped` and the matching `Right…` states; the storyboard of the `…Swiped` state is played to completion before the side returns to normal.

**Constructors**

| | |
|---|---|
| `SwipeViewer()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean IsLeftSideEnabled { get; set; }` | Gets or sets whether left-side swipes are detected. |
| `System.Boolean IsRightSideEnabled { get; set; }` | Gets or sets whether right-side swipes are detected. |
| `System.Double LastSwipeVelocity { get; }` | Gets the most recent swipe velocity reported by the gesture system. |
| `System.Double LeftPeekProgress { get; }` | Gets how far the user's hand has moved into the left activation zone. |
| `System.Double LeftSwipeProgress { get; }` | Gets the progress of the swipe gesture on the left side. |
| `System.Double RightPeekProgress { get; }` | Gets how far the user's hand has moved into the right activation zone. |
| `System.Double RightSwipeProgress { get; }` | Gets the progress of the swipe gesture on the right side. |
| `System.TimeSpan PeekDuration { get; }` | Gets the peek duration reported by the console's gesture system. |
| `System.Windows.Rect LeftActivationZone { get; set; }` | Gets or sets the rectangle, in the gesture system's coordinates, in which a left-side swipe is detected. Changes are passed to the gesture system immediately and again whenever the viewer is activated. |
| `System.Windows.Rect RightActivationZone { get; set; }` | Gets or sets the rectangle, in the gesture system's coordinates, in which a right-side swipe is detected. Changes are passed to the gesture system immediately and again whenever the viewer is activated. |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xbox.Controls.PeekCompletedEventArgs> PeekCompleted` | Occurs when the peek progress of a side reaches 1. |
| `event System.EventHandler<Microsoft.Xbox.Controls.PeekProgressChangedEventArgs> PeekProgressChanged` | Occurs whenever the peek progress of an enabled side changes. |
| `event System.EventHandler<Microsoft.Xbox.Controls.PeekStartedEventArgs> PeekStarted` | Occurs when the user's hand starts moving into an activation zone (peek progress leaves 0). |
| `event System.EventHandler<Microsoft.Xbox.Controls.SwipeCompletedEventArgs> SwipeCompleted` | Occurs when the user completes a swipe on an enabled side. The side enters its `Swiped` visual state; the event is not raised again for that side until the state has been reset. |
| `event System.EventHandler<Microsoft.Xbox.Controls.SwipeFailedEventArgs> SwipeFailed` | Occurs when a swipe attempt is abandoned. |
| `event System.EventHandler<Microsoft.Xbox.Controls.SwipeProgressChangedEventArgs> SwipeProgressChanged` | Occurs when the swipe progress of an enabled side changes. |
| `event System.EventHandler<Microsoft.Xbox.Controls.SwipeReadyEventArgs> SwipeReady` | Occurs when the gesture system reports that a swipe on a side is ready to be performed. |
| `event System.EventHandler<Microsoft.Xbox.Controls.SwipeVelocityChangedEventArgs> SwipeVelocityChanged` | Occurs when the gesture system reports a new swipe velocity. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty IsLeftSideEnabledProperty` |  |
| `static System.Windows.DependencyProperty IsRightSideEnabledProperty` |  |
| `static System.Windows.DependencyProperty LastSwipeVelocityProperty` |  |
| `static System.Windows.DependencyProperty LeftActivationZoneProperty` |  |
| `static System.Windows.DependencyProperty LeftPeekProgressProperty` |  |
| `static System.Windows.DependencyProperty LeftSwipeProgressProperty` |  |
| `static System.Windows.DependencyProperty PeekDurationProperty` |  |
| `static System.Windows.DependencyProperty RightActivationZoneProperty` |  |
| `static System.Windows.DependencyProperty RightPeekProgressProperty` |  |
| `static System.Windows.DependencyProperty RightSwipeProgressProperty` |  |

## ThumbnailRequestEventArgs

`class Microsoft.Xbox.Controls.ThumbnailRequestEventArgs`

Provides data for the [`MediaTransport.ThumbnailRequest`](Microsoft.Xbox.Controls.md#mediatransport) event.

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.PlayRate PlayRate { get; }` | Gets the play rate at the time of the request. |
| `System.TimeSpan Position { get; }` | Gets the position for which a thumbnail should be shown. |

## TimelineRangeMarker

`class Microsoft.Xbox.Controls.TimelineRangeMarker`

A clamped, non-snappable marker that covers the span between [`TimelineRangeMarker.MinimumPosition`](Microsoft.Xbox.Controls.md#timelinerangemarker) and [`TimelineRangeMarker.MaximumPosition`](Microsoft.Xbox.Controls.md#timelinerangemarker).

The timeline template uses two of these to draw the seekable range and the playback progress. Setting either property updates [`NuiTimelineMarker.Time`](Microsoft.Xbox.Controls.md#nuitimelinemarker) and [`NuiTimelineMarker.Duration`](Microsoft.Xbox.Controls.md#nuitimelinemarker).

**Constructors**

| | |
|---|---|
| `TimelineRangeMarker()` |  |

**Properties**

| | |
|---|---|
| `System.TimeSpan MaximumPosition { get; set; }` | Gets or sets the end of the range. |
| `System.TimeSpan MinimumPosition { get; set; }` | Gets or sets the start of the range. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty MaximumPositionProperty` |  |
| `static System.Windows.DependencyProperty MinimumPositionProperty` |  |

## TimespanToStringConverter

`class Microsoft.Xbox.Controls.TimespanToStringConverter`

Value converter that formats a `TimeSpan` as a playback time string.

Values under one hour are formatted as `mm:ss`, values under one day as `h:mm:ss`, and longer values as `d:hh:mm:ss`. Negative values get a leading minus sign. This is the default [`MediaTransport.PositionConverter`](Microsoft.Xbox.Controls.md#mediatransport) and [`MediaTransport.EndPositionConverter`](Microsoft.Xbox.Controls.md#mediatransport). `ConvertBack` is not implemented and throws.

**Constructors**

| | |
|---|---|
| `TimespanToStringConverter()` |  |

**Methods**

| | |
|---|---|
| `System.Object Convert(System.Object value, System.Type targetType, System.Object parameter, System.Globalization.CultureInfo culture)` |  |
| `System.Object ConvertBack(System.Object value, System.Type targetType, System.Object parameter, System.Globalization.CultureInfo culture)` |  |

## TransportBar

`class Microsoft.Xbox.Controls.TransportBar`

The horizontal row of [`TransportBarButton`](Microsoft.Xbox.Controls.md#transportbarbutton) controls shown at the bottom of [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport).

The bar itself is not a tab stop. D-pad (or left stick) left/right move focus between enabled, visible buttons and wrap around at the ends. When a button gets focus its [`TransportBarButton.StatusText`](Microsoft.Xbox.Controls.md#transportbarbutton) is copied to [`TransportBar.CurrentStatusText`](Microsoft.Xbox.Controls.md#transportbar).

**Constructors**

| | |
|---|---|
| `TransportBar()` |  |

**Properties**

| | |
|---|---|
| `System.String CurrentStatusText { get; set; }` | Gets or sets the status text of the focused button, shown by the template as a caption. |

**Methods**

| | |
|---|---|
| `System.Void FocusButton(System.Windows.Media.MediaCommand command)` | Moves focus to the enabled button whose [`TransportBarButton.TargetMediaCommand`](Microsoft.Xbox.Controls.md#transportbarbutton) matches a command. If no enabled button has that command, the first enabled button gets focus. |
| `System.Void OnGotFocus(System.Windows.RoutedEventArgs e)` | Updates [`TransportBar.CurrentStatusText`](Microsoft.Xbox.Controls.md#transportbar) when one of the bar's buttons receives focus. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty CurrentStatusTextProperty` |  |

## TransportBarButton

`class Microsoft.Xbox.Controls.TransportBarButton`

A button in a [`TransportBar`](Microsoft.Xbox.Controls.md#transportbar).

Set [`TransportBarButton.TargetMediaCommand`](Microsoft.Xbox.Controls.md#transportbarbutton) so [`TransportBar.FocusButton`](Microsoft.Xbox.Controls.md#transportbar) can find the button, and [`TransportBarButton.StatusText`](Microsoft.Xbox.Controls.md#transportbarbutton) for the caption shown while it has focus. Handle `Click` (or bind `Command`) to make it do something; the transport only wires up its own built-in buttons.

**Constructors**

| | |
|---|---|
| `TransportBarButton()` |  |

**Properties**

| | |
|---|---|
| `System.Nullable<System.Windows.Media.MediaCommand> TargetMediaCommand { get; set; }` | Gets or sets the media command this button represents. |
| `System.String StatusText { get; set; }` | Gets or sets the caption shown in the transport bar while this button has focus. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty StatusTextProperty` |  |
| `static System.Windows.DependencyProperty TargetMediaCommandProperty` |  |

## VuiActiveListeningChangedEventArgs

`class Microsoft.Xbox.Controls.VuiActiveListeningChangedEventArgs`

Provides data for the [`VuiBar.ActiveListeningChanged`](Microsoft.Xbox.Controls.md#vuibar) event.

**Properties**

| | |
|---|---|
| `System.Boolean IsActiveListening { get; }` | Gets the new value of [`VuiBar.IsActiveListening`](Microsoft.Xbox.Controls.md#vuibar). |

## VuiBar

`class Microsoft.Xbox.Controls.VuiBar`

The voice user interface (VUI) bar: Kinect speech recognition for the app and the on-screen bar that lists the commands the user can say.

Only one instance can exist; it is available as [`VuiBar.Current`](Microsoft.Xbox.Controls.md#vuibar). The default [`XboxApplicationFrame`](Microsoft.Xbox.Controls.md#xboxapplicationframe) template already contains it, so apps normally do not create one. Creating a second instance throws `InvalidOperationException`.

Typical setup: create one or more [`VuiGrammar`](Microsoft.Xbox.Controls.md#vuigrammar) objects with phrases whose semantic values match your commands' [`VuiCommand.SemanticValue`](Microsoft.Xbox.Controls.md#vuicommand), call [`VuiBar.LoadGrammar`](Microsoft.Xbox.Controls.md#vuibar) for each, add [`VuiCommand`](Microsoft.Xbox.Controls.md#vuicommand) objects to [`VuiBar.PrimaryCommands`](Microsoft.Xbox.Controls.md#vuibar) or [`VuiBar.SecondaryCommands`](Microsoft.Xbox.Controls.md#vuibar), and call [`VuiBar.StartRecognition`](Microsoft.Xbox.Controls.md#vuibar). Grammars can only be loaded or unloaded while recognition is stopped. The phrases for the built-in [`VuiCommands`](Microsoft.Xbox.Controls.md#vuicommands) are loaded automatically.

The user says "Xbox" to open the bar (active listening, which times out after 12 seconds without a command). While the bar is open the user can say a command phrase on its own; while it is closed, a command can be said together with the "Xbox" keyword. The two cases use separate confidence thresholds. If a phrase matches several executable commands the bar enters disambiguation and labels the candidates (see [`VuiBar.SetDisambiguationSlots`](Microsoft.Xbox.Controls.md#vuibar)). Commands with a [`VuiCommand.Confirmation`](Microsoft.Xbox.Controls.md#vuicommand) ask for confirmation before running. Two fixed commands, Cancel and go Home (with an explicit confirmation), are always available while the bar is open.

Speech requires a Kinect sensor, a supported [`Localization.Culture`](Microsoft.Xbox.Controls.md#localization) and speech recognition being enabled in the console settings; check [`VuiBar.IsCurrentCultureSupported`](Microsoft.Xbox.Controls.md#vuibar) and [`VuiBar.IsDashSpeechRecognitionEnabled`](Microsoft.Xbox.Controls.md#vuibar). Changing [`Localization.Culture`](Microsoft.Xbox.Controls.md#localization) stops recognition and unloads all grammars, including the app's.

Events and command execution happen on the UI thread. Native calls go to npctrl.dll ordinals 200–218 and 1200.

**Constructors**

| | |
|---|---|
| `VuiBar()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.VuiBarVisibilityState VisibilityState { get; }` | Gets how the bar is currently displayed. Changes raise `VisibilityStateChanged`. [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport) uses this to make room for the bar. |
| `System.Boolean IsActiveListening { get; }` | Gets whether the bar is open and actively listening for commands. Changes raise [`VuiBar.ActiveListeningChanged`](Microsoft.Xbox.Controls.md#vuibar). |
| `System.Boolean IsCurrentCultureSupported { get; }` | Gets whether speech recognition supports the current [`Localization.Culture`](Microsoft.Xbox.Controls.md#localization). |
| `System.Boolean IsDashSpeechRecognitionEnabled { get; }` | Gets whether the user has speech recognition enabled in the console settings. |
| `System.Boolean IsEnabled { get; set; }` | Gets or sets whether speech recognition is enabled. Setting `true` while the culture is unsupported throws `InvalidOperationException`; the value is ignored when speech is disabled in the console settings. Disabling the bar pauses the recognizer and dismisses any open bar, confirmation or disambiguation. |
| `System.Boolean IsRecognitionStarted { get; }` | Gets whether [`VuiBar.StartRecognition`](Microsoft.Xbox.Controls.md#vuibar) has been called (and [`VuiBar.StopRecognition`](Microsoft.Xbox.Controls.md#vuibar) has not). |
| `System.Collections.Generic.IList<Microsoft.Xbox.Controls.VuiCommand> ConfirmationCommands { get; }` | Gets the commands currently offered to confirm or cancel a command. |
| `System.Collections.Generic.IList<Microsoft.Xbox.Controls.VuiCommand> ExecutablePrimaryCommands { get; }` | Gets the subset of [`VuiBar.PrimaryCommands`](Microsoft.Xbox.Controls.md#vuibar) that can currently execute, in the same order. |
| `System.Collections.Generic.IList<Microsoft.Xbox.Controls.VuiCommand> ExecutableSecondaryCommands { get; }` | Gets the subset of [`VuiBar.SecondaryCommands`](Microsoft.Xbox.Controls.md#vuibar) that can currently execute, in the same order. |
| `System.Collections.Generic.IList<Microsoft.Xbox.Controls.VuiCommand> FixedCommands { get; }` | Gets the built-in commands that are always available while the bar is open (Cancel and go Home). |
| `System.Collections.Generic.IList<Microsoft.Xbox.Controls.VuiCommand> PrimaryCommands { get; }` | Gets the commands shown prominently on the bar. Adding a command throws `InvalidOperationException` if it is `null`, has no [`VuiCommand.DisplayText`](Microsoft.Xbox.Controls.md#vuicommand) or [`VuiCommand.SemanticValue`](Microsoft.Xbox.Controls.md#vuicommand), needs confirmation but has no [`VuiCommand.ConfirmationText`](Microsoft.Xbox.Controls.md#vuicommand), is a fixed command, is already on the bar, or shares a semantic value with a command already on the bar. If no loaded grammar contains its semantic value, [`VuiBar.VuiCommandNotRecognized`](Microsoft.Xbox.Controls.md#vuibar) is raised with [`VuiCommandNotRecognizedReason.PhraseNotLoaded`](Microsoft.Xbox.Controls.md#vuicommandnotrecognizedreason). |
| `System.Collections.Generic.IList<Microsoft.Xbox.Controls.VuiCommand> SecondaryCommands { get; }` | Gets the less prominent commands shown on the bar. |
| `static Microsoft.Xbox.Controls.VuiBar Current { get; }` | Gets the app's single [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) instance. |

**Methods**

| | |
|---|---|
| `System.Void LoadGrammar(Microsoft.Xbox.Controls.VuiGrammar grammar)` | Loads a grammar into the speech recognizer so its phrases can be recognized. Throws `InvalidOperationException` if recognition is started, the grammar is already loaded or it has no phrases. After loading, [`VuiGrammar.IsLoaded`](Microsoft.Xbox.Controls.md#vuigrammar) is `true` and no more phrases can be added. Phrases become active only while a command with the same semantic value is on the bar and can execute. All grammars are unloaded automatically when [`Localization.Culture`](Microsoft.Xbox.Controls.md#localization) changes. |
| `System.Void OnApplyTemplate()` |  |
| `System.Void SetDisambiguationSlots(System.Collections.Generic.IEnumerable<Microsoft.Xbox.Controls.VuiDisambiguationSlot> slots)` | Sets the labels used to tell apart commands that match the same phrase. When disambiguation starts, executable commands that have a UI element and [`VuiCommand.IsDisambiguationEnabled`](Microsoft.Xbox.Controls.md#vuicommand) set are assigned slots in order, and each slot's [`VuiDisambiguationSlot.DisambiguationText`](Microsoft.Xbox.Controls.md#vuidisambiguationslot) is shown as the command's [`VuiCommand.DisambiguationText`](Microsoft.Xbox.Controls.md#vuicommand). The slot semantic values must match phrases in a loaded grammar. Throws `ArgumentException` if a slot has empty text or semantic value, or if fewer than [`VuiBar.MinDisambiguationSlotCount`](Microsoft.Xbox.Controls.md#vuibar) slots are given. |
| `System.Void StartRecognition()` | Starts listening for speech. The recognizer is started on the next dispatcher cycle, and only if the bar is enabled; if the bar is disabled it starts when the bar is enabled. Calling this while already started does nothing. Load your grammars first, because grammars cannot be loaded while recognition is started. |
| `System.Void StopRecognition()` | Stops listening for speech. Call this before loading or unloading grammars. Does nothing if recognition is not started. |
| `System.Void UnloadGrammar(Microsoft.Xbox.Controls.VuiGrammar grammar)` | Removes a loaded grammar from the speech recognizer. Throws `ArgumentNullException` if `grammar` is `null`, and `InvalidOperationException` if recognition is started. Its phrases cannot be added to again after unloading; create a new grammar instead. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xbox.Controls.VuiActiveListeningChangedEventArgs> ActiveListeningChanged` | Occurs when [`VuiBar.IsActiveListening`](Microsoft.Xbox.Controls.md#vuibar) changes. [`Pivot`](Microsoft.Xbox.Controls.md#pivot) uses this to highlight page headers that can be spoken. |
| `event System.EventHandler<Microsoft.Xbox.Controls.VuiBarVisibilityStateChangedEventArgs> VisibilityStateChanged` |  |
| `event System.EventHandler<Microsoft.Xbox.Controls.VuiCommandNotRecognizedEventArgs> VuiCommandNotRecognized` | Occurs when speech was heard but did not run a command, or when a command is added whose phrase is not loaded. Use it for diagnostics or to give the user feedback. See [`VuiCommandNotRecognizedReason`](Microsoft.Xbox.Controls.md#vuicommandnotrecognizedreason) for the possible causes. |

**Fields**

| | |
|---|---|
| `static System.Int32 MinDisambiguationSlotCount` | The minimum number of slots that must be passed to [`VuiBar.SetDisambiguationSlots`](Microsoft.Xbox.Controls.md#vuibar) (1). |
| `static System.Windows.DependencyProperty ConfirmationTextProperty` | Identifies the read-only `ConfirmationText` dependency property: the [`VuiCommand.ConfirmationText`](Microsoft.Xbox.Controls.md#vuicommand) of the command being confirmed, or empty. The property itself is not public; bind to it from a custom [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) template. |
| `static System.Windows.DependencyProperty DisambiguationTextProperty` | Identifies the read-only `DisambiguationText` dependency property: the localized prompt shown while the user must choose between matching commands. The property itself is not public; bind to it from a custom [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) template. |
| `static System.Windows.DependencyProperty IsActiveListeningProperty` |  |
| `static System.Windows.DependencyProperty IsRecognitionStartedProperty` |  |
| `static System.Windows.DependencyProperty ListeningTextProperty` | Identifies the read-only `ListeningText` dependency property: the localized prompt the bar shows while listening with no commands to list. The property itself is not public; bind to it from a custom [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) template. |
| `static System.Windows.DependencyProperty VisibilityStateProperty` |  |
| `static System.Windows.DependencyProperty VuiLanguageProperty` | Identifies the read-only `VuiLanguage` dependency property: the speech language selected from the current culture (US English by default). The property itself is not public. |

## VuiBarVisibilityState

`enum Microsoft.Xbox.Controls.VuiBarVisibilityState`

How the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) is displayed.

**Values**

| | |
|---|---|
| `Hidden` | The bar is not shown. |
| `Shown` | The bar is shown at its normal size (listening or confirming). |
| `ShownLarge` | The bar is shown enlarged, while disambiguating between commands with primary commands present. |

## VuiBarVisibilityStateChangedEventArgs

`class Microsoft.Xbox.Controls.VuiBarVisibilityStateChangedEventArgs`

Provides data for the `VisibilityStateChanged` event of [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar).

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.VuiBarVisibilityState VisibilityState { get; }` | Gets the new visibility state of the bar. |

## VuiCommand

`class Microsoft.Xbox.Controls.VuiCommand`

A command the user can trigger by voice through the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar).

A command is matched to speech through its [`VuiCommand.SemanticValue`](Microsoft.Xbox.Controls.md#vuicommand): load a [`VuiGrammar`](Microsoft.Xbox.Controls.md#vuigrammar) containing one or more phrases with that semantic value, then add the command to [`VuiBar.PrimaryCommands`](Microsoft.Xbox.Controls.md#vuibar) or [`VuiBar.SecondaryCommands`](Microsoft.Xbox.Controls.md#vuibar) (or assign it to [`PivotItem.VuiCommand`](Microsoft.Xbox.Controls.md#pivotitem)). When recognized, the command runs [`VuiCommand.TargetCommand`](Microsoft.Xbox.Controls.md#vuicommand) and raises [`VuiCommand.Executed`](Microsoft.Xbox.Controls.md#vuicommand).

The command is an `ICommand`, so it can also be bound to buttons. A command can be attached to only one loaded UI element at a time; doing otherwise throws `InvalidOperationException`.

The predefined commands in [`VuiCommands`](Microsoft.Xbox.Controls.md#vuicommands) are built in: their display text, semantic value and confirmation settings cannot be changed.

**Constructors**

| | |
|---|---|
| `VuiCommand()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.VuiConfirmation Confirmation { get; set; }` | Gets or sets whether the user must confirm the command before it runs. Requires [`VuiCommand.ConfirmationText`](Microsoft.Xbox.Controls.md#vuicommand) when not [`VuiConfirmation.None`](Microsoft.Xbox.Controls.md#vuiconfirmation). Throws `InvalidOperationException` for built-in commands. |
| `Microsoft.Xbox.Controls.VuiPersistence Persistence { get; set; }` | Gets or sets what happens to the bar's active listening after the command executes. |
| `System.Boolean IsBuiltIn { get; }` | Gets whether the command is one of the predefined commands in [`VuiCommands`](Microsoft.Xbox.Controls.md#vuicommands) (or an internal confirmation command). |
| `System.Boolean IsDisambiguationEnabled { get; set; }` | Gets or sets whether the command may be offered as a candidate when several commands match a phrase. Only commands attached to a `Button` take part in disambiguation. |
| `System.Boolean IsEnabled { get; set; }` | Gets or sets whether the command may execute. Disabled commands are removed from the executable lists and their phrases are deactivated. [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport) and [`Pivot`](Microsoft.Xbox.Controls.md#pivot) manage this property for the commands they own. |
| `System.Boolean IsFixed { get; }` | Gets whether the command is one of the bar's fixed commands (Cancel, go Home). |
| `System.Object TargetCommandParameter { get; set; }` | Gets or sets the parameter passed to [`VuiCommand.TargetCommand`](Microsoft.Xbox.Controls.md#vuicommand). |
| `System.String ConfirmationText { get; set; }` | Gets or sets the question or notice shown while the command is being confirmed. Throws `InvalidOperationException` for built-in commands. |
| `System.String DisambiguationText { get; }` | Gets the label assigned to the command while the bar is disambiguating between matching commands. |
| `System.String DisplayText { get; set; }` | Gets or sets the text shown for the command on the bar. Throws `InvalidOperationException` for built-in commands, whose text is localized automatically. Show the words the user should say. |
| `System.String SemanticValue { get; set; }` | Gets or sets the value that links the command to grammar phrases. Throws `InvalidOperationException` for built-in commands and while the command is on the bar. The value must be unique among commands on the bar and must not be "xbox" or a built-in semantic value. |
| `System.Windows.Input.ICommand TargetCommand { get; set; }` | Gets or sets an `ICommand` to run when the voice command executes. The voice command can execute only while the target's `CanExecute` returns `true` for [`VuiCommand.TargetCommandParameter`](Microsoft.Xbox.Controls.md#vuicommand); its `CanExecuteChanged` is tracked. |

**Methods**

| | |
|---|---|
| `System.Boolean CanExecute(System.Object parameter)` | Determines whether the command can execute. |
| `System.Void Execute(System.Object parameter)` | Executes the command: runs [`VuiCommand.TargetCommand`](Microsoft.Xbox.Controls.md#vuicommand) and raises [`VuiCommand.Executed`](Microsoft.Xbox.Controls.md#vuicommand). Must be called on the UI thread. Throws `InvalidOperationException` if [`VuiCommand.CanExecute`](Microsoft.Xbox.Controls.md#vuicommand) returns `false`. Re-entrant calls while the command is executing are ignored. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xbox.Controls.VuiCommandExecutedEventArgs> Executed` | Occurs after the command has executed (after [`VuiCommand.TargetCommand`](Microsoft.Xbox.Controls.md#vuicommand) has run). Raised on the UI thread. The built-in commands in [`VuiCommands`](Microsoft.Xbox.Controls.md#vuicommands) are static, so remove handlers you add to them when your page unloads. |

## VuiCommandExecutedEventArgs

`class Microsoft.Xbox.Controls.VuiCommandExecutedEventArgs`

Provides data for the [`VuiCommand.Executed`](Microsoft.Xbox.Controls.md#vuicommand) event. It carries no additional information.

**Constructors**

| | |
|---|---|
| `VuiCommandExecutedEventArgs()` |  |

## VuiCommandNotRecognizedEventArgs

`class Microsoft.Xbox.Controls.VuiCommandNotRecognizedEventArgs`

Provides data for the [`VuiBar.VuiCommandNotRecognized`](Microsoft.Xbox.Controls.md#vuibar) event.

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Controls.VuiCommand VuiCommand { get; }` | Gets the command involved, if one was found; otherwise `null`. |
| `Microsoft.Xbox.Controls.VuiCommandNotRecognizedReason Reason { get; }` | Gets why no command was executed. |
| `System.Double Confidence { get; }` | Gets the recognizer's confidence in the phrase, from 0 to 1. |
| `System.Double RequiredConfidence { get; }` | Gets the confidence that would have been required, for the confidence-related reasons; otherwise 0. |
| `System.String SemanticValue { get; }` | Gets the semantic value of the recognized phrase (or of the command, for [`VuiCommandNotRecognizedReason.PhraseNotLoaded`](Microsoft.Xbox.Controls.md#vuicommandnotrecognizedreason)). |
| `System.String Text { get; }` | Gets the recognized phrase text, or `null` for [`VuiCommandNotRecognizedReason.PhraseNotLoaded`](Microsoft.Xbox.Controls.md#vuicommandnotrecognizedreason). |

## VuiCommandNotRecognizedReason

`enum Microsoft.Xbox.Controls.VuiCommandNotRecognizedReason`

Explains why [`VuiBar.VuiCommandNotRecognized`](Microsoft.Xbox.Controls.md#vuibar) was raised.

**Values**

| | |
|---|---|
| `LanguageActiveConfidence` | The phrase was spoken on its own while the bar was open but its confidence was below the speech language's default threshold. |
| `LanguageNormalConfidence` | The phrase was spoken with the "Xbox" keyword but its confidence was below the speech language's default threshold. |
| `None` | No reason given. |
| `PhraseActiveConfidence` | The phrase was spoken on its own while the bar was open but its confidence was below the phrase's own threshold. |
| `PhraseNormalConfidence` | The phrase was spoken with the "Xbox" keyword but its confidence was below the phrase's own threshold. |
| `PhraseNotFound` | The recognizer returned a rule that does not belong to any loaded phrase. |
| `PhraseNotLoaded` | A command was added to the bar but no loaded grammar contains a phrase with its semantic value, so it can never be spoken. |
| `TargetCommandCannotExecute` | The matching command is enabled but its [`VuiCommand.TargetCommand`](Microsoft.Xbox.Controls.md#vuicommand) cannot execute. |
| `VuiCommandDisabled` | The matching command's [`VuiCommand.IsEnabled`](Microsoft.Xbox.Controls.md#vuicommand) is `false`. |
| `VuiCommandNotFound` | The phrase was recognized but no command on the bar has its semantic value. |
| `WaitingForSelectionAnimation` | Speech arrived while a previously recognized command was still playing its selection animation. |
| `XboxConfidence` | The "Xbox" keyword spoken with the phrase was recognized with too little confidence. |

## VuiCommands

`class Microsoft.Xbox.Controls.VuiCommands`

Predefined, localized voice commands for common actions.

The phrases for these commands are loaded automatically for the current speech language, so you only need to add the commands to the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) and handle [`VuiCommand.Executed`](Microsoft.Xbox.Controls.md#vuicommand) or set [`VuiCommand.TargetCommand`](Microsoft.Xbox.Controls.md#vuicommand). Their display text and semantic values cannot be changed. The instances are shared app-wide. [`MediaTransport.AddDefaultVuiBarCommands`](Microsoft.Xbox.Controls.md#mediatransport) adds the media commands for you.

**Properties**

| | |
|---|---|
| `static Microsoft.Xbox.Controls.VuiCommand FastForward { get; }` | Gets the built-in "Fast Forward" command. |
| `static Microsoft.Xbox.Controls.VuiCommand Faster { get; }` | Gets the built-in "Faster" command. |
| `static Microsoft.Xbox.Controls.VuiCommand GoBack { get; }` | Gets the built-in "Go Back" command. |
| `static Microsoft.Xbox.Controls.VuiCommand Next { get; }` | Gets the built-in "Next" command. |
| `static Microsoft.Xbox.Controls.VuiCommand No { get; }` | Gets the built-in "No" command. |
| `static Microsoft.Xbox.Controls.VuiCommand Pause { get; }` | Gets the built-in "Pause" command. For US English this command accepts a lower recognition confidence while the bar is open. |
| `static Microsoft.Xbox.Controls.VuiCommand Play { get; }` | Gets the built-in "Play" command. |
| `static Microsoft.Xbox.Controls.VuiCommand Previous { get; }` | Gets the built-in "Previous" command. |
| `static Microsoft.Xbox.Controls.VuiCommand Rewind { get; }` | Gets the built-in "Rewind" command. |
| `static Microsoft.Xbox.Controls.VuiCommand Slower { get; }` | Gets the built-in "Slower" command. |
| `static Microsoft.Xbox.Controls.VuiCommand Stop { get; }` | Gets the built-in "Stop" command. |
| `static Microsoft.Xbox.Controls.VuiCommand Yes { get; }` | Gets the built-in "Yes" command. The bar uses its own copies of Yes and No for confirmations; this instance is for app use. |

## VuiConfirmation

`enum Microsoft.Xbox.Controls.VuiConfirmation`

Specifies whether a [`VuiCommand`](Microsoft.Xbox.Controls.md#vuicommand) must be confirmed before it runs.

**Values**

| | |
|---|---|
| `Explicit` | The bar shows the confirmation text and runs the command only if the user says Yes within 5 seconds; No or a timeout cancels it. |
| `Implicit` | The bar shows the confirmation text and runs the command after 3 seconds unless the user says Cancel. |
| `None` | The command runs immediately when recognized. |

## VuiDisambiguationSlot

`class Microsoft.Xbox.Controls.VuiDisambiguationSlot`

A label used by the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) to let the user pick one of several commands that matched the same phrase.

Pass a list of slots to [`VuiBar.SetDisambiguationSlots`](Microsoft.Xbox.Controls.md#vuibar), and load a grammar with a phrase for each slot's semantic value.

**Constructors**

| | |
|---|---|
| `VuiDisambiguationSlot(System.String disambiguationText, System.String disambiguationSemanticValue)` | Initializes a new disambiguation slot. |

**Properties**

| | |
|---|---|
| `System.String DisambiguationSemanticValue { get; }` | Gets the semantic value of the phrase that selects this slot. |
| `System.String DisambiguationText { get; }` | Gets the label shown next to a candidate command (for example a number the user can say). |

## VuiGrammar

`class Microsoft.Xbox.Controls.VuiGrammar`

A set of spoken phrases, each mapped to a semantic value, that can be loaded into the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) recognizer.

Add phrases with [`VuiGrammar.AddPhrase`](Microsoft.Xbox.Controls.md#vuigrammar) and then call [`VuiBar.LoadGrammar`](Microsoft.Xbox.Controls.md#vuibar) while recognition is stopped. Several phrases may share a semantic value (synonyms). A phrase is active only while a [`VuiCommand`](Microsoft.Xbox.Controls.md#vuicommand) with the same semantic value is on the bar and can execute. Phrases should be in the language of the current culture.

**Constructors**

| | |
|---|---|
| `VuiGrammar()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean IsLoaded { get; }` | Gets whether the grammar is loaded into the recognizer. |

**Methods**

| | |
|---|---|
| `System.Void AddPhrase(System.String text, System.String semanticValue)` | Adds a phrase that uses the speech language's default confidence thresholds. Same rules as [`VuiGrammar.AddPhrase`](Microsoft.Xbox.Controls.md#vuigrammar). |
| `System.Void AddPhrase(System.String text, System.String semanticValue, System.Double normalRequiredConfidence, System.Double activeRequiredConfidence)` | Adds a phrase with its own recognition confidence thresholds. Throws `InvalidOperationException` if the grammar is loaded, `ArgumentException` for invalid text or semantic values, and `ArgumentOutOfRangeException` for confidences outside 0–1. |

## VuiPersistence

`enum Microsoft.Xbox.Controls.VuiPersistence`

Specifies whether the [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) keeps actively listening after a command executes.

**Values**

| | |
|---|---|
| `Dismiss` | Close the bar after the command runs. |
| `ForceMaintain` | Open the bar (or keep it open) after the command runs, with the 12-second listening timeout. |
| `ForceMaintainNoTimeout` | Open the bar (or keep it open) after the command runs, with no timeout. |
| `Maintain` | Keep the bar open if it was already open, restarting the 12-second listening timeout. |

## XboxApplicationFrame

`class Microsoft.Xbox.Controls.XboxApplicationFrame`

The navigation frame to use as the root of an Xbox Silverlight app. It hosts pages, plays page transitions and contains the app's [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar).

Creating the frame initializes GamerServices (`GamerServicesDispatcher.Initialize`) and the UI sound system if they are not initialized yet, and pumps the XNA framework and GamerServices dispatchers on every rendered frame. Controls that depend on GamerServices, such as the screen-saver handling in [`MediaTransport`](Microsoft.Xbox.Controls.md#mediatransport), therefore work automatically inside this frame.

The template must contain a [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) named `PART_VuiBar` (the default template does); otherwise `InvalidOperationException` is thrown. Only one [`VuiBar`](Microsoft.Xbox.Controls.md#vuibar) may exist per app, so do not add another one when you use this frame.

On navigation the old and new pages are shown in two presenters and their navigation transitions (set with the `TransitionService` attached properties) are played. Elements marked as transition targets animate in order after the page. Any [`SwipeViewer`](Microsoft.Xbox.Controls.md#swipeviewer) on the outgoing page is turned off and the one on the incoming page is turned on.

**Constructors**

| | |
|---|---|
| `XboxApplicationFrame()` |  |

**Methods**

| | |
|---|---|
| `System.Void OnApplyTemplate()` |  |
| `System.Void OnContentChanged(System.Object oldContent, System.Object newContent)` | Starts the page transition when the frame's content changes. Completes any transition still in progress, places both pages in the frame's presenters, and starts the out and in transitions once the new page's items controls have loaded (or after 0.3 seconds if it has none). |

## XboxApplicationPage

`class Microsoft.Xbox.Controls.XboxApplicationPage`

A `Page` preconfigured with Z-order navigation transitions so that pages layer correctly while [`XboxApplicationFrame`](Microsoft.Xbox.Controls.md#xboxapplicationframe) animates between them.

Replace the page's `TransitionService` navigation transitions if you want a different animation.

**Constructors**

| | |
|---|---|
| `XboxApplicationPage()` |  |

