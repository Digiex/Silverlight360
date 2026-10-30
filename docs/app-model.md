# App model

## Startup

XamlHost (`default.xex`) starts the CLR, reads `AppManifest.xaml`, loads the entry assembly and creates the `Application` class named there. As in any Silverlight app, `Startup` sets `RootVisual`:

```csharp
private void Application_Startup(object sender, StartupEventArgs e)
{
    RootVisual = new MainPage();
}
```

The screen is 1280x720. Design pages at that size and keep important content inside the title-safe area, the inner 90% (64 pixels from the left and right, 36 from the top and bottom), because TVs crop the edges.

## XboxApplicationFrame

Apps with more than one page use `XboxApplicationFrame` (`Microsoft.Xbox.Controls`) as the root. It's a navigation `Frame` that also:

- **Starts GamerServices**: it calls `GamerServicesDispatcher.Initialize`, then pumps `GamerServicesDispatcher.Update` and `FrameworkDispatcher.Update` every frame. Signed-in gamer information, the Guide, storage containers and `MediaTransport`'s screen-saver control depend on that.
- **Initializes the UI sounds.**
- **Plays the page transitions** set with `TransitionService`.
- **Hosts the one `VuiBar`** used for speech, in its template.

```csharp
private void Application_Startup(object sender, StartupEventArgs e)
{
    var frame = new XboxApplicationFrame();
    frame.Source = new Uri("/Pages/HomePage.xaml", UriKind.Relative);
    RootVisual = frame;
}
```

Without the frame, an app that uses gamer services or storage has to start GamerServices itself. The PlatformCalls sample does:

```csharp
if (!GamerServicesDispatcher.IsInitialized)
{
    GamerServicesDispatcher.Initialize(null);
}
CompositionTarget.Rendering += delegate
{
    FrameworkDispatcher.Update();
    GamerServicesDispatcher.Update();
};
```

## Pages and navigation

Pages are `XboxApplicationPage` XAML files (a `Page` with Xbox transitions):

```xml
<xbox:XboxApplicationPage x:Class="MyApp.Pages.HomePage"
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:xbox="clr-namespace:Microsoft.Xbox.Controls;assembly=Microsoft.Xbox">
  ...
</xbox:XboxApplicationPage>
```

Navigate by URI. Parameters go on the query string and come back in `NavigationContext.QueryString`:

```csharp
NavigationService.Navigate(new Uri("/Pages/DetailPage.xaml?id=7", UriKind.Relative));

protected override void OnNavigatedTo(NavigationEventArgs e)
{
    base.OnNavigatedTo(e);
    int id = int.Parse(NavigationContext.QueryString["id"]);
    Dispatcher.BeginInvoke(delegate { FirstButton.Focus(); });
}
```

- **Every navigation creates a new page instance.** Keep state that must survive in the `App` class or a static field, and focus something in `OnNavigatedTo`.
- **Navigation is asynchronous.** To go back several pages, call `GoBack()` again from the frame's `Navigated` event rather than in a loop, through `Dispatcher.BeginInvoke` so the back stack has settled. Detach the handlers when the walk ends, and also when a `Navigating` event comes with a `NavigationMode` other than `Back`. A handler left attached sends every later navigation back to the first page. On the console that happened a few pages deep. See `App.GoHome` in `samples\ui\PageNavigation`.

### Transitions

`XboxApplicationPage` slides pages in and out (`ZIndexTransition`) by default. Elements marked with `TransitionService.TransitionTarget="True"` animate on their own, staggered by `TransitionService.TransitionOrder`, with each step 160 ms later:

```xml
<TextBlock Text="Title" transitions:TransitionService.TransitionTarget="True"
           transitions:TransitionService.TransitionOrder="0" />
<Button Content="First" transitions:TransitionService.TransitionTarget="True"
        transitions:TransitionService.TransitionOrder="1" />
```

with `xmlns:transitions="clr-namespace:Microsoft.Xbox.Transitions;assembly=Microsoft.Xbox"`.

## Back and exit

B is the back button by convention, and the app handles it. A frame-level handler sees B after the focused control has had its chance:

```csharp
frame.GamePadButtonDown += delegate(object s, GamePadButtonEventArgs args)
{
    if (args.Button == GamePadButton.B && frame.CanGoBack)
    {
        frame.GoBack();
        args.Handled = true;
    }
};
```

`Application.Current.Shutdown()`, an Xbox addition, ends the app and returns to the dashboard. Shipped apps ask first (with `Guide.BeginShowMessageBox`) when B is pressed on the first page.

## Unhandled exceptions

An exception nobody catches reaches `Application.UnhandledException`. Unless the handler sets `e.Handled = true`, XamlHost quits to the dashboard. While developing, handle it and show the message on screen; the samples' `App` classes all do.

## Threading

The UI thread runs the app. Network callbacks from `WebClient` arrive on the UI thread. Storage, cache container and gamer services callbacks (`Begin...`/`End...`, `...Async` completion events) arrive on other threads, so use `Dispatcher.BeginInvoke` before touching the UI (see [Storage](storage.md) and [Gamer services](gamer-services.md)).
