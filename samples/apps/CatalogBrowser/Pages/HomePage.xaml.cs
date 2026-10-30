using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Navigation;
using Microsoft.Xbox.Controls;
using Microsoft.Xna.Framework.GamerServices;

namespace CatalogBrowser.Pages
{
    /// <summary>
    /// The catalog by category, plus a favourites section. Each section is a
    /// PivotItem holding a Grid of poster buttons; PivotItem moves focus
    /// through the Grid itself, and LB/RB switch sections.
    /// </summary>
    public partial class HomePage : XboxApplicationPage
    {
        private const int Columns = 6;
        private static int lastSection;
        private static int lastItemId;

        public HomePage()
        {
            InitializeComponent();
            Sections.SelectionChanged += delegate
            {
                lastSection = Sections.SelectedIndex;
                FocusFirstIn(Sections.SelectedItem as PivotItem);
            };
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);
            ShowGamer();
            Status.Text = "Loading the catalog...";
            App.Catalog.Load(delegate(List<CatalogCategory> categories, Exception error)
            {
                if (error != null)
                {
                    Status.Text = "Couldn't load the catalog: " + error.Message + ". Is samples\\TestServer\\server.py running?";
                    return;
                }
                App.Favorites.Load(delegate { Build(categories); });
            });
        }

        private void ShowGamer()
        {
            // Gamer.SignedInGamers is kept up to date by GamerServices, which
            // XboxApplicationFrame starts and pumps.
            SignedInGamer gamer = Gamer.SignedInGamers.Count > 0 ? Gamer.SignedInGamers[0] : null;
            GamerText.Text = gamer != null ? "Signed in as " + gamer.Gamertag : "Not signed in";
        }

        private void Build(List<CatalogCategory> categories)
        {
            Sections.Items.Clear();
            foreach (CatalogCategory category in categories)
            {
                Sections.Items.Add(Section(category.Name.ToLower(), category.Items));
            }
            List<CatalogItem> favorites = App.Favorites.Ids.Select(id => App.Catalog.Find(id)).Where(i => i != null).ToList();
            Sections.Items.Add(Section("favourites", favorites));
            Status.Text = App.Favorites.LastError != null
                ? "Favourites unavailable: " + App.Favorites.LastError
                : string.Format("{0} titles, {1} favourites. LB/RB change section.",
                                categories.Sum(c => c.Items.Count), favorites.Count);
            Sections.SelectedIndex = Math.Min(lastSection, Sections.Items.Count - 1);
            FocusFirstIn(Sections.SelectedItem as PivotItem);
        }

        private PivotItem Section(string header, List<CatalogItem> items)
        {
            Grid grid = new Grid { HorizontalAlignment = HorizontalAlignment.Left, VerticalAlignment = VerticalAlignment.Top };
            for (int c = 0; c < Columns; c++)
            {
                grid.ColumnDefinitions.Add(new ColumnDefinition());
            }
            for (int r = 0; r < (items.Count + Columns - 1) / Columns; r++)
            {
                grid.RowDefinitions.Add(new RowDefinition());
            }
            for (int i = 0; i < items.Count; i++)
            {
                grid.Children.Add(Poster(items[i], i / Columns, i % Columns));
            }
            if (items.Count == 0)
            {
                grid.Children.Add(new TextBlock
                {
                    Text = "Nothing here yet. Add favourites from a title's page.",
                    FontSize = 24,
                    Foreground = new SolidColorBrush(Colors.White),
                });
            }
            return new PivotItem { Header = header, Content = grid };
        }

        private Button Poster(CatalogItem item, int row, int column)
        {
            Image image = new Image { Stretch = Stretch.UniformToFill };
            Button button = new Button { Style = (Style)Application.Current.Resources["PosterButton"], Content = image, Tag = item };
            Grid.SetRow(button, row);
            Grid.SetColumn(button, column);
            Legend.SetAButtonText(button, "details");
            Legend.SetYButtonText(button, App.Favorites.Contains(item.Id) ? "unfavourite" : "favourite");
            App.Posters.Get(item.Image, delegate(System.Windows.Media.Imaging.BitmapImage bitmap) { image.Source = bitmap; });
            button.GotFocus += delegate
            {
                Status.Text = string.Format("{0} ({1}, {2} min)   posters: {3} downloaded, {4} from the cache drive",
                                            item.Title, item.Year, item.Minutes, App.Posters.Downloads, App.Posters.CacheHits);
            };
            button.Click += delegate
            {
                lastItemId = item.Id;
                NavigationService.Navigate(new Uri("/Pages/DetailPage.xaml?id=" + item.Id, UriKind.Relative));
            };
            // Y toggles the favourite without leaving the page. Buttons don't
            // use Y, so it reaches this handler.
            button.GamePadButtonDown += delegate(object sender, System.Windows.Input.GamePadButtonEventArgs e)
            {
                if (e.Button != System.Windows.Input.GamePadButton.Y)
                {
                    return;
                }
                e.Handled = true;
                App.Favorites.Toggle(item.Id, delegate
                {
                    Legend.SetYButtonText(button, App.Favorites.Contains(item.Id) ? "unfavourite" : "favourite");
                    Status.Text = (App.Favorites.Contains(item.Id) ? "Added " : "Removed ") + item.Title +
                                  (App.Favorites.LastError != null ? " (not saved: " + App.Favorites.LastError + ")" : "");
                });
            };
            return button;
        }

        private void FocusFirstIn(PivotItem section)
        {
            if (section == null)
            {
                return;
            }
            Grid grid = section.Content as Grid;
            if (grid == null)
            {
                return;
            }
            Button target = grid.Children.OfType<Button>().FirstOrDefault(b => ((CatalogItem)b.Tag).Id == lastItemId)
                            ?? grid.Children.OfType<Button>().FirstOrDefault();
            if (target != null)
            {
                Dispatcher.BeginInvoke(delegate { target.Focus(); });
            }
        }
    }
}
