using System;
using System.Windows;
using System.Windows.Input;
using Microsoft.Xbox.Controls;
using XboxSdk.Samples;

namespace CatalogBrowser
{
    public partial class App : Application
    {
        private XboxApplicationFrame frame;

        public App()
        {
            InitializeComponent();
        }

        /// <summary>The app-wide services the pages share.</summary>
        public static Catalog Catalog { get; private set; }
        public static PosterCache Posters { get; private set; }
        public static Favorites Favorites { get; private set; }

        private void Application_Startup(object sender, StartupEventArgs e)
        {
            ServerClient server = new ServerClient((string)Resources["ServerUrl"]);
            Catalog = new Catalog(server);
            Posters = new PosterCache();
            Favorites = new Favorites();

            // XboxApplicationFrame also starts GamerServices, which the
            // gamertag display and the storage container need.
            frame = new XboxApplicationFrame();
            frame.Source = new Uri("/Pages/HomePage.xaml", UriKind.Relative);
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

        private void Application_UnhandledException(object sender, ApplicationUnhandledExceptionEventArgs e)
        {
            e.Handled = true;
        }
    }
}
