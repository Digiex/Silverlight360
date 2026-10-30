using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using System.Xml.Linq;
using Microsoft.Xbox.Controls;

namespace MediaPlayer.Pages
{
    /// <summary>
    /// The files packaged in the app's Media folder, then the ones the test
    /// server offers from its media folder.
    /// </summary>
    public partial class ListPage : XboxApplicationPage
    {
        public ListPage()
        {
            InitializeComponent();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);
            Files.Children.Clear();
            // Packaged media plays from a URI relative to the XAP, without
            // the network.
            foreach (string name in PackagedMedia())
            {
                AddFile(name + "  (in the package)", "Media/" + name);
            }
            Status.Text = "Loading the media list...";
            App.Server.Get("api/media", delegate(string xml, Exception error)
            {
                if (error != null)
                {
                    Status.Text = "Couldn't reach the server: " + error.Message + ". Is samples\\TestServer\\server.py running?";
                }
                else
                {
                    foreach (XElement file in XDocument.Parse(xml).Root.Elements("file"))
                    {
                        AddFile((string)file.Attribute("name"), (string)file.Attribute("url"));
                    }
                }
                if (Files.Children.Count == 0)
                {
                    Status.Text = "No media yet. Put .wmv, .mp4, .wma or .mp3 files in samples\\TestServer\\media, or in this sample's Media folder and rebuild.";
                    return;
                }
                if (error == null)
                {
                    Status.Text = "Pick something to play. In the player, A shows the controls and B comes back here.";
                }
                Control first = (Control)Files.Children[0];
                Dispatcher.BeginInvoke(delegate { first.Focus(); });
            });
        }

        private void AddFile(string name, string url)
        {
            Button button = new Button { Content = name, Style = (Style)Application.Current.Resources["FileButton"] };
            button.Click += delegate
            {
                NavigationService.Navigate(new Uri("/Pages/PlayerPage.xaml?url=" + Uri.EscapeDataString(url) +
                                                   "&name=" + Uri.EscapeDataString(name), UriKind.Relative));
            };
            Files.Children.Add(button);
        }

        /// <summary>The names the build listed in Media/index.txt.</summary>
        private static IEnumerable<string> PackagedMedia()
        {
            var index = Application.GetResourceStream(new Uri("Media/index.txt", UriKind.Relative));
            if (index == null)
            {
                return new string[0];
            }
            using (var reader = new StreamReader(index.Stream))
            {
                return reader.ReadToEnd()
                    .Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries)
                    .ToList();
            }
        }
    }
}
