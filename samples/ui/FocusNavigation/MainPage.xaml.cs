using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace FocusNavigation
{
    /// <summary>
    /// A grid of tiles. A clicks the focused Button on its own; the D-pad and
    /// left stick move focus through DirectionalFocus, set on the grid in
    /// XAML. The page gives the first tile focus and reports what has it.
    /// </summary>
    public partial class MainPage : UserControl
    {
        public MainPage()
        {
            InitializeComponent();
            Loaded += delegate { FirstTile.Focus(); };
            foreach (UIElement child in Tiles.Children)
            {
                Button tile = child as Button;
                if (tile == null)
                {
                    continue;
                }
                tile.GotFocus += delegate { Status.Text = "Focused: " + tile.Content; };
                tile.Click += delegate { Status.Text = "Picked: " + tile.Content; };
            }
            // Buttons the focused tile doesn't use bubble up to here.
            GamePadButtonDown += delegate(object sender, GamePadButtonEventArgs e)
            {
                if (e.Button == GamePadButton.Y)
                {
                    Status.Text = "Y reached the page: the tile didn't handle it.";
                }
            };
        }
    }
}
