# Getting started

## What you need

- Windows with **MSBuild 14 or later**: Visual Studio 2015 to 2026, or their Build Tools (see [Projects and Visual Studio](project-setup.md)).
- The **Silverlight 3 SDK** (3.0.40818, the platform's version), whose build folder (`MSBuild\Microsoft\Silverlight\v3.0`) compiles the C# and XAML. Microsoft no longer offers it; see [Getting the Silverlight 3 SDK](#getting-the-silverlight-3-sdk).
- An **extracted Xbox 360 Silverlight app**. Every app ships its own copy of the platform, and the SDK builds against it. Plex has the newest platform of the shipped apps; the default profile uses Plex v0.0.0.7, a Games on Demand package. For example, Digiex has the [Plex app for Xbox 360](https://digiex.net/threads/plex-app-download-for-xbox-360.14043/) (its `PlexApp_v0.0.1.7.zip` holds v0.0.0.7 and its title update), and other apps in its [Xbox 360 apps forum](https://digiex.net/forums/apps-xbox-360.83/). `tools\Expand-GodPackage.ps1` extracts the package from the download, with nothing else installed:

  ```powershell
  .\tools\Expand-GodPackage.ps1 $env:USERPROFILE\Downloads\PlexApp_v0.0.1.7.zip -Output ..\apps
  ```

  That gives `..\apps\Plex`, the folder to pass as `-DonorApp`.
- Optional: **Python 3.7 or later** for the test server, and **7-Zip 15.06 or later** for a `.rar` app download Windows' `tar.exe` can't open.
- **xenia-edge** to run the apps: the `silverlight-build` branch of [jessenic/xenia-edge](https://github.com/jessenic/xenia-edge/tree/silverlight-build), which native images need. Its binary build is the [silverlight-build-20261105 release](https://github.com/jessenic/xenia-edge/releases/tag/silverlight-build-20261105), which step 1 downloads if you have no xenia-edge (see [Status under xenia](xenia-status.md)).
- Optional, for more IntelliSense text: the Silverlight 4 SDK and XNA Game Studio 4.
- Optional, for a native library (DLL) of the app's own in C: [xsdk](https://github.com/xenosworks/xsdk)'s DLL support and toolchain in WSL ([Samples](samples.md), NativeLibrary).

### Getting the Silverlight 3 SDK

Microsoft no longer offers the Silverlight 3 SDK for download. Download `Silverlight3_sdk.zip`, attached to the [Silverlight360 thread on Digiex](https://digiex.net/threads/silverlight360-c-xaml-sdk-for-the-xbox-360.20115/), and unzip it. It has the SDK's installer, `silverlight_sdk.msi` with its `silverlight_sdk.cab` (signed by Microsoft, as on Visual Studio 2010's install disc), and its build folder's six files in `Extracted`. Then either:

- **Install it**: run `silverlight_sdk.msi`. It needs nothing else installed, and it also gives `Install-ApiDocs.ps1` the Silverlight 3 documentation for IntelliSense.
- **Or copy only its build folder**, which is all a build uses, with these commands in an administrator PowerShell in the unzipped folder:

```powershell
$target = "${env:ProgramFiles(x86)}\MSBuild\Microsoft\Silverlight\v3.0"
New-Item -ItemType Directory $target -Force | Out-Null
Copy-Item Extracted\* $target
```

The Silverlight 4 and 5 SDKs don't include it and can't stand in for it: their XAML compiler rejects the Xbox controls' content.

## 1. Configure

```powershell
.\tools\Configure.ps1
```

Run it first. It checks each of the above, says how to get any that's missing, and saves where everything is in `config.json` at the repository's root (ignored by git), which the other tools read. It also downloads [XboxNGen](https://github.com/Digiex/Silverlight360-XboxNGen), which makes the native images the builds get (see [Native images](native-images.md)), and runs XboxNGen's own configure script, which finds your xenia-edge or offers to download the build XboxNGen needs. Run it again after installing something it reported missing; `-Show` prints what it saved.

The runtime profile, the next step, is reported missing until you make it. `Configure.ps1 -DonorApp '<extracted Plex v0.0.0.7>'` makes it for you.

## 2. Make a runtime profile

A runtime profile is the platform copied out of one app: the native host and runtime (`package\`) and the framework assemblies to compile against (`reference\`). Every build starts from it.

```powershell
.\tools\New-RuntimeProfile.ps1 -DonorApp '<extracted Plex v0.0.0.7>' -Output .\runtime\plex-2015
```

The script takes the donor's title out of the profile's `default.xex`, so your app declares no title and the console offers it none of Plex's title updates (see [The app's title](title.md)). Without a title there's no title storage or presence; an app that needs them is built on a profile made with `-KeepTitle`.

With the title kept, use Plex v0.0.0.7, the base version Plex's last title update (v0.0.1.7) applies to. A package then runs as the donor's title (Plex, `574407D1`) at the donor's version. A console signed in to LIVE asks for an update when that version is older than the current one, and Plex's title update only applies to v0.0.0.7. Accept the update and the console installs Plex's title update, which then patches your package to v0.0.1.7 as it loads. The platform code is the same, and your app runs as before; xenia-edge does the same when that update is in its content folder. A profile made from the older v0.0.0.4 gets the update prompt but can't take the update.

The script finishes by installing the IntelliSense files into `reference\` (`tools\Install-ApiDocs.ps1`; run it again after updating the SDK's docs).

The profile holds Microsoft's and the donor app's binaries. It stays on your machine; `runtime\` is ignored by git.

## 3. Build a sample

```powershell
.\tools\Build-XboxApp.ps1 -Project .\samples\ui\FocusNavigation\FocusNavigation.csproj
```

The package lands in `samples\ui\FocusNavigation\bin\Release\xbox\`. Its `default.xex` is the platform's host; your code is `FocusNavigation.dll`, plain IL next to it, and `FocusNavigation.ni.dll`, its native image, which the script makes after the build by running the package in xenia-edge for a few seconds. `-NoNGen` leaves the image out and the code runs interpreted ([Native images](native-images.md)).

## 4. Run it

```powershell
& (.\tools\Config.ps1 Xenia) samples\ui\FocusNavigation\bin\Release\xbox\default.xex
```

`.\tools\Config.ps1 Xenia` gives the `xenia_edge.exe` step 1 set up.

Use a controller, or xenia's keyboard input (`--hid=keyboard`): Shift+W/A/S/D is the D-pad, W/A/S/D the left stick, `;` is A and `'` is B (the last two depend on the keyboard layout).

The samples that talk to a server need the test server running in another window:

```powershell
python samples\TestServer\server.py
```

## 5. Make your own app

Copy a sample close to what you want; `samples\ui\PageNavigation` is a good start for a multi-page app. Then read [Projects and Visual Studio](project-setup.md) and [App model](app-model.md).

Things that trip people up:

- **Nothing has focus at startup.** Controller input goes to the focused element, so focus something in `Loaded` or `OnNavigatedTo`.
- **The D-pad doesn't move focus by itself** outside a `Pivot`. Use `DirectionalFocus` from [the common library](common-library.md) or a `PivotItem` with a `Grid` (see [Input and focus](input-and-focus.md)).
- **Unhandled exceptions quit the app.** Set `e.Handled = true` in `Application.UnhandledException` while developing.
- **Controls from `Microsoft.Xbox` need their assembly in the manifest.** The SDK does this for every Xbox library you reference; don't mark those references `Private=false`.
- **The title is the donor's.** The package keeps the donor app's title ID and name, and with them its saved data.
