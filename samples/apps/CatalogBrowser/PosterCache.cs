using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Windows;
using System.Windows.Media.Imaging;
using Microsoft.Xna.Framework.Storage;

namespace CatalogBrowser
{
    /// <summary>
    /// Poster images, kept on the cache drive so they're only downloaded
    /// once. The cache drive (CacheContainer) is scratch space for the title:
    /// fast to open, not backed up, and may be emptied by the console. Only
    /// one CacheContainer can be open at a time, so this opens it once and
    /// keeps it for the session.
    /// </summary>
    public class PosterCache
    {
        private CacheContainer cache;
        private bool opening;
        private readonly List<Action> waiting = new List<Action>();

        public int Downloads { get; private set; }
        public int CacheHits { get; private set; }

        /// <summary>Calls back with the image, on the UI thread.</summary>
        public void Get(Uri url, Action<BitmapImage> done)
        {
            WhenOpen(delegate
            {
                string file = "poster-" + Path.GetFileName(url.AbsolutePath);
                if (cache != null && cache.FileExists(file))
                {
                    CacheHits++;
                    using (Stream stream = cache.OpenFile(file, FileMode.Open))
                    {
                        done(Decode(stream));
                    }
                    return;
                }
                Download(url, file, done);
            });
        }

        private void Download(Uri url, string file, Action<BitmapImage> done)
        {
            WebClient client = new WebClient();
            client.OpenReadCompleted += delegate(object sender, OpenReadCompletedEventArgs e)
            {
                if (e.Error != null)
                {
                    done(null);
                    return;
                }
                Downloads++;
                MemoryStream copy = new MemoryStream();
                byte[] buffer = new byte[16384];
                int read;
                while ((read = e.Result.Read(buffer, 0, buffer.Length)) > 0)
                {
                    copy.Write(buffer, 0, read);
                }
                if (cache != null)
                {
                    try
                    {
                        using (Stream stream = cache.CreateFile(file))
                        {
                            copy.WriteTo(stream);
                        }
                    }
                    catch (Exception)
                    {
                        // A full or unavailable cache only costs a download.
                    }
                }
                copy.Position = 0;
                done(Decode(copy));
            };
            client.OpenReadAsync(url);
        }

        private static BitmapImage Decode(Stream stream)
        {
            BitmapImage image = new BitmapImage();
            image.SetSource(stream);
            return image;
        }

        private void WhenOpen(Action action)
        {
            if (cache != null || (!opening && waiting.Count == 0 && cacheFailed))
            {
                action();
                return;
            }
            waiting.Add(action);
            if (opening)
            {
                return;
            }
            opening = true;
            try
            {
                CacheContainer.BeginOpenCacheContainer(delegate(IAsyncResult ar)
                {
                    // The callback runs on another thread.
                    Deployment.Current.Dispatcher.BeginInvoke(delegate
                    {
                        try
                        {
                            cache = CacheContainer.EndOpenCacheContainer(ar);
                        }
                        catch (Exception)
                        {
                            cacheFailed = true;
                        }
                        Flush();
                    });
                }, null);
            }
            catch (Exception)
            {
                cacheFailed = true;
                Flush();
            }
        }

        private bool cacheFailed;

        private void Flush()
        {
            opening = false;
            Action[] pending = waiting.ToArray();
            waiting.Clear();
            foreach (Action action in pending)
            {
                action();
            }
        }
    }
}
