using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using XboxSdk.Samples;

namespace CatalogBrowser
{
    public class CatalogItem
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Category { get; set; }
        public int Year { get; set; }
        public int Minutes { get; set; }
        public string Description { get; set; }
        public Uri Image { get; set; }
    }

    public class CatalogCategory
    {
        public string Name { get; set; }
        public List<CatalogItem> Items { get; set; }
    }

    /// <summary>
    /// The catalog from the test server's /api/catalog, an XML document
    /// parsed with LINQ to XML. Loaded once and kept for the session.
    /// </summary>
    public class Catalog
    {
        private readonly ServerClient server;
        private List<CatalogCategory> categories;

        public Catalog(ServerClient server)
        {
            this.server = server;
        }

        public void Load(Action<List<CatalogCategory>, Exception> done)
        {
            if (categories != null)
            {
                done(categories, null);
                return;
            }
            server.Get("api/catalog", delegate(string xml, Exception error)
            {
                if (error != null)
                {
                    done(null, error);
                    return;
                }
                try
                {
                    categories = XDocument.Parse(xml).Root.Elements("category").Select(c => new CatalogCategory
                    {
                        Name = (string)c.Attribute("name"),
                        Items = c.Elements("item").Select(i => new CatalogItem
                        {
                            Id = (int)i.Attribute("id"),
                            Title = (string)i.Attribute("title"),
                            Category = (string)c.Attribute("name"),
                            Year = (int)i.Attribute("year"),
                            Minutes = (int)i.Attribute("minutes"),
                            Description = i.Value,
                            Image = new Uri((string)i.Attribute("image"), UriKind.Absolute),
                        }).ToList(),
                    }).ToList();
                }
                catch (Exception e)
                {
                    done(null, e);
                    return;
                }
                done(categories, null);
            });
        }

        public CatalogItem Find(int id)
        {
            return categories == null ? null : categories.SelectMany(c => c.Items).FirstOrDefault(i => i.Id == id);
        }
    }
}
