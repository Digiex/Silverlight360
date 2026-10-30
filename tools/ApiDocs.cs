// Builds IntelliSense files (<Assembly>.xml) for a runtime profile's
// reference assemblies. Each member's text comes from the SDK's own docs
// first, then from documentation files already installed on this machine
// (Silverlight, .NET Framework, XNA Game Studio), matched by documentation ID.
// Used by tools\Install-ApiDocs.ps1.
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Linq;

namespace XboxSdk
{
    public class DocIndex
    {
        readonly Dictionary<string, XElement> members = new Dictionary<string, XElement>(StringComparer.Ordinal);
        readonly Dictionary<string, string> sources = new Dictionary<string, string>(StringComparer.Ordinal);

        public int Count { get { return members.Count; } }

        // Adds the members of a documentation file; earlier files win.
        public void AddFile(string path)
        {
            XDocument doc;
            try { doc = XDocument.Load(path, LoadOptions.PreserveWhitespace); }
            catch (Exception) { return; }
            var root = doc.Root;
            if (root == null || root.Name.LocalName != "doc") return;
            var list = root.Element("members");
            if (list == null) return;
            foreach (var m in list.Elements("member"))
            {
                var name = (string)m.Attribute("name");
                if (name == null || members.ContainsKey(name)) continue;
                members[name] = m;
                sources[name] = path;
            }
        }

        public void AddDirectory(string dir)
        {
            if (!Directory.Exists(dir)) return;
            foreach (var f in Directory.GetFiles(dir, "*.xml"))
                AddFile(f);
        }

        public XElement Find(string id) { XElement e; return members.TryGetValue(id, out e) ? e : null; }
        public string SourceOf(string id) { string s; return sources.TryGetValue(id, out s) ? s : null; }
    }

    public class DocResult
    {
        public int Total;
        public int Own;
        public int Installed;
        public int Pattern;
        public List<string> Missing = new List<string>();
    }

    public static class ApiDocs
    {
        // Problems in an SDK documentation file: unknown IDs (typos or members
        // that don't exist), parameter names that don't match, empty
        // summaries, cref targets that don't resolve.
        public static List<string> Validate(string docPath, IEnumerable<string> assemblyPaths)
        {
            var problems = new List<string>();
            var api = new Dictionary<string, ApiMember>(StringComparer.Ordinal);
            foreach (var a in assemblyPaths)
                foreach (var m in Api.Read(a))
                    api[m.Id] = m;
            XDocument doc;
            try { doc = XDocument.Load(docPath); }
            catch (Exception e) { problems.Add("not well-formed XML: " + e.Message); return problems; }
            var seen = new HashSet<string>(StringComparer.Ordinal);
            foreach (var e in doc.Descendants("member"))
            {
                string id = (string)e.Attribute("name");
                if (id == null) { problems.Add("member without name"); continue; }
                if (!seen.Add(id)) problems.Add(id + ": documented twice");
                ApiMember m;
                if (!api.TryGetValue(id, out m)) { problems.Add(id + ": no such public type or member"); continue; }
                var summary = e.Element("summary");
                if (summary == null || string.IsNullOrWhiteSpace(summary.Value)) problems.Add(id + ": no summary");
                var names = e.Elements("param").Select(p => (string)p.Attribute("name")).ToList();
                foreach (var n in names)
                    if (!m.Parameters.Contains(n)) problems.Add(id + ": no parameter named " + n);
                foreach (var p in m.Parameters)
                    if (!names.Contains(p)) problems.Add(id + ": parameter " + p + " not documented");
                if (m.HasReturn && e.Element("returns") == null && m.Kind != "property")
                    problems.Add(id + ": no returns");
                foreach (var c in e.Descendants().Select(d => (string)d.Attribute("cref")).Where(c => c != null))
                    if (c.Length > 2 && c[1] == ':' && !api.ContainsKey(c) && !c.StartsWith("T:System.") && !c.StartsWith("M:System.")
                        && !c.StartsWith("P:System.") && !c.StartsWith("E:System.") && !c.StartsWith("F:System."))
                        problems.Add(id + ": cref " + c + " doesn't resolve");
            }
            return problems;
        }

        static string Short(string typeId)
        {
            string name = typeId;
            int tick = name.IndexOf('`');
            if (tick >= 0) name = name.Substring(0, tick);
            return name.Substring(name.LastIndexOf('.') + 1);
        }

        static XElement Summary(string id, string text, ApiMember m)
        {
            var e = XElement.Parse("<member name=\"" + System.Security.SecurityElement.Escape(id) + "\"><summary>" + text + "</summary></member>");
            foreach (var p in m.Parameters)
                e.Add(new XElement("param", new XAttribute("name", p)));
            return e;
        }

        // Text for members whose meaning follows from a .NET pattern:
        // dependency property identifiers, default constructors, standard
        // overrides and change events. Null for anything else.
        public static XElement FromPattern(ApiMember m, HashSet<string> ids)
        {
            string type = m.DeclaringType;
            string cref = "T:" + type;
            string memberName = m.Id.Substring(2);
            int paren = memberName.IndexOf('(');
            if (paren >= 0) memberName = memberName.Substring(0, paren);
            memberName = memberName.Substring(memberName.LastIndexOf('.') + 1);

            if (m.Kind == "field" && memberName.EndsWith("Property"))
            {
                string prop = "P:" + type + "." + memberName.Substring(0, memberName.Length - "Property".Length);
                if (ids.Contains(prop))
                    return Summary(m.Id, "Identifies the <see cref=\"" + prop + "\"/> dependency property.", m);
                string attached = memberName.Substring(0, memberName.Length - "Property".Length);
                if (ids.Contains("M:" + type + ".Get" + attached + "(System.Windows.DependencyObject)"))
                    return Summary(m.Id, "Identifies the " + attached + " attached property.", m);
            }
            if (m.Kind == "constructor" && m.Parameters.Length == 0)
                return Summary(m.Id, "Initializes a new instance of the <see cref=\"" + cref + "\"/> class.", m);
            if (m.Kind == "event" && memberName.EndsWith("Changed"))
            {
                string prop = "P:" + type + "." + memberName.Substring(0, memberName.Length - "Changed".Length);
                if (ids.Contains(prop))
                    return Summary(m.Id, "Occurs when <see cref=\"" + prop + "\"/> changes.", m);
            }
            if (m.Kind == "method")
            {
                switch (memberName)
                {
                    case "OnApplyTemplate":
                        return Summary(m.Id, "Gets the parts of the control template when a template is applied.", m);
                    case "MeasureOverride":
                        return Summary(m.Id, "Measures the children and returns the size this element needs.", m);
                    case "ArrangeOverride":
                        return Summary(m.Id, "Places the children and returns the size used.", m);
                    case "OnCreateAutomationPeer":
                        return Summary(m.Id, "Returns the automation peer for this element.", m);
                    case "ToString":
                        return Summary(m.Id, "Returns a string that represents this instance.", m);
                    case "GetHashCode":
                        return Summary(m.Id, "Returns a hash code for this instance.", m);
                    case "Equals":
                        return Summary(m.Id, "Returns whether this instance equals another.", m);
                    case "Dispose":
                        if (m.Parameters.Length == 0)
                            return Summary(m.Id, "Releases the resources this instance holds.", m);
                        break;
                    case "Convert":
                        if (m.Parameters.Length == 4)
                            return Summary(m.Id, "Converts a binding source value to the target type.", m);
                        break;
                    case "ConvertBack":
                        if (m.Parameters.Length == 4)
                            return Summary(m.Id, "Converts a target value back to the binding source type.", m);
                        break;
                }
            }
            return null;
        }

        // Writes <assembly>.xml next to the assembly, for the members of its
        // public API that either index documents.
        public static DocResult Build(string assemblyPath, DocIndex own, DocIndex installed, string outPath)
        {
            var api = Api.Read(assemblyPath);
            var ids = new HashSet<string>(api.Select(a => a.Id), StringComparer.Ordinal);
            var result = new DocResult { Total = api.Count };
            var doc = new XElement("doc",
                new XElement("assembly", new XElement("name", Path.GetFileNameWithoutExtension(assemblyPath))));
            var list = new XElement("members");
            doc.Add(list);
            foreach (var m in api)
            {
                var e = own.Find(m.Id);
                if (e != null) result.Own++;
                else
                {
                    e = installed.Find(m.Id);
                    if (e != null) result.Installed++;
                    else
                    {
                        e = FromPattern(m, ids);
                        if (e != null) result.Pattern++;
                    }
                }
                if (e == null) { result.Missing.Add(m.Id); continue; }
                list.Add(new XElement(e));
            }
            var settings = new XmlWriterSettings { Indent = true, Encoding = new UTF8Encoding(false) };
            using (var w = XmlWriter.Create(outPath, settings))
                new XDocument(new XDeclaration("1.0", "utf-8", null), doc).Save(w);
            return result;
        }
    }
}
