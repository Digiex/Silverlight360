# Status under xenia

Silverlight apps need [xenia-edge](https://github.com/has207/xenia-edge) plus three pull requests that aren't merged yet:

| Pull request | What it adds |
|---|---|
| [#325](https://github.com/has207/xenia-edge/pull/325) | What apps need to start: locale, guest timers and mutants, `XamContentOpenFile`. |
| [#326](https://github.com/has207/xenia-edge/pull/326) | XHttp over the host's HTTP client: every `WebClient` and `HttpWebRequest`. |
| [#327](https://github.com/has207/xenia-edge/pull/327) | The exports apps call once running, and a second commit that fixes XNA storage containers, the cache drive and `MediaTransport` commands. |

The samples were tested on a build of xenia-edge with all three merged.

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
| **Media playback** | WMA plays. WMV and MP3 play with a xenia-edge build that loads the console's extra AV codec module (`dash.ExtraAVCodecs.xex` in xenia's `system\` folder); that loader is pull request [#329](https://github.com/has207/xenia-edge/pull/329), not merged yet. MP4 also needs the Optional Media Update and plays with a garbled picture (unsupported `k_32` texture format). See [Media](media.md). |
| **SmartGlass keyboard** | Opening a `Rune` calls `XamLrcKeyboardRegister` and related functions, which xenia doesn't have. The Rune still works with the controller. |
| **System screens** | Most Guide screens (friends, gamer card, ...) aren't implemented in xenia. |
| **Xbox LIVE and XAuth** | No tokens, so sign-in to partner services, Marketplace and social networks fails. |
| **Kinect and speech** | xenia has no Kinect. |

## The donor title

A package runs as the donor app (the window title shows `574407D1 Plex` with the default profile), with the donor's title ID and save area. xenia applies the donor's installed title update to the runtime's native images if one is installed; that's harmless, and the log mentions it.
