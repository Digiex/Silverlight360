"""Writes Markdown API reference pages from the SDK's documentation files.

    python tools/new_api_reference.py

Reads docs/api/*.xml (the SDK's own IntelliSense text) and the public API
listings docs/api/*.api.jsonl and docs/api/xbox-additions/*.api.jsonl (made by
tools/Get-PublicApi.ps1), and writes docs/reference/<Namespace>.md plus an
index. Only APIs the SDK documents itself are covered: the Xbox libraries and
the Xbox additions to the Silverlight assemblies. Standard Silverlight, .NET
and XNA APIs are documented by Microsoft.
"""
import collections
import glob
import json
import os
import re
import xml.etree.ElementTree as ET

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
API = os.path.join(ROOT, "docs", "api")
OUT = os.path.join(ROOT, "docs", "reference")

KIND_ORDER = ["constructor", "property", "method", "event", "field", "enum value", "operator"]
KIND_TITLE = {"constructor": "Constructors", "property": "Properties", "method": "Methods", "event": "Events",
              "field": "Fields", "enum value": "Values", "operator": "Operators"}


def load_docs():
    docs = {}
    for path in glob.glob(os.path.join(API, "*.xml")):
        for member in ET.parse(path).getroot().iter("member"):
            docs.setdefault(member.get("name"), member)
    return docs


def load_api():
    members = {}
    for path in glob.glob(os.path.join(API, "*.api.jsonl")) + glob.glob(os.path.join(API, "xbox-additions", "*.api.jsonl")):
        assembly = os.path.basename(path)[:-len(".api.jsonl")]
        with open(path, encoding="utf-8") as f:
            for line in f:
                m = json.loads(line)
                m["assembly"] = assembly
                members.setdefault(m["id"], m)
    return members


def short_name(type_id):
    name = type_id.split("`")[0]
    return name.rsplit(".", 1)[-1]


def namespace_of(type_id):
    name = re.sub(r"`\d+", "", type_id)
    parts = name.split(".")
    return ".".join(parts[:-1]) or "(global)"


def link(cref, types):
    """A Markdown link for a cref: to the type's section when we have it."""
    target = cref[2:]
    if cref.startswith("T:"):
        type_id = target
    else:
        type_id = re.sub(r"\(.*", "", target).rsplit(".", 1)[0]
    label = re.sub(r"\(.*", "", target).replace("#ctor", short_name(type_id))
    label = re.sub(r"`+\d+", "", label)
    if not cref.startswith("T:"):
        label = short_name(type_id) + "." + label.rsplit(".", 1)[-1]
    else:
        label = short_name(type_id)
    if type_id in types:
        ns = namespace_of(type_id)
        return "[`%s`](%s.md#%s)" % (label, ns, anchor(type_id))
    return "`%s`" % label


def anchor(type_id):
    return re.sub(r"[^a-z0-9]+", "-", short_name(type_id).lower()).strip("-")


def text(element, types):
    """Flattens a doc element (summary, remarks, ...) to Markdown."""
    if element is None:
        return ""
    out = [element.text or ""]
    for child in element:
        tag = child.tag
        if tag == "see" and child.get("cref"):
            out.append(link(child.get("cref"), types))
        elif tag == "see" and child.get("langword"):
            out.append("`%s`" % child.get("langword"))
        elif tag in ("paramref", "typeparamref"):
            out.append("`%s`" % child.get("name"))
        elif tag == "c":
            out.append("`%s`" % "".join(child.itertext()))
        elif tag == "para":
            out.append("\n\n" + text(child, types).strip() + "\n\n")
        elif tag == "code":
            out.append("\n\n```csharp\n%s\n```\n\n" % "".join(child.itertext()).strip("\n"))
        elif tag == "list":
            for item in child.iter("item"):
                out.append("\n- " + text(item.find("description") if item.find("description") is not None else item, types).strip())
            out.append("\n")
        else:
            out.append(text(child, types))
        out.append(child.tail or "")
    result = "".join(out)
    result = re.sub(r"[ \t]*\n[ \t]*", "\n", result)
    result = re.sub(r"(?<!\n)\n(?!\n|- |```)", " ", result)
    return re.sub(r"\n{3,}", "\n\n", result).strip()


def main():
    docs = load_docs()
    api = load_api()
    types = {m["id"][2:]: m for m in api.values() if m["id"].startswith("T:") and m["id"] in docs}
    by_ns = collections.defaultdict(list)
    for type_id in types:
        by_ns[namespace_of(type_id)].append(type_id)
    members_of = collections.defaultdict(list)
    for m in api.values():
        if not m["id"].startswith("T:") and m["type"] in types:
            members_of[m["type"]].append(m)

    os.makedirs(OUT, exist_ok=True)
    for old in glob.glob(os.path.join(OUT, "*.md")):
        os.remove(old)
    index = ["# API reference", "",
             "The Xbox-specific APIs of the Silverlight runtime, from the SDK's own documentation.",
             "Visual Studio shows the same text in IntelliSense once `tools\\Install-ApiDocs.ps1` has run.",
             "Standard Silverlight 3, .NET and XNA APIs are covered by Microsoft's documentation.", ""]
    for ns in sorted(by_ns):
        type_ids = sorted(by_ns[ns], key=lambda t: short_name(t).lower())
        assemblies = sorted({types[t]["assembly"] for t in type_ids})
        index.append("- [%s](%s.md): %d types (%s)" % (ns, ns, len(type_ids), ", ".join(assemblies)))
        page = ["# %s" % ns, "", "Assembly: %s" % ", ".join("`%s.dll`" % a for a in assemblies), ""]
        page += ["| Type | Summary |", "|---|---|"]
        for t in type_ids:
            summary = text(docs[types[t]["id"]].find("summary"), types).replace("\n", " ").replace("|", "\\|")
            page.append("| [`%s`](#%s) | %s |" % (short_name(t), anchor(t), summary))
        page.append("")
        for t in type_ids:
            m = types[t]
            doc = docs[m["id"]]
            page += ["## %s" % short_name(t), "", "`%s`" % m["signature"], ""]
            page.append(text(doc.find("summary"), types))
            remarks = text(doc.find("remarks"), types)
            if remarks:
                page += ["", remarks]
            members = sorted(members_of[t], key=lambda x: (KIND_ORDER.index(x["kind"]) if x["kind"] in KIND_ORDER else 99, x["signature"]))
            for kind in KIND_ORDER:
                group = [x for x in members if x["kind"] == kind]
                if not group:
                    continue
                page += ["", "**%s**" % KIND_TITLE[kind], "", "| | |", "|---|---|"]
                for x in group:
                    d = docs.get(x["id"])
                    summary = text(d.find("summary"), types) if d is not None else ""
                    if d is not None and d.find("remarks") is not None:
                        summary += " " + text(d.find("remarks"), types)
                    summary = summary.replace("\n", " ").replace("|", "\\|").strip()
                    page.append("| `%s` | %s |" % (x["signature"].replace("|", "\\|"), summary))
            page.append("")
        with open(os.path.join(OUT, ns + ".md"), "w", encoding="utf-8") as f:
            f.write("\n".join(page) + "\n")
    with open(os.path.join(OUT, "README.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(index) + "\n")
    print("%d namespaces, %d types" % (len(by_ns), len(types)))


if __name__ == "__main__":
    main()
