# Native images

On a retail console, the platform's runtime has no JIT compiler, so an app's own code goes through the IL interpreter (see [Performance](performance.md)). [XboxNGen](https://github.com/Digiex/Silverlight360-XboxNGen) supplies a JIT for the runtime and runs the runtime's own native-image generator (the *zapper*) in xenia-edge, so an app's assemblies get `.ni.dll` native images, as Microsoft's apps have. In XboxNGen's benchmarks, compiled code runs tens to hundreds of times faster than interpreted code.

`tools\NGen-XboxApp.ps1` makes native images for a built package with XboxNGen's latest release, and `Build-XboxApp.ps1 -NGen` runs it after a build.

!!! warning "The images are unsigned"
    They run in xenia-edge and on a console that runs unsigned code. They don't run on a stock retail console: an image there has to be signed for its app, as Microsoft's are. To hand out a package for retail consoles, leave the images out.

## What it needs

- **xenia-edge from the `silverlight-build` branch of [jessenic/xenia-edge](https://github.com/jessenic/xenia-edge/tree/silverlight-build)**, built. Upstream xenia-edge lacks fixes the zapper needs, such as devkit code buffers and code patched in place. The script uses `-Xenia`, else the `XENIA_EDGE` environment variable, else `xenia-edge\build\bin\Windows\Release\xenia_edge.exe` beside this repository or beside its parent folder (where XboxNGen's `Configure.ps1` looks), else `xenia_edge.exe` on `PATH`.
- **Python 3** on `PATH` as `python`. XboxNGen's tools use it to rebase and wrap each image (the standard library only).
- **A whole package**: `bin\<Configuration>\xbox`, or any app folder with a `default.xex`, an `AppManifest.xaml`, the runtime and its `mscorlib.ni.dll`. An `-AppOnly` build doesn't have the runtime the zapper runs in.
- **Internet access to GitHub**, the first time and whenever a newer release is out. No account is needed.

It doesn't need xsdk or WSL: the release's zip has the JIT (`jit\xclrjit.dll`), the zapper host (`host\ngenhost.xex`) and the code cache module (`codecache\CLRCodeCachedll_0.xex`) already built.

## Running it

```powershell
# Build, then compile the app's own assemblies in bin\Release\xbox.
.\tools\Build-XboxApp.ps1 -Project .\samples\HelloXbox\HelloXbox.csproj -NGen

# Or on a package built earlier.
.\tools\NGen-XboxApp.ps1 -Package .\samples\HelloXbox\bin\Release\xbox

# Then run it as usual.
.\tools\Test-XboxApp.ps1 -Xex .\samples\HelloXbox\bin\Release\xbox\default.xex -Output $env:TEMP\hello-ngen
```

The script:

1. Gets XboxNGen. It asks GitHub for the latest release (or `-Tag v0.1.0`), downloads its `XboxNGen-*.zip` into `%LOCALAPPDATA%\Silverlight360\XboxNGen\<tag>` (`-Cache` changes the folder), and checks it against the SHA-256 digest GitHub records for the asset (and a `SHA256SUMS` or `.sha256` asset, if the release has one). Later runs reuse the cached release. Offline, it uses the newest cached release.
2. Compiles the `AppManifest.xaml` assemblies that have no native image yet (or those given with `-Assemblies`), one xenia-edge run each. xenia-edge runs without a window; a small assembly such as a sample's takes a few seconds. The images go beside the assemblies in the package, from load address 0x95000000 up (`-BaseAddress`).
3. Prints what it compiled. If an assembly got no image, it warns and exits with code 1. That assembly runs interpreted, as before.

`-Output <folder>` compiles in a copy of the package and leaves the package as it is.

Run one xenia-edge at a time: the script won't start while one is running, since two at once can stop one with "Overflowed stackpoints!". xenia-edge sometimes stalls right after it starts. If a compile reports no image for that reason, run the script again: it compiles only what has no image yet.

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

Images are bound to the exact IL they were compiled from, to the runtime and framework build in the profile, and to their load addresses. Compile them against the profile your users will run the app with, or leave them out and let the app run interpreted.

XboxNGen's license is noncommercial, and an app shipped with native images its JIT made has to include a visible reference to https://github.com/Digiex/Silverlight360-XboxNGen (see its `LICENSE.md`).
