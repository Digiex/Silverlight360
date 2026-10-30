using System;
using System.Windows;
using System.Windows.Input;
using Microsoft.Xbox.Controls;
using XboxSdk.Samples;

namespace MediaPlayer
{
    public partial class App : Application
    {
        private XboxApplicationFrame frame;

        public App()
        {
            InitializeComponent();
        }

        public static ServerClient Server { get; private set; }

        private void Application_Startup(object sender, StartupEventArgs e)
        {
            Server = new ServerClient((string)Resources["ServerUrl"]);
            // MediaTransport needs GamerServices (screen saver control),
            // which XboxApplicationFrame starts.
            frame = new XboxApplicationFrame();
            frame.Source = new Uri("/Pages/ListPage.xaml", UriKind.Relative);
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
