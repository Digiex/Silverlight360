# Libraries

Class libraries for Silverlight360 apps. Each builds as a Silverlight360 class library ([Class libraries of your own](common-library.md#class-libraries-of-your-own)): an app references its project, or its DLL from a release, and the SDK's build puts the DLL in the app's package and makes its native image with the app's own.

| | |
|---|---|
| [Silverlight360.Common](common-library.md) | The SDK's own: `NativeBuffer` and `BigEndian` for native calls, `DebugLog`, `DirectionalFocus` and `Screenshot`. Every app and library references it already. |
| [Silverlight360.Https](https://digiex.github.io/Silverlight360.Https/) | HTTP and HTTPS with TLS 1.2 and 1.3 and Mozilla's current root certificates: libcurl on Mbed TLS in a native DLL, `https360.xex`, called from C# through `HttpsClient`. Its drop-in sends an app's own `WebClient` and `HttpWebRequest` calls through it, for the sites the console's own HTTPS can't reach. Runs on consoles. [Documentation](https://digiex.github.io/Silverlight360.Https/), [source and releases](https://github.com/Digiex/Silverlight360.Https). |
| [Silverlight360.UnRAR](https://digiex.github.io/Silverlight360.UnRAR/) | RAR extraction on the console's drives: UnRAR's library in a native DLL, `unrar360.xex`, called from C# through `RarExtractor`. RAR5 and RAR4, solid, encrypted and split archives, of any size, decompressed natively rather than in interpreted app code. Loads on consoles; extraction tested in xenia-edge. [Documentation](https://digiex.github.io/Silverlight360.UnRAR/), [source and releases](https://github.com/Digiex/Silverlight360.UnRAR). |

## Silverlight360.Https

The platform's `HttpWebRequest` and `WebClient` do HTTPS with the console's own certificate authorities, which are years old: on a console they fail for sites such as `example.com` and `github.com` ([Networking](networking.md)). Silverlight360.Https makes those requests with TLS 1.3 and Mozilla's roots, on any thread.

```csharp
using Silverlight360.Https;

HttpsRequestCreator.Register();   // once: WebClient and HttpWebRequest now go through Silverlight360.Https
var web = new WebClient();
web.DownloadStringCompleted += (s, e) => Show(e.Error == null ? e.Result : e.Error.Message);
web.DownloadStringAsync(new Uri("https://example.com/"));
```

An app references `Silverlight360.Https.dll` and puts `https360.xex` and `cacert.pem` beside `default.xex`; see [Adding it to an app](https://digiex.github.io/Silverlight360.Https/using/). Its native DLL loads at `0x8D000000`, a base free in a Silverlight app's process on the console: a native library of the app's own ([Native code](native-code.md)) needs another.

## Silverlight360.UnRAR

```csharp
using Silverlight360.UnRAR;

using (var rar = new RarExtractor())
{
    // On a thread of its own: Extract returns when the archive is done.
    int result = rar.Extract(@"hdd:\Downloads\game.part1.rar", @"hdd:\Games\Game", null);
    if (result != RarExtractor.Success)
        Show(RarExtractor.Describe(result) + ": " + rar.Message);
}
```

An app references `Silverlight360.UnRAR.dll` and puts `unrar360.xex` beside `default.xex`; see [Adding it to an app](https://digiex.github.io/Silverlight360.UnRAR/using/). Its native DLL loads at `0x8F000000`, beside Silverlight360.Https's, so an app can use both. UnRAR's own license allows extracting RAR archives, not making them.

## Adding one

A library for Silverlight360 apps can be listed here: open an issue or a pull request ([Contributing](contributing.md)) with what it does, where its documentation is, and whether it has run on a console.
