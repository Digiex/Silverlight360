using System;
using System.IO;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Threading;
using Microsoft.Xbox.Controls;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.GamerServices;
using Microsoft.Xna.Framework.Storage;

namespace PlatformCalls
{
    /// <summary>
    /// Runs the three platform paths the video apps hit after startup:
    /// saving settings through an XNA storage container (encrypted files),
    /// keeping a disk cache on the cache drive, and sending commands through
    /// the playback bar, which reports media state to SmartGlass. Each runs
    /// once on load and again from its button.
    /// </summary>
    public partial class MainPage : UserControl
    {
        private const string TestText = "Saved by the platform call test";

        private MediaTransport transport;

        public MainPage()
        {
            InitializeComponent();
            // What XboxApplicationFrame does for the apps: storage containers
            // need GamerServices running.
            if (!GamerServicesDispatcher.IsInitialized)
            {
                GamerServicesDispatcher.Initialize(null);
            }
            CompositionTarget.Rendering += delegate
            {
                FrameworkDispatcher.Update();
                GamerServicesDispatcher.Update();
            };
            Loaded += delegate
            {
                SaveButton.Focus();
                TestEncryptedSave();
                TestCacheDrive();
                // Later, so the storage results show even if this one hangs.
                DispatcherTimer timer = new DispatcherTimer();
                timer.Interval = TimeSpan.FromSeconds(8);
                timer.Tick += delegate
                {
                    timer.Stop();
                    TestPlaybackBar();
                };
                timer.Start();
            };
        }

        public void Report(string test, object result)
        {
            Exception error = result as Exception;
            string line = error != null
                ? test + ": FAILED " + error.GetType().Name + ": " + error.Message
                : test + ": " + result;
            ResultsText.Text += line + "\n";
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            TestEncryptedSave();
        }

        private void CacheButton_Click(object sender, RoutedEventArgs e)
        {
            TestCacheDrive();
        }

        private void PlaybackButton_Click(object sender, RoutedEventArgs e)
        {
            TestPlaybackBar();
        }

        // Like YouTube's SettingPersister and Netflix's persistent storage:
        // open the title's container, write a file, read it back.
        private void TestEncryptedSave()
        {
            const string test = "Encrypted save";
            try
            {
                StorageDevice device = new StorageDevice();
                device.BeginOpenContainer("Platform call test", "PlatformCalls", delegate(IAsyncResult ar)
                {
                    Dispatcher.BeginInvoke((Action)delegate
                    {
                        try
                        {
                            using (StorageContainer container = device.EndOpenContainer(ar))
                            {
                                Report(test, RoundTrip(container, "settings.txt"));
                            }
                        }
                        catch (Exception ex)
                        {
                            Report(test, ex);
                        }
                    });
                }, null);
            }
            catch (Exception ex)
            {
                Report(test, ex);
            }
        }

        // Like Netflix, Plex and Crackle's disk caches: mount the cache
        // drive, write a file, read it back, unmount.
        private void TestCacheDrive()
        {
            const string test = "Cache drive";
            try
            {
                CacheContainer.BeginOpenCacheContainer(delegate(IAsyncResult ar)
                {
                    Dispatcher.BeginInvoke((Action)delegate
                    {
                        try
                        {
                            using (CacheContainer cache = CacheContainer.EndOpenCacheContainer(ar))
                            {
                                Report(test, RoundTrip(cache, "cache.txt"));
                            }
                        }
                        catch (Exception ex)
                        {
                            Report(test, ex);
                        }
                    });
                }, null);
            }
            catch (Exception ex)
            {
                Report(test, ex);
            }
        }

        // Like the players' fast forward and rewind: every command reports
        // the transport state to SmartGlass.
        private void TestPlaybackBar()
        {
            const string test = "Playback bar";
            try
            {
                if (transport == null)
                {
                    // Playback bar like the video apps use, driven from code.
                    transport = new MediaTransport();
                    transport.MediaAssetId = "platform-calls-test";
                    transport.VerticalAlignment = VerticalAlignment.Bottom;
                    transport.MediaElement = Player;
                    LayoutRoot.Children.Add(transport);
                }
                transport.ExecuteMediaCommand(System.Windows.Media.MediaCommand.Play);
                transport.ExecuteMediaCommand(System.Windows.Media.MediaCommand.Pause);
                Report(test, "OK, sent play and pause");
            }
            catch (Exception ex)
            {
                Report(test, ex);
            }
        }

        private static string RoundTrip(StorageContainer container, string file)
        {
            string text = TestText + " at " + DateTime.Now.ToString("HH:mm:ss");
            using (Stream stream = container.CreateFile(file))
            {
                byte[] bytes = Encoding.UTF8.GetBytes(text);
                stream.Write(bytes, 0, bytes.Length);
            }
            using (Stream stream = container.OpenFile(file, FileMode.Open))
            using (StreamReader reader = new StreamReader(stream, Encoding.UTF8))
            {
                string read = reader.ReadToEnd();
                return read == text ? "OK, wrote and read back \"" + read + "\"" : "MISMATCH, read \"" + read + "\"";
            }
        }
    }
}
