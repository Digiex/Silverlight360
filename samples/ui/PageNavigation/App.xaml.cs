using System;
using System.Windows;
using System.Windows.Input;
using System.Windows.Navigation;
using Microsoft.Xbox.Controls;

namespace PageNavigation
{
    /// <summary>
    /// The app's root is an XboxApplicationFrame, a navigation Frame that
    /// plays the Xbox page transitions and starts GamerServices. Pages are
    /// XboxApplicationPage XAML files navigated to by URI.
    /// </summary>
    public partial class App : Application
    {
        private XboxApplicationFrame frame;

        public App()
        {
            InitializeComponent();
        }

        private void Application_Startup(object sender, StartupEventArgs e)
        {
            frame = new XboxApplicationFrame();
            frame.Source = new Uri("/Pages/HomePage.xaml", UriKind.Relative);
            // B goes back a page. Pages see the button first (it bubbles up
            // from the focused control) and can handle it themselves.
            frame.GamePadButtonDown += delegate(object s, GamePadButtonEventArgs args)
            {
                if (args.Button == GamePadButton.B && frame.CanGoBack)
                {
                    frame.GoBack();
                    args.Handled = true;
                }
            };
            RootVisual = frame;
        }

        /// <summary>
        /// Goes back to the first page. Navigation is asynchronous, so this
        /// steps back once per completed navigation instead of looping.
        /// </summary>
        public static void GoHome()
        {
            XboxApplicationFrame frame = ((App)Current).frame;
            if (!frame.CanGoBack)
            {
                return;
            }
            NavigatingCancelEventHandler watch = null;
            NavigatedEventHandler step = null;
            // A handler left attached would send every later navigation
            // straight back to the first page, so any navigation that isn't
            // a step back ends the walk before it completes.
            watch = delegate(object sender, NavigatingCancelEventArgs e)
            {
                if (e.NavigationMode != NavigationMode.Back)
                {
                    frame.Navigating -= watch;
                    frame.Navigated -= step;
                }
            };
            // Take the next step once the previous one has settled.
            step = delegate
            {
                frame.Dispatcher.BeginInvoke(delegate
                {
                    if (frame.CanGoBack)
                    {
                        frame.GoBack();
                    }
                    else
                    {
                        frame.Navigating -= watch;
                        frame.Navigated -= step;
                    }
                });
            };
            frame.Navigating += watch;
            frame.Navigated += step;
            frame.GoBack();
        }

        private void Application_UnhandledException(object sender, ApplicationUnhandledExceptionEventArgs e)
        {
            e.Handled = true;
        }
    }
}
