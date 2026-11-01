# Contributing to Silverlight360

Contributions and pull requests are welcome: fixes to the build and the tools, documentation for the platform's APIs, guides, samples, testing on a console, and good bug reports.

- **Problems and feature requests** go to [GitHub Issues](https://github.com/Digiex/Silverlight360/issues). Look through the open ones first; the forms ask for what helps. Emulator problems go to [xenia-edge](https://github.com/has207/xenia-edge/issues). See [Problems and ideas](https://digiex.github.io/Silverlight360/issues/).
- **For a new feature, tool or bigger change**, open an issue first, or comment on one, so we can agree on how it should work. A small fix can go straight to a pull request.
- **Pull requests** go against `master`, one change each. Say what it changes and why, which issue it fixes, and how you tested it: which samples or apps, in xenia-edge or on a console. Update the docs in `docs` when what the SDK does changes; regenerate the API reference with `python tools/new_api_reference.py` rather than editing it, and check `docs\api` with `tools\Test-ApiDocs.ps1`.
- **Getting set up**: see [Getting started](https://digiex.github.io/Silverlight360/getting-started/). You need a runtime profile made from an app you have.
- **What can't go in**: files from an Xbox 360 app or a runtime profile (`default.xex`, `xcoreclr.dll`, the framework assemblies), Microsoft's documentation or SDK files, files from a console's firmware, and anything else whose license doesn't allow it.
- **License**: by opening a pull request, you agree that your contribution is licensed under Silverlight360's [license](LICENSE.md), the PolyForm Noncommercial License 1.0.0 with its additional condition.

The full guide is [Contributing](https://digiex.github.io/Silverlight360/contributing/) in the docs.
