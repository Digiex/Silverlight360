using System;
using System.Windows;
using System.Windows.Navigation;
using Microsoft.Xbox.Controls;

namespace PageNavigation.Pages
{
    public partial class DetailPage : XboxApplicationPage
    {
        private string topic;
        private int depth;

        public DetailPage()
        {
            InitializeComponent();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);
            // Parameters come in on the query string of the page URI.
            topic = NavigationContext.QueryString["topic"];
            depth = int.Parse(NavigationContext.QueryString["depth"]);
            Heading.Text = topic;
            Info.Text = string.Format("Page {0} deep. B goes back to the previous one.", depth);
            Dispatcher.BeginInvoke(delegate { Deeper.Focus(); });
        }

        private void Deeper_Click(object sender, RoutedEventArgs e)
        {
            NavigationService.Navigate(new Uri(
                string.Format("/Pages/DetailPage.xaml?topic={0}&depth={1}", topic, depth + 1), UriKind.Relative));
        }

        private void Home_Click(object sender, RoutedEventArgs e)
        {
            // Unwind the back stack rather than navigating forward to a new
            // home page, so B on the home page has nothing left to go back to.
            App.GoHome();
        }
    }
}
