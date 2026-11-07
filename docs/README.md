# Silverlight360 documentation

Silverlight360 builds C# and XAML Silverlight apps for the Xbox 360 Silverlight platform, the one Netflix, YouTube and the other Xbox 360 apps used. The output is a package with a `default.xex` you can run in the [xenia-edge](https://github.com/has207/xenia-edge) emulator.

![The CatalogBrowser sample](images/samples/catalog-browser.png)

The code, samples and tools are at [github.com/Digiex/Silverlight360](https://github.com/Digiex/Silverlight360).

Guides:

| | |
|---|---|
| [Getting started](getting-started.md) | Install the tools, make a runtime profile, build and run a sample. |
| [Projects and Visual Studio](project-setup.md) | The project file, references, build properties, packaging, IntelliSense. |
| [The common library](common-library.md) | Silverlight360.Common, which every project references, and class libraries of your own. |
| [App model](app-model.md) | Startup, `XboxApplicationFrame`, pages and navigation, back and exit, the TV screen. |
| [Input and focus](input-and-focus.md) | Controller events, focus, moving focus with the D-pad, the Legend, media remotes. |
| [Xbox controls](controls.md) | Pivot, Rune, Legend, MediaTransport, ContinuousList, transitions, speech. |
| [Networking](networking.md) | `WebClient` and `HttpWebRequest`, cross-domain policy, what needs Xbox LIVE. |
| [Storage](storage.md) | Saving settings in a storage container, the cache drive. |
| [Media](media.md) | `MediaElement`, `MediaTransport`, Smooth Streaming, DRM. |
| [Gamer services](gamer-services.md) | Signed-in gamers, the Guide, presence, threading. |
| [Native code](native-code.md) | Calling the kernel and XAM with `DllImport`. |
| [Performance](performance.md) | Why app code is slow on the console and how to write it so it isn't. |
| [Native images](native-images.md) | Compiling an app's code with XboxNGen, for xenia-edge and consoles that run unsigned code. |
| [Testing in xenia](testing.md) | Running an app with scripted controller input and screenshots. |
| [Status under xenia](xenia-status.md) | What works in the emulator today and what doesn't. |

Reference:

- [API reference](reference/README.md): the Xbox libraries and the Xbox additions to Silverlight, one page per namespace. The same text appears in Visual Studio's IntelliSense.
- [Samples](samples.md): what each sample shows and how it was tested.
- [Libraries](libraries.md): class libraries for Silverlight360 apps, such as [Silverlight360.Https](https://digiex.github.io/Silverlight360.Https/) for HTTPS with TLS 1.3 and [Silverlight360.UnRAR](https://digiex.github.io/Silverlight360.UnRAR/) for RAR extraction.
- [Runtime inventory](runtime-inventory.md): the platform versions found in the shipped apps.
- [Assemblies in other donor apps](donor-assemblies.md): every assembly the other shipped apps carry that Plex doesn't, and the apps to take each from.

An app built with it: [Silverdash360](https://github.com/Digiex/Silverdash360), a dashboard for the Xbox 360 that runs on consoles ([its documentation](https://digiex.github.io/Silverdash360/)). See [Samples](samples.md#apps-built-with-silverlight360).

Problems and ideas go to [GitHub Issues](https://github.com/Digiex/Silverlight360/issues) (see [Problems and ideas](issues.md)), and contributions and pull requests are welcome: see [Contributing](contributing.md).

Everything here comes from running apps in the [xenia-edge](https://github.com/has207/xenia-edge) emulator and from reading the platform's own assemblies. Of the samples, only PageNavigation has been run on a console so far.
