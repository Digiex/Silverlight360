# Microsoft.Xbox.Media.Mpeg

Assembly: `Microsoft.Xbox.dll`

| Type | Summary |
|---|---|
| [`MpegAudioStreamKey`](#mpegaudiostreamkey) | Keys of the dictionary returned by [`MpegDemultiplexer.GetAudioStreamProperties`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer). |
| [`MpegContainerType`](#mpegcontainertype) | MPEG-2 system container formats. |
| [`MpegDemultiplexer`](#mpegdemultiplexer) | Splits an MPEG-2 transport stream into its elementary audio, video and caption streams using the console's native demultiplexer. Typically used inside a custom `MediaStreamSource` to play transport-stream content. |
| [`MpegElementaryStreamType`](#mpegelementarystreamtype) | The coding of an elementary stream. Most values equal the MPEG-2 transport-stream `stream_type` code. |
| [`MpegFrameType`](#mpegframetype) | How a video sample depends on other frames. |
| [`MpegSampleProperty`](#mpegsampleproperty) | Flags attached to a demultiplexed sample. |
| [`MpegStreamSample`](#mpegstreamsample) | One demultiplexed elementary-stream sample (an access unit) with its timing information. |
| [`MpegStreamsNotInitializedException`](#mpegstreamsnotinitializedexception) | The exception thrown when an [`MpegDemultiplexer`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer) method needs the stream layout before enough input has been processed. Keep calling [`MpegDemultiplexer.ProcessInput`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer) and retry. |
| [`MpegStreamType`](#mpegstreamtype) | Kinds of elementary streams, used to look up stream IDs with [`MpegDemultiplexer.GetStreamIdAtIndex`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer). |
| [`MpegVideoStreamKey`](#mpegvideostreamkey) | Keys of the dictionary returned by [`MpegDemultiplexer.GetVideoStreamProperties`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer). |

## MpegAudioStreamKey

`enum Microsoft.Xbox.Media.Mpeg.MpegAudioStreamKey`

Keys of the dictionary returned by [`MpegDemultiplexer.GetAudioStreamProperties`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer).

**Values**

| | |
|---|---|
| `AudioProfile` | The codec profile, as a decimal number. |
| `Channels` | The number of audio channels. |
| `ChannelsMask` | The speaker-position mask for the channels, as a decimal number. |
| `CodecPrivateData` | Codec initialization data (up to 128 bytes) as an uppercase hexadecimal string, suitable for the `CodecPrivateData` media attribute of a `MediaStreamSource`. |
| `Frequency` | The sampling rate, in Hz. |
| `Language` | The language code declared for the stream. |

## MpegContainerType

`enum Microsoft.Xbox.Media.Mpeg.MpegContainerType`

MPEG-2 system container formats.

**Values**

| | |
|---|---|
| `Program` | MPEG-2 program stream. Not supported; the [`MpegDemultiplexer`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer) constructor throws `NotImplementedException`. |
| `Transport` | MPEG-2 transport stream (188-byte packets). This is the only supported format. |

## MpegDemultiplexer

`class Microsoft.Xbox.Media.Mpeg.MpegDemultiplexer`

Splits an MPEG-2 transport stream into its elementary audio, video and caption streams using the console's native demultiplexer. Typically used inside a custom `MediaStreamSource` to play transport-stream content.

Feed raw transport-stream bytes with [`MpegDemultiplexer.ProcessInput`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer). Once [`MpegDemultiplexer.HasStreamProperties`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer) returns `true`, find streams with [`MpegDemultiplexer.GetStreamIdAtIndex`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer), enable them with [`MpegDemultiplexer.SelectStream`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer), read their formats, and pull samples with [`MpegDemultiplexer.ProduceOutputForStream`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer).

Only [`MpegContainerType.Transport`](Microsoft.Xbox.Media.Mpeg.md#mpegcontainertype) is supported. Dispose the demultiplexer to release the native instance; calls after disposal throw `InvalidOperationException`.

**Constructors**

| | |
|---|---|
| `MpegDemultiplexer()` |  |
| `MpegDemultiplexer(Microsoft.Xbox.Media.Mpeg.MpegContainerType streamType)` | Creates a demultiplexer for the specified container format. |

**Methods**

| | |
|---|---|
| `Microsoft.Xbox.Media.Mpeg.MpegStreamSample ProduceOutputForStream(System.Int32 streamId)` | Retrieves the next complete sample for an elementary stream. |
| `System.Boolean HasStreamProperties()` | Gets whether enough input has been processed for the stream layout and formats to be known. |
| `System.Collections.Generic.Dictionary<Microsoft.Xbox.Media.Mpeg.MpegAudioStreamKey,System.String> GetAudioStreamProperties(System.Int32 streamIndex)` | Gets the format of an audio stream. |
| `System.Collections.Generic.Dictionary<Microsoft.Xbox.Media.Mpeg.MpegVideoStreamKey,System.String> GetVideoStreamProperties(System.Int32 streamIndex)` | Gets the format of a video stream. |
| `System.Int32 GetProgramIdForStreamId(System.Int32 id)` | Gets the transport-stream packet identifier (PID) for a stream ID. |
| `System.Int32 GetStreamIdAtIndex(Microsoft.Xbox.Media.Mpeg.MpegStreamType streamType, System.Int32 index)` | Gets the ID of the n-th elementary stream of a given kind. |
| `System.Int32 GetStreamIdForProgramId(System.Int32 programId)` | Gets the stream ID for a transport-stream packet identifier (PID). |
| `System.Void Dispose()` |  |
| `System.Void Finalize()` | Releases the native demultiplexer if [`MpegDemultiplexer.Dispose`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer) was not called. |
| `System.Void Flush()` | Discards all buffered input and pending samples, for example when playback stops or the source changes. |
| `System.Void PrepareForSeek(System.Int64 seekToTime)` | Prepares the demultiplexer to receive data from a new position in the stream. Call it before feeding input from the seek target. |
| `System.Void ProcessInput(System.Byte[] data, System.Int32 dataLength)` | Passes a block of raw container data to the demultiplexer. |
| `System.Void SelectStream(System.Int32 id, System.Boolean enableStream)` | Enables or disables output for an elementary stream. Only enabled streams produce samples. |

## MpegElementaryStreamType

`enum Microsoft.Xbox.Media.Mpeg.MpegElementaryStreamType`

The coding of an elementary stream. Most values equal the MPEG-2 transport-stream `stream_type` code.

**Values**

| | |
|---|---|
| `AdvancedAudioCoding` | AAC audio with ADTS framing, stream type 15. |
| `AdvancedVideoCodingH264` | H.264/AVC video, stream type 27. |
| `Audio11172` | MPEG-1 audio (ISO/IEC 11172-3), stream type 3. |
| `Audio13818Part3` | MPEG-2 audio (ISO/IEC 13818-3), stream type 4. |
| `AudioAC3` | Dolby Digital (AC-3) audio, code 129. |
| `AudioDts` | DTS audio, code 133. |
| `AudioEnhancedAC3` | Dolby Digital Plus (E-AC-3) audio, code 135. |
| `AudioPulseCodeModulation` | LPCM audio, code 131. |
| `AudioVC9` | Audio stream with private code 136. |
| `AudioWma` | Windows Media Audio, code 230. |
| `AudioWmaPro` | Windows Media Audio Professional, code 231. |
| `AudioWmaWithHeader` | Windows Media Audio with an embedded format header, code 255. |
| `Auxiliary` | MPEG-2 auxiliary data, stream type 14. |
| `ClosedCaption` | Closed-caption data, code 134. |
| `DigitalStorageMedia` | DSM-CC data, stream type 8. |
| `DigitalStorageMediaTypeA` | DSM-CC type A (multiprotocol encapsulation), stream type 10. |
| `DigitalStorageMediaTypeB` | DSM-CC type B (U-N messages), stream type 11. |
| `DigitalStorageMediaTypeC` | DSM-CC type C (stream descriptors), stream type 12. |
| `DigitalStorageMediaTypeD` | DSM-CC type D (sections), stream type 13. |
| `DistributionFormatExchangeProfile` | DFXP (TTML) timed-text data. |
| `EntitlementControlMessage` | Conditional-access entitlement control messages (ECM); not a media stream. |
| `HighEfficiencyAdvancedAudioCoding` | HE-AAC (MPEG-4 audio with LATM framing), stream type 17. |
| `None` | No stream type, or not known. |
| `PacketizedElementaryStreamPrivate` | Private data carried in PES packets, stream type 6. |
| `Video` | MPEG-1 video (ISO/IEC 11172-2), stream type 1. |
| `Video13522Part5` | MHEG data (ISO/IEC 13522-5), stream type 7. |
| `VideoConstrained` | MPEG-2 video (ISO/IEC 13818-2), stream type 2. |
| `VideoMpg2High` | MPEG-2 video (private code 128). Reported as `"MPG2"` by [`MpegDemultiplexer.GetVideoStreamProperties`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer). |
| `VideoVC1` | VC-1 video, code 234. |
| `WindowsMediaVideo9` | Windows Media Video 9, code 235. |

## MpegFrameType

`enum Microsoft.Xbox.Media.Mpeg.MpegFrameType`

How a video sample depends on other frames.

**Values**

| | |
|---|---|
| `Depend` | A predicted frame (P-frame) that depends on an earlier frame. |
| `DependAndDepend` | A bidirectionally predicted frame (B-frame) that depends on earlier and later frames. |
| `NoDepend` | An intra-coded frame (I-frame) that does not depend on other frames; a valid seek or start point. |
| `Unknown` | The frame type is not known (for example, for audio samples). |

## MpegSampleProperty

`enum Microsoft.Xbox.Media.Mpeg.MpegSampleProperty`

Flags attached to a demultiplexed sample.

**Values**

| | |
|---|---|
| `Discontinuity` | The sample follows a break in the stream (for example, after a seek or lost data); timestamps may jump. |
| `None` | No special condition. |

## MpegStreamSample

`class Microsoft.Xbox.Media.Mpeg.MpegStreamSample`

One demultiplexed elementary-stream sample (an access unit) with its timing information.

**Constructors**

| | |
|---|---|
| `MpegStreamSample()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Media.Mpeg.MpegElementaryStreamType ElementaryStreamType { get; }` | Gets the coding of the stream the sample came from. |
| `Microsoft.Xbox.Media.Mpeg.MpegFrameType FrameType { get; }` | Gets how the sample depends on other frames. Use it to find key frames. |
| `Microsoft.Xbox.Media.Mpeg.MpegSampleProperty SampleAttributes { get; }` | Gets flags for the sample, such as a discontinuity. |
| `System.Int32 SampleDataSize { get; }` | Gets the number of bytes of sample data. |
| `System.Int32 SampleDuration { get; }` | Gets the duration of the sample, as reported by the native demultiplexer. |
| `System.Int64 PresentationTime { get; }` | Gets the presentation timestamp (PTS) of the sample, as reported by the native demultiplexer. |
| `System.Int64 StreamTime { get; }` | Gets the decoding timestamp (DTS) of the sample, as reported by the native demultiplexer. |

**Methods**

| | |
|---|---|
| `System.Byte[] GetBuffer()` | Gets the sample data. |
| `System.Void Dispose()` |  |

## MpegStreamsNotInitializedException

`class Microsoft.Xbox.Media.Mpeg.MpegStreamsNotInitializedException`

The exception thrown when an [`MpegDemultiplexer`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer) method needs the stream layout before enough input has been processed. Keep calling [`MpegDemultiplexer.ProcessInput`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer) and retry.

**Constructors**

| | |
|---|---|
| `MpegStreamsNotInitializedException()` |  |
| `MpegStreamsNotInitializedException(System.String message)` | Initializes a new instance with the specified error message. |
| `MpegStreamsNotInitializedException(System.String message, System.Exception innerException)` | Initializes a new instance with the specified error message and inner exception. |

## MpegStreamType

`enum Microsoft.Xbox.Media.Mpeg.MpegStreamType`

Kinds of elementary streams, used to look up stream IDs with [`MpegDemultiplexer.GetStreamIdAtIndex`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer).

**Values**

| | |
|---|---|
| `Audio` | An audio stream. |
| `ClosedCaption` | A closed-caption stream. |
| `PlayReadyProtected` | A stream protected with PlayReady encryption. |
| `Unknown` | Any other or unrecognized stream. |
| `Video` | A video stream. |

## MpegVideoStreamKey

`enum Microsoft.Xbox.Media.Mpeg.MpegVideoStreamKey`

Keys of the dictionary returned by [`MpegDemultiplexer.GetVideoStreamProperties`](Microsoft.Xbox.Media.Mpeg.md#mpegdemultiplexer).

**Values**

| | |
|---|---|
| `Codec` | The codec: `"H264"` or `"MPG2"`. |
| `Height` | The frame height, in pixels. |
| `Width` | The frame width, in pixels. |

