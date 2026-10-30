using System;
using System.Net;

namespace HelloXbox
{
    /// <summary>Receives a response body, or the error that stopped it.</summary>
    public delegate void ResponseHandler(string result, Exception error);

    /// <summary>
    /// Talks to the sample's test server with WebClient, which the Xbox
    /// runtime sends through the console's HTTP stack. Results come back on
    /// the UI thread.
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

        public void Get(string path, ResponseHandler done)
        {
            WebClient client = new WebClient();
            client.DownloadStringCompleted += delegate(object sender, DownloadStringCompletedEventArgs e)
            {
                done(e.Error == null ? e.Result : null, e.Error);
            };
            client.DownloadStringAsync(new Uri(baseUri, path));
        }

        public void Post(string path, string body, ResponseHandler done)
        {
            WebClient client = new WebClient();
            client.Headers["Content-Type"] = "text/plain";
            client.UploadStringCompleted += delegate(object sender, UploadStringCompletedEventArgs e)
            {
                done(e.Error == null ? e.Result : null, e.Error);
            };
            client.UploadStringAsync(new Uri(baseUri, path), "POST", body);
        }
    }
}
