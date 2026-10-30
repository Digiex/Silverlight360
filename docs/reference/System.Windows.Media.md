# System.Windows.Media

Assembly: `System.Windows.dll`

| Type | Summary |
|---|---|
| [`ContentIdentifierType`](#contentidentifiertype) | Specifies how the content identifier passed to [`PRNDReceiver.AcquireLicenseAsync`](System.Windows.Media.md#prndreceiver) is interpreted. |
| [`DrmSetupDecryptorCompletedEventArgs`](#drmsetupdecryptorcompletedeventargs) | Provides data for the `MediaStreamSource.DrmSetupDecryptorCompleted` event. |
| [`EngageCgmsaCompletedEventArgs`](#engagecgmsacompletedeventargs) | Provides data for the `VideoOutputConnector.EngageCgmsaCompleted` event. |
| [`EngageHdcpCompletedEventArgs`](#engagehdcpcompletedeventargs) | Provides data for the `VideoOutputConnector.EngageHdcpCompleted` event. |
| [`EngageOutputProtectionCompletedEventArgs`](#engageoutputprotectioncompletedeventargs) | Base class for the data of the output-protection completion events of `VideoOutputConnector`. |
| [`MediaCommand`](#mediacommand) | Identifies a media transport or navigation command, such as those sent by a media remote. |
| [`MediaCommandEventArgs`](#mediacommandeventargs) | Provides data for the `UIElement.MediaCommand` event. |
| [`MediaCommandEventHandler`](#mediacommandeventhandler) | Represents the method that handles the `UIElement.MediaCommand` event. |
| [`PRNDException`](#prndexception) | The exception reported when a PlayReady-ND receiver operation fails. |
| [`PRNDReceiver`](#prndreceiver) | A PlayReady-ND (network device) receiver: obtains licenses for protected content from a PlayReady-ND transmitter on the local network. |
| [`PRNDReceiverAcquireLicenseCompletedEventArgs`](#prndreceiveracquirelicensecompletedeventargs) | Provides data for the [`PRNDReceiver.PRNDReceiverAcquireLicenseCompleted`](System.Windows.Media.md#prndreceiver) event. |
| [`PRNDReceiverOpenCompletedEventArgs`](#prndreceiveropencompletedeventargs) | Provides data for the [`PRNDReceiver.PRNDReceiverOpenCompleted`](System.Windows.Media.md#prndreceiver) event. |
| [`PRNDReceiverPerformHandshakeCompletedEventArgs`](#prndreceiverperformhandshakecompletedeventargs) | Provides data for the [`PRNDReceiver.PRNDReceiverPerformHandshakeCompleted`](System.Windows.Media.md#prndreceiver) event. |

## ContentIdentifierType

`enum System.Windows.Media.ContentIdentifierType`

Specifies how the content identifier passed to [`PRNDReceiver.AcquireLicenseAsync`](System.Windows.Media.md#prndreceiver) is interpreted.

**Values**

| | |
|---|---|
| `Custom` | The identifier is a custom value understood by the transmitter. |
| `KeyId` | The identifier is the content key ID. |

## DrmSetupDecryptorCompletedEventArgs

`class System.Windows.Media.DrmSetupDecryptorCompletedEventArgs`

Provides data for the `MediaStreamSource.DrmSetupDecryptorCompleted` event.

Check `AsyncCompletedEventArgs.Error` first; it holds a DRM exception when setup failed. `AsyncCompletedEventArgs.Cancelled` is true when the operation was aborted.

**Properties**

| | |
|---|---|
| `System.Guid KeyID { get; }` | Gets the key ID of the decryptor that was set up. |

## EngageCgmsaCompletedEventArgs

`class System.Windows.Media.EngageCgmsaCompletedEventArgs`

Provides data for the `VideoOutputConnector.EngageCgmsaCompleted` event.

**Constructors**

| | |
|---|---|
| `EngageCgmsaCompletedEventArgs(System.Exception error, System.Boolean cancelled, System.Object userState)` | Initializes a new instance of the [`EngageCgmsaCompletedEventArgs`](System.Windows.Media.md#engagecgmsacompletedeventargs) class. |

## EngageHdcpCompletedEventArgs

`class System.Windows.Media.EngageHdcpCompletedEventArgs`

Provides data for the `VideoOutputConnector.EngageHdcpCompleted` event.

## EngageOutputProtectionCompletedEventArgs

`class System.Windows.Media.EngageOutputProtectionCompletedEventArgs`

Base class for the data of the output-protection completion events of `VideoOutputConnector`.

**Constructors**

| | |
|---|---|
| `EngageOutputProtectionCompletedEventArgs(System.Exception error, System.Boolean cancelled, System.Object userState)` | Initializes a new instance of the [`EngageOutputProtectionCompletedEventArgs`](System.Windows.Media.md#engageoutputprotectioncompletedeventargs) class. |

## MediaCommand

`enum System.Windows.Media.MediaCommand`

Identifies a media transport or navigation command, such as those sent by a media remote.

**Values**

| | |
|---|---|
| `ChannelDown` | The Channel Down key. |
| `ChannelUp` | The Channel Up key. |
| `DecreaseVolume` | The Volume Down key. |
| `Display` | The Display key, typically used to show or hide on-screen playback information. |
| `FastForward` | Fast forward. |
| `Guide` | The Guide key of a media remote. |
| `IncreaseVolume` | The Volume Up key. |
| `Info` | The Info key, typically used to show details about the current item. |
| `Menu` | The Menu key, typically used to open a menu or options for the current content. |
| `MuteVolume` | The Mute key. |
| `NextTrack` | Skip to the next track, chapter or item. |
| `Pause` | Pause playback. |
| `Play` | Start or resume playback. |
| `PreviousTrack` | Go back to the previous track, chapter or item. |
| `Record` | The Record key. |
| `Rewind` | Rewind. |
| `Stop` | Stop playback. |
| `TV` | The TV key of a media remote. |
| `Title` | The Title key, typically used to go to the title or top menu of the content. |
| `TogglePlayPause` | Toggle between playing and paused (a single Play/Pause key). A focused `Button` also treats this command as a press. |

## MediaCommandEventArgs

`class System.Windows.Media.MediaCommandEventArgs`

Provides data for the `UIElement.MediaCommand` event.

**Properties**

| | |
|---|---|
| `System.Boolean Handled { get; set; }` | Gets or sets a value that marks the routed event as handled. |
| `System.Windows.Media.MediaCommand MediaCommand { get; set; }` | Gets or sets the command that arrived. |

## MediaCommandEventHandler

`delegate System.Void System.Windows.Media.MediaCommandEventHandler(System.Object, System.Windows.Media.MediaCommandEventArgs)`

Represents the method that handles the `UIElement.MediaCommand` event.

## PRNDException

`class System.Windows.Media.PRNDException`

The exception reported when a PlayReady-ND receiver operation fails.

Delivered through `AsyncCompletedEventArgs.Error` of the [`PRNDReceiver`](System.Windows.Media.md#prndreceiver) completion events.

**Properties**

| | |
|---|---|
| `System.Int32 RawErrorCode { get; }` | Gets the native error code (HRESULT) of the failure. |

## PRNDReceiver

`class System.Windows.Media.PRNDReceiver`

A PlayReady-ND (network device) receiver: obtains licenses for protected content from a PlayReady-ND transmitter on the local network.

Call [`PRNDReceiver.OpenAsync`](System.Windows.Media.md#prndreceiver), then [`PRNDReceiver.PerformHandshakeAsync`](System.Windows.Media.md#prndreceiver), then [`PRNDReceiver.AcquireLicenseAsync`](System.Windows.Media.md#prndreceiver) for each item; wait for each step's completion event before the next. Pass [`PRNDReceiver.SessionId`](System.Windows.Media.md#prndreceiver) to the media pipeline with `MediaSourceAttributesKeys.PRNDSessionID`.

Exceptions thrown by your event handlers are swallowed.

**Constructors**

| | |
|---|---|
| `PRNDReceiver()` |  |

**Properties**

| | |
|---|---|
| `System.Byte[] SessionId { get; }` | Gets the identifier of the receiver's current session. |
| `System.Int32 HandshakeAlertInterval { get; set; }` | Gets or sets how long after a successful handshake [`PRNDReceiver.PRNDReceiverHandshakeAlert`](System.Windows.Media.md#prndreceiver) is raised, in minutes. Set it before the handshake; the timer is started when the handshake completes. |

**Methods**

| | |
|---|---|
| `System.Void AcquireLicenseAsync(System.Windows.Media.ContentIdentifierType contentIdentifierType, System.Byte[] contentIdentifier, System.Byte[] customDataTypeId, System.Byte[] customData)` | Starts acquiring a license for one content item from the transmitter. Completion is reported by [`PRNDReceiver.PRNDReceiverAcquireLicenseCompleted`](System.Windows.Media.md#prndreceiver). |
| `System.Void Close()` | Closes the receiver and cancels any pending handshake alert. The receiver can then be opened again. |
| `System.Void OpenAsync(System.Uri transmitterUri)` | Starts connecting to a PlayReady-ND transmitter. Completion is reported by [`PRNDReceiver.PRNDReceiverOpenCompleted`](System.Windows.Media.md#prndreceiver). |
| `System.Void PerformHandshakeAsync(System.Byte[] customDataTypeId, System.Byte[] customData)` | Starts the registration handshake with the transmitter, optionally sending custom data. Completion is reported by [`PRNDReceiver.PRNDReceiverPerformHandshakeCompleted`](System.Windows.Media.md#prndreceiver). The handshake may be repeated on an open receiver. |

**Events**

| | |
|---|---|
| `event System.EventHandler PRNDReceiverHandshakeAlert` | Occurs once, [`PRNDReceiver.HandshakeAlertInterval`](System.Windows.Media.md#prndreceiver) minutes after a successful handshake, to signal that the handshake (proximity check) should be repeated. Raised on the UI thread by a dispatcher timer. The event arguments are null. [`PRNDReceiver.Close`](System.Windows.Media.md#prndreceiver) cancels the pending alert. |
| `event System.EventHandler<System.Windows.Media.PRNDReceiverAcquireLicenseCompletedEventArgs> PRNDReceiverAcquireLicenseCompleted` | Occurs when [`PRNDReceiver.AcquireLicenseAsync`](System.Windows.Media.md#prndreceiver) finishes. |
| `event System.EventHandler<System.Windows.Media.PRNDReceiverOpenCompletedEventArgs> PRNDReceiverOpenCompleted` | Occurs when [`PRNDReceiver.OpenAsync`](System.Windows.Media.md#prndreceiver) finishes. If `AsyncCompletedEventArgs.Error` is null the receiver is open and ready for a handshake; otherwise it holds a [`PRNDException`](System.Windows.Media.md#prndexception). |
| `event System.EventHandler<System.Windows.Media.PRNDReceiverPerformHandshakeCompletedEventArgs> PRNDReceiverPerformHandshakeCompleted` | Occurs when [`PRNDReceiver.PerformHandshakeAsync`](System.Windows.Media.md#prndreceiver) finishes. On success the receiver can acquire licenses, and the timer for [`PRNDReceiver.PRNDReceiverHandshakeAlert`](System.Windows.Media.md#prndreceiver) starts. |

**Fields**

| | |
|---|---|
| `const System.Int32 IdByteCount` | The length, in bytes, of session IDs and custom data type IDs (16). This field is constant. |
| `const System.Int32 MaxHandshakeAlertInterval` | The largest value accepted by [`PRNDReceiver.HandshakeAlertInterval`](System.Windows.Media.md#prndreceiver): 2880 minutes (48 hours). This field is constant. |

## PRNDReceiverAcquireLicenseCompletedEventArgs

`class System.Windows.Media.PRNDReceiverAcquireLicenseCompletedEventArgs`

Provides data for the [`PRNDReceiver.PRNDReceiverAcquireLicenseCompleted`](System.Windows.Media.md#prndreceiver) event.

**Properties**

| | |
|---|---|
| `System.Byte[] CustomData { get; }` | Gets the custom data the transmitter returned with the license. |
| `System.Byte[] CustomDataTypeId { get; }` | Gets the type ID of the custom data the transmitter returned with the license. |

## PRNDReceiverOpenCompletedEventArgs

`class System.Windows.Media.PRNDReceiverOpenCompletedEventArgs`

Provides data for the [`PRNDReceiver.PRNDReceiverOpenCompleted`](System.Windows.Media.md#prndreceiver) event.

## PRNDReceiverPerformHandshakeCompletedEventArgs

`class System.Windows.Media.PRNDReceiverPerformHandshakeCompletedEventArgs`

Provides data for the [`PRNDReceiver.PRNDReceiverPerformHandshakeCompleted`](System.Windows.Media.md#prndreceiver) event.

**Properties**

| | |
|---|---|
| `System.Byte[] CustomData { get; }` | Gets the custom data the transmitter returned with the handshake. |
| `System.Byte[] CustomDataTypeId { get; }` | Gets the type ID of the custom data the transmitter returned with the handshake. |

