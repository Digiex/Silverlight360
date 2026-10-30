"""A small HTTP server for the SDK samples.

    python server.py [--host 127.0.0.1] [--port 8360] [--media DIR]

Endpoints:
    GET  /api/hello              a greeting (HelloXbox)
    GET  /api/time               the server's clock (HelloXbox)
    POST /api/echo               the request body echoed back with a count (HelloXbox)
    GET  /api/catalog            an XML catalog of made-up shows (CatalogBrowser)
    GET  /images/<id>.png        a generated poster for a catalog item (CatalogBrowser)
    GET  /api/media              an XML list of the files in the media folder (MediaPlayer)
    GET  /media/<file>           a media file, with byte range support (MediaPlayer)
    GET  /clientaccesspolicy.xml Silverlight's cross-domain policy, allowing all
    GET  /crossdomain.xml        the Flash-style policy Silverlight also accepts

The media folder (default: media next to this script) is where you put your
own .wmv, .mp4, .wma or .mp3 files for the MediaPlayer sample; nothing is
shipped in it.

Every request is printed, so you can watch the apps talk to it.
"""
import argparse
import datetime
import http.server
import os
import re
import struct
import threading
import urllib.parse
import zlib
from xml.sax.saxutils import escape, quoteattr

CLIENT_ACCESS_POLICY = """<?xml version="1.0" encoding="utf-8"?>
<access-policy>
  <cross-domain-access>
    <policy>
      <allow-from http-request-headers="*">
        <domain uri="*"/>
      </allow-from>
      <grant-to>
        <resource path="/" include-subpaths="true"/>
      </grant-to>
    </policy>
  </cross-domain-access>
</access-policy>
"""

CROSS_DOMAIN = """<?xml version="1.0"?>
<cross-domain-policy>
  <allow-http-request-headers-from domain="*" headers="*"/>
  <allow-access-from domain="*"/>
</cross-domain-policy>
"""

# Made-up catalog for the CatalogBrowser sample: (category, [(title, year, minutes, text)])
CATALOG = [
    ("Documentaries", [
        ("Northern Lights", 2011, 52, "A winter in Lapland, chasing the aurora across the fells."),
        ("The Clockmakers", 2012, 47, "Three generations of a family who still build clocks by hand."),
        ("Deep Harbour", 2010, 58, "What lives under the busiest port in the Baltic."),
        ("Salt Roads", 2013, 49, "Following the old salt trade routes on foot."),
    ]),
    ("Comedy", [
        ("Office Plants", 2012, 22, "A sitcom told from the point of view of a ficus."),
        ("The Late Bus", 2011, 24, "Night-shift passengers and the driver who knows them all."),
        ("Second Breakfast", 2013, 21, "A cooking show that keeps going wrong."),
        ("Neighbours Again", 2010, 23, "Two families, one shared driveway."),
    ]),
    ("Science", [
        ("How Bridges Stand", 2012, 44, "The engineering behind the world's longest spans."),
        ("Small Weather", 2013, 41, "Microclimates in a single city park."),
        ("The Quiet Sun", 2011, 50, "A year of solar observations from a mountain lab."),
        ("Ice Cores", 2010, 46, "Reading a hundred thousand years of climate from ice."),
    ]),
]

MEDIA_TYPES = {
    ".wmv": "video/x-ms-wmv", ".wma": "audio/x-ms-wma", ".asf": "video/x-ms-asf",
    ".mp4": "video/mp4", ".m4v": "video/mp4", ".m4a": "audio/mp4", ".mp3": "audio/mpeg",
}


def catalog_items():
    n = 0
    for category, items in CATALOG:
        for title, year, minutes, text in items:
            n += 1
            yield n, category, title, year, minutes, text


def catalog_xml(base):
    out = ['<?xml version="1.0" encoding="utf-8"?>', "<catalog>"]
    for category, items in CATALOG:
        out.append("  <category name=%s>" % quoteattr(category))
        for n, cat, title, year, minutes, text in catalog_items():
            if cat != category:
                continue
            out.append('    <item id="%d" title=%s year="%d" minutes="%d" image=%s>%s</item>'
                       % (n, quoteattr(title), year, minutes,
                          quoteattr("%s/images/%d.png" % (base, n)), escape(text)))
        out.append("  </category>")
    out.append("</catalog>")
    return "\n".join(out)


def poster_png(seed, width=240, height=360):
    """A vertical gradient poster with a band, colored from the item number."""
    hue = (seed * 47) % 360

    def rgb(h, s, v):
        c = v * s
        x = c * (1 - abs((h / 60.0) % 2 - 1))
        m = v - c
        r, g, b = [(c, x, 0), (x, c, 0), (0, c, x), (0, x, c), (x, 0, c), (c, 0, x)][int(h // 60) % 6]
        return int((r + m) * 255), int((g + m) * 255), int((b + m) * 255)

    rows = []
    for y in range(height):
        t = y / float(height - 1)
        if 0.62 < t < 0.70:
            color = rgb((hue + 180) % 360, 0.45, 0.95)
        else:
            color = rgb(hue, 0.65, 0.85 - 0.55 * t)
        rows.append(b"\x00" + bytes(color) * width)
    raw = zlib.compress(b"".join(rows), 9)

    def chunk(kind, data):
        return struct.pack(">I", len(data)) + kind + data + struct.pack(">I", zlib.crc32(kind + data) & 0xFFFFFFFF)

    return (b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0))
            + chunk(b"IDAT", raw) + chunk(b"IEND", b""))


class Handler(http.server.BaseHTTPRequestHandler):
    server_version = "XboxSdkTestServer/1.1"
    protocol_version = "HTTP/1.1"
    echo_count = 0
    lock = threading.Lock()
    media_dir = ""

    def _send_bytes(self, status, data, content_type, extra=None):
        self.send_response(status)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(data)))
        self.send_header("Cache-Control", "no-cache")
        for k, v in (extra or {}).items():
            self.send_header(k, v)
        self.end_headers()
        if self.command != "HEAD":
            self.wfile.write(data)

    def _send(self, status, body, content_type="text/plain; charset=utf-8"):
        self._send_bytes(status, body.encode("utf-8"), content_type)

    def _base(self):
        return "http://%s" % (self.headers.get("Host") or "%s:%d" % self.server.server_address)

    def _media_files(self):
        if not os.path.isdir(self.media_dir):
            return []
        return sorted(f for f in os.listdir(self.media_dir)
                      if os.path.splitext(f)[1].lower() in MEDIA_TYPES)

    def _send_media(self, name):
        if name not in self._media_files():
            return self._send(404, "Not found")
        path = os.path.join(self.media_dir, name)
        size = os.path.getsize(path)
        content_type = MEDIA_TYPES[os.path.splitext(name)[1].lower()]
        start, end, status = 0, size - 1, 200
        if self.headers.get("Range"):
            print("    range: %s (file is %d bytes)" % (self.headers.get("Range"), size), flush=True)
        m = re.match(r"bytes=(\d*)-(\d*)$", self.headers.get("Range") or "")
        if m and (m.group(1) or m.group(2)):
            if m.group(1):
                start = int(m.group(1))
                end = int(m.group(2)) if m.group(2) else size - 1
            else:
                start = max(0, size - int(m.group(2)))
            end = min(end, size - 1)
            if start > end:
                self.send_response(416)
                self.send_header("Content-Range", "bytes */%d" % size)
                self.send_header("Content-Length", "0")
                self.end_headers()
                return
            status = 206
        self.send_response(status)
        self.send_header("Content-Type", content_type)
        self.send_header("Accept-Ranges", "bytes")
        self.send_header("Content-Length", str(end - start + 1))
        if status == 206:
            self.send_header("Content-Range", "bytes %d-%d/%d" % (start, end, size))
        self.end_headers()
        if self.command == "HEAD":
            return
        with open(path, "rb") as f:
            f.seek(start)
            left = end - start + 1
            try:
                while left > 0:
                    block = f.read(min(left, 256 * 1024))
                    if not block:
                        break
                    self.wfile.write(block)
                    left -= len(block)
            except (ConnectionError, OSError):
                pass  # the player closed the connection, which it does when seeking

    def do_HEAD(self):
        self.do_GET()

    def do_GET(self):
        path = urllib.parse.unquote(urllib.parse.urlparse(self.path).path)
        if path == "/api/hello":
            self._send(200, "Hello from %s! The Xbox app reached the server."
                       % self.server.server_address[0])
        elif path == "/api/time":
            self._send(200, datetime.datetime.now().strftime("%H:%M:%S"))
        elif path == "/api/catalog":
            self._send(200, catalog_xml(self._base()), "text/xml; charset=utf-8")
        elif re.match(r"^/images/\d+\.png$", path):
            self._send_bytes(200, poster_png(int(path[8:-4])), "image/png")
        elif path == "/api/media":
            items = "\n".join("  <file name=%s url=%s/>"
                              % (quoteattr(f), quoteattr("%s/media/%s" % (self._base(), urllib.parse.quote(f))))
                              for f in self._media_files())
            self._send(200, '<?xml version="1.0" encoding="utf-8"?>\n<media>\n%s\n</media>' % items,
                       "text/xml; charset=utf-8")
        elif path.startswith("/media/"):
            self._send_media(path[len("/media/"):])
        elif path == "/clientaccesspolicy.xml":
            self._send(200, CLIENT_ACCESS_POLICY, "text/xml")
        elif path == "/crossdomain.xml":
            self._send(200, CROSS_DOMAIN, "text/xml")
        else:
            self._send(404, "Not found")

    def do_POST(self):
        length = int(self.headers.get("Content-Length") or 0)
        body = self.rfile.read(length).decode("utf-8", "replace")
        if self.path == "/api/echo":
            with Handler.lock:
                Handler.echo_count += 1
                count = Handler.echo_count
            print("    echo body: %r" % body, flush=True)
            self._send(200, "Server got #%d: %s" % (count, body))
        else:
            self._send(404, "Not found")

    def log_message(self, format, *args):
        print("%s %s" % (datetime.datetime.now().strftime("%H:%M:%S"),
                         format % args), flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8360)
    parser.add_argument("--media", default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "media"))
    args = parser.parse_args()
    Handler.media_dir = args.media
    server = http.server.ThreadingHTTPServer((args.host, args.port), Handler)
    print("Serving on http://%s:%d/ (media from %s)" % (args.host, args.port, args.media), flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
