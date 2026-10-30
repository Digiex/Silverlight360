# Microsoft.Xna.Framework.Storage

Assembly: `Microsoft.Xbox.Storage.dll`

| Type | Summary |
|---|---|
| [`CacheContainer`](#cachecontainer) | A temporary storage area on the console's utility (cache) partition, for downloaded data that can be recreated if lost, such as images or media segments. Use the inherited `StorageContainer` file methods to read and write files. |

## CacheContainer

`class Microsoft.Xna.Framework.Storage.CacheContainer`

A temporary storage area on the console's utility (cache) partition, for downloaded data that can be recreated if lost, such as images or media segments. Use the inherited `StorageContainer` file methods to read and write files.

Only one cache container can be open at a time. Disposing it unmounts the partition. The container is not tied to a user profile; opening it with `format` set to `true` erases its content, so treat it as a cache rather than a place for user data.

**Methods**

| | |
|---|---|
| `static Microsoft.Xna.Framework.Storage.CacheContainer EndOpenCacheContainer(System.IAsyncResult result)` | Completes mounting the cache partition and returns the container. Blocks until the mount has finished. |
| `static System.IAsyncResult BeginOpenCacheContainer(System.AsyncCallback callback, System.Object state)` | Starts mounting the cache partition with default settings (no format, 4,096-byte clusters, minimum file cache). |
| `static System.IAsyncResult BeginOpenCacheContainer(System.Boolean format, System.Int32 bytesPerCluster, System.Int32 fileCacheSize, System.AsyncCallback callback, System.Object state)` | Starts mounting the cache partition with the specified settings. The mount runs on a thread-pool thread. |

