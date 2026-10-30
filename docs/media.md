# Media

> Under xenia-edge, media plays once the console's codec modules are installed. Everything around the player works: `MediaTransport`, its transport bar and its commands.
>
> - **WMA** plays as is: its decoder is built into the runtime.
> - **WMV**, **MP3** and **MP4** need the console's extra AV codecs. The runtime gets their decoders from `dash.ExtraAVCodecs.xex`, a module of the console's system software that it loads through xam (`XamLoadExtraAVCodecs`). Without it, playback fails with `MediaFailed` "4001 An error has occured" right after `Opening`. Despite that code's name (`AG_E_NETWORK_ERROR`), the network isn't involved: the real error is `C00DF804` for WMV (no video decoder) and `8007000E` for MP3. Loading the module needs a xenia-edge build with the codec loader, pull request [#329](https://github.com/has207/xenia-edge/pull/329), which isn't merged yet; with it, copy `dash.ExtraAVCodecs.xex` and `dash.ExtraAVCodecs2.xex` from your console's system files to xenia's `system\` folder (next to `content\`). WMV (VC-1) and MP3 then play.
> - **MP4 (H.264/AAC)** also needs the console's Optional Media Update, a content package (machine-wide content of type 2 for title FFFE07DF) that isn't part of the system update. Without it, the runtime shows the "media update required" screen when playback starts, and that can't complete without Xbox LIVE. Install it by copying the package file to xenia's `content\0000000000000000\FFFE07DF\00000002\`. With both, MP4 plays, but the picture is wrong: green blocks over the right base colour, because xenia doesn't support a texture format (`k_32`) the H.264 output uses. The first MP4 playback also waits for xenia to compile some very large shaders.
>
> To test without a server, put media files in `samples\apps\MediaPlayer\Media` and rebuild; the sample lists them as "(in the package)" and plays them from a URI relative to the XAP.
>
> The rest of this page is from the platform's code and the shipped apps.

## MediaElement

The standard Silverlight `MediaElement`, playing WMV, WMA, MP4 (H.264/AAC) and MP3 over progressive download, plus Smooth Streaming through `SmoothStreamingMediaElement`. The Xbox version adds DRM and output-protection members (see the [reference](reference/System.Windows.Controls.md)).

## MediaTransport

`MediaTransport` (`Microsoft.Xbox.Controls`) is the playback chrome every video app uses. It provides:

- the transport bar (play/pause, skip, rewind, fast forward, stop, info, display mode),
- the timeline, status text and busy indicator,
- controller and remote handling.

Put the player inside it:

```xml
<xbox:MediaTransport x:Name="Transport" Back="Transport_Back">
  <MediaElement x:Name="Player" AutoPlay="True" />
</xbox:MediaTransport>
```

```csharp
protected override void OnNavigatedTo(NavigationEventArgs e)
{
    base.OnNavigatedTo(e);
    Transport.MediaAssetId = "episode-42";          // required, see below
    Player.Source = new Uri(url, UriKind.Absolute);
    Dispatcher.BeginInvoke(delegate { Transport.Focus(); });
}

private void Transport_Back(object sender, EventArgs e)
{
    NavigationService.GoBack();
}
```

**What it handles itself:**

- **Controller:** A, Start or the D-pad shows the transport bar. The triggers rewind and fast forward. The shoulder buttons skip between chapter markers. B hides whatever is showing and raises `Back` when nothing is left.
- **Remote commands:** they go through `ExecuteMediaCommand`.
- **Fast forward and rewind:** they're emulated. The player pauses and the timeline previews ahead, then seeks when you resume.

**Required:** set `MediaAssetId` before any command. Each command is reported with it (for SmartGlass and usage statistics) and throws `InvalidOperationException` without it.

**Side effects while it's loaded:**

- **Media app status:** it tells the console a video is playing, so the dashboard treats the app as a media app.
- **SmartGlass:** it reports position and state for companion devices on every command and state change.
- **Screen saver:** it suppresses the screen saver during playback. This needs GamerServices, so use it inside `XboxApplicationFrame`.

`samples\apps\MediaPlayer` plays files from the test server's media folder.

## Smooth Streaming

`SmoothStreamingMediaElement` (`Microsoft.Web.Media.SmoothStreaming`) plays adaptive streams:

- **Source:** set `SmoothStreamingSource` to a `.../Manifest` URL. Setting `Source` (progressive) throws `NotSupportedException` on Xbox.
- **Set first:** set `SmoothStreamingPlaybackMode`, `SmoothStreamingCache`, `CookieContainer` and `LivePlaybackStartPosition` before the source.
- **Events:** `ManifestReady` comes before `MediaOpened`. Restrict tracks with `StreamInfo.RestrictTracks` only in `ManifestReady`; `SelectTracks` works at any time.
- **Errors:** after `SmoothStreamingErrorOccurred` the source is shut down; set it again to retry.
- **Trick play:** `SetPlaybackRate` only takes the values in `SupportedPlaybackRates`.

Wrap it for `MediaTransport` with `SmoothStreamingMediaElementAdapter`.

## DRM

PlayReady-protected content goes through `LicenseAcquirer` and `MediaElement.LicenseAcquirer`, as in Silverlight. `VideoOutputConnector.EngageHdcpAsync` and `EngageCgmsaAsync` turn on output protection before protected playback. None of this has been tested.
