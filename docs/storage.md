# Storage

Two places to keep data, both from `Microsoft.Xbox.Storage` (`Microsoft.Xna.Framework.Storage`):

| | Storage container | Cache container |
|---|---|---|
| Use for | Settings, favourites, PINs, resume positions | Downloaded images and responses |
| Lives on | The title's save area for the user | The console's cache partition |
| Survives | Until the user deletes it | Until the console clears the cache |
| Encrypted | Yes, per console | No |
| At a time | Any number | One per app |

The runtime host doesn't implement isolated storage (its isolated-storage callbacks return "not implemented"), so use these instead of `IsolatedStorageFile`.

Both need GamerServices running; `XboxApplicationFrame` starts it (see [App model](app-model.md)).

## Storage container

```csharp
var device = new StorageDevice();
device.BeginOpenContainer("My App", "MyApp", delegate(IAsyncResult ar)
{
    // The callback runs on another thread.
    Deployment.Current.Dispatcher.BeginInvoke(delegate
    {
        using (StorageContainer container = device.EndOpenContainer(ar))
        {
            using (Stream stream = container.CreateFile("settings.xml"))
            {
                settings.Save(stream);
            }
        }
    });
}, null);
```

- `CreateFile` and `OpenFile` return streams that encrypt and decrypt with a key bound to the console, so saved files can't be read on another console.
- `FileExists`, `DeleteFile`, `GetFileNames` and the directory methods work like `System.IO`.
- Open the container when you need it and dispose it afterwards. `Favorites` in `samples\apps\CatalogBrowser` wraps this pattern.

## Cache container

```csharp
CacheContainer.BeginOpenCacheContainer(delegate(IAsyncResult ar)
{
    Deployment.Current.Dispatcher.BeginInvoke(delegate
    {
        cache = CacheContainer.EndOpenCacheContainer(ar);   // keep it open
    });
}, null);
```

- **One at a time:** opening a second container while one is open throws `InvalidOperationException`. Open it once and keep it for the session, as `PosterCache` in `samples\apps\CatalogBrowser` does.
- **It may disappear:** the console can clear the cache partition at any time, so treat anything in it as re-downloadable.
- **Cluster size:** `BeginOpenCacheContainer(format, bytesPerCluster, fileCacheSize, ...)` sets the cluster size (4 KB to 64 KB, 4 KB by default). The drive is formatted when the size doesn't match.
- **Unmounting:** disposing the container unmounts the drive.

## Tested

`samples\PlatformCalls` writes and reads back a file in each kind of container. `samples\apps\CatalogBrowser` keeps favourites in a storage container and posters on the cache drive. Both work under xenia-edge with the storage fixes in the `pr-silverlight-exports` pull request (see [Status under xenia](xenia-status.md)).
