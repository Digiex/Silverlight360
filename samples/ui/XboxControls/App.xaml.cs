using System.Windows;

namespace XboxControls
{
    public partial class App : Application
    {
        public App()
        {
            InitializeComponent();
        }

        private void Application_Startup(object sender, StartupEventArgs e)
        {
            RootVisual = new MainPage();
            // Thirty frames in, the app is up and drawing: test scripts stop on this line ("(DbgPrint) XboxControls: ready",
            // Run-App.ps1 -DonePattern), since the app keeps running after it.
            int framesDrawn = 0;
            System.EventHandler ready = null;
            ready = delegate
            {
                if (++framesDrawn == 30)
                {
                    System.Windows.Media.CompositionTarget.Rendering -= ready;
                    XboxSdk.Samples.DebugLog.WriteLine("XboxControls: ready");
                }
            };
            System.Windows.Media.CompositionTarget.Rendering += ready;
        }

        private void Application_UnhandledException(object sender, ApplicationUnhandledExceptionEventArgs e)
        {
            e.Handled = true;
        }
    }
}
