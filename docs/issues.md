# Problems and ideas

Problems and feature requests go to [GitHub Issues](https://github.com/Digiex/Silverlight360/issues), where they're kept track of until they're fixed or done. You need a GitHub account, which is free.

Before you open one, look through the [open issues](https://github.com/Digiex/Silverlight360/issues) in case it's there already. A 👍 on an issue says you'd like it too, and a comment can add what's different for you.

Some problems belong elsewhere:

- **The emulator itself**: a crash or a missing kernel or XAM function in xenia-edge that isn't the SDK's doing goes to [xenia-edge's issues](https://github.com/has207/xenia-edge/issues). [Status under xenia](xenia-status.md) lists what's known not to work yet.
- **Silverdash360**, the dashboard built with the SDK, has [its own issues](https://github.com/Digiex/Silverdash360/issues).

## Reporting a problem

[Report the problem](https://github.com/Digiex/Silverlight360/issues/new?template=bug_report.yml). The form asks for:

- **Where**: making a runtime profile, building, running in xenia-edge or on a console, a sample, or the docs.
- **What happened**, and what you expected instead, with error messages as text.
- **How to make it happen**: the commands you ran, or the smallest app or sample that shows it. A repository or a zip of the project helps most.
- **The SDK's version**: the commit you have (`git rev-parse --short HEAD`).
- **The runtime profile**: the app it was made from, such as Plex v0.0.0.7, and whether `-KeepTitle` was given.
- **Where it runs**: the xenia-edge commit or build, or the console and its system version.
- **The log**: the build output, xenia's log (`Test-XboxApp.ps1` prints its path) or your app's debug output (see [Testing in xenia](testing.md#debug-output)).

Don't attach a runtime profile or files from an Xbox 360 app: they're Microsoft's and the app's, not ours to share. Name the app and its version instead.

## Asking for a feature

[Request a feature](https://github.com/Digiex/Silverlight360/issues/new?template=feature_request.yml): something the build or the tools could do, a platform API that needs documenting or an easier way to use, or a sample or guide that would help. Say what you're making and what it would help you with.

To make it yourself, see [Contributing](contributing.md): pull requests are welcome.
