# Gamer services

`Microsoft.Xbox.Services` is the platform's build of XNA gamer services (`Microsoft.Xna.Framework.GamerServices`), with Xbox additions for Kinect versions of the system screens, social networks, presence and parental ratings.

## Starting it

GamerServices has to be initialized, then pumped regularly. `XboxApplicationFrame` does both; without it, see [App model](app-model.md#xboxapplicationframe). Sign-in changes, `SignedIn` and `SignedOut`, and `Guide.IsVisible` only update while it's pumped, and presence changes are only sent then.

## The signed-in gamer

```csharp
SignedInGamer gamer = Gamer.SignedInGamers.Count > 0 ? Gamer.SignedInGamers[0] : null;
GamerText.Text = gamer != null ? "Signed in as " + gamer.Gamertag : "Not signed in";
```

`samples\apps\CatalogBrowser` shows the gamertag. Under xenia it's the emulator's profile name.

## System screens

The XNA `Guide` methods, plus `SignedInGamer.ShowFriends`, `ShowGamerCard`, `ShowComposeMessage`, `ShowParty` and others, open the console's own screens. A few points:

- **One at a time:** only one system screen can be open; opening another throws `GuideAlreadyVisibleException`.
- **Kinect versions:** overloads that take a `trackingId` show the Kinect version of the screen for that tracked user. `NuiGuide` has the Kinect-required, controller-required and troubleshooting screens.
- **Text limits:** message boxes take 1 to 3 buttons, and titles, text and keyboard fields must be under 256 characters.

Under xenia, most of these screens aren't implemented: the calls return without showing anything.

## Threading and async calls

Completion callbacks of the `Begin...`/`End...` methods and of the `...Async` events run on thread-pool threads, so use `Dispatcher.BeginInvoke` for UI. Many of the events are static and pass `sender` as null; use the `userState` argument to tell your requests apart.

## What needs Xbox LIVE

Marketplace, purchase receipts, social network tokens and XAuth tokens need an Xbox LIVE sign-in, which isn't available, so they fail. Missing sign-in or privileges throws `GamerPrivilegeException`. `PresenceModeString` must be a mode defined in the title's LIVE configuration, or it throws `ArgumentException`.

## Parental controls

`ContentRating` with `CanAccess`/`CanAccessAsync`, and `SignedInGamer.GetRating`, check content against the console's family settings.
