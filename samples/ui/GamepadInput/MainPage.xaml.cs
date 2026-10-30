using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Shapes;

namespace GamepadInput
{
    /// <summary>
    /// Shows every controller event the Xbox runtime raises: button down/up,
    /// thumbstick and trigger movement. They're routed events on UIElement,
    /// raised on the focused element and bubbling up to its parents.
    /// </summary>
    public partial class MainPage : UserControl
    {
        private const int LogLines = 6;
        private static readonly Brush Lit = new SolidColorBrush(Color.FromArgb(0xFF, 0x51, 0x86, 0x0F));
        private static readonly Brush Unlit = new SolidColorBrush(Color.FromArgb(0xFF, 0x2A, 0x34, 0x40));
        private readonly List<string> log = new List<string>();
        private readonly Dictionary<GamePadButton, bool> held = new Dictionary<GamePadButton, bool>();

        public MainPage()
        {
            InitializeComponent();
            // A UserControl isn't focusable by default. Make it so and give it
            // focus, or controller events have no element to start from.
            IsTabStop = true;
            Loaded += delegate { Focus(); };

            GamePadButtonDown += OnButtonDown;
            GamePadButtonUp += OnButtonUp;
            GamePadThumbStickMoved += OnThumbStickMoved;
            GamePadTriggerMoved += OnTriggerMoved;
        }

        private void OnButtonDown(object sender, GamePadButtonEventArgs e)
        {
            held[e.Button] = true;
            Light(e.Button, true);
            Log("down  " + e.Button);
            // Handled stops the event bubbling further. Without it, B and the
            // D-pad would also reach any parent control that reacts to them.
            e.Handled = true;

            bool back, start;
            if (held.TryGetValue(GamePadButton.Back, out back) && back &&
                held.TryGetValue(GamePadButton.Start, out start) && start)
            {
                Log("Back + Start: exiting");
                // Shutdown is an Xbox addition: XamlHost quits to the dashboard.
                Application.Current.Shutdown();
            }
        }

        private void OnButtonUp(object sender, GamePadButtonEventArgs e)
        {
            held[e.Button] = false;
            Light(e.Button, false);
            Log("up    " + e.Button);
            e.Handled = true;
        }

        private void OnThumbStickMoved(object sender, GamePadThumbStickMovedEventArgs e)
        {
            // Positions run from -1 to 1; Y is positive up.
            UIElement dot = e.Side == GamePadSide.Left ? LeftStickDot : RightStickDot;
            Canvas.SetLeft(dot, 52 + e.XPosition * 48);
            Canvas.SetTop(dot, 52 - e.YPosition * 48);
            Log(string.Format("stick {0,-5} x={1,5:0.00} y={2,5:0.00}", e.Side, e.XPosition, e.YPosition));
            e.Handled = true;
        }

        private void OnTriggerMoved(object sender, GamePadTriggerMovedEventArgs e)
        {
            // Position runs from 0 (released) to 1 (fully pulled).
            Rectangle bar = e.Side == GamePadSide.Left ? LeftTrigger : RightTrigger;
            bar.Height = 120 * e.Position;
            Log(string.Format("trigger {0,-5} {1:0.00}", e.Side, e.Position));
            e.Handled = true;
        }

        private void Light(GamePadButton button, bool on)
        {
            // The indicator for each button is named after its enum value.
            Border indicator = FindName(button.ToString()) as Border;
            if (indicator != null)
            {
                indicator.Background = on ? Lit : Unlit;
            }
        }

        private void Log(string line)
        {
            log.Add(line);
            if (log.Count > LogLines)
            {
                log.RemoveAt(0);
            }
            EventLog.Text = string.Join("\n", log.ToArray());
        }
    }
}
