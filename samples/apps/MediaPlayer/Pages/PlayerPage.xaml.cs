using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using Microsoft.Xbox.Controls;
using XboxSdk.Samples;

namespace MediaPlayer.Pages
{
    /// <summary>
    /// Plays one file. MediaTransport handles the controller itself: A or the
    /// D-pad shows the transport bar, the triggers rewind and fast forward,
    /// B hides the bar and then raises Back.
    /// </summary>
    public partial class PlayerPage : XboxApplicationPage
    {
        private string error;

        public PlayerPage()
        {
            InitializeComponent();
            Player.CurrentStateChanged += delegate
            {
                DebugLog.WriteLine("MediaPlayer: {0} is {1}", Player.Source, Player.CurrentState);
                // Keep a failure message: the player goes to Closed right after.
                if (error == null)
                {
                    Status.Text = Name() + "   " + Player.CurrentState;
                }
            };
            Player.MediaFailed += delegate(object sender, ExceptionRoutedEventArgs e)
            {
                error = e.ErrorException.Message;
                DebugLog.WriteLine("MediaPlayer: {0} failed: {1}", Player.Source, e.ErrorException);
                Status.Text = Name() + "   couldn't be played: " + error;
            };
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);
            // MediaTransport reports every play, pause and seek with this ID
            // (for SmartGlass and usage statistics) and refuses commands
            // without one.
            Transport.MediaAssetId = Name();
            // A server URL, or a path relative to the XAP for packaged media.
            Player.Source = new Uri(NavigationContext.QueryString["url"], UriKind.RelativeOrAbsolute);
            Dispatcher.BeginInvoke(delegate { Transport.Focus(); });
        }

        protected override void OnNavigatedFrom(NavigationEventArgs e)
        {
            // Stop the download and decoder when leaving the page.
            Player.Stop();
            Player.Source = null;
            base.OnNavigatedFrom(e);
        }

        private new string Name()
        {
            return NavigationContext.QueryString["name"];
        }

        private void Transport_Back(object sender, EventArgs e)
        {
            if (NavigationService.CanGoBack)
            {
                NavigationService.GoBack();
            }
        }
    }
}
