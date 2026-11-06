# Assemblies in other donor apps

The default runtime profile is made from Plex v0.0.0.7 ([Runtime inventory](runtime-inventory.md)). This page lists every assembly the other extracted apps carry that Plex doesn't, and the apps that carry each. An app that needs one of them can take it from one of those apps. They are Microsoft's or the app publisher's files, so the same rules apply as for the donor's: keep them local.

The list was made with `tools\Get-DonorAssemblies.ps1` from the 78 other app folders. The raw data is in [donor-assemblies.json](donor-assemblies.json): each assembly's name, assembly and file versions, public key token, whether it is a reference assembly only, and its apps. It counts IL assemblies (a `.dll` with metadata) and native images without IL. Assemblies that Plex has a file of, in either form, are left out, even where another app has a newer build.

## Two names that are no assembly of their own

`System.Xml.Serialization` and `Microsoft.Xbox.RuntimeHelpers` are listed in the `AppManifest.xaml` of 45 apps (IGN, Crackle, Netflix, Wall Street Journal and others), and apps' code references them: Crackle's `Cypress.Core.XBox` uses `XmlSerializer`, and IGN, Netflix and `Microsoft.Advertising` use `Microsoft.Xbox.RuntimeHelpers`. Yet no package has either file except EPIX. This is not an extraction error: a raw scan of IGN's package's directory lists the same 119 files as `tools\Expand-GodPackage.ps1` extracts.

EPIX's copies are reference assemblies, with no code to run. In `Microsoft.Xbox.RuntimeHelpers` the `ALU`, `FPU` and `Cache` methods (`fsqrt`, `cntlzw`, `dcbt` and others) are InternalCall and the rest have 2-byte stub bodies. In `System.Xml.Serialization` every body is a stub too. The platform has the real types: every app's `mscorlib.dll` defines `Microsoft.Xbox.RuntimeHelpers`, `FPU`, `ALU` and `Cache`, and its `System.Xml.dll` defines `System.Xml.Serialization.XmlSerializer` and the attributes. So an app compiled against these names runs on the platform's types, and a native image compiler needs EPIX's reference assemblies (or the SDK's) only to resolve the names.

<!-- tables: tools\Get-DonorAssemblies.ps1 -->

## Platform assemblies

| Assembly | Version | Key token | Apps | Notes |
|---|---|---|---|---|
| `Microsoft.Xbox.Epg` | 2.0.5.0 (file 4.1.21107.0) | `7cec85d7bea7798e` | Revision3, WWE PPV Wrestlemania | Program guide. |
| `Microsoft.Xbox.Extensions` | 4.0.0.0 (file 4.1.10828.0) | `842cf8be1de50553` | Netflix |  |
| `Microsoft.Xbox.RuntimeHelpers` | 2.0.5.0 (file 4.0.337.5374 built by: main) | `7cec85d7bea7798e` | EPIX | Reference assembly only (InternalCall intrinsics and stub bodies). The types are in every app's `mscorlib.dll`. |
| `System.Xml.Serialization` | 2.0.5.0 (file 4.0.337.5374 built by: main) | `7cec85d7bea7798e` | EPIX | Reference assembly only (no code). The code is in every app's `System.Xml.dll`. |

## Microsoft's libraries

| Assembly | Newest build | Apps |
|---|---|---|
| `Microsoft.Advertising` | 5.2.0.0 (file 5.2.1406.0) in Amazon Instant Video, Manga Entertainment; 5 older builds | Amazon Instant Video, Aol On, Blip, CNET, Crackle, Exp Sony Pictures, Fox Broadcast, GameSpot TV, GameTrailers, HBO GO, IGN, IndieFlix, Manga Entertainment, Maxim, MSN Video, MTV, MUZU.TV, Napster, Neon Alley, NOW TV, Pizza Hut, Real Sports, Revision3, Rhapsody, Screenrush, Slacker Radio, Syfy, Telemundo, The Next Level, TMZ, UVideos, Vimeo, Wall Street Journal, WWE PPV Wrestlemania, Xbox LIVE Dailymotion, Xbox Tournaments, XFINITY (37) |
| `Microsoft.WebAnalytics` | 2.3.6.0 (file 1.0.0.0) in IGN; 1 older build | IGN, XFINITY (2) |
| `Microsoft.WebAnalytics.Behaviors` | 2.3.2.0 (file 1.0.0.0) | IGN, XFINITY (2) |
| `Microsoft.Xbox.Sample.Common` | 1.1.1206.0 (file 1.01.1206.00) in MSN Video; 2 older builds | 4oD, ABC iview, Absolute Radio, Amazon Instant Video, Antena 3 Modo Salón, Blip, Canal+, CinemaNow, CNET, Crackle, Crunchyroll, Disney XD, EPIX, Fox Broadcast, GameSpot TV, GameTrailers, HBO GO, IndieFlix, Maxim, MSN Video, MTV, Mustang Customizer, MUZU.TV, Neon Alley, NOW TV, Real Sports, Redbox Instant, Rogers On Demand, Slacker Radio, Syfy, The CW Network, Verizon FiOS TV, Vimeo, VUDU Movies, Wall Street Journal, Xbox Tournaments, XFINITY (37) |
| `Microsoft.Xbox.Sample.Controls` | 1.1.1206.0 (file 1.01.1206.00) in MSN Video; 2 older builds | 4oD, ABC iview, Absolute Radio, Amazon Instant Video, Antena 3 Modo Salón, Blip, Canal+, CinemaNow, CNET, Crackle, Crunchyroll, Disney XD, EPIX, Fox Broadcast, GameSpot TV, GameTrailers, HBO GO, IndieFlix, Maxim, MSN Video, MTV, Mustang Customizer, MUZU.TV, Neon Alley, NOW TV, Paramount Movies, Real Sports, Redbox Instant, Rogers On Demand, Slacker Radio, Syfy, The CW Network, Verizon FiOS TV, Vimeo, VUDU Movies, Wall Street Journal, Xbox Tournaments, XFINITY (38) |
| `Microsoft.Xbox.Sample.Models` | 1.1.1206.0 (file 1.01.1206.00) in MSN Video; 2 older builds | 4oD, ABC iview, Absolute Radio, Amazon Instant Video, Antena 3 Modo Salón, Blip, Canal+, CinemaNow, CNET, Crackle, Disney XD, EPIX, Fox Broadcast, GameSpot TV, GameTrailers, HBO GO, IndieFlix, Maxim, MSN Video, MTV, Mustang Customizer, MUZU.TV, Neon Alley, NOW TV, Paramount Movies, Real Sports, Redbox Instant, Rogers On Demand, Slacker Radio, Syfy, The CW Network, UVideos, Verizon FiOS TV, Vimeo, VUDU Movies, Wall Street Journal, Xbox Tournaments, XFINITY (38) |
| `Microsoft.Xbox.Sample.PlayerUI` | 1.0.0.0 | Blip, GameTrailers, Maxim, MTV, Neon Alley, The CW Network (6) |
| `Microsoft.Xbox.Sample.UI` | 1.1.0.0 (file 1.1.0) in Screenrush; 3 older builds | 4oD, ABC iview, Absolute Radio, Amazon Instant Video, Antena 3 Modo Salón, Blip, Canal+, CinemaNow, CNET, Crackle, Disney XD, EPIX, Fox Broadcast, GameSpot TV, GameTrailers, HBO GO, IndieFlix, Maxim, MSN Video, MTV, MUZU.TV, Neon Alley, NOW TV, Paramount Movies, Real Sports, Redbox Instant, Rogers On Demand, Screenrush, Slacker Radio, Syfy, Verizon FiOS TV, Vimeo, VUDU Movies, Wall Street Journal, Xbox Tournaments, XFINITY (36) |
| `Services` | 1.1.1206.0 (file 1.01.1206.00) in MSN Video; 2 older builds | 4oD, ABC iview, Absolute Radio, Amazon Instant Video, Antena 3 Modo Salón, Blip, Canal+, CinemaNow, CNET, Crackle, Crunchyroll, Disney XD, EPIX, Fox Broadcast, GameSpot TV, GameTrailers, IndieFlix, Maxim, MSN Video, MTV, Mustang Customizer, MUZU.TV, Neon Alley, NOW TV, Paramount Movies, Real Sports, Redbox Instant, Revision3, Rogers On Demand, Slacker Radio, Syfy, The CW Network, UVideos, Verizon FiOS TV, Vimeo, VUDU Movies, Wall Street Journal, WWE PPV Wrestlemania, Xbox Tournaments, XFINITY (40) |
| `Video.Services.Cms` | 1.0.54.8 in 4oD; 1 older build | 4oD, Antena 3 Modo Salón, Blip, Canal+, CinemaNow, CNET, IndieFlix, Neon Alley, Real Sports, Redbox Instant, Revision3, Slacker Radio, The CW Network, UVideos, Verizon FiOS TV, Wall Street Journal, WWE PPV Wrestlemania, Xbox Tournaments, XFINITY (19) |
| `Video.Services.Sample` | 1.1.1206.0 (file 1.01.1206.00) in MSN Video; 2 older builds | 4oD, Antena 3 Modo Salón, Canal+, Crackle, GameSpot TV, MSN Video, Neon Alley, Real Sports, Redbox Instant, The CW Network, Verizon FiOS TV, Wall Street Journal (12) |

## Media player framework (MMPPF) parts Plex doesn't have

| Assembly | Newest build | Apps |
|---|---|---|
| `MMPPF.Plugins.Advertising.Xbox` | 2.2012.1005.0 in GameTrailers, MTV, Revision3, Vimeo, Xbox Tournaments; 8 older builds | 4oD, Amazon Instant Video, Blip, CNET, Crackle, Fox Broadcast, GameSpot TV, GameTrailers, HBO GO, IGN, IndieFlix, Manga Entertainment, Maxim, MSN Video, MTV, MUZU.TV, Neon Alley, NOW TV, Real Sports, Revision3, Rogers On Demand, Screenrush, Syfy, Telemundo, UVideos, Vimeo, Wall Street Journal, Xbox LIVE Dailymotion, Xbox Tournaments, XFINITY (30) |
| `MMPPF.Plugins.Heuristics.Xbox` | 2.2012.824.0 (file 2.2012.0824.0) in Telemundo; 3 older builds | Crackle, Fox Broadcast, HBO GO, MSN Video, MUZU.TV, Telemundo (6) |
| `MMPPF.Plugins.Thumbnails.Xbox` | 2.2012.1005.0 in Revision3, The CW Network; 4 older builds | Blip, Crackle, Fox Broadcast, HBO GO, IndieFlix, MSN Video, MTV, Neon Alley, Redbox Instant, Revision3, Telemundo, The CW Network, UVideos (13) |
| `MMPPF.Plugins.TimedText.Xbox` | 2.2012.1005.0 in Xbox Tournaments; 9 older builds | Amazon Instant Video, BBC iPlayer, Disney XD, Fox Broadcast, GameSpot TV, HBO GO, IndieFlix, MSN Video, MUZU.TV, Neon Alley, NOW TV, Real Sports, Redbox Instant, Telemundo, The CW Network, UVideos, Wall Street Journal, Xbox LIVE Dailymotion, Xbox Tournaments, XFINITY (20) |
| `MMPPF.Plugins.TTConnector.Xbox` | 2.2012.1005.0 | GameTrailers, MTV, Revision3 (3) |
| `MMPPF.Plugins.UAC.Xbox` | 2.2012.1005.0 in GameTrailers, MTV, Revision3, Vimeo, Xbox Tournaments; 8 older builds | Amazon Instant Video, Blip, CNET, Crackle, Fox Broadcast, GameSpot TV, GameTrailers, HBO GO, IGN, IndieFlix, Manga Entertainment, Maxim, MSN Video, MTV, MUZU.TV, Neon Alley, NOW TV, Real Sports, Revision3, Screenrush, Syfy, Telemundo, UVideos, Vimeo, Wall Street Journal, Xbox LIVE Dailymotion, Xbox Tournaments, XFINITY (28) |
| `MMPPF.Plugins.Vpaid.Xbox` | 2.2012.1005.0 in GameTrailers, MTV, Revision3, Vimeo, Xbox Tournaments; 9 older builds | 4oD, Amazon Instant Video, Blip, CNET, Crackle, Fox Broadcast, GameSpot TV, GameTrailers, HBO GO, IGN, IndieFlix, Manga Entertainment, Maxim, MSN Video, MTV, MUZU.TV, Neon Alley, NOW TV, Real Sports, Revision3, Rogers On Demand, Syfy, Telemundo, UVideos, Vimeo, Wall Street Journal, Xbox LIVE Dailymotion, Xbox Tournaments, XFINITY (29) |

## Third-party libraries

| Assembly | Newest build | Apps |
|---|---|---|
| `AdobePass` | 1.0.0.0 | Fox Broadcast, GameTrailers, MTV (3) |
| `AppMeasurement_XBOX` | 1.3.9.0 | GameTrailers, MTV (2) |
| `BrightcoveSDK` | 1.0.0.0 | GameTrailers, MTV (2) |
| `BrightcoveViacomSDK` | 1.0.0.0 | GameTrailers, MTV (2) |
| `com.Akamai.Analytics` | 2.2.0.4 | GameTrailers, MTV (2) |
| `com.Akamai.AnalyticsPluginLoader` | 1.5.0.0 | GameTrailers, MTV (2) |
| `Controls.SilverlightToolkit` | 1.0.0.0 | EPIX, Paramount Movies (2) |
| `Crypto` | 1.1162.434.2 in Netflix; 1 older build | Amazon Instant Video, Netflix (2) |
| `GalaSoft.MvvmLight` | 3.0.0.24641 in 4oD, ABC iview, Absolute Radio, Amazon Instant Video, Antena 3 Modo Salón, blinkbox, Blip, Canal+, CNET, Crackle, Crunchyroll, Dailymotion, Demand 5, Disney XD, EPIX, Fox Broadcast, GameSpot TV, GameTrailers, HBO GO, IGN, IndieFlix, Live Event Player, Maxim, Movistar Imagenio, MSN Video, MTV, Mustang Customizer, MUZU.TV, Neon Alley, NOW TV, Paramount Movies, Premium Play, Quickflix, Real Sports, Redbox Instant, Revision3, Rogers On Demand, Screenrush, Slacker Radio, Syfy, Telemundo, The CW Network, UVideos, Verizon FiOS TV, VEVO, Vimeo, VUDU Movies, Wall Street Journal, WWE PPV Wrestlemania, Xbox LIVE Dailymotion, Xbox Tournaments, XFINITY; 1 older build | 4oD, ABC iview, Absolute Radio, Amazon Instant Video, Antena 3 Modo Salón, blinkbox, Blip, Canal+, CNET, Crackle, Crunchyroll, Dailymotion, Demand 5, Disney XD, EPIX, Fox Broadcast, GameSpot TV, GameTrailers, HBO GO, IGN, IndieFlix, Live Event Player, Maxim, Movistar Imagenio, MSN Video, MTV, Mustang Customizer, MUZU.TV, Neon Alley, NOW TV, Paramount Movies, Premium Play, Quickflix, Real Sports, Redbox Instant, Revision3, Rogers On Demand, Screenrush, SkyDrive, Slacker Radio, Syfy, Telemundo, The CW Network, UVideos, Verizon FiOS TV, VEVO, Vimeo, VUDU Movies, Wall Street Journal, WWE PPV Wrestlemania, Xbox LIVE Dailymotion, Xbox Tournaments, XFINITY (53) |
| `GalaSoft.MvvmLight.Extras` | 3.0.0.24670 in blinkbox, Movistar Imagenio, Xbox LIVE Dailymotion; 1 older build | blinkbox, Movistar Imagenio, SkyDrive, Xbox LIVE Dailymotion (4) |
| `GalaSoft.MvvmLight.Extras.ADK` | 3.0.0.20427 | 4oD, ABC iview, Absolute Radio, Amazon Instant Video, Antena 3 Modo Salón, Blip, Canal+, CNET, Crackle, Crunchyroll, Dailymotion, Demand 5, Disney XD, EPIX, Fox Broadcast, GameSpot TV, GameTrailers, HBO GO, IGN, IndieFlix, Live Event Player, Maxim, MSN Video, MTV, Mustang Customizer, MUZU.TV, Neon Alley, NOW TV, Paramount Movies, Premium Play, Quickflix, Real Sports, Redbox Instant, Revision3, Rogers On Demand, Screenrush, Slacker Radio, Syfy, Telemundo, The CW Network, UVideos, Verizon FiOS TV, VEVO, Vimeo, VUDU Movies, Wall Street Journal, WWE PPV Wrestlemania, Xbox Tournaments, XFINITY (49) |
| `json.net.adk` | 4.0.0.0 (file 4.1.21107.0) in The CW Network; 2 older builds | IndieFlix, Maxim, SkyDrive, The CW Network (4) |
| `MediaAnalytics` | 2.2.0.12 | GameTrailers, MTV (2) |
| `Newtonsoft.Json` | 4.5.0.0 (file 4.5.7.15008) in GameTrailers, Maxim, MTV, Neon Alley, Vimeo; 2 older builds | Disney XD, GameTrailers, IGN, Maxim, MTV, Neon Alley, Rogers On Demand, UVideos, Vimeo (9) |
| `Newtonsoft.Json.WindowsPhone` | 4.0.2.0 (file 4.0.2.13623) | Premium Play, Redbox Instant, Verizon FiOS TV (3) |
| `Newtonsoft.Json.XBox` | 4.5.0.0 (file 4.5.1.14720) in Wall Street Journal; 1 older build | Crackle, Fox Broadcast, Wall Street Journal (3) |
| `Ninject` | 2.2.0.0 in 4oD, ABC iview, Amazon Instant Video, Antena 3 Modo Salón, blinkbox, Canal+, Crackle, Demand 5, Disney XD, EPIX, Fox Broadcast, HBO GO, IGN, Movistar Imagenio, MSN Video, Mustang Customizer, MUZU.TV, NOW TV, Paramount Movies, Premium Play, Real Sports, Redbox Instant, Rogers On Demand, Syfy, Telemundo, The CW Network, Verizon FiOS TV, VEVO, VUDU Movies, XFINITY; 1 older build | 4oD, ABC iview, Amazon Instant Video, Antena 3 Modo Salón, blinkbox, Canal+, Crackle, Demand 5, Disney XD, EPIX, Fox Broadcast, HBO GO, IGN, Movistar Imagenio, MSN Video, Mustang Customizer, MUZU.TV, Netflix, NOW TV, Paramount Movies, Premium Play, Real Sports, Redbox Instant, Rogers On Demand, Syfy, Telemundo, The CW Network, Verizon FiOS TV, VEVO, VUDU Movies, XFINITY (31) |

## Shared by one publisher's apps

| Assembly | Newest build | Apps |
|---|---|---|
| `Cypress.Analytics.XBox` | 1.1.0.0 | Crackle, Fox Broadcast |
| `Cypress.Core.XBox` | 1.1.0.0 | Crackle, Fox Broadcast |
| `Cypress.Reimplemented.XBox` | 1.1.0.0 | Crackle, Fox Broadcast |
| `Cypress.Rest.XBox` | 1.1.0.0 | Crackle, Fox Broadcast |
| `Cypress.Storage.XBox` | 1.1.0.0 | Crackle, Fox Broadcast |
| `GreenApp.Controls` | 1.0.1327.0 in YouTube; 1 older build | Hulu Plus, YouTube |
| `GreenApp.Converters` | 1.0.1327.0 in YouTube; 1 older build | Hulu Plus, YouTube |
| `IdentityMine.Merge.Client` | 1.0.0.0 | Exp Sony Pictures, The Next Level |
| `LoggingLV` | 1.0.1327.0 in YouTube; 1 older build | Hulu Plus, YouTube |
| `LoggingPluginLV` | 1.0.1327.0 in YouTube; 1 older build | Hulu Plus, YouTube |
| `Microsoft.Xbox.Dailymotion.UI` | 1.1.0.0 (file 1.1.0) in Dailymotion; 1 older build | Dailymotion, Xbox LIVE Dailymotion |
| `PAMonitorLV` | 1.0.1327.0 in YouTube; 1 older build | Hulu Plus, YouTube |
| `Rhapsody.Core` | 1.0.44.0 in Napster; 1 older build | Napster, Rhapsody |
| `Rhapsody.Data` | 1.0.44.0 in Napster; 1 older build | Napster, Rhapsody |
| `Rhapsody.Logging` | 1.0.44.0 in Napster; 1 older build | Napster, Rhapsody |
| `Rhapsody.RhapsodyDirect` | 1.0.44.0 in Napster; 1 older build | Napster, Rhapsody |
| `Rhapsody.Utility` | 1.0.44.0 in Napster; 1 older build | Napster, Rhapsody |
| `Rhapsody.ViewModel` | 1.0.44.0 in Napster; 1 older build | Napster, Rhapsody |
| `RSAF.Xbox` | 1.0.0.0 | Blip, CNET, IndieFlix |
| `RSCF.Xbox` | 1.0.0.0 | Blip, CNET, IndieFlix |
| `RSF.Xbox` | 1.0.0.0 | Blip, CNET, IndieFlix |
| `StorageLV` | 1.0.1327.0 in YouTube; 1 older build | Hulu Plus, YouTube |
| `SubtitlePluginLV` | 1.0.1327.0 in YouTube; 1 older build | Hulu Plus, YouTube |
| `UtilitiesLV` | 1.0.1327.0 in YouTube; 1 older build | Hulu Plus, YouTube |
| `Viacom.Xbox.Custom` | 1.0.0.0 | GameTrailers, MTV |
| `Viacom.Xbox.Services` | 1.0.0.0 | GameTrailers, MTV |
| `ViacomCommon` | 1.0.0.0 | GameTrailers, MTV |
| `ViacomPlayout` | 1.0.0.0 | GameTrailers, MTV |
| `Xbox.Dailymotion.Common` | 1.1.0.0 (file 1.1.0) in Dailymotion; 1 older build | Dailymotion, Xbox LIVE Dailymotion |
| `Xbox.Dailymotion.Controls` | 1.1.0.0 (file 1.1.0) in Dailymotion; 1 older build | Dailymotion, Xbox LIVE Dailymotion |
| `Xbox.Dailymotion.Models` | 1.1.0.0 (file 1.1.0) in Dailymotion; 1 older build | Dailymotion, Xbox LIVE Dailymotion |
| `Xbox.Dailymotion.Services` | 1.1.0.0 (file 1.1.0) in Dailymotion; 1 older build | Dailymotion, Xbox LIVE Dailymotion |
| `Xbox.Dailymotion.Services.DLM` | 1.1.0.0 (file 1.1.0) in Dailymotion; 1 older build | Dailymotion, Xbox LIVE Dailymotion |
| `Xbox.Transverse.Json` | 1.0.0.0 | Dailymotion, Screenrush, Xbox LIVE Dailymotion |
| `XBoxLiveLV` | 1.0.1327.0 in YouTube; 1 older build | Hulu Plus, YouTube |

## Each app's own assemblies

`XboxApplication` (42 apps) and `Resources` (5 apps) are names, not shared code: each app's is its own. Every other assembly here is in one app only.

| App | Assemblies |
|---|---|
| 4oD | `Channel4.Xbox.UIC4`, `Common.C4`, `Controls.C4`, `HAPXbox`, `Models.C4`, `Services.Analytics`, `Services.C4`, `Services.Cms.C4`, `Services.Sample.C4` |
| ABC iview | `Video.Services.ABC` |
| Amazon Instant Video | `Pushbutton.Services.AIV`, `XboxApplication.AIV` |
| Antena 3 Modo Salón | `Analytics` |
| Aol On | `AolViewModel`, `AolXboxApplication` |
| BBC iPlayer | `iPlayer.Application.Xbox`, `iPlayer.Services.Xbox`, `iPlayerApplication` |
| blinkbox | `BlinkBox.Client`, `BlinkBox.Client.WebApi`, `BlinkBox.Client.Xbox`, `BlinkBox.Client.Xbox.Application`, `BlinkBox.Client.Xbox.Controls`, `BlinkBox.Client.Xbox.UI` |
| Blip | `RSPF.Xbox` |
| Canal+ | `CanalPlusLakeviewApplication`, `Common.Prisa`, `Controls.Prisa`, `Models.Prisa`, `MyCodeContracts`, `Services.Cms.Prisa`, `Services.Prisa`, `UI.Prisa` |
| Crackle | `Services.Crackle` |
| Crunchyroll | `CrunchyLib` |
| Demand 5 | `AuditudeXBoxSMFPlugin_1_0_0`, `Channel5.Xbox.Common`, `Channel5.Xbox.Controls`, `Channel5.Xbox.Models`, `Channel5.Xbox.Services`, `Channel5.Xbox.Services.Cms`, `Channel5.Xbox.UI`, `Channel5.XboxApplication` |
| EPIX | `SnocapsCommon`, `Video.Services.Epix` |
| Exp Sony Pictures | `SonyPicturesViewModel`, `SonyPicturesXboxApplication` |
| Fox Broadcast | `Cypress.Xbox.FOX.Services` |
| GameSpot TV | `Services.GameSpot` |
| HBO GO | `Video.Services`, `Video.Services.Hbo` |
| Hulu Plus | `ClosedCaptionsService`, `HttpLiveStreamingLV`, `HuluAppXboxApplication`, `Json.Xbox` |
| IGN | `Google.WebAnalytics`, `IGN.HttpLiveStreaming`, `IGN.Xbox`, `IGN.Xbox.Common`, `IGN.Xbox.Controls`, `IGN.Xbox.Data`, `IGN.Xbox.Models`, `IGN.Xbox.Services`, `IGN.Xbox.UI` |
| iHeartRadio | `iHeartRadioXboxApplication`, `iHRData`, `iHRViewModel`, `ShoutCastMedia` |
| IndieFlix | `Silverlight.Samples.HLS` |
| Live Event Player | `GS.ADK.Common`, `GS.ADK.Common.Auth`, `GS.ADK.Common.Telemetry`, `GS.ADK.LEP.App` |
| Manga Entertainment | `StarzMangaApplication` |
| Maxim | `Ensemble.Xbox.UI`, `Maxim.Api`, `Maxim.Xbox.Services`, `Maxim.Xbox.UI` |
| Movistar Imagenio | `MovistarImagenio.Controls`, `MovistarImagenio.Models`, `MovistarImagenio.Services`, `MovistarImagenio.Services.GVP`, `MovistarImagenio.Tools`, `MovistarImagenio.UI`, `MovistarImagenioApplication` |
| Mustang Customizer | `Microsoft.Xbox.Services.Mustang`, `Microsoft.Xbox.UI`, `SimpleSerializer` |
| MUZU.TV | `Services.Muzu` |
| Napster | `Napster` |
| Neon Alley | `Video.Services.Viz` |
| Netflix | `DataModels`, `Http`, `LitJson`, `Localization`, `Logging`, `MediaStreamSource`, `Nccp`, `NrdConf`, `Ntba`, `PiffParser`, `PlaybackHeuristics`, `PlayerDataModel`, `Serialization`, `SLControls`, `SLPlayer`, `Utilities`, `ViewModels`, `Windows`, `xboxApp` |
| NOW TV | `BSkyB.NowTV.UI.Common`, `BSkyB.NowTV.UI.Interfaces`, `Video.Services.Sky` |
| Paramount Movies | `Paramount.Xbox.Common`, `ParamountCommon`, `Video.Services.Paramount` |
| Pizza Hut | `PizzaHutViewModel`, `PizzaHutXboxApplication` |
| Premium Play | `MediasetNetTv.Core`, `MediasetNetTv.DataProviders`, `MediasetNetTv.Mocks`, `MediasetNetTv.Models`, `MediasetNetTv.ServiceContracts`, `MediasetNetTv.ServiceStub`, `MediasetNetTv.UI`, `MediasetNetTvApplication` |
| Quickflix | `QF.Xbox.App.Common`, `QF.Xbox.App.Controls`, `QF.Xbox.App.Models`, `QF.Xbox.App.Services`, `QF.Xbox.App.UI` |
| Real Sports | `Services.MyCms` |
| Redbox Instant | `Video.Services.Zoetrope` |
| Revision3 | `Microsoft.Xbox.Rev3.Common`, `Microsoft.Xbox.Rev3.Controls`, `Microsoft.Xbox.Rev3.Models`, `Microsoft.Xbox.Rev3.PlayerUI`, `Microsoft.Xbox.Rev3.UI` |
| Rhapsody | `Rhapsody` |
| Rogers On Demand | `Security`, `Services.Rodo` |
| Screenrush | `Models.allocine`, `Services.Allocine`, `XboxAllocine.Common`, `XboxAllocine.Controls`, `XboxAllocine.Models`, `XboxAllocine.Services` |
| SkyDrive | `Platform`, `WinLive.XSky.Application` |
| Syfy | `Services.Syfy` |
| Telemundo | `Msn.Common`, `Msn.Configuration`, `Msn.Controls`, `Msn.Globalization`, `Msn.Pages`, `Msn.Services`, `Msn.VideoCatalog`, `Msn.XboxApplication`, `ZLib.Xbox` |
| The CW Network | `CW.Xbox.UI`, `DSPlugins`, `Google.InteractiveAds`, `MMPPF.Logging.Xbox`, `Newtonsoft.Json.360` |
| The Next Level | `LOrealViewModel`, `LOrealXboxApplication` |
| TMZ | `TmzData`, `TmzViewModel`, `TmzXboxApplication` |
| UVideos | `Univision.Xbox.Common`, `Univision.Xbox.Controls`, `Univision.Xbox.PlayerUI`, `Univision.Xbox.UI` |
| Verizon FiOS TV | `DH.Scrypt`, `Video.Services.Caspian` |
| VEVO | `Vevo.XBOX.Advertising`, `Vevo.XBOX.Common`, `Vevo.XBOX.Controls`, `Vevo.XBOX.Data`, `Vevo.XBOX.Services`, `Vevo.XBOX.UI`, `Vevo.XBOXApplication` |
| Vimeo | `BouncyCastleCrypto`, `EnsembleSupport`, `VimeoApi`, `VimeoXbox` |
| VUDU Movies | `HLSMSS_VUDU`, `MMPPF.Plugins.Vudu.Xbox`, `Services.Vudu`, `VuduDirector`, `VuduWebStream` |
| Wall Street Journal | `mDialog.Media.HLSMS.Xbox`, `mDialog.Media.Interfaces.Xbox`, `mDialog.Media.MMSS.Xbox`, `mDialog.Utility.Xbox`, `mDialog.Xbox.Sdk`, `MMPPF.Plugins.mDialogHLS.Xbox` |
| WWE PPV Wrestlemania | `Common`, `Controls`, `Models`, `WWE.SapphireFeed.XBOX360`, `WWEApplication` |
| YouTube | `adsapi`, `DataServiceLV`, `Google.YouTube.Ads.Xbox`, `Google.YouTube.Captions.Xbox`, `Google.YouTube.Media.Xbox`, `Google.YouTube.Util.Xbox`, `Google.YouTube.VideoStats`, `Google.YouTube.Xbox`, `SilverlightGlueLV`, `YouTubeAPISilverlightGL`, `YouTubeCaptions`, `YouTubeXBoxApplication` |

<!-- end of tables -->
