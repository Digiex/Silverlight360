# Silverlight360

An SDK for the Xbox 360 Silverlight platform.


Builds C# and XAML Silverlight apps that run on the Xbox 360 Silverlight
platform (the one Netflix, YouTube, Hulu Plus and the other Xbox 360 apps
used). The output is a folder with a `default.xex` you can launch in the
[xenia-edge](https://github.com/has207/xenia-edge) emulator.

Status: XAML UI, controller input, page navigation, the Xbox controls, HTTP,
storage containers and the cache drive all work under xenia-edge, and WMA,
WMV and MP3 playback with the console's codec module (see
[docs/media.md](docs/media.md)). The PageNavigation sample has also been run
on a console.

**Documentation:** [docs/README.md](docs/README.md): guides, the API
reference, the samples and what works in xenia. Visual Studio shows the same
API text in IntelliSense once a runtime profile exists
([Projects and Visual Studio](docs/project-setup.md#intellisense)).

**Samples:** UI samples in [samples/ui](samples/ui) (gamepad input, focus
navigation, Xbox controls, page navigation) and application samples in
[samples/apps](samples/apps) (a catalog browser, a media player). See
[docs/samples.md](docs/samples.md).

## How it works

Every Xbox 360 Silverlight app ships its own copy of the platform: the
native host `default.xex` (XamlHost), the CLR (`xcoreclr.dll`), Silverlight
(`agcore.dll`, `npctrl.dll`) and the framework assemblies. XamlHost reads
`AppManifest.xaml` from the app folder, loads the entry assembly it names and
runs the `Application` class.

The SDK reuses that platform:

1. **Runtime profile.** `tools\New-RuntimeProfile.ps1` copies the platform
   out of an extracted app (the *donor*) into `runtime\<name>`: a `package`
   folder every build starts from, and a `reference` folder with the
   framework IL assemblies.
2. **Compile.** `msbuild\XboxSilverlight.targets` drives the installed
   Silverlight 3 compiler and XAML markup compiler, but resolves framework
   references from the profile instead of desktop Silverlight. Apps get the
   Xbox-only APIs that way, such as `UIElement.GamePadButtonDown` and the
   `Microsoft.Xbox` controls.
3. **Package.** After the build, the targets copy the profile's package,
   the app's assemblies, the generated `AppManifest.xaml`, an
   `XboxAppManifest.xml` and splash screens into `bin\<Configuration>\xbox`.

The app's own assemblies stay plain IL. The Xbox CLR compiles IL itself when
an assembly has no Xenon native image, so no native-image generator is
needed (see [docs/runtime-inventory.md](docs/runtime-inventory.md)).

## Requirements

| Dependency | Used for | Notes |
|---|---|---|
| Windows | everything | |
| MSBuild 14 (Visual Studio 2015 or its Build Tools) | builds | Found in its default install folder; `Build-XboxApp.ps1 -MsBuildPath` points at another. |
| Silverlight 3 tools and SDK | C# + XAML compilation | Must provide `MSBuild\Microsoft\Silverlight\v3.0\Microsoft.Silverlight.CSharp.targets` and the v3.0 reference assemblies. |
| Windows SDK 7.0A | Silverlight build tasks | Found in its default install folder. |
| An extracted Xbox 360 Silverlight app | runtime profile | Plex v0.0.0.7 is the default donor; see [docs/getting-started.md](docs/getting-started.md). |
| `xextool.exe` (optional) | profile metadata | On PATH or passed with `-Xextool`; only used to record build dates. |
| 7-Zip and Python 3 | `tools\extract_god_packages.py` | Only for extracting app archives. |
| Python 3 | `samples\TestServer\server.py` | Standard library only. |
| [xenia-edge](https://github.com/has207/xenia-edge) with the Silverlight pull requests | running apps | See [docs/xenia-status.md](docs/xenia-status.md). |
| XNA Game Studio 4 (optional) | IntelliSense | Its docs cover the XNA parts of the Xbox libraries. |

The runtime profile and every package built from it contain Microsoft's and
the donor publisher's binaries. Keep them local; `runtime\` is ignored by
git and nothing in this repository includes them.

## Quick start

From PowerShell in this folder:

```powershell
# 1. Once: extract the app archives, if they aren't extracted yet.
python tools\extract_god_packages.py <archive folder> <apps folder> $env:TEMP\god-staging

# 2. Once: make the default runtime profile from Plex.
.\tools\New-RuntimeProfile.ps1 -DonorApp '<apps folder>\Plex v0.0.0.7' -Output .\runtime\plex-2015

# 3. Build the sample.
.\tools\Build-XboxApp.ps1 -Project .\samples\HelloXbox\HelloXbox.csproj

# 4. Start the test server the sample talks to (separate window).
python samples\TestServer\server.py

# 5. Run it with your xenia-edge build.
xenia_edge.exe `
    samples\HelloXbox\bin\Release\xbox\default.xex
```

The sample shows the server's greeting, polls `/api/time` every 5 seconds,
and posts to `/api/echo` when you press A on the controller. The server
prints every request it gets.

## Making an app

A project is an ordinary Silverlight 3 class library project that imports
the SDK targets instead of the Silverlight ones:

```xml
<Project ToolsVersion="4.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <PropertyGroup>
    <OutputType>Library</OutputType>
    <AssemblyName>MyApp</AssemblyName>
    <RootNamespace>MyApp</RootNamespace>
    <SilverlightAppEntry>MyApp.App</SilverlightAppEntry>
    <OutputPath>bin\$(Configuration)\</OutputPath>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="mscorlib" />
    <Reference Include="System" />
    <Reference Include="System.Net" />
    <Reference Include="System.Windows" />
    <!-- Optional: Microsoft.Xbox, Microsoft.Xbox.Core, Microsoft.Xbox.Services, ... -->
  </ItemGroup>
  <ItemGroup>
    <ApplicationDefinition Include="App.xaml"><Generator>MSBuild:Compile</Generator></ApplicationDefinition>
    <Page Include="MainPage.xaml"><Generator>MSBuild:Compile</Generator></Page>
    <Compile Include="App.xaml.cs" />
    <Compile Include="MainPage.xaml.cs" />
  </ItemGroup>
  <Import Project="path\to\Silverlight360\msbuild\XboxSilverlight.targets" />
</Project>
```

Properties you can set:

| Property | Default | |
|---|---|---|
| `XboxRuntimeProfile` | `runtime\plex-2015` | Profile to compile against and package with. |
| `XboxPackageDir` | `bin\<Configuration>\xbox\` | Package output. |
| `XboxSplashScreen`, `XboxSplashScreen480` | `templates\*.jpg` | 1280x720 and 640x480 JPEG splash screens. |

The core framework comes with the runtime and isn't listed in the manifest;
every other reference, the Xbox libraries included, is copied and listed in
the generated `AppManifest.xaml` (XAML can't use types from assemblies the
manifest doesn't list).

### What to keep in mind

- **The language is C# 3 and the API is Silverlight 3** plus the Xbox
  additions. `Action<T1,T2>`, `Func<>` and LINQ live in `System.Core`; add
  that reference to use them. XAML can't use `x:String`; use
  `xmlns:sys="clr-namespace:System;assembly=mscorlib"` and `sys:String`.
- **Controller input** arrives as `GamePadButtonDown`/`Up`,
  `GamePadThumbStickMoved` and `GamePadTriggerMoved` on any `UIElement`, and
  bubbles.
- **Networking**: `WebClient` and `HttpWebRequest` go out through the
  console's XHttp stack; in xenia-edge that's the host's WinHTTP. `127.0.0.1`
  is the PC running the emulator.
- **Unhandled exceptions** make XamlHost quit to the dashboard unless you set
  `e.Handled = true` in `Application.UnhandledException`.
- **The title identity is the donor's.** `default.xex` keeps the donor's
  title ID and name (the window shows `574407D1 Plex` for the default
  profile), and with it the donor's save data and settings.
- **No Xbox LIVE.** LIVE security tokens can't be obtained, so anything
  behind XAuth (Plex sign-in, many partner services) fails. Plain HTTP and
  HTTPS work.

## Calling native code

App code can call the kernel and XAM with `DllImport` by ordinal; see
[docs/native-code.md](docs/native-code.md) and [samples/NativeProbe](samples/NativeProbe).

## Package layout

```
bin\Release\xbox\
  default.xex                  XamlHost, from the profile
  xcoreclr.dll agcore.dll npctrl.dll captions.dll
  mscorlib.dll mscorlib.ni.dll System*.dll Microsoft.Xbox*.dll ...
  Config\machine.config  SystemSounds\  *.ttf  nuisp*  ...
  AppManifest.xaml             generated: entry point and assembly parts
  XboxAppManifest.xml          resolutions and splash screens
  SplashScreenImage.jpg  SplashScreenImage480.jpg
  MyApp.dll                    your code (IL)
```

## Tools

| Script | |
|---|---|
| `tools\extract_god_packages.py <archives> <output> <staging>` | Extracts the Games on Demand packages in `.zip`/`.rar` archives into `<output>\<package title>`. Handles every SVOD layout xenia does. |
| `tools\extract_stfs_package.py <package> <output>` | Extracts an STFS package (CON/LIVE/PIRS), such as a title update. |
| `tools\Get-AppInventory.ps1 -OutJson <file>` | Lists runtime and framework versions of extracted apps. |
| `tools\New-RuntimeProfile.ps1 -DonorApp <app> -Output <profile>` | Makes a runtime profile. |
| `tools\Build-XboxApp.ps1 -Project <csproj> [-RuntimeProfile <profile>]` | Builds and packages a project. |
| `tools\Test-XboxApp.ps1 -Xex <xex> -Output <dir> -Steps ...` | Runs an app in xenia with scripted controller input and screenshots ([docs/testing.md](docs/testing.md)). |
| `tools\Install-ApiDocs.ps1 [-RuntimeProfile <profile>]` | Writes the IntelliSense files into a profile. |
| `tools\Test-ApiDocs.ps1` | Checks the SDK's documentation files against the API. |
| `tools\Get-PublicApi.ps1 -Assembly <dll> -Output <dir>` | Lists an assembly's public API with documentation IDs. |
| `python tools\new_api_reference.py` | Regenerates the Markdown API reference. |

## xenia-edge support

See [docs/xenia-status.md](docs/xenia-status.md) for the pull requests apps
need and what works.

## Not done

- Little console testing: only the PageNavigation sample has been run on a
  console so far.
- No native images for app code. They aren't required, but startup is
  slower than with them.
- The donor's title ID is kept; changing it needs XamlHost's XEX rebuilt.
- Linux and macOS hosts can build nothing (MSBuild 14 and the Silverlight 3
  tools are Windows-only) and xenia-edge's XHttp only has a Windows backend.

## Trademarks

Microsoft, Xbox, Xbox 360, Xbox LIVE, Silverlight, Windows, Visual Studio
and XNA are trademarks or registered trademarks of Microsoft Corporation.
Netflix, YouTube, Hulu, Plex and the other app and service names mentioned
here are trademarks of their respective owners. They are used only to
describe what this project works with. Silverlight360 is an independent
project, not affiliated with, endorsed or sponsored by Microsoft or any of
these companies.
