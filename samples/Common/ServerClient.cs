using System;
using System.Net;

namespace XboxSdk.Samples
{
    /// <summary>Receives a response body, or the error that stopped it.</summary>
    public delegate void ResponseHandler(string result, Exception error);

    /// <summary>
    /// Talks to the samples' test server (samples\TestServer\server.py) with
    /// WebClient, which the Xbox runtime sends through the console's HTTP
    /// stack. Results come back on the UI thread.
    /// </summary>
    public class ServerClient
    {
        private readonly Uri baseUri;

        public ServerClient(string baseUrl)
        {
            baseUri = new Uri(baseUrl, UriKind.Absolute);
        }

        public Uri BaseUri
        {
            get { return baseUri; }
        }

        public Uri Resolve(string path)
        {
            return new Uri(baseUri, path);
        }

        public void Get(string path, ResponseHandler done)
        {
            WebClient client = new WebClient();
            client.DownloadStringCompleted += delegate(object sender, DownloadStringCompletedEventArgs e)
            {
                done(e.Error == null ? e.Result : null, e.Error);
            };
            client.DownloadStringAsync(Resolve(path));
        }

        public void Post(string path, string body, ResponseHandler done)
        {
            WebClient client = new WebClient();
            client.Headers["Content-Type"] = "text/plain";
            client.UploadStringCompleted += delegate(object sender, UploadStringCompletedEventArgs e)
            {
                done(e.Error == null ? e.Result : null, e.Error);
            };
            client.UploadStringAsync(Resolve(path), "POST", body);
        }
    }
}
