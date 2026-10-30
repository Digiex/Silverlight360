using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Threading;

namespace HelloXbox
{
    public partial class MainPage : UserControl
    {
        private const int MaxLogLines = 6;

        private readonly ServerClient server;
        private readonly DispatcherTimer timer = new DispatcherTimer();
        private readonly List<string> log = new List<string>();
        private int echoCount;

        public MainPage()
        {
            InitializeComponent();
            server = new ServerClient((string)Application.Current.Resources["ServerUrl"]);
            ServerText.Text = "Server: " + server.BaseUri;
            timer.Interval = TimeSpan.FromSeconds(5);
            timer.Tick += delegate { RequestTime(); };
            Loaded += MainPage_Loaded;
            // The Xbox runtime raises controller events on any focused element
            // and lets them bubble here.
            GamePadButtonDown += MainPage_GamePadButtonDown;
        }

        private void MainPage_Loaded(object sender, RoutedEventArgs e)
        {
            EchoButton.Focus();
            server.Get("api/hello", delegate(string result, Exception error)
            {
                if (error != null)
                {
                    GreetingText.Text = "Couldn't reach the server.";
                    AddLog("GET /api/hello failed: " + error.Message);
                    return;
                }
                GreetingText.Text = result.Trim();
                AddLog("GET /api/hello -> " + result.Trim());
            });
            RequestTime();
            timer.Start();
        }

        private void RequestTime()
        {
            server.Get("api/time", delegate(string result, Exception error)
            {
                if (error != null)
                {
                    TimeText.Text = "Server time: unavailable";
                    AddLog("GET /api/time failed: " + error.Message);
                    return;
                }
                TimeText.Text = "Server time: " + result.Trim();
            });
        }

        private void SendEcho()
        {
            echoCount++;
            string message = "Hello from the Xbox, #" + echoCount;
            EchoText.Text = "Sending...";
            server.Post("api/echo", message, delegate(string result, Exception error)
            {
                if (error != null)
                {
                    EchoText.Text = "Echo failed";
                    AddLog("POST /api/echo failed: " + error.Message);
                    return;
                }
                EchoText.Text = result.Trim();
                AddLog("POST /api/echo -> " + result.Trim());
            });
        }

        private void EchoButton_Click(object sender, RoutedEventArgs e)
        {
            SendEcho();
        }

        private void MainPage_GamePadButtonDown(object sender, GamePadButtonEventArgs e)
        {
            if (e.Button == GamePadButton.A && !e.Handled)
            {
                e.Handled = true;
                SendEcho();
            }
        }

        private void AddLog(string line)
        {
            log.Add(DateTime.Now.ToString("HH:mm:ss") + "  " + line);
            if (log.Count > MaxLogLines)
            {
                log.RemoveAt(0);
            }
            LogText.Text = string.Join("\n", log.ToArray());
        }

        public void ShowError(Exception error)
        {
            AddLog("Unhandled: " + error.GetType().Name + ": " + error.Message);
        }
    }
}
