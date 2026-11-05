# Native images

On a retail console, the platform's runtime has no JIT compiler, so an app's own code goes through the IL interpreter (see [Performance](performance.md)). [XboxNGen](https://github.com/Digiex/Silverlight360-XboxNGen) supplies a JIT for the runtime and runs the runtime's own native-image generator (the *zapper*) in xenia-edge, so an app's assemblies get `.ni.dll` native images, as Microsoft's apps have. In XboxNGen's benchmarks, compiled code runs tens to hundreds of times faster than interpreted code.

`Build-XboxApp.ps1` makes them for the app's assemblies after every build, with `tools\NGen-XboxApp.ps1`; `-NoNGen` leaves them out. An `-AppOnly` build has them too: they're made in the whole package, then copied beside the app's assemblies. `NGen-XboxApp.ps1` also works on a package built earlier.

!!! warning "The images are unsigned"
    They run in xenia-edge and on a console that runs unsigned code. They don't run on a stock retail console: an image there has to be signed for its app, as Microsoft's are. To hand out a package for retail consoles, build it with `-NoNGen`.

## What it needs

`tools\Configure.ps1` sets it all up; run it first, and again for a newer XboxNGen:

- **XboxNGen**: Configure downloads its latest release (`-Tag v0.1.1` for another) into `%LOCALAPPDATA%\Silverlight360\XboxNGen\<tag>`, and checks it against the SHA-256 digest GitHub records for the asset (and a `SHA256SUMS` or `.sha256` asset, if the release has one). Offline, it uses the newest release already there. The release's zip has the JIT (`jit\xclrjit.dll`), the zapper host (`host\ngenhost.xex`) and the code cache module (`codecache\CLRCodeCachedll_0.xex`) already built, so it doesn't need xsdk or WSL.
- **xenia-edge from the `silverlight-build` branch of [jessenic/xenia-edge](https://github.com/jessenic/xenia-edge/tree/silverlight-build)**. Upstream xenia-edge lacks fixes the zapper needs, such as devkit code buffers and code patched in place. Configure runs XboxNGen's own `tools\Configure.ps1`, giving it the xenia-edge it finds (`-Xenia`, the `XENIA_EDGE` environment variable, the last configuration, `xenia-edge\` beside this repository or `PATH`). With none, it offers to download that branch's Windows build, the release [silverlight-build-20261105](https://github.com/jessenic/xenia-edge/releases/tag/silverlight-build-20261105) (`-DownloadXenia` without asking), which goes beside the XboxNGen release. To change xenia-edge, build the branch yourself and give it with `-Xenia`.
- **Python 3.7 or later** on `PATH` as `python`. XboxNGen's tools use it to rebase and wrap each image (the standard library only).

And a **whole package**: `bin\<Configuration>\xbox`, or any app folder with a `default.xex`, an `AppManifest.xaml`, the runtime and its `mscorlib.ni.dll`. `NGen-XboxApp.ps1` can't work on an `-AppOnly` build, which doesn't have the runtime the zapper runs in; `Build-XboxApp.ps1 -AppOnly` builds the whole package for that first.

## Running it

```powershell
# Build, then compile the app's own assemblies in bin\Release\xbox.
.\tools\Build-XboxApp.ps1 -Project .\samples\HelloXbox\HelloXbox.csproj

# Without native images: the app's code runs interpreted.
.\tools\Build-XboxApp.ps1 -Project .\samples\HelloXbox\HelloXbox.csproj -NoNGen

# Or on a package built earlier.
.\tools\NGen-XboxApp.ps1 -Package .\samples\HelloXbox\bin\Release\xbox

# Then run it as usual.
.\tools\Test-XboxApp.ps1 -Xex .\samples\HelloXbox\bin\Release\xbox\default.xex -Output $env:TEMP\hello-ngen
```

The script:

1. Takes the XboxNGen release and xenia-edge Configure set up (`-XboxNGen` and `-Xenia` give others). Without them it stops and says to run `Configure.ps1`, and so does `Build-XboxApp.ps1`, before building.
2. Compiles the `AppManifest.xaml` assemblies that have no native image yet (or those given with `-Assemblies`), one xenia-edge run each. xenia-edge runs without a window; a small assembly such as a sample's takes a few seconds. The images go beside the assemblies in the package, from load address 0x95000000 up (`-BaseAddress`).
3. Prints what it compiled. If an assembly got no image, it warns and exits with code 1. That assembly runs interpreted, as before.

`-Output <folder>` compiles in a copy of the package and leaves the package as it is.

Run one xenia-edge at a time: the script, and `Build-XboxApp.ps1` unless given `-NoNGen`, won't start while one is running, since two at once can stop one with "Overflowed stackpoints!". xenia-edge sometimes stalls right after it starts. If a compile reports no image for that reason, run the script again: it compiles only what has no image yet.

### The platform too

```powershell
.\tools\NGen-XboxApp.ps1 -Package .\samples\ui\XboxControls\bin\Release\xbox -Platform
```

`-Platform` (`-NGenPlatform` on `Build-XboxApp.ps1`) first compiles the platform assemblies the package has (`System`, `System.Core`, `System.Xml`, `System.Net`, `System.Windows`, `System.Xml.Linq`, the `Microsoft.Xbox` libraries and others). It replaces the profile's native images of them with XboxNGen's, from 0x96200000 up, then compiles the app's assemblies again after them, against the new images. `mscorlib.ni.dll` stays the profile's. It takes one xenia-edge run per platform assembly, about a minute for the default profile's fourteen. The profile's images already run the platform compiled, so you need it only to run a package on XboxNGen's images alone, for instance to test XboxNGen.

### A local XboxNGen

```powershell
.\tools\NGen-XboxApp.ps1 -Package .\samples\HelloXbox\bin\Release\xbox -XboxNGen C:\src\Silverlight360-XboxNGen
```

`-XboxNGen <folder>` (also on `Build-XboxApp.ps1`) uses an XboxNGen checkout instead of a release, for working on XboxNGen itself. Its JIT, host and code cache module have to be built (`make` in WSL, as its README says). The script uses the checkout's `tools\` as they are.

## Handing out an app with native images

Images are bound to the exact IL they were compiled from, to the runtime and framework build in the profile, and to their load addresses. Compile them against the profile your users will run the app with, or build with `-NoNGen` and let the app run interpreted.

An `-AppOnly` build, for handing the app's own files out, has the images of the app's assemblies. They load only when the files go over a package made from the same donor app as the profile (Plex v0.0.0.7 for the default one), which the build says. For people who use another, build with `-NoNGen`. `-AppOnly` can't be used with `-NGenPlatform`: the app's images would then be compiled against new images of the platform, which the app files leave out.

XboxNGen's license is noncommercial, and an app shipped with native images its JIT made has to include a visible reference to https://github.com/Digiex/Silverlight360-XboxNGen (see its `LICENSE.md`).
