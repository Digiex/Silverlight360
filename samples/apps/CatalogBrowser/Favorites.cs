using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Windows;
using System.Xml.Linq;
using Microsoft.Xna.Framework.Storage;

namespace CatalogBrowser
{
    /// <summary>
    /// The user's favourites, saved in the title's storage container: the
    /// place for settings and other data that must survive. Files in a
    /// StorageContainer are encrypted with a per-console key, so they can't
    /// be read on another console.
    /// </summary>
    public class Favorites
    {
        private const string FileName = "favorites.xml";
        private readonly List<int> ids = new List<int>();

        public bool Loaded { get; private set; }
        public string LastError { get; private set; }

        public IList<int> Ids
        {
            get { return ids; }
        }

        public bool Contains(int id)
        {
            return ids.Contains(id);
        }

        public void Load(Action done)
        {
            WithContainer(delegate(StorageContainer container)
            {
                ids.Clear();
                if (container.FileExists(FileName))
                {
                    using (Stream stream = container.OpenFile(FileName, FileMode.Open))
                    {
                        ids.AddRange(XDocument.Load(stream).Root.Elements("item").Select(e => (int)e.Attribute("id")));
                    }
                }
                Loaded = true;
            }, done);
        }

        public void Toggle(int id, Action done)
        {
            if (!ids.Remove(id))
            {
                ids.Add(id);
            }
            WithContainer(delegate(StorageContainer container)
            {
                XDocument doc = new XDocument(new XElement("favorites", ids.Select(i => new XElement("item", new XAttribute("id", i)))));
                using (Stream stream = container.CreateFile(FileName))
                {
                    doc.Save(stream);
                }
            }, done);
        }

        // Opens the container, runs the action, closes it, then calls done
        // on the UI thread. Opening is asynchronous; the container is only
        // held while it's used.
        private void WithContainer(Action<StorageContainer> action, Action done)
        {
            StorageDevice device = new StorageDevice();
            try
            {
                device.BeginOpenContainer("Catalog Browser", "CatalogBrowser", delegate(IAsyncResult ar)
                {
                    Deployment.Current.Dispatcher.BeginInvoke(delegate
                    {
                        try
                        {
                            using (StorageContainer container = device.EndOpenContainer(ar))
                            {
                                action(container);
                            }
                            LastError = null;
                        }
                        catch (Exception e)
                        {
                            LastError = e.Message;
                        }
                        done();
                    });
                }, null);
            }
            catch (Exception e)
            {
                LastError = e.Message;
                done();
            }
        }
    }
}
