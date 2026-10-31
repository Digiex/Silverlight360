# Status under xenia

Silverlight apps run on a current build of [xenia-edge](https://github.com/has207/xenia-edge). What they need is in its `edge` branch since 31 October 2026:

| Commit | What it adds |
|---|---|
| [Add what Silverlight apps need to start](https://github.com/has207/xenia-edge/commit/1a2b1654444d507a1f278ae5f22de401e6e0f639) | Locale, guest timers and mutants, `XamContentOpenFile`. |
| [Send XHttp requests through the host's HTTP client](https://github.com/has207/xenia-edge/commit/d4d6c543b8cd800af3ea32e5b774018bd3352e97) | Every `WebClient` and `HttpWebRequest`. |
| [Add the exports Silverlight apps call](https://github.com/has207/xenia-edge/commit/4fcace3702527afb610f53ae389f890d04992ff4) | The exports apps call once running, with XNA storage containers and the cache drive. |
| [Load the extra AV codec modules from the sysext folder](https://github.com/has207/xenia-edge/commit/6196811b762cd7604d9ec79c003e68f63b05183a) | The console's extra AV codecs, for WMV and MP3 (see [Media](media.md)). |

An older build needs those commits.

## Works

| | Tested with |
|---|---|
| XAML UI, layout, styles, templates, visual states | every sample |
| Controller input: buttons, sticks, triggers | GamepadInput |
| Focus, A clicking buttons, `DirectionalFocus` | FocusNavigation |
| `Pivot` with grid navigation, `Rune`, `Legend` | XboxControls |
| `XboxApplicationFrame`, pages, transitions, back navigation | PageNavigation |
| HTTP GET and POST, XML, images from the network | HelloXbox, CatalogBrowser |
| Signed-in gamer, gamertag | CatalogBrowser |
| Storage containers (encrypted files) | PlatformCalls, CatalogBrowser |
| Cache container | PlatformCalls, CatalogBrowser |
| `MediaTransport` and its transport bar | PlatformCalls, MediaPlayer |
| `DllImport` into xam and the kernel | NativeProbe |

## Doesn't work yet

| | |
|---|---|
| **Media playback** | WMA plays. WMV and MP3 play with the console's extra AV codec modules (`dash.ExtraAVCodecs.xex` and `dash.ExtraAVCodecs2.xex`) in the `sysext\` folder of xenia's storage root. MP4 also needs the Optional Media Update and plays with a garbled picture (unsupported `k_32` texture format). See [Media](media.md). |
| **SmartGlass keyboard** | Opening a `Rune` calls `XamLrcKeyboardRegister` and related functions, which xenia doesn't have. The Rune still works with the controller. |
| **System screens** | Most Guide screens (friends, gamer card, ...) aren't implemented in xenia. |
| **Xbox LIVE and XAuth** | No tokens, so sign-in to partner services, Marketplace and social networks fails. |
| **Kinect and speech** | xenia has no Kinect. |

## The donor title

A package runs as the donor app (the window title shows `574407D1 Plex` with the default profile), with the donor's title ID and save area. xenia applies the donor's installed title update to the runtime's native images if one is installed; that's harmless, and the log mentions it.
