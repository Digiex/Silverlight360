using System;
using System.Collections.Generic;
using System.Windows.Controls;
using System.Windows.Threading;
using XboxSdk.Samples;

namespace NativeLibrary
{
    public partial class MainPage : UserControl
    {
        private delegate string Check();

        private readonly Queue<KeyValuePair<string, Check>> checks = new Queue<KeyValuePair<string, Check>>();
        private readonly DispatcherTimer timer = new DispatcherTimer();
        private int passed;
        private int failed;

        public MainPage()
        {
            InitializeComponent();
            // One check a second, each logged before it runs, so the log shows
            // which call took the app down if one does.
            timer.Interval = TimeSpan.FromSeconds(1);
            timer.Tick += delegate
            {
                if (checks.Count == 0)
                {
                    timer.Stop();
                    Report("NativeLibrary: checks: " + passed + " passed, " + failed + " failed");
                    return;
                }
                KeyValuePair<string, Check> next = checks.Dequeue();
                Run(next.Key, next.Value);
            };
            Loaded += delegate
            {
                QueueChecks();
                timer.Start();
            };
        }

        private void QueueChecks()
        {
            // The CLR loads testlib.xex from the package folder at the first
            // call. A module or export it can't find becomes a call through a
            // null pointer rather than an exception.
            Add("TestLib.Version (#1)", delegate
            {
                uint version = TestLib.Version();
                Expect(version == TestLib.ExpectedVersion, Hex(version));
                return Hex(version);
            });
            Add("TestLib.Add(40, 2) (#2)", delegate
            {
                uint sum = TestLib.Add(40, 2);
                Expect(sum == 42, sum.ToString());
                return sum.ToString();
            });
            Add("TestLib.Add64(0x100000000, 5) (#3)", delegate
            {
                ulong sum = TestLib.Add64(0x100000000UL, 5);
                Expect(sum == 0x100000005UL, sum.ToString("X"));
                return "0x" + sum.ToString("X");
            });
            Add("TestLib.SumAndFill, 16 bytes through a pinned buffer (#4)", delegate
            {
                byte[] contents = new byte[16];
                for (int i = 0; i < contents.Length; i++)
                {
                    contents[i] = (byte)(i * 3);
                }
                using (NativeBuffer buffer = new NativeBuffer(contents))
                {
                    uint sum = TestLib.SumAndFill(buffer.Address, (uint)contents.Length, 100);
                    Expect(sum == 360, "sum " + sum);
                    for (int i = 0; i < contents.Length; i++)
                    {
                        Expect(buffer.U8(i) == 100 + i, "byte " + i + " is " + buffer.U8(i));
                    }
                    return "sum " + sum + ", bytes " + buffer.U8(0) + " to " + buffer.U8(contents.Length - 1);
                }
            });
            Add("TestLib.Calls (#5)", delegate
            {
                uint calls = TestLib.Calls();
                Expect(calls == 4, calls.ToString());
                return calls.ToString();
            });
            // The kernel's loader then hands back the module the CLR loaded,
            // and finds the same exports by ordinal.
            uint module = 0;
            Add("XexLoadImage(\"" + TestLib.Path + "\")", delegate
            {
                int status = Kernel.XexLoadImage(TestLib.Path, Kernel.LoadDll, 0, out module);
                Expect(status == 0 && module != 0, "status " + Hex(status) + ", module " + Hex(module));
                return "module " + Hex(module);
            });
            Add("XexGetModuleHandle(\"" + TestLib.Module + "\")", delegate
            {
                uint found;
                int status = Kernel.XexGetModuleHandle(TestLib.Module, out found);
                Expect(status == 0 && found == module, "status " + Hex(status) + ", module " + Hex(found));
                return "module " + Hex(found);
            });
            Add("XexGetProcedureAddress, ordinals 1 to 5", delegate
            {
                string addresses = "";
                for (uint ordinal = 1; ordinal <= 5; ordinal++)
                {
                    uint address;
                    int status = Kernel.XexGetProcedureAddress(module, ordinal, out address);
                    Expect(status == 0 && address != 0, "ordinal " + ordinal + ": status " + Hex(status));
                    addresses += (ordinal > 1 ? " " : "") + Hex(address);
                }
                return addresses;
            });
        }

        private void Add(string name, Check check)
        {
            checks.Enqueue(new KeyValuePair<string, Check>(name, check));
        }

        private void Run(string name, Check check)
        {
            DebugLog.WriteLine("NativeLibrary: " + name + "...");
            try
            {
                string result = check();
                passed++;
                Report("PASS: " + name + " -> " + result);
            }
            catch (Exception e)
            {
                failed++;
                Report("FAIL: " + name + " -> " + e.GetType().Name + ": " + e.Message);
            }
        }

        private void Report(string line)
        {
            ResultsText.Text += line + "\n";
            DebugLog.WriteLine(line);
        }

        public void ShowError(Exception error)
        {
            Report("Unhandled: " + error.GetType().Name + ": " + error.Message);
        }

        private static void Expect(bool condition, string what)
        {
            if (!condition)
            {
                throw new InvalidOperationException(what);
            }
        }

        private static string Hex(uint value)
        {
            return "0x" + value.ToString("X8");
        }

        private static string Hex(int value)
        {
            return Hex((uint)value);
        }
    }
}
