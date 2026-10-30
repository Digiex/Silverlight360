# Microsoft.Xbox.Input

Assembly: `Microsoft.Xbox.dll`

| Type | Summary |
|---|---|
| [`GridFocusHelper`](#gridfocushelper) | Moves keyboard focus between the cells of a `Grid` in response to the controller's D-pad and thumbstick (arrow keys). |
| [`InputModality`](#inputmodality) | Identifies how the user is currently driving the application. |
| [`InputModalityChangedEventArgs`](#inputmodalitychangedeventargs) | Provides data for the [`Kinect.InputModalityChanged`](Microsoft.Xbox.Input.md#kinect) event. |
| [`Kinect`](#kinect) | Reports Kinect sensor status, user engagement and identification, and switches between controller and gesture input. |
| [`KinectBindingChangedEventArgs`](#kinectbindingchangedeventargs) | Provides data for a change in which signed-in user a Kinect user is bound to. No public event in this version raises it. |
| [`KinectDeviceStatus`](#kinectdevicestatus) | Describes the state of the Kinect sensor. |
| [`KinectDeviceStatusChangedEventArgs`](#kinectdevicestatuschangedeventargs) | Provides data for the [`Kinect.DeviceStatusChanged`](Microsoft.Xbox.Input.md#kinect) event. |
| [`KinectSystemGestureInvokedEventArgs`](#kinectsystemgestureinvokedeventargs) | Provides data for the [`Kinect.SystemGestureInvoked`](Microsoft.Xbox.Input.md#kinect) event. |
| [`KinectTrackedSkeletonCountChangedEventArgs`](#kinecttrackedskeletoncountchangedeventargs) | Provides data for the [`Kinect.TrackedSkeletonCountChanged`](Microsoft.Xbox.Input.md#kinect) event. |
| [`KinectUserEngagedEventArgs`](#kinectuserengagedeventargs) | Provides data for the [`Kinect.UserEngaged`](Microsoft.Xbox.Input.md#kinect) event. A `TrackingId` of [`Kinect.InvalidTrackingId`](Microsoft.Xbox.Input.md#kinect) means no user is engaged. |
| [`KinectUserEventArgs`](#kinectusereventargs) | Base class for Kinect event data that refers to a tracked user. |
| [`KinectUserIdentificationQualityFlags`](#kinectuseridentificationqualityflags) | Conditions that prevent the Kinect sensor from identifying a user. Several flags can be set at once. |
| [`KinectUserIdentificationUpdateEventArgs`](#kinectuseridentificationupdateeventargs) | Provides data for the [`Kinect.UserIdentificationUpdate`](Microsoft.Xbox.Input.md#kinect) event. |
| [`KinectUserIdentifiedEventArgs`](#kinectuseridentifiedeventargs) | Provides data for the [`Kinect.UserIdentified`](Microsoft.Xbox.Input.md#kinect) event. [`KinectUserEventArgs.UserInformation`](Microsoft.Xbox.Input.md#kinectusereventargs) carries both the tracking ID and the player index. |
| [`KinectWaveProgressChangedEventArgs`](#kinectwaveprogresschangedeventargs) | Provides data for the [`Kinect.WaveProgressChanged`](Microsoft.Xbox.Input.md#kinect) event. |
| [`RuneTileActivationEventArgs`](#runetileactivationeventargs) | Provides data when a key tile of the on-screen keyboard (`Rune`) control is activated. |

## GridFocusHelper

`class Microsoft.Xbox.Input.GridFocusHelper`

Moves keyboard focus between the cells of a `Grid` in response to the controller's D-pad and thumbstick (arrow keys).

The easiest way to use it is to set the `GridFocusHelper.IsFocusTarget` attached property to `true` on a `Grid` in XAML. On each unhandled arrow key the helper picks the nearest child in that direction, using the children's `Grid.Row`, `Grid.Column` and span values rather than their pixel positions, and focuses the first visible, enabled tab stop inside it (breadth-first). Call [`GridFocusHelper.Dispose`](Microsoft.Xbox.Input.md#gridfocushelper) or set the property to `false` to detach.

**Constructors**

| | |
|---|---|
| `GridFocusHelper(System.Windows.Controls.Grid target)` | Creates a helper and attaches it to the specified grid, which also sets `IsFocusTarget` to `true` on that grid. |

**Methods**

| | |
|---|---|
| `System.Void Dispose()` |  |
| `System.Windows.Controls.Control GetFocusableChild(System.Windows.FrameworkElement directChild)` | Returns the control that should receive focus when navigation lands on a direct child of the grid. Override this in a derived class to redirect focus to a specific control within a cell. |
| `static System.Boolean GetIsFocusTarget(System.Windows.Controls.Grid g)` | Gets whether a [`GridFocusHelper`](Microsoft.Xbox.Input.md#gridfocushelper) is attached to the specified grid. |
| `static System.Void SetIsFocusTarget(System.Windows.Controls.Grid g, System.Boolean value)` | Enables or disables directional focus navigation on the specified grid. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty IsFocusTargetProperty` | Identifies the `GridFocusHelper.IsFocusTarget` attached property. Setting it to `true` on a `Grid` creates and attaches a [`GridFocusHelper`](Microsoft.Xbox.Input.md#gridfocushelper); setting it to `false` disposes it. The default is `false`. |

## InputModality

`enum Microsoft.Xbox.Input.InputModality`

Identifies how the user is currently driving the application.

**Values**

| | |
|---|---|
| `Controller` | The user is using a controller or remote. This is also the value at design time. |
| `Gesture` | The user is using Kinect gestures (hand cursor). |

## InputModalityChangedEventArgs

`class Microsoft.Xbox.Input.InputModalityChangedEventArgs`

Provides data for the [`Kinect.InputModalityChanged`](Microsoft.Xbox.Input.md#kinect) event.

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Input.InputModality InputModality { get; }` | Gets the input modality that is now active. |

## Kinect

`class Microsoft.Xbox.Input.Kinect`

Reports Kinect sensor status, user engagement and identification, and switches between controller and gesture input.

Requires a Kinect sensor for anything other than status queries. The first access to any member registers for sensor notifications and reads the initial [`Kinect.DeviceStatus`](Microsoft.Xbox.Input.md#kinect), engaged user and tracked skeleton count, so touch the class early (for example, read [`Kinect.DeviceStatus`](Microsoft.Xbox.Input.md#kinect) at startup) if you rely on its events. Event handlers are invoked directly from the runtime's notification; they are not re-posted through a `Dispatcher`.

**Properties**

| | |
|---|---|
| `static Microsoft.Xbox.Input.InputModality CurrentInputModality { get; }` | Gets whether the user is currently using the controller or Kinect gestures. Queried from the console each time; returns [`InputModality.Controller`](Microsoft.Xbox.Input.md#inputmodality) at design time. |
| `static Microsoft.Xbox.Input.KinectDeviceStatus DeviceStatus { get; }` | Gets the most recently reported state of the Kinect sensor. Updated before [`Kinect.DeviceStatusChanged`](Microsoft.Xbox.Input.md#kinect) is raised. |
| `static System.Int32 TrackedSkeletonCount { get; }` | Gets the number of skeletons the Kinect sensor is currently tracking. Updated before [`Kinect.TrackedSkeletonCountChanged`](Microsoft.Xbox.Input.md#kinect) is raised. |
| `static System.Windows.Input.UserInformation EngagedUserInformation { get; }` | Gets the tracking ID and player index of the user currently engaged with the Kinect sensor. The same object is updated in place as engagement and identification change. |

**Methods**

| | |
|---|---|
| `static System.Void ForceDisengage()` | Disengages the current Kinect user, so that a user has to engage again (for example, by waving) before gesture input resumes. Throws if the console reports a failure. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xbox.Input.InputModalityChangedEventArgs> InputModalityChanged` | Occurs when the user switches between controller and Kinect gesture input. |
| `event System.EventHandler<Microsoft.Xbox.Input.KinectDeviceStatusChangedEventArgs> DeviceStatusChanged` |  |
| `event System.EventHandler<Microsoft.Xbox.Input.KinectSystemGestureInvokedEventArgs> SystemGestureInvoked` | Occurs when a Kinect user performs the console's reserved system gesture. |
| `event System.EventHandler<Microsoft.Xbox.Input.KinectTrackedSkeletonCountChangedEventArgs> TrackedSkeletonCountChanged` |  |
| `event System.EventHandler<Microsoft.Xbox.Input.KinectUserEngagedEventArgs> UserEngaged` | Occurs when a user engages with or disengages from the Kinect sensor. A tracking ID of [`Kinect.InvalidTrackingId`](Microsoft.Xbox.Input.md#kinect) means the engaged user disengaged. [`Kinect.EngagedUserInformation`](Microsoft.Xbox.Input.md#kinect) is updated before the event is raised, and the engage or disengage system sound plays if [`Sounds.IsEnabled`](Microsoft.Xbox.Media.md#sounds) is `true`. |
| `event System.EventHandler<Microsoft.Xbox.Input.KinectUserIdentificationUpdateEventArgs> UserIdentificationUpdate` | Occurs while the sensor is trying to identify an engaged user, reporting conditions that prevent recognition (lighting, position, occlusion) so the application can guide the user. |
| `event System.EventHandler<Microsoft.Xbox.Input.KinectUserIdentifiedEventArgs> UserIdentified` | Occurs when an engaged Kinect user has been matched to a signed-in profile. [`Kinect.EngagedUserInformation`](Microsoft.Xbox.Input.md#kinect) is updated with the player index before the event is raised. |
| `event System.EventHandler<Microsoft.Xbox.Input.KinectWaveProgressChangedEventArgs> WaveProgressChanged` | Occurs repeatedly while a user performs the engagement wave, reporting how far the wave has progressed. |

**Fields**

| | |
|---|---|
| `const System.Int32 InvalidTrackingId` | The tracking ID (0) that means no Kinect skeleton, for example when no user is engaged. |
| `const System.Int32 NoUserIndex` | The player index (254) used when a tracked Kinect user has not been matched to a signed-in profile. |

## KinectBindingChangedEventArgs

`class Microsoft.Xbox.Input.KinectBindingChangedEventArgs`

Provides data for a change in which signed-in user a Kinect user is bound to. No public event in this version raises it.

**Properties**

| | |
|---|---|
| `System.Int32 UserIndex { get; }` | Gets the player index whose binding changed. |

## KinectDeviceStatus

`enum Microsoft.Xbox.Input.KinectDeviceStatus`

Describes the state of the Kinect sensor.

**Values**

| | |
|---|---|
| `Connected` | The sensor is plugged in but not yet ready for use. |
| `Disconnected` | No sensor is connected. |
| `Error` | The sensor is connected but has reported an error. |
| `Ready` | The sensor is connected and ready. |

## KinectDeviceStatusChangedEventArgs

`class Microsoft.Xbox.Input.KinectDeviceStatusChangedEventArgs`

Provides data for the [`Kinect.DeviceStatusChanged`](Microsoft.Xbox.Input.md#kinect) event.

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Input.KinectDeviceStatus Status { get; }` | Gets the new sensor state. |

## KinectSystemGestureInvokedEventArgs

`class Microsoft.Xbox.Input.KinectSystemGestureInvokedEventArgs`

Provides data for the [`Kinect.SystemGestureInvoked`](Microsoft.Xbox.Input.md#kinect) event.

**Properties**

| | |
|---|---|
| `System.Windows.Input.UserInformation UserInformation { get; }` | Gets the user who performed the gesture. Only `TrackingId` is filled in. |

## KinectTrackedSkeletonCountChangedEventArgs

`class Microsoft.Xbox.Input.KinectTrackedSkeletonCountChangedEventArgs`

Provides data for the [`Kinect.TrackedSkeletonCountChanged`](Microsoft.Xbox.Input.md#kinect) event.

**Properties**

| | |
|---|---|
| `System.Int32 TrackedSkeletonCount { get; }` | Gets the new number of tracked skeletons. |

## KinectUserEngagedEventArgs

`class Microsoft.Xbox.Input.KinectUserEngagedEventArgs`

Provides data for the [`Kinect.UserEngaged`](Microsoft.Xbox.Input.md#kinect) event. A `TrackingId` of [`Kinect.InvalidTrackingId`](Microsoft.Xbox.Input.md#kinect) means no user is engaged.

## KinectUserEventArgs

`class Microsoft.Xbox.Input.KinectUserEventArgs`

Base class for Kinect event data that refers to a tracked user.

**Constructors**

| | |
|---|---|
| `KinectUserEventArgs(System.Int32 trackingId)` | Initializes the event data for the specified tracked user. |

**Properties**

| | |
|---|---|
| `System.Windows.Input.UserInformation UserInformation { get; }` | Gets the user the event relates to. `TrackingId` is always set; `PlayerIndex` is set only by [`Kinect.UserIdentified`](Microsoft.Xbox.Input.md#kinect). |

## KinectUserIdentificationQualityFlags

`enum Microsoft.Xbox.Input.KinectUserIdentificationQualityFlags`

Conditions that prevent the Kinect sensor from identifying a user. Several flags can be set at once.

**Values**

| | |
|---|---|
| `EnvironmentFaceDetectFailure` | The user's face could not be detected. |
| `EnvironmentTooBright` | The room is too bright, or there is strong light behind the user. |
| `EnvironmentTooDark` | The room is too dark. |
| `UserBodyTurned` | The user is not facing the sensor. |
| `UserClippedAtBottom` | The user is partly outside the bottom edge of the sensor's view. |
| `UserClippedAtLeft` | The user is partly outside the left edge of the sensor's view. |
| `UserClippedAtRight` | The user is partly outside the right edge of the sensor's view. |
| `UserClippedAtTop` | The user is partly outside the top edge of the sensor's view. |
| `UserClose` | The user is too close to the sensor. |
| `UserFarAway` | The user is too far from the sensor. |
| `UserNotUpright` | The user is not standing or sitting upright. |
| `UserOccludedBody` | Something is blocking the user's body. |
| `UserOccludedFace` | Something is blocking the user's face. |

## KinectUserIdentificationUpdateEventArgs

`class Microsoft.Xbox.Input.KinectUserIdentificationUpdateEventArgs`

Provides data for the [`Kinect.UserIdentificationUpdate`](Microsoft.Xbox.Input.md#kinect) event.

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Input.KinectUserIdentificationQualityFlags QualityFlags { get; }` | Gets the conditions currently preventing identification of the user. |

## KinectUserIdentifiedEventArgs

`class Microsoft.Xbox.Input.KinectUserIdentifiedEventArgs`

Provides data for the [`Kinect.UserIdentified`](Microsoft.Xbox.Input.md#kinect) event. [`KinectUserEventArgs.UserInformation`](Microsoft.Xbox.Input.md#kinectusereventargs) carries both the tracking ID and the player index.

**Properties**

| | |
|---|---|
| `System.Boolean UserReturned { get; }` | Gets whether the identified user is one who was previously engaged and has come back, rather than a newly recognized user. |

## KinectWaveProgressChangedEventArgs

`class Microsoft.Xbox.Input.KinectWaveProgressChangedEventArgs`

Provides data for the [`Kinect.WaveProgressChanged`](Microsoft.Xbox.Input.md#kinect) event.

**Properties**

| | |
|---|---|
| `System.Double Progress { get; }` | Gets how far the engagement wave has progressed, as the value reported by the sensor. Use it to drive an engagement progress indicator. |

## RuneTileActivationEventArgs

`class Microsoft.Xbox.Input.RuneTileActivationEventArgs`

Provides data when a key tile of the on-screen keyboard (`Rune`) control is activated.

**Properties**

| | |
|---|---|
| `System.String RuneString { get; }` | Gets the text of the activated key tile. |

