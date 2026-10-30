using System.Windows;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using Microsoft.Xbox.Controls;

namespace CatalogBrowser.Pages
{
    public partial class DetailPage : XboxApplicationPage
    {
        private CatalogItem item;

        public DetailPage()
        {
            InitializeComponent();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);
            item = App.Catalog.Find(int.Parse(NavigationContext.QueryString["id"]));
            if (item == null)
            {
                NavigationService.GoBack();
                return;
            }
            Category.Text = item.Category.ToUpper();
            TitleText.Text = item.Title;
            Facts.Text = string.Format("{0}   {1} min", item.Year, item.Minutes);
            Description.Text = item.Description;
            UpdateFavorite();
            // Comes from the cache drive: the home page already fetched it.
            App.Posters.Get(item.Image, delegate(BitmapImage bitmap) { Poster.Source = bitmap; });
            Dispatcher.BeginInvoke(delegate { FavoriteButton.Focus(); });
        }

        private void UpdateFavorite()
        {
            FavoriteButton.Content = App.Favorites.Contains(item.Id) ? "Remove from favourites" : "Add to favourites";
        }

        private void Favorite_Click(object sender, RoutedEventArgs e)
        {
            App.Favorites.Toggle(item.Id, delegate
            {
                UpdateFavorite();
                Status.Text = App.Favorites.LastError != null
                    ? "Couldn't save: " + App.Favorites.LastError
                    : "Saved to the storage container.";
            });
        }

        private void Back_Click(object sender, RoutedEventArgs e)
        {
            NavigationService.GoBack();
        }
    }
}
