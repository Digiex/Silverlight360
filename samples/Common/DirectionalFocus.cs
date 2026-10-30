using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace XboxSdk.Samples
{
    /// <summary>
    /// Moves focus with the D-pad and the left thumbstick. The Xbox runtime
    /// clicks the focused Button when A is pressed, but leaves moving focus
    /// to the app; set <c>DirectionalFocus.IsEnabled="True"</c> on a panel and
    /// focus moves to the nearest focusable control in the pressed direction
    /// among its descendants.
    /// </summary>
    public static class DirectionalFocus
    {
        private const double StickThreshold = 0.6;
        private static readonly TimeSpan StickRepeat = TimeSpan.FromMilliseconds(300);

        public static readonly DependencyProperty IsEnabledProperty = DependencyProperty.RegisterAttached(
            "IsEnabled", typeof(bool), typeof(DirectionalFocus), new PropertyMetadata(false, OnIsEnabledChanged));

        private static readonly DependencyProperty StickStateProperty = DependencyProperty.RegisterAttached(
            "StickState", typeof(StickState), typeof(DirectionalFocus), null);

        public static bool GetIsEnabled(DependencyObject element)
        {
            return (bool)element.GetValue(IsEnabledProperty);
        }

        public static void SetIsEnabled(DependencyObject element, bool value)
        {
            element.SetValue(IsEnabledProperty, value);
        }

        private enum Direction { None, Up, Down, Left, Right }

        private class StickState
        {
            public Direction Held;
            public DateTime Last;
        }

        private static void OnIsEnabledChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            UIElement root = d as UIElement;
            if (root == null)
            {
                return;
            }
            if ((bool)e.NewValue)
            {
                root.SetValue(StickStateProperty, new StickState());
                root.GamePadButtonDown += OnButtonDown;
                root.GamePadThumbStickMoved += OnThumbStickMoved;
            }
            else
            {
                root.GamePadButtonDown -= OnButtonDown;
                root.GamePadThumbStickMoved -= OnThumbStickMoved;
            }
        }

        private static void OnButtonDown(object sender, GamePadButtonEventArgs e)
        {
            Direction direction = Direction.None;
            switch (e.Button)
            {
                case GamePadButton.DPadUp: direction = Direction.Up; break;
                case GamePadButton.DPadDown: direction = Direction.Down; break;
                case GamePadButton.DPadLeft: direction = Direction.Left; break;
                case GamePadButton.DPadRight: direction = Direction.Right; break;
            }
            if (direction != Direction.None && Move((UIElement)sender, direction))
            {
                e.Handled = true;
            }
        }

        private static void OnThumbStickMoved(object sender, GamePadThumbStickMovedEventArgs e)
        {
            if (e.Side != GamePadSide.Left)
            {
                return;
            }
            UIElement root = (UIElement)sender;
            StickState state = (StickState)root.GetValue(StickStateProperty);
            Direction direction = Direction.None;
            if (Math.Abs(e.XPosition) >= Math.Abs(e.YPosition))
            {
                if (e.XPosition > StickThreshold) direction = Direction.Right;
                else if (e.XPosition < -StickThreshold) direction = Direction.Left;
            }
            else
            {
                if (e.YPosition > StickThreshold) direction = Direction.Up;
                else if (e.YPosition < -StickThreshold) direction = Direction.Down;
            }
            // One move per push, then repeat while held.
            if (direction == Direction.None)
            {
                state.Held = Direction.None;
                return;
            }
            DateTime now = DateTime.Now;
            if (direction == state.Held && now - state.Last < StickRepeat)
            {
                return;
            }
            state.Held = direction;
            state.Last = now;
            if (Move(root, direction))
            {
                e.Handled = true;
            }
        }

        private static bool Move(UIElement root, Direction direction)
        {
            Control current = FocusManager.GetFocusedElement() as Control;
            if (current == null || !IsDescendant(root, current))
            {
                return false;
            }
            Rect from = Bounds(current, root);
            Control best = null;
            double bestScore = double.MaxValue;
            foreach (Control candidate in Focusable(root))
            {
                if (candidate == current)
                {
                    continue;
                }
                Rect to = Bounds(candidate, root);
                double score = Score(from, to, direction);
                if (score < bestScore)
                {
                    bestScore = score;
                    best = candidate;
                }
            }
            return best != null && best.Focus();
        }

        // Distance along the direction, plus a penalty for being off to the
        // side; NaN-free and MaxValue when the candidate isn't that way.
        private static double Score(Rect from, Rect to, Direction direction)
        {
            double along, across;
            switch (direction)
            {
                case Direction.Right:
                    if (to.Left < from.Right - 1) return double.MaxValue;
                    along = to.Left - from.Right;
                    across = Overlap(from.Top, from.Bottom, to.Top, to.Bottom);
                    break;
                case Direction.Left:
                    if (to.Right > from.Left + 1) return double.MaxValue;
                    along = from.Left - to.Right;
                    across = Overlap(from.Top, from.Bottom, to.Top, to.Bottom);
                    break;
                case Direction.Down:
                    if (to.Top < from.Bottom - 1) return double.MaxValue;
                    along = to.Top - from.Bottom;
                    across = Overlap(from.Left, from.Right, to.Left, to.Right);
                    break;
                default:
                    if (to.Bottom > from.Top + 1) return double.MaxValue;
                    along = from.Top - to.Bottom;
                    across = Overlap(from.Left, from.Right, to.Left, to.Right);
                    break;
            }
            return along + across * 2;
        }

        // 0 when the ranges overlap, otherwise the gap between them.
        private static double Overlap(double a1, double a2, double b1, double b2)
        {
            if (b2 < a1) return a1 - b2;
            if (b1 > a2) return b1 - a2;
            return 0;
        }

        private static Rect Bounds(FrameworkElement element, UIElement root)
        {
            Point origin = element.TransformToVisual(root).Transform(new Point(0, 0));
            return new Rect(origin.X, origin.Y, element.ActualWidth, element.ActualHeight);
        }

        private static bool IsDescendant(UIElement root, DependencyObject element)
        {
            while (element != null)
            {
                if (element == root)
                {
                    return true;
                }
                element = VisualTreeHelper.GetParent(element);
            }
            return false;
        }

        private static IEnumerable<Control> Focusable(DependencyObject parent)
        {
            int count = VisualTreeHelper.GetChildrenCount(parent);
            for (int i = 0; i < count; i++)
            {
                DependencyObject child = VisualTreeHelper.GetChild(parent, i);
                UIElement element = child as UIElement;
                if (element != null && element.Visibility != Visibility.Visible)
                {
                    continue;
                }
                Control control = child as Control;
                if (control != null && control.IsTabStop && control.IsEnabled && control.ActualWidth > 0)
                {
                    yield return control;
                    // A focusable control's template parts aren't separate stops.
                    continue;
                }
                foreach (Control nested in Focusable(child))
                {
                    yield return nested;
                }
            }
        }
    }
}
