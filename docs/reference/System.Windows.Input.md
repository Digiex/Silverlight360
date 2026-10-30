# System.Windows.Input

Assembly: `System.Windows.dll`

| Type | Summary |
|---|---|
| [`AttachCompletedEventArgs`](#attachcompletedeventargs) | Provides data for the `Button.AttachCompleted` event. |
| [`AttachProgressChangedEventArgs`](#attachprogresschangedeventargs) | Provides data for the `Button.AttachProgressChanged` event. |
| [`AttachStartedEventArgs`](#attachstartedeventargs) | Provides data for the `Button.AttachStarted` event. |
| [`DetachCompletedEventArgs`](#detachcompletedeventargs) | Provides data for the `Button.DetachCompleted` event. |
| [`DetachProgressChangedEventArgs`](#detachprogresschangedeventargs) | Provides data for the `Button.DetachProgressChanged` event. |
| [`DetachStartedEventArgs`](#detachstartedeventargs) | Provides data for the `Button.DetachStarted` event. |
| [`GamePadButton`](#gamepadbutton) | Identifies a digital button on an Xbox 360 controller. |
| [`GamePadButtonEventArgs`](#gamepadbuttoneventargs) | Provides data for the `UIElement.GamePadButtonDown` and `UIElement.GamePadButtonUp` events. |
| [`GamePadSide`](#gamepadside) | Identifies which of a pair of analog controls (thumbstick or trigger) produced an event. |
| [`GamePadThumbStickMovedEventArgs`](#gamepadthumbstickmovedeventargs) | Provides data for the `UIElement.GamePadThumbStickMoved` event. |
| [`GamePadTriggerMovedEventArgs`](#gamepadtriggermovedeventargs) | Provides data for the `UIElement.GamePadTriggerMoved` event. |
| [`Handedness`](#handedness) | Identifies which hand drives the Kinect hand cursor. |
| [`HoverCompletedEventArgs`](#hovercompletedeventargs) | Provides data for the `Button.HoverCompleted` event. |
| [`HoverProgressChangedEventArgs`](#hoverprogresschangedeventargs) | Provides data for the `Button.HoverProgressChanged` event. |
| [`HoverStartedEventArgs`](#hoverstartedeventargs) | Provides data for the `Button.HoverStarted` event. |
| [`InputModality`](#inputmodality) | Identifies the kind of input that caused an action, such as a button click. |
| [`InputModalityRoutedEventArgs`](#inputmodalityroutedeventargs) | Routed event data that records which input modality, and which user, caused the event. |
| [`MagneticDelays`](#magneticdelays) | Holds the four dwell times, in milliseconds, used by a magnetic `Button`. |
| [`MagneticDelaysTypeConverter`](#magneticdelaystypeconverter) | Converts between strings of four comma-separated integers and [`MagneticDelays`](System.Windows.Input.md#magneticdelays) values, so the property can be set in XAML. |
| [`MagneticEventArgs`](#magneticeventargs) | Base class for the data of the attach and detach events of a magnetic `Button`. |
| [`MagneticRadii`](#magneticradii) | Holds the four zone sizes used by a magnetic `Button`, from the innermost zone outward. |
| [`MagneticRadiiTypeConverter`](#magneticradiitypeconverter) | Converts between strings of four comma-separated numbers and [`MagneticRadii`](System.Windows.Input.md#magneticradii) values, so the property can be set in XAML. |
| [`MagneticZone`](#magneticzone) | Identifies the concentric zones around a magnetic button's origin that govern how the Kinect hand cursor snaps to it, from innermost to outermost. |
| [`SpeechCommand`](#speechcommand) | Base class for an `ICommand` that can also be invoked by voice, and that ties a phrase to a `Button`. |
| [`UserInformation`](#userinformation) | Identifies the user who produced an input event: the controller slot for controller input, and the Kinect tracking ID for gesture input. |

## AttachCompletedEventArgs

`class System.Windows.Input.AttachCompletedEventArgs`

Provides data for the `Button.AttachCompleted` event.

## AttachProgressChangedEventArgs

`class System.Windows.Input.AttachProgressChangedEventArgs`

Provides data for the `Button.AttachProgressChanged` event.

**Properties**

| | |
|---|---|
| `System.Double AttachProgress { get; }` | Gets the attach progress. |

## AttachStartedEventArgs

`class System.Windows.Input.AttachStartedEventArgs`

Provides data for the `Button.AttachStarted` event.

## DetachCompletedEventArgs

`class System.Windows.Input.DetachCompletedEventArgs`

Provides data for the `Button.DetachCompleted` event.

## DetachProgressChangedEventArgs

`class System.Windows.Input.DetachProgressChangedEventArgs`

Provides data for the `Button.DetachProgressChanged` event.

**Properties**

| | |
|---|---|
| `System.Double DetachProgress { get; }` | Gets the detach progress, expressed as remaining attachment. |

## DetachStartedEventArgs

`class System.Windows.Input.DetachStartedEventArgs`

Provides data for the `Button.DetachStarted` event.

## GamePadButton

`enum System.Windows.Input.GamePadButton`

Identifies a digital button on an Xbox 360 controller.

Reported by [`GamePadButtonEventArgs.Button`](System.Windows.Input.md#gamepadbuttoneventargs) in the `UIElement.GamePadButtonDown` and `UIElement.GamePadButtonUp` events. The analog thumbsticks and triggers are reported separately through `UIElement.GamePadThumbStickMoved` and `UIElement.GamePadTriggerMoved`.

**Values**

| | |
|---|---|
| `A` | The A face button (green). A `Button` with focus treats it as a press and raises Click. |
| `B` | The B face button (red), conventionally used for "back" or "cancel". |
| `Back` | The Back button, to the left of the Xbox Guide button. |
| `DPadDown` | Down on the directional pad. |
| `DPadLeft` | Left on the directional pad. |
| `DPadRight` | Right on the directional pad. |
| `DPadUp` | Up on the directional pad. |
| `LeftShoulder` | The left bumper (LB), the digital button above the left trigger. |
| `LeftStick` | Pressing the left thumbstick down (left stick click). |
| `RightShoulder` | The right bumper (RB), the digital button above the right trigger. |
| `RightStick` | Pressing the right thumbstick down (right stick click). |
| `Start` | The Start button, to the right of the Xbox Guide button. A focused `Button` treats it like [`GamePadButton.A`](System.Windows.Input.md#gamepadbutton). |
| `X` | The X face button (blue). |
| `Y` | The Y face button (yellow). |

## GamePadButtonEventArgs

`class System.Windows.Input.GamePadButtonEventArgs`

Provides data for the `UIElement.GamePadButtonDown` and `UIElement.GamePadButtonUp` events.

The values are read from the native event object, so read them inside the handler rather than storing the arguments for later.

**Constructors**

| | |
|---|---|
| `GamePadButtonEventArgs()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean Handled { get; set; }` | Gets or sets a value that marks the routed event as handled. Handlers added with `UIElement.AddHandler` and handledEventsToo set to true still run. |
| `System.Windows.Input.GamePadButton Button { get; }` | Gets the controller button that was pressed or released. |
| `System.Windows.Input.UserInformation UserInformation { get; }` | Gets information about the user whose controller produced the event. |

## GamePadSide

`enum System.Windows.Input.GamePadSide`

Identifies which of a pair of analog controls (thumbstick or trigger) produced an event.

**Values**

| | |
|---|---|
| `Left` | The left thumbstick or left trigger. |
| `Right` | The right thumbstick or right trigger. |

## GamePadThumbStickMovedEventArgs

`class System.Windows.Input.GamePadThumbStickMovedEventArgs`

Provides data for the `UIElement.GamePadThumbStickMoved` event.

**Constructors**

| | |
|---|---|
| `GamePadThumbStickMovedEventArgs()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean Handled { get; set; }` | Gets or sets a value that marks the routed event as handled. |
| `System.Double XPosition { get; }` | Gets the horizontal position of the thumbstick that moved. |
| `System.Double YPosition { get; }` | Gets the vertical position of the thumbstick that moved. |
| `System.Windows.Input.GamePadSide Side { get; }` | Gets which thumbstick moved. |
| `System.Windows.Input.UserInformation UserInformation { get; }` | Gets information about the user whose controller produced the event. |

## GamePadTriggerMovedEventArgs

`class System.Windows.Input.GamePadTriggerMovedEventArgs`

Provides data for the `UIElement.GamePadTriggerMoved` event.

**Constructors**

| | |
|---|---|
| `GamePadTriggerMovedEventArgs()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean Handled { get; set; }` | Gets or sets a value that marks the routed event as handled. |
| `System.Double Position { get; }` | Gets how far the trigger that moved is pressed. |
| `System.Windows.Input.GamePadSide Side { get; }` | Gets which trigger moved. |
| `System.Windows.Input.UserInformation UserInformation { get; }` | Gets information about the user whose controller produced the event. |

## Handedness

`enum System.Windows.Input.Handedness`

Identifies which hand drives the Kinect hand cursor.

**Values**

| | |
|---|---|
| `Left` | The user's left hand. |
| `Right` | The user's right hand. |

## HoverCompletedEventArgs

`class System.Windows.Input.HoverCompletedEventArgs`

Provides data for the `Button.HoverCompleted` event.

**Properties**

| | |
|---|---|
| `System.Windows.Input.UserInformation UserInformation { get; }` | Gets the user whose hover completed. |

## HoverProgressChangedEventArgs

`class System.Windows.Input.HoverProgressChangedEventArgs`

Provides data for the `Button.HoverProgressChanged` event.

**Constructors**

| | |
|---|---|
| `HoverProgressChangedEventArgs(System.Double hoverProgress, System.Windows.Input.UserInformation userInfo)` | Initializes a new instance of the [`HoverProgressChangedEventArgs`](System.Windows.Input.md#hoverprogresschangedeventargs) class. |

**Properties**

| | |
|---|---|
| `System.Double HoverProgress { get; }` | Gets the new hover progress. |
| `System.Windows.Input.UserInformation UserInformation { get; }` | Gets the user whose hand cursor is hovering. |

## HoverStartedEventArgs

`class System.Windows.Input.HoverStartedEventArgs`

Provides data for the `Button.HoverStarted` event.

**Properties**

| | |
|---|---|
| `System.Windows.Input.UserInformation UserInformation { get; }` | Gets the user whose hand cursor started the hover. |

## InputModality

`enum System.Windows.Input.InputModality`

Identifies the kind of input that caused an action, such as a button click.

The arguments of `ButtonBase.Click` are an [`InputModalityRoutedEventArgs`](System.Windows.Input.md#inputmodalityroutedeventargs); cast the `RoutedEventArgs` to read which modality activated the button.

**Values**

| | |
|---|---|
| `GamePad` | An Xbox 360 controller button, such as A or Start. |
| `Gesture` | Kinect gesture input, such as completing a hover over a button with the hand cursor. |
| `Keyboard` | A keyboard key (Space, or Enter where it is accepted). |
| `Mouse` | A mouse or other pointer press. |
| `RemoteControl` | A media remote, for example the Play/Pause key. |
| `Unknown` | The source of the input is not known, for example when Click is raised from code or through automation. |
| `Voice` | A voice command, delivered through a [`SpeechCommand`](System.Windows.Input.md#speechcommand). |

## InputModalityRoutedEventArgs

`class System.Windows.Input.InputModalityRoutedEventArgs`

Routed event data that records which input modality, and which user, caused the event.

Passed as the arguments of `ButtonBase.Click`. The event is still declared with `RoutedEventHandler`, so cast the arguments to this type.

**Properties**

| | |
|---|---|
| `System.Windows.Input.InputModality InputModality { get; }` | Gets the kind of input that caused the event. |
| `System.Windows.Input.UserInformation UserInformation { get; }` | Gets the user who caused the event. |

## MagneticDelays

`struct System.Windows.Input.MagneticDelays`

Holds the four dwell times, in milliseconds, used by a magnetic `Button`.

The XAML and string form is four comma-separated integers in constructor order, for example "350,840,2000,75". See `Button.MagneticDelays` for the allowed ranges.

**Constructors**

| | |
|---|---|
| `MagneticDelays(System.Int32 fastAttachDelay, System.Int32 slowAttachDelay, System.Int32 slowDetachDelay, System.Int32 fastDetachDelay)` | Initializes a new [`MagneticDelays`](System.Windows.Input.md#magneticdelays) with the given delays. |

**Properties**

| | |
|---|---|
| `System.Int32 FastAttachDelay { get; set; }` | Gets or sets how long the cursor must stay in the fast-attach zone before it attaches. |
| `System.Int32 FastDetachDelay { get; set; }` | Gets or sets how long an attached cursor must stay in the fast-detach zone before it detaches. |
| `System.Int32 SlowAttachDelay { get; set; }` | Gets or sets how long the cursor must stay in the slow-attach zone before it attaches. |
| `System.Int32 SlowDetachDelay { get; set; }` | Gets or sets how long an attached cursor must stay in the slow-detach zone before it detaches. |

**Methods**

| | |
|---|---|
| `System.String ToString()` |  |

## MagneticDelaysTypeConverter

`class System.Windows.Input.MagneticDelaysTypeConverter`

Converts between strings of four comma-separated integers and [`MagneticDelays`](System.Windows.Input.md#magneticdelays) values, so the property can be set in XAML.

**Constructors**

| | |
|---|---|
| `MagneticDelaysTypeConverter()` |  |

**Methods**

| | |
|---|---|
| `System.Boolean CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType)` | Determines whether a value of the given type can be converted to [`MagneticDelays`](System.Windows.Input.md#magneticdelays). |
| `System.Boolean CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType)` | Determines whether a [`MagneticDelays`](System.Windows.Input.md#magneticdelays) can be converted to the given type. |
| `System.Object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, System.Object value)` | Parses a string of four comma-separated integers into a [`MagneticDelays`](System.Windows.Input.md#magneticdelays). |
| `System.Object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, System.Object value, System.Type destinationType)` | Converts a [`MagneticDelays`](System.Windows.Input.md#magneticdelays) to its string form. |

## MagneticEventArgs

`class System.Windows.Input.MagneticEventArgs`

Base class for the data of the attach and detach events of a magnetic `Button`.

**Properties**

| | |
|---|---|
| `System.Windows.Input.UserInformation UserInformation { get; }` | Gets the user whose hand cursor caused the event. |

## MagneticRadii

`struct System.Windows.Input.MagneticRadii`

Holds the four zone sizes used by a magnetic `Button`, from the innermost zone outward.

The XAML and string form is four comma-separated numbers in constructor order, for example "0.1,0.15,0.1875,0.225".

**Constructors**

| | |
|---|---|
| `MagneticRadii(System.Double fastAttachRadius, System.Double slowAttachRadius, System.Double approachRadius, System.Double slowDetachRadius)` | Initializes a new [`MagneticRadii`](System.Windows.Input.md#magneticradii) with the given zone sizes. |

**Properties**

| | |
|---|---|
| `System.Double ApproachRadius { get; set; }` | Gets or sets the size of the approach zone. |
| `System.Double FastAttachRadius { get; set; }` | Gets or sets the size of the fast-attach zone. |
| `System.Double SlowAttachRadius { get; set; }` | Gets or sets the size of the slow-attach zone. |
| `System.Double SlowDetachRadius { get; set; }` | Gets or sets the size of the slow-detach zone; beyond it lies the fast-detach zone. |

**Methods**

| | |
|---|---|
| `System.String ToString()` |  |

## MagneticRadiiTypeConverter

`class System.Windows.Input.MagneticRadiiTypeConverter`

Converts between strings of four comma-separated numbers and [`MagneticRadii`](System.Windows.Input.md#magneticradii) values, so the property can be set in XAML.

**Constructors**

| | |
|---|---|
| `MagneticRadiiTypeConverter()` |  |

**Methods**

| | |
|---|---|
| `System.Boolean CanConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Type sourceType)` | Determines whether a value of the given type can be converted to [`MagneticRadii`](System.Windows.Input.md#magneticradii). |
| `System.Boolean CanConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Type destinationType)` | Determines whether a [`MagneticRadii`](System.Windows.Input.md#magneticradii) can be converted to the given type. |
| `System.Object ConvertFrom(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, System.Object value)` | Parses a string of four comma-separated numbers into a [`MagneticRadii`](System.Windows.Input.md#magneticradii). |
| `System.Object ConvertTo(System.ComponentModel.ITypeDescriptorContext context, System.Globalization.CultureInfo culture, System.Object value, System.Type destinationType)` | Converts a [`MagneticRadii`](System.Windows.Input.md#magneticradii) to its string form. |

## MagneticZone

`enum System.Windows.Input.MagneticZone`

Identifies the concentric zones around a magnetic button's origin that govern how the Kinect hand cursor snaps to it, from innermost to outermost.

The zone sizes are set with `Button.MagneticRadii` and the time spent in each zone before the cursor attaches or detaches with `Button.MagneticDelays`.

**Values**

| | |
|---|---|
| `Approach` | The zone in which the cursor is approaching the button but does not attach. |
| `FastAttach` | The innermost zone; the cursor attaches after the short fast-attach delay. |
| `FastDetach` | The outermost zone; an attached cursor detaches after the short fast-detach delay. |
| `SlowAttach` | The zone outside [`MagneticZone.FastAttach`](System.Windows.Input.md#magneticzone); the cursor attaches after the longer slow-attach delay. |
| `SlowDetach` | The zone in which an attached cursor detaches after the slow-detach delay. |

## SpeechCommand

`class System.Windows.Input.SpeechCommand`

Base class for an `ICommand` that can also be invoked by voice, and that ties a phrase to a `Button`.

Derive from this class, implement [`SpeechCommand.DisplayText`](System.Windows.Input.md#speechcommand), [`SpeechCommand.CanExecute`](System.Windows.Input.md#speechcommand) and [`SpeechCommand.Execute`](System.Windows.Input.md#speechcommand), and assign an instance to a button's Command property.

While the button is loaded, the command is linked to it. When the command reports a voice activation by calling [`SpeechCommand.OnInternalExecuted`](System.Windows.Input.md#speechcommand), the button raises Click with [`InputModality.Voice`](System.Windows.Input.md#inputmodality), which then executes the command. The button's IsEnabled state is combined with [`SpeechCommand.CanExecute`](System.Windows.Input.md#speechcommand) to decide whether the phrase is available. A command instance can be linked to only one loaded button at a time.

Voice input requires a Kinect sensor. The button template can define the SpeechHidden, SpeechShown and SpeechDisambiguating visual states to show the phrase on screen.

**Constructors**

| | |
|---|---|
| `SpeechCommand()` |  |

**Properties**

| | |
|---|---|
| `System.String DisambiguationText { get; }` | Gets the extra text shown when several commands share the same phrase and the user must choose between them. |
| `System.String DisplayText { get; set; }` | When overridden in a derived class, gets or sets the phrase the user says to invoke the command, as it is shown on screen. |

**Methods**

| | |
|---|---|
| `System.Boolean CanExecute(System.Object parameter)` | When overridden in a derived class, determines whether the command can run. |
| `System.Void Execute(System.Object parameter)` | When overridden in a derived class, performs the command's action. |
| `System.Void OnCanExecuteChanged()` | Raises the [`SpeechCommand.CanExecuteChanged`](System.Windows.Input.md#speechcommand) event unconditionally. |
| `System.Void OnInternalExecuted()` | Reports that the command was invoked by voice. The linked `Button` responds by raising Click with [`InputModality.Voice`](System.Windows.Input.md#inputmodality), which in turn calls [`SpeechCommand.Execute`](System.Windows.Input.md#speechcommand). Nothing happens if no loaded button is linked to the command, or if the button is already executing its command. |
| `System.Void OnPropertyChanged(System.String propertyName)` | Raises the [`SpeechCommand.PropertyChanged`](System.Windows.Input.md#speechcommand) event. |
| `System.Void UpdateCanExecute()` | Re-evaluates [`SpeechCommand.CanExecute`](System.Windows.Input.md#speechcommand) with a null parameter and raises [`SpeechCommand.CanExecuteChanged`](System.Windows.Input.md#speechcommand) if the result differs from the previous one. Call this whenever the state that [`SpeechCommand.CanExecute`](System.Windows.Input.md#speechcommand) depends on changes, so the voice phrase is enabled or disabled to match. |

**Events**

| | |
|---|---|
| `event System.ComponentModel.PropertyChangedEventHandler PropertyChanged` | Occurs when a property value changes, for example [`SpeechCommand.DisplayText`](System.Windows.Input.md#speechcommand). |
| `event System.EventHandler CanExecuteChanged` | Occurs when the result of [`SpeechCommand.CanExecute`](System.Windows.Input.md#speechcommand) changes. Raised by [`SpeechCommand.OnCanExecuteChanged`](System.Windows.Input.md#speechcommand), and by [`SpeechCommand.UpdateCanExecute`](System.Windows.Input.md#speechcommand) when it detects a change. |

## UserInformation

`class System.Windows.Input.UserInformation`

Identifies the user who produced an input event: the controller slot for controller input, and the Kinect tracking ID for gesture input.

Instances are created by the platform. When a value is not known, the properties hold [`UserInformation.InvalidPlayerIndex`](System.Windows.Input.md#userinformation) and [`UserInformation.InvalidTrackingId`](System.Windows.Input.md#userinformation).

**Properties**

| | |
|---|---|
| `System.Int32 PlayerIndex { get; }` | Gets the player (controller slot) index of the user who produced the input. |
| `System.Int32 TrackingId { get; }` | Gets the Kinect tracking ID of the body that produced the input. |

**Fields**

| | |
|---|---|
| `const System.Int32 InvalidPlayerIndex` | The value of [`UserInformation.PlayerIndex`](System.Windows.Input.md#userinformation) when no player is associated with the input. This field is constant (254). |
| `const System.Int32 InvalidTrackingId` | The value of [`UserInformation.TrackingId`](System.Windows.Input.md#userinformation) when no tracked body is associated with the input. This field is constant (0). |

