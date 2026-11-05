# The app's title

Every Xbox 360 executable can declare a title: a title ID, a version and a media ID, in its header's execution info. A donor app's `default.xex` declares the donor's title (Plex, `574407D1`, v0.0.0.7) and carries the title's own resource, named after the title ID, with its name, tile and presence strings.

## Default: no title

`tools\New-RuntimeProfile.ps1` takes the donor's title out of the profile's `default.xex` (`tools\Remove-DonorTitle.ps1`):

- the execution info goes, so the executable declares no title, as homebrew executables don't;
- the title's resource goes from the resource directory, and its bytes in the image are zeroed;
- the header digest is computed again.

The donor's binaries are otherwise untouched. An app built on that profile:

- **gets no title updates.** A console signed in to LIVE checks a title for updates when it starts; with the donor's title it offered the donor's title update, and an app started again within seconds of starting had it installed every time.
- **doesn't show as the donor.** The console runs it as its own dashboard title, `FFFE07D1` (`XamGetCurrentTitleId`), with no name or tile of the donor's.
- **has no per-title services of its own.** Whatever the console keeps per title goes by the title it runs the app as, the dashboard's, not the app's. Keep the app's files in its own folder instead: an app runs from a folder on the hard drive or a USB drive, which it can write to with the kernel's file calls (see [Native code](native-code.md)).

`profile.json` records which kind a profile is: `DonorTitle` is `false` for one without the title.

## Keeping the donor's title

Make a profile with `-KeepTitle` for an app that needs a title of its own, and build against it:

```powershell
.\tools\New-RuntimeProfile.ps1 -DonorApp '<extracted Plex v0.0.0.7>' -Output .\runtime\plex-2015-title -KeepTitle
.\tools\Build-XboxApp.ps1 -Project <csproj> -RuntimeProfile .\runtime\plex-2015-title
```

Or set `XboxRuntimeProfile` in the project (see [Projects and Visual Studio](project-setup.md)). It's needed for:

- **storage and cache containers** (`Microsoft.Xbox.Storage`, [Storage](storage.md)): the title's save area for the user and the console's cache are per title.
- **presence and other per-title gamer services** ([Gamer services](gamer-services.md)): rich presence strings come from the title's resource.
- **the donor's title updates**, wanted or not: a console signed in to LIVE offers them, and Plex's applies only to v0.0.0.7 (see [Getting started](getting-started.md)).

Signing in and the signed-in gamer's gamertag work either way.

The samples that keep data in a storage container, `apps\CatalogBrowser` (favourites) and `PlatformCalls`, need a profile with the title.
