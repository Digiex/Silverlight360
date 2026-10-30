using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using Microsoft.Xbox.Controls;

namespace PageNavigation.Pages
{
    public partial class HomePage : XboxApplicationPage
    {
        public HomePage()
        {
            InitializeComponent();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);
            // Each navigation makes a new page instance; give it focus so the
            // controller has somewhere to start.
            Dispatcher.BeginInvoke(delegate { First.Focus(); });
        }

        private void Open_Click(object sender, RoutedEventArgs e)
        {
            string topic = (string)((Button)sender).Tag;
            NavigationService.Navigate(new Uri("/Pages/DetailPage.xaml?topic=" + topic + "&depth=1", UriKind.Relative));
        }
    }
}
