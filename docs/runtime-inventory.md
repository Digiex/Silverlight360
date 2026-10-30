# Xbox 360 Silverlight runtime inventory

Survey of the 79 Games on Demand packages extracted with
`tools\extract_god_packages.py`. 68 of them are Silverlight apps (they ship
`agcore.dll`). The rest are native apps (Last.fm, ESPN, MLB.TV, Video Kinect
and similar) that only use a few small XEX files. The raw data is in
[app-inventory.json](app-inventory.json) and comes from
`tools\Get-AppInventory.ps1`.

## What every Silverlight app carries

Each app ships the whole platform next to its own code:

| Piece | Files | Role |
|---|---|---|
| XamlHost | `default.xex` | Native host the console launches. Reads `AppManifest.xaml`, loads the CLR and Silverlight, services Xbox calls (gamer services, storage, audio, media). |
| CLR | `xcoreclr.dll` | The .NET runtime. Compiles IL itself when an assembly has no native image. |
| Silverlight core | `agcore.dll`, `npctrl.dll`, `captions.dll` | Rendering, XAML, media, networking (through xam's XHttp). |
| Framework | `mscorlib`, `System*`, `Microsoft.Xbox*`, `Microsoft.Web.Media.SmoothStreaming` | IL assemblies plus `.ni.dll` Xenon native images. |
| Data | fonts, `SystemSounds`, `Config\machine.config`, `nuisp*` speech databases, `NuiIdentity.bin.be`, `Database.xmplr` | Platform resources. |

All framework assemblies report assembly version `2.0.5.0` and the
deployment runtime is `3.0.40818.0` (Silverlight 3), so the real differences
are in build dates and file versions.

## Runtime generations

| CLR build | XamlHost SDK | Apps | Notes |
|---|---|---|---|
| 2011-09-29 | 2.0.20951 | Xbox LIVE Dailymotion | Oldest. |
| 2011-11-09 | 2.0.21076 | 35 apps incl. YouTube, Netflix, Hulu Plus, Disney XD | Launch wave. Framework 3.7.60901 / 4.1.11119. |
| 2012-03-08 | 2.0.21076 | Fox, NOW TV, GameSpot TV, Sony Pictures | |
| 2012-05-09 | 2.0.21173 | CNET, Blip, WSJ, Quickflix, Mustang Customizer, ... | |
| 2012-07-18 | 2.0.21173 - 2.0.21256 | 21 apps incl. Vimeo, GameTrailers, MTV, Plex | Last CLR build (file version 4.0.338.9242). |

Every CLR build decompresses to the same 4.8 MB image; the 1.6 MB vs 4.8 MB
file sizes only reflect XEX compression. None of them ship a separate
`xclrjit.dll`, yet they run IL with no native image (see below).

## Newest and most complete: Plex (Dec 2013)

| Component | Plex | MTV (May 2013) | GameTrailers / Vimeo (Nov 2012) | YouTube (Nov 2011) |
|---|---|---|---|---|
| XamlHost SDK | 2.0.21256 | 2.0.21250 | 2.0.21250 | 2.0.21076 |
| agcore / npctrl | 2013-12-17 | 2013-05-30 | 2012-11-08 | 2011-11-19 |
| CLR / mscorlib | 4.0.338.9242 | 4.0.338.9242 | 4.0.338.9242 | 4.0.337.5446 |
| System.Windows, System.Net | 4.1.31216 | 4.1.30530 | 4.1.21107 | 3.7.60901 |
| Microsoft.Xbox, .Core, .Services, .Storage | 4.1.31216 | 4.1.30530 | 4.1.21107 | 3.7.60901 / 4.1.11119 |

Plex has the newest build of every platform component and all the commonly
used framework assemblies, so the SDK's default runtime profile
(`runtime\plex-2015`) is made from it. Assemblies only a few apps carry:

| Assembly | Where | Notes |
|---|---|---|
| `Microsoft.Advertising` 5.2 | 37 apps | Ad SDK, needs `xadvertising.xex`. |
| `Microsoft.Xbox.Sample.*` | ~38 apps | Microsoft's sample media app framework (UI, player, models). |
| `Microsoft.Xbox.Epg` | Revision3, WWE | Program guide. |
| `Microsoft.Xbox.Extensions` | Netflix | |
| `System.Xml.Serialization` | EPIX | |
| `XBoxLiveLV` | YouTube | LIVE sign-in helpers. |

These are app-level libraries, not part of the platform; a profile can carry
them if an app needs one, but they aren't included by default.

## Native images are optional

The Xbox CLR runs an assembly's IL when its `.ni.dll` is missing. YouTube
with `YouTubeXBoxApplication.ni.dll` removed still runs its own startup code
(the `xbox_startup` ping to youtube.com), and the SDK's sample app runs with
no native image at all. Framework native images are kept because the
platform ships them and they load faster.
