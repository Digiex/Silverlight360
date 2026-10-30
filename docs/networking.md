# Networking

`WebClient` and `HttpWebRequest` work as in Silverlight 3. The runtime sends the requests through the console's HTTP stack (XHttp); in xenia-edge that's the host's WinHTTP, so `127.0.0.1` is the PC running the emulator.

```csharp
var client = new WebClient();
client.DownloadStringCompleted += delegate(object sender, DownloadStringCompletedEventArgs e)
{
    if (e.Error != null) { ShowError(e.Error); return; }
    Show(XDocument.Parse(e.Result));
};
client.DownloadStringAsync(new Uri("http://127.0.0.1:8360/api/catalog"));
```

`WebClient` completion events arrive on the UI thread. `samples\Common\ServerClient.cs` wraps GET and POST.

- **Cross-domain policy:** as with any Silverlight app, a server on another host must allow access with `/clientaccesspolicy.xml` or `/crossdomain.xml`. The test server serves both.
- **Data formats:** the platform has no JSON serializer. Use XML with `System.Xml.Linq`, as the samples do, or ship a JSON library compiled for Silverlight 3.
- **Images:** `BitmapImage` takes a URI or a stream; `WebClient.OpenReadAsync` gets the bytes if you want to cache them (see `PosterCache` in `samples\apps\CatalogBrowser`).
- **Xbox additions to `HttpWebRequest`:** `IsAuthCall`, `LimitDownloadBufferSize` and `AllowLocalConnections` are passed to the native stack. The last two can't be set once the request has been sent.

## Xbox LIVE and XAuth

Requests to partner services were authenticated with XAuth tokens from Xbox LIVE (`Microsoft.Xbox.Security.XAuth`: call `XAuthService.Start`, then use `XAuthTokenRequest`; each request object can be used once). There's no Xbox LIVE to get tokens from, so anything behind XAuth fails. That includes sign-in for many of the shipped apps, Marketplace and social network tokens. Plain HTTP and HTTPS to your own servers work.

## The test server

`samples\TestServer\server.py` serves what the samples need:

| Endpoint | |
|---|---|
| `GET /api/hello`, `GET /api/time`, `POST /api/echo` | HelloXbox |
| `GET /api/catalog`, `GET /images/<id>.png` | CatalogBrowser: an XML catalog of made-up shows and generated posters |
| `GET /api/media`, `GET /media/<file>` | MediaPlayer: the files in `samples\TestServer\media`, with byte ranges |

It prints every request, so you can see what an app asks for.
