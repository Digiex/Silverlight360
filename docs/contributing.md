# Contributing

Contributions are welcome: fixes to the build and the tools, documentation for the platform's APIs, guides, samples, testing apps on a console, and good bug reports. Pull requests go to [GitHub](https://github.com/Digiex/Silverlight360/pulls).

## Ways to help

- **Report problems and ideas** on [GitHub Issues](https://github.com/Digiex/Silverlight360/issues): see [Problems and ideas](issues.md).
- **Test on a console**: little has been run on one so far, so what works and what doesn't on real hardware is worth a lot.
- **Document the platform**: the API reference comes from the files in `docs\api`, and every Xbox type and member there could use better text and examples.
- **Write guides and samples** for what the platform can do and isn't shown yet.
- **Fix something or add a feature** with a pull request.

## Before you start

For a small fix, a pull request on its own is fine. For a new feature, a new tool or a bigger change, open an [issue](https://github.com/Digiex/Silverlight360/issues) first, or comment on one that's there, so we can agree on how it should work before you spend time on it. Issues labelled [good first issue](https://github.com/Digiex/Silverlight360/labels/good%20first%20issue) and [help wanted](https://github.com/Digiex/Silverlight360/labels/help%20wanted) are a good place to start.

## Making a change

1. Fork the repository and make a branch from `master`.
2. Set up the tools and a runtime profile: see [Getting started](getting-started.md).
3. Make the change, in the style of the code and the docs around it.
4. Check it:
    - The samples still build with `tools\Build-XboxApp.ps1`, and the ones your change touches run in xenia-edge (`tools\Test-XboxApp.ps1`, see [Testing in xenia](testing.md)) or on a console.
    - After changing the API documentation in `docs\api`, `tools\Test-ApiDocs.ps1` passes and `python tools\new_api_reference.py` has regenerated the [API reference](reference/README.md); the reference pages aren't edited by hand.
    - The docs build: `python -m mkdocs build --strict`.
5. Update the docs when you change what the SDK does or how it's used, and [Status under xenia](xenia-status.md) when you find what works in the emulator.
6. Open a pull request against `master`.

## Pull requests

- Keep each one to one change, so it's easy to review; a fix and an unrelated feature are two pull requests.
- Say what it changes and why, which issue it fixes (`Fixes #12`), and how you tested it: which samples or apps, in xenia-edge (which build) or on a console.
- Screenshots help for anything on screen: `tools\Test-XboxApp.ps1` takes them.
- Commit messages say what the change does, in a short first line, such as "Add an app-only build, for handing an app out".

## What can't go in

The SDK works from a platform that isn't ours, so a pull request can't add:

- **Files from an Xbox 360 app or a runtime profile**: `default.xex`, `xcoreclr.dll`, `agcore.dll`, the framework assemblies, native images, or anything else in a profile's `package` or `reference` folder. Each user makes their own profile from an app they have.
- **Microsoft's documentation or SDK files**, such as text copied from the Silverlight, .NET or XNA reference files `Install-ApiDocs.ps1` reads on your machine, or anything from the Xbox 360 SDK. Describe what you found in your own words.
- **Anything taken from a console's firmware** or from other projects whose licenses don't allow it.

## License

Silverlight360 is licensed under the [PolyForm Noncommercial License 1.0.0](https://github.com/Digiex/Silverlight360/blob/master/LICENSE.md) with an additional condition. By opening a pull request, you agree that your contribution is licensed under the same terms.
