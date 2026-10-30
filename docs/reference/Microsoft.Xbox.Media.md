# Microsoft.Xbox.Media

Assembly: `Microsoft.Xbox.dll`

| Type | Summary |
|---|---|
| [`MediaCapabilities`](#mediacapabilities) | Reads and changes the console's closed-captioning settings and reports optional media components. |
| [`MusicPlayer`](#musicplayer) | Controls background music that the user is playing from the console's music player. |
| [`Sounds`](#sounds) | Plays the standard console navigation sounds for buttons and lets you replace them per element. |
| [`Speakers`](#speakers) | Reports the console's audio output configuration and lets the application force stereo output. |
| [`TimedTextColor`](#timedtextcolor) | Caption colors that the user can choose in the console's closed-captioning settings. |
| [`TimedTextEdgeAttribute`](#timedtextedgeattribute) | The edge effect drawn around caption characters. |
| [`TimedTextFontSize`](#timedtextfontsize) | Caption text size. |
| [`TimedTextFontStyle`](#timedtextfontstyle) | Caption font family style. |
| [`TimedTextLanguage`](#timedtextlanguage) | The caption track the user prefers. |
| [`TimedTextOpacity`](#timedtextopacity) | Opacity of caption text, background or window. |
| [`TimedTextSettings`](#timedtextsettings) | A snapshot of the user's caption appearance preferences. Obtain one from [`MediaCapabilities.GetTimedTextSettings`](Microsoft.Xbox.Media.md#mediacapabilities) and apply it when rendering captions; the properties are read-only. |

## MediaCapabilities

`class Microsoft.Xbox.Media.MediaCapabilities`

Reads and changes the console's closed-captioning settings and reports optional media components.

At design time the properties return `false`, setters do nothing, and [`MediaCapabilities.GetTimedTextSettings`](Microsoft.Xbox.Media.md#mediacapabilities) returns default settings.

**Properties**

| | |
|---|---|
| `static System.Boolean Enable708Captioning { get; set; }` | Gets or sets whether the media pipeline decodes CEA-708 closed captions embedded in the video stream. |
| `static System.Boolean TimedTextEnabled { get; set; }` | Gets or sets the console-wide closed-captioning on/off state. Check it before showing captions so that you honor the user's system setting. |

**Methods**

| | |
|---|---|
| `static Microsoft.Xbox.Media.TimedTextSettings GetTimedTextSettings()` | Gets the user's caption appearance preferences (font, colors, opacity, edge style and language) from the console settings. |
| `static System.Boolean IsOptionalMediaUpdateInstalled()` | Gets whether the console's optional media update is installed. Some codecs and formats are available only after this update. |

## MusicPlayer

`class Microsoft.Xbox.Media.MusicPlayer`

Controls background music that the user is playing from the console's music player.

Pause the user's music before playing your own audio or video, and resume it when you are done. Both methods must be called on the UI thread.

**Methods**

| | |
|---|---|
| `static System.Void Pause()` | Pauses the user's background music so that the application's audio can play. Must be called on the UI thread. |
| `static System.Void Resume()` | Resumes background music that was paused with [`MusicPlayer.Pause`](Microsoft.Xbox.Media.md#musicplayer). Must be called on the UI thread. |

## Sounds

`class Microsoft.Xbox.Media.Sounds`

Plays the standard console navigation sounds for buttons and lets you replace them per element.

Buttons play click, focus and hover sounds automatically. Sounds play only when [`Sounds.IsEnabled`](Microsoft.Xbox.Media.md#sounds) is `true`, which requires the user to have enabled interface sound effects in the console settings. A custom sound is loaded with `Application.GetResourceStream`, so the URI must refer to a WAV resource in the application package; each sound is loaded once and cached.

**Properties**

| | |
|---|---|
| `static System.Boolean IsDashSoundEffectEnabled { get; }` | Gets whether interface sound effects are enabled in the console settings. Read once when the runtime initializes the sounds system. |
| `static System.Boolean IsEnabled { get; set; }` | Gets or sets whether the application plays navigation sounds. |

**Methods**

| | |
|---|---|
| `static System.Uri GetButtonClickUri(System.Windows.UIElement element)` | Gets the click sound for the specified element. |
| `static System.Uri GetButtonFocusUri(System.Windows.UIElement element)` | Gets the focus sound for the specified element. |
| `static System.Uri GetButtonHoverUri(System.Windows.UIElement element)` | Gets the hover sound for the specified element. |
| `static System.Void SetButtonClickUri(System.Windows.UIElement element, System.Uri value)` | Sets the sound played when the specified button is clicked. |
| `static System.Void SetButtonFocusUri(System.Windows.UIElement element, System.Uri value)` | Sets the sound played when the specified button receives focus. |
| `static System.Void SetButtonHoverUri(System.Windows.UIElement element, System.Uri value)` | Sets the sound played when the Kinect hand cursor hovers over the specified button. |

**Fields**

| | |
|---|---|
| `static System.Uri DefaultButtonBackUri` | The relative URI of the built-in "back" navigation sound (`/SystemSounds/DefaultButtonBack.wav`). |
| `static System.Uri DefaultButtonClickUri` | The relative URI of the built-in button click sound (`/SystemSounds/DefaultButtonClick.wav`). |
| `static System.Uri DefaultButtonFocusUri` | The relative URI of the built-in button focus sound (`/SystemSounds/DefaultButtonFocus.wav`). |
| `static System.Uri DefaultButtonHoverUri` | The relative URI of the built-in button hover sound (`/SystemSounds/DefaultButtonHover.wav`). |
| `static System.Windows.DependencyProperty ButtonClickUriProperty` | Identifies the `Sounds.ButtonClickUri` attached property: the sound played when a button is clicked. Defaults to [`Sounds.DefaultButtonClickUri`](Microsoft.Xbox.Media.md#sounds). |
| `static System.Windows.DependencyProperty ButtonFocusUriProperty` | Identifies the `Sounds.ButtonFocusUri` attached property: the sound played when a button receives focus. Defaults to [`Sounds.DefaultButtonFocusUri`](Microsoft.Xbox.Media.md#sounds). |
| `static System.Windows.DependencyProperty ButtonHoverUriProperty` | Identifies the `Sounds.ButtonHoverUri` attached property: the sound played when the Kinect hand cursor hovers over a button. Defaults to [`Sounds.DefaultButtonHoverUri`](Microsoft.Xbox.Media.md#sounds). |

## Speakers

`class Microsoft.Xbox.Media.Speakers`

Reports the console's audio output configuration and lets the application force stereo output.

All members must be used on the UI thread.

**Properties**

| | |
|---|---|
| `static System.Boolean ForceAudioOutputToStereo { get; set; }` | Gets or sets whether audio output is downmixed to stereo even when the console is configured for surround sound. Must be used on the UI thread. |
| `static System.Boolean Stereo { get; }` | Gets whether the console's audio output is configured for stereo (the inverse of [`Speakers.Surround`](Microsoft.Xbox.Media.md#speakers)). Must be read on the UI thread. |
| `static System.Boolean Surround { get; }` | Gets whether the console's audio output is configured for surround sound. Must be read on the UI thread. |

## TimedTextColor

`enum Microsoft.Xbox.Media.TimedTextColor`

Caption colors that the user can choose in the console's closed-captioning settings.

**Values**

| | |
|---|---|
| `Black` | Black. |
| `Blue` | Blue. |
| `Cyan` | Cyan. |
| `Green` | Green. |
| `Magenta` | Magenta. |
| `Red` | Red. |
| `White` | White. |
| `Yellow` | Yellow. |

## TimedTextEdgeAttribute

`enum Microsoft.Xbox.Media.TimedTextEdgeAttribute`

The edge effect drawn around caption characters.

**Values**

| | |
|---|---|
| `Depressed` | Characters appear depressed (engraved). |
| `DropShadow` | Characters have a drop shadow. |
| `None` | No edge effect. |
| `Raised` | Characters appear raised (embossed). |
| `Uniform` | Characters have a uniform outline. |

## TimedTextFontSize

`enum Microsoft.Xbox.Media.TimedTextFontSize`

Caption text size.

**Values**

| | |
|---|---|
| `Large` | Large text. |
| `Medium` | Medium (standard) text. |
| `Small` | Small text. |

## TimedTextFontStyle

`enum Microsoft.Xbox.Media.TimedTextFontStyle`

Caption font family style.

**Values**

| | |
|---|---|
| `Casual` | Casual (informal) font. |
| `Cursive` | Cursive (script) font. |
| `Default` | The renderer's default caption font. |
| `MonoSansSerif` | Monospaced font without serifs. |
| `MonoSerif` | Monospaced font with serifs. |
| `ProportionalSansSerif` | Proportional font without serifs. |
| `ProportionalSerif` | Proportional font with serifs. |
| `SmallCaps` | Small capitals. |

## TimedTextLanguage

`enum Microsoft.Xbox.Media.TimedTextLanguage`

The caption track the user prefers.

**Values**

| | |
|---|---|
| `EasyReader` | Easy-reader captions (simplified text at a reduced reading rate). |
| `English` | English captions. |
| `Spanish` | Spanish captions. |

## TimedTextOpacity

`enum Microsoft.Xbox.Media.TimedTextOpacity`

Opacity of caption text, background or window.

**Values**

| | |
|---|---|
| `Opaque` | Fully opaque. |
| `SemiTransparent` | Partly transparent. |
| `Transparent` | Fully transparent (not drawn). |

## TimedTextSettings

`class Microsoft.Xbox.Media.TimedTextSettings`

A snapshot of the user's caption appearance preferences. Obtain one from [`MediaCapabilities.GetTimedTextSettings`](Microsoft.Xbox.Media.md#mediacapabilities) and apply it when rendering captions; the properties are read-only.

**Constructors**

| | |
|---|---|
| `TimedTextSettings()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Media.TimedTextColor BackgroundColor { get; }` | Gets the color of the box drawn directly behind the caption text. |
| `Microsoft.Xbox.Media.TimedTextColor FontColor { get; }` | Gets the caption text color. The default is [`TimedTextColor.White`](Microsoft.Xbox.Media.md#timedtextcolor). |
| `Microsoft.Xbox.Media.TimedTextColor WindowColor { get; }` | Gets the color of the caption window (the area enclosing all caption lines). |
| `Microsoft.Xbox.Media.TimedTextEdgeAttribute EdgeAttribute { get; }` | Gets the edge effect for caption characters. |
| `Microsoft.Xbox.Media.TimedTextFontSize FontSize { get; }` | Gets the caption text size. |
| `Microsoft.Xbox.Media.TimedTextFontStyle FontStyle { get; }` | Gets the caption font style. |
| `Microsoft.Xbox.Media.TimedTextLanguage PreferredLanguage { get; }` | Gets the caption track the user prefers. |
| `Microsoft.Xbox.Media.TimedTextOpacity BackgroundOpacity { get; }` | Gets the opacity of the box drawn directly behind the caption text. |
| `Microsoft.Xbox.Media.TimedTextOpacity FontOpacity { get; }` | Gets the caption text opacity. |
| `Microsoft.Xbox.Media.TimedTextOpacity WindowOpacity { get; }` | Gets the opacity of the caption window. |
| `System.Boolean UseDefaults { get; }` | Gets whether the user has kept the default caption style. When `true`, render captions in your own default style and ignore the other properties. |

