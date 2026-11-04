"""Renders the tables of docs/donor-assemblies.md from the JSON Get-DonorAssemblies.ps1 writes.

usage: donor_assemblies_md.py <donor-assemblies.json> <donor-assemblies.md>

Replaces everything between the page's two table markers and keeps the rest.
"""
import json
import re
import sys
from collections import defaultdict

src, dst = sys.argv[1:]
rows = json.load(open(src, encoding="utf-8-sig"))

PLATFORM = {"Microsoft.Xbox.Epg", "Microsoft.Xbox.Extensions", "Microsoft.Xbox.RuntimeHelpers",
            "System.Xml.Serialization"}
# Same name in many apps, but each app's own code.
OWN = {"XboxApplication", "Resources"}
GROUPS = [
    ("Microsoft's libraries", lambda n: n.startswith(("Microsoft.Advertising", "Microsoft.WebAnalytics",
                                                       "Microsoft.Xbox.Sample.", "Video.Services.")) or n in ("Services",)),
    ("Media player framework (MMPPF) parts Plex doesn't have", lambda n: n.startswith("MMPPF.")),
    ("Third-party libraries", lambda n: n.startswith(("GalaSoft.", "Newtonsoft.", "json.net", "Ninject", "ZLib.",
                                                      "Controls.SilverlightToolkit", "Silverlight.Samples.HLS",
                                                      "IGN.HttpLiveStreaming", "com.Akamai", "AppMeasurement",
                                                      "MediaAnalytics", "Brightcove", "AdobePass", "Crypto"))),
]


def build(b):
    a, f = b["Version"], b["FileVersion"]
    return a if f in ("", a) else "%s (file %s)" % (a, f)


def versions(r):
    """The newest build and the apps that carry it, and how many older builds there are."""
    bs = r["Builds"]
    text = build(bs[-1])
    if len(bs) > 1:
        text += " in %s; %d older build%s" % (", ".join(bs[-1]["Apps"]), len(bs) - 1, "s" if len(bs) > 2 else "")
    return text


def apps(r):
    return ", ".join(r["Apps"])


out = []
w = out.append
platform = [r for r in rows if r["Name"] in PLATFORM]
w("## Platform assemblies\n")
w("| Assembly | Version | Key token | Apps | Notes |\n|---|---|---|---|---|")
notes = {
    "System.Xml.Serialization": "Reference assembly only (no code). The code is in every app's `System.Xml.dll`.",
    "Microsoft.Xbox.RuntimeHelpers": "Reference assembly only (InternalCall intrinsics and stub bodies). The types are in every app's `mscorlib.dll`.",
    "Microsoft.Xbox.Epg": "Program guide.",
    "Microsoft.Xbox.Extensions": "",
}
for r in platform:
    w("| `%s` | %s | `%s` | %s | %s |" % (r["Name"], versions(r), r["Token"], apps(r), notes[r["Name"]]))
w("")
rest = [r for r in rows if r["Name"] not in PLATFORM]
shared = [r for r in rest if len(r["Apps"]) > 1 and r["Name"] not in OWN]
used = set()
for title, pred in GROUPS:
    sel = [r for r in shared if pred(r["Name"])]
    used.update(r["Name"] for r in sel)
    w("## %s\n" % title)
    w("| Assembly | Newest build | Apps |\n|---|---|---|")
    for r in sel:
        w("| `%s` | %s | %s (%d) |" % (r["Name"], versions(r), apps(r), len(r["Apps"])))
    w("")
families = [r for r in shared if r["Name"] not in used]
w("## Shared by one publisher's apps\n")
w("| Assembly | Newest build | Apps |\n|---|---|---|")
for r in families:
    w("| `%s` | %s | %s |" % (r["Name"], versions(r), apps(r)))
w("")
w("## Each app's own assemblies\n")
w("`XboxApplication` (%d apps) and `Resources` (%d apps) are names, not shared code: each app's is its own."
  " Every other assembly here is in one app only.\n" % (
      len(next(r for r in rows if r["Name"] == "XboxApplication")["Apps"]),
      len(next(r for r in rows if r["Name"] == "Resources")["Apps"])))
per_app = defaultdict(list)
for r in rest:
    if len(r["Apps"]) == 1:
        per_app[r["Apps"][0]].append(r)
w("| App | Assemblies |\n|---|---|")
for app in sorted(per_app, key=str.lower):
    w("| %s | %s |" % (app, ", ".join("`%s`%s" % (r["Name"], "" if r["Kind"] == "IL" else " (native image only)")
                                         for r in sorted(per_app[app], key=lambda r: r["Name"].lower()))))
w("")
tables = "\n".join(out)
page = open(dst, encoding="utf-8").read()
start, end = "<!-- tables: tools\\Get-DonorAssemblies.ps1 -->\n", "<!-- end of tables -->"
a = page.index(start) + len(start)
b = page.index(end)
open(dst, "w", encoding="utf-8", newline="\r\n").write(page[:a] + "\n" + tables + "\n" + page[b:])
print(len(platform), len(shared), len(families), len(per_app))
