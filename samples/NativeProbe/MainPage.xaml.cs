using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Threading;
using System.Collections.Generic;
using HelloXbox;
using XboxSdk.Samples;

namespace NativeProbe
{
    public partial class MainPage : UserControl
    {
        private delegate string Probe();

        private readonly ServerClient server;
        private readonly Queue<KeyValuePair<string, Probe>> probes =
            new Queue<KeyValuePair<string, Probe>>();
        private readonly DispatcherTimer timer = new DispatcherTimer();

        public MainPage()
        {
            InitializeComponent();
            server = new ServerClient((string)Application.Current.Resources["ServerUrl"]);
            // One probe a second, so each result is drawn and sent to the
            // server before the next call can take the app down.
            timer.Interval = TimeSpan.FromSeconds(1);
            timer.Tick += delegate
            {
                if (probes.Count == 0)
                {
                    timer.Stop();
                    return;
                }
                KeyValuePair<string, Probe> next = probes.Dequeue();
                Run(next.Key, next.Value);
            };
            Loaded += delegate
            {
                QueueProbes();
                timer.Start();
            };
        }

        private void QueueProbes()
        {
            Add("XamGetSystemVersion (xam #642)", delegate
            {
                return FormatVersion(NativeMethods.XamGetSystemVersion());
            });
            Add("XGetAVPack (xam #971)", delegate
            {
                return NativeMethods.XGetAVPack().ToString();
            });
            Add("XGetLanguage (xam #973)", delegate
            {
                return NativeMethods.XGetLanguage().ToString();
            });
            Add("KeGetCurrentProcessType (xboxkrnl #102)", delegate
            {
                return NativeMethods.KeGetCurrentProcessType().ToString();
            });
            Add("KeQuerySystemTime (xboxkrnl #132, out)", delegate
            {
                long fileTime;
                NativeMethods.KeQuerySystemTime(out fileTime);
                return DateTime.FromFileTimeUtc(fileTime).ToString("yyyy-MM-dd HH:mm:ss") + " UTC";
            });
            Add("XamUserGetSigninInfo (xam #551, pinned buffer)", delegate
            {
                using (NativeBuffer info = new NativeBuffer(0x28))
                {
                    uint result = NativeMethods.XamUserGetSigninInfo(0, 0, info.Address);
                    return result != 0
                        ? "error " + result
                        : info.Ansi(0x18, 16) + ", XUID " + info.U64(0).ToString("X16");
                }
            });
            Add("XamGetSystemVersion, [SecurityCritical]", delegate
            {
                return FormatVersion(CriticalNativeMethods.GetSystemVersion());
            });
            // Last, since a module or export the CLR can't find becomes a call
            // through a null pointer rather than an exception.
            Add("XamGetSystemVersion from \"xam\"", delegate
            {
                return FormatVersion(NativeMethods.XamGetSystemVersionShortName());
            });
        }

        private void Add(string name, Probe probe)
        {
            probes.Enqueue(new KeyValuePair<string, Probe>(name, probe));
        }

        private void Run(string name, Probe probe)
        {
            string result;
            try
            {
                result = "OK " + probe();
            }
            catch (Exception e)
            {
                result = "FAILED " + e.GetType().Name + ": " + e.Message;
            }
            string line = name + " -> " + result;
            ResultsText.Text += line + "\n";
            server.Post("api/echo", "probe: " + line, delegate { });
        }

        public void ShowError(Exception error)
        {
            ResultsText.Text += "Unhandled: " + error.GetType().Name + ": " + error.Message + "\n";
        }

        private static string FormatVersion(uint v)
        {
            return string.Format("{0}.{1}.{2}.{3}", v >> 28, (v >> 24) & 0xF, (v >> 8) & 0xFFFF, v & 0xFF);
        }
    }
}
