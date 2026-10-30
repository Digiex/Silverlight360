using System.Windows;

namespace GamepadInput
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
        }

        private void Application_UnhandledException(object sender, ApplicationUnhandledExceptionEventArgs e)
        {
            // XamlHost quits to the dashboard on an unhandled exception unless
            // it's marked handled.
            e.Handled = true;
        }
    }
}
