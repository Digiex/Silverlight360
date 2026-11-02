using System.Windows;
using System.Windows.Controls;
using Microsoft.Xbox.Controls;

namespace XboxControls
{
    /// <summary>
    /// Pivot, Rune and Legend from Microsoft.Xbox.dll. The controls do the
    /// navigation themselves; this page only reports what happened.
    /// </summary>
    public partial class MainPage : UserControl
    {
        private int focusAttempts;

        // Loaded can come before the first layout pass, when a control can't take focus yet (Focus returns false);
        // then try again on a later dispatcher turn. (Retrying from LayoutUpdated recurses: Focus runs layout, which
        // raises LayoutUpdated again.)
        private void FocusFirstTile()
        {
            Button first = (Button)BrowseGrid.Children[0];
            if (!first.Focus() && ++focusAttempts < 100)
            {
                Dispatcher.BeginInvoke(FocusFirstTile);
            }
        }

        public MainPage()
        {
            InitializeComponent();
            Loaded += delegate { FocusFirstTile(); };
            foreach (UIElement child in BrowseGrid.Children)
            {
                Button tile = (Button)child;
                tile.GotFocus += delegate { Status.Text = "Focused: " + tile.Content; };
                tile.Click += delegate { Status.Text = "Opened: " + tile.Content; };
            }
            Sections.SelectionChanged += delegate
            {
                PivotItem item = Sections.SelectedItem as PivotItem;
                Status.Text = "Section: " + (item != null ? item.Header : Sections.SelectedIndex.ToString());
                // Open the Rune and give it focus when its section comes up.
                bool search = item != null && "search".Equals(item.Header);
                SearchRune.IsOpen = search;
                if (search)
                {
                    SearchRune.Focus();
                }
            };
            SearchRune.TextChanged += delegate
            {
                SearchEcho.Text = "Searching for: " + SearchRune.Text;
            };
        }
    }
}
