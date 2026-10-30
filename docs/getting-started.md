# Getting started

## What you need

- Windows with **MSBuild 14** (Visual Studio 2015 or its Build Tools). Newer Visual Studio versions can open and build the projects too (see [Projects and Visual Studio](project-setup.md)).
- The **Silverlight 3 tools and SDK**, which provide the C# and XAML build tasks and the Silverlight 3 reference assemblies.
- **Windows SDK 7.0A**, which the Silverlight build tasks use.
- An **extracted Xbox 360 Silverlight app**. Every app ships its own copy of the platform, and the SDK builds against it. Plex has the newest platform of the shipped apps; the default profile uses Plex v0.0.0.7, a Games on Demand package (`tools\extract_god_packages.py` extracts those).
- **Python 3** for the test server and the extraction tools.
- **[xenia-edge](https://github.com/has207/xenia-edge)** with the Silverlight work to run the apps (see [Status under xenia](xenia-status.md)).
- Optional, for IntelliSense text on the standard APIs: XNA Game Studio 4. Silverlight 3 is required anyway.

## 1. Make a runtime profile

A runtime profile is the platform copied out of one app: the native host and runtime (`package\`) and the framework assemblies to compile against (`reference\`). Every build starts from it.

```powershell
.\tools\New-RuntimeProfile.ps1 -DonorApp '<extracted Plex v0.0.0.7>' -Output .\runtime\plex-2015
```

Use Plex v0.0.0.7, the base version Plex's last title update (v0.0.1.7) applies to. A package runs as the donor's title (Plex, `574407D1`) at the donor's version. A console signed in to LIVE asks for an update when that version is older than the current one, and Plex's title update only applies to v0.0.0.7. Accept the update and the console installs Plex's title update, which then patches your package to v0.0.1.7 as it loads. The platform code is the same, and your app runs as before; xenia-edge does the same when that update is in its content folder. A profile made from the older v0.0.0.4 gets the update prompt but can't take the update.

The script finishes by installing the IntelliSense files into `reference\` (`tools\Install-ApiDocs.ps1`; run it again after updating the SDK's docs).

The profile holds Microsoft's and the donor app's binaries. It stays on your machine; `runtime\` is ignored by git.

## 2. Build a sample

```powershell
.\tools\Build-XboxApp.ps1 -Project .\samples\ui\FocusNavigation\FocusNavigation.csproj
```

The package lands in `samples\ui\FocusNavigation\bin\Release\xbox\`. Its `default.xex` is the platform's host; your code is `FocusNavigation.dll`, plain IL next to it.

## 3. Run it

```powershell
xenia_edge.exe samples\ui\FocusNavigation\bin\Release\xbox\default.xex
```

`xenia_edge.exe` is your xenia-edge build (`build\bin\Windows\Release` in its folder).

Use a controller, or xenia's keyboard input (`--hid=keyboard`): Shift+W/A/S/D is the D-pad, W/A/S/D the left stick, `;` is A and `'` is B (the last two depend on the keyboard layout).

The samples that talk to a server need the test server running in another window:

```powershell
python samples\TestServer\server.py
```

## 4. Make your own app

Copy a sample close to what you want; `samples\ui\PageNavigation` is a good start for a multi-page app. Then read [Projects and Visual Studio](project-setup.md) and [App model](app-model.md).

Things that trip people up:

- **Nothing has focus at startup.** Controller input goes to the focused element, so focus something in `Loaded` or `OnNavigatedTo`.
- **The D-pad doesn't move focus by itself** outside a `Pivot`. Use the samples' `DirectionalFocus` helper or a `PivotItem` with a `Grid` (see [Input and focus](input-and-focus.md)).
- **Unhandled exceptions quit the app.** Set `e.Handled = true` in `Application.UnhandledException` while developing.
- **Controls from `Microsoft.Xbox` need their assembly in the manifest.** The SDK does this for every Xbox library you reference; don't mark those references `Private=false`.
- **The title is the donor's.** The package keeps the donor app's title ID and name, and with them its saved data.
