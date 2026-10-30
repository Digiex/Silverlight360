// Reads the public API of .NET assemblies with System.Reflection.Metadata and
// names every type and member with its XML documentation comment ID, the key
// Visual Studio uses to find IntelliSense text in <Assembly>.xml.
// Used by tools\Get-PublicApi.ps1 and tools\Install-ApiDocs.ps1.
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Reflection.Metadata;
using System.Reflection.PortableExecutable;
using System.Text;

namespace XboxSdk
{
    public class ApiMember
    {
        public string Id;          // documentation comment ID, e.g. M:Ns.Type.Method(System.Int32)
        public string Kind;        // type kind or member kind
        public string Signature;   // readable C#-like signature
        public string DeclaringType;
        public string[] Parameters = new string[0];
        public string[] TypeParameters = new string[0];
        public bool HasReturn;
    }

    // Writes type names in documentation ID form.
    class DocIdProvider : ISignatureTypeProvider<string, object>
    {
        readonly MetadataReader md;
        public DocIdProvider(MetadataReader md) { this.md = md; }

        public string GetPrimitiveType(PrimitiveTypeCode t)
        {
            switch (t)
            {
                case PrimitiveTypeCode.Boolean: return "System.Boolean";
                case PrimitiveTypeCode.Byte: return "System.Byte";
                case PrimitiveTypeCode.SByte: return "System.SByte";
                case PrimitiveTypeCode.Char: return "System.Char";
                case PrimitiveTypeCode.Int16: return "System.Int16";
                case PrimitiveTypeCode.UInt16: return "System.UInt16";
                case PrimitiveTypeCode.Int32: return "System.Int32";
                case PrimitiveTypeCode.UInt32: return "System.UInt32";
                case PrimitiveTypeCode.Int64: return "System.Int64";
                case PrimitiveTypeCode.UInt64: return "System.UInt64";
                case PrimitiveTypeCode.Single: return "System.Single";
                case PrimitiveTypeCode.Double: return "System.Double";
                case PrimitiveTypeCode.IntPtr: return "System.IntPtr";
                case PrimitiveTypeCode.UIntPtr: return "System.UIntPtr";
                case PrimitiveTypeCode.Object: return "System.Object";
                case PrimitiveTypeCode.String: return "System.String";
                case PrimitiveTypeCode.TypedReference: return "System.TypedReference";
                case PrimitiveTypeCode.Void: return "System.Void";
            }
            return "?";
        }
        public string GetTypeFromDefinition(MetadataReader r, TypeDefinitionHandle h, byte kind) { return Api.TypeName(r, h); }
        public string GetTypeFromReference(MetadataReader r, TypeReferenceHandle h, byte kind) { return Api.TypeRefName(r, h); }
        public string GetTypeFromSpecification(MetadataReader r, object ctx, TypeSpecificationHandle h, byte kind)
        {
            return r.GetTypeSpecification(h).DecodeSignature(this, ctx);
        }
        public string GetSZArrayType(string e) { return e + "[]"; }
        public string GetArrayType(string e, ArrayShape s)
        {
            var dims = new List<string>();
            for (int i = 0; i < s.Rank; i++) dims.Add(i < s.LowerBounds.Length ? s.LowerBounds[i] + ":" : "0:");
            return e + "[" + string.Join(",", dims) + "]";
        }
        public string GetByReferenceType(string e) { return e + "@"; }
        public string GetPointerType(string e) { return e + "*"; }
        public string GetPinnedType(string e) { return e; }
        public string GetModifiedType(string m, string u, bool req) { return u; }
        public string GetFunctionPointerType(MethodSignature<string> s) { return "System.IntPtr"; }
        public string GetGenericMethodParameter(object ctx, int i) { return "``" + i; }
        public string GetGenericTypeParameter(object ctx, int i) { return "`" + i; }
        public string GetGenericInstantiation(string g, ImmutableArray<string> args)
        {
            int tick = g.LastIndexOf('`');
            string bare = tick > 0 ? g.Substring(0, tick) : g;
            return bare + "{" + string.Join(",", args) + "}";
        }
    }

    public static class Api
    {
        public static string TypeName(MetadataReader md, TypeDefinitionHandle h)
        {
            var t = md.GetTypeDefinition(h);
            string name = md.GetString(t.Name);
            var decl = t.GetDeclaringType();
            if (!decl.IsNil) return TypeName(md, decl) + "." + name;
            string ns = md.GetString(t.Namespace);
            return ns.Length > 0 ? ns + "." + name : name;
        }

        public static string TypeRefName(MetadataReader md, TypeReferenceHandle h)
        {
            var t = md.GetTypeReference(h);
            string name = md.GetString(t.Name);
            if (t.ResolutionScope.Kind == HandleKind.TypeReference)
                return TypeRefName(md, (TypeReferenceHandle)t.ResolutionScope) + "." + name;
            string ns = md.GetString(t.Namespace);
            return ns.Length > 0 ? ns + "." + name : name;
        }

        static bool IsVisible(MetadataReader md, TypeDefinition t)
        {
            var vis = t.Attributes & TypeAttributes.VisibilityMask;
            if (vis == TypeAttributes.Public) return true;
            if (vis == TypeAttributes.NestedPublic || vis == TypeAttributes.NestedFamily || vis == TypeAttributes.NestedFamORAssem)
                return IsVisible(md, md.GetTypeDefinition(t.GetDeclaringType()));
            return false;
        }

        static bool IsVisible(MethodAttributes a)
        {
            var acc = a & MethodAttributes.MemberAccessMask;
            return acc == MethodAttributes.Public || acc == MethodAttributes.Family || acc == MethodAttributes.FamORAssem;
        }

        static bool IsVisible(FieldAttributes a)
        {
            var acc = a & FieldAttributes.FieldAccessMask;
            return acc == FieldAttributes.Public || acc == FieldAttributes.Family || acc == FieldAttributes.FamORAssem;
        }

        static string Readable(string docType)
        {
            return docType.Replace('{', '<').Replace('}', '>').Replace("@", "&");
        }

        static string ParamList(MethodSignature<string> sig)
        {
            if (sig.ParameterTypes.Length == 0) return "";
            return "(" + string.Join(",", sig.ParameterTypes) + ")";
        }

        static string[] ParamNames(MetadataReader md, MethodDefinition m)
        {
            var names = new List<string>();
            foreach (var ph in m.GetParameters())
            {
                var p = md.GetParameter(ph);
                if (p.SequenceNumber > 0) names.Add(md.GetString(p.Name));
            }
            return names.ToArray();
        }

        static string[] GenericNames(MetadataReader md, GenericParameterHandleCollection g)
        {
            return g.Select(h => md.GetString(md.GetGenericParameter(h).Name)).ToArray();
        }

        static string TypeKind(MetadataReader md, TypeDefinition t)
        {
            if ((t.Attributes & TypeAttributes.Interface) != 0) return "interface";
            string baseName = "";
            if (!t.BaseType.IsNil)
            {
                if (t.BaseType.Kind == HandleKind.TypeReference) baseName = TypeRefName(md, (TypeReferenceHandle)t.BaseType);
                else if (t.BaseType.Kind == HandleKind.TypeDefinition) baseName = TypeName(md, (TypeDefinitionHandle)t.BaseType);
            }
            if (baseName == "System.Enum") return "enum";
            if (baseName == "System.ValueType") return "struct";
            if (baseName == "System.MulticastDelegate") return "delegate";
            return "class";
        }

        public static List<ApiMember> Read(string path)
        {
            var result = new List<ApiMember>();
            using (var pe = new PEReader(File.OpenRead(path)))
            {
                var md = pe.GetMetadataReader();
                var provider = new DocIdProvider(md);
                foreach (var th in md.TypeDefinitions)
                {
                    var t = md.GetTypeDefinition(th);
                    if (!IsVisible(md, t)) continue;
                    string tn = TypeName(md, th);
                    int typeArity = t.GetGenericParameters().Count;
                    string kind = TypeKind(md, t);
                    // Metadata names already end in `arity for generic types.
                    string typeId = tn;
                    var type = new ApiMember { Id = "T:" + typeId, Kind = kind, Signature = kind + " " + tn, DeclaringType = "",
                                               TypeParameters = GenericNames(md, t.GetGenericParameters()) };
                    result.Add(type);
                    if (kind == "delegate")
                    {
                        foreach (var mh in t.GetMethods())
                        {
                            var m = md.GetMethodDefinition(mh);
                            if (md.GetString(m.Name) != "Invoke") continue;
                            var sig = m.DecodeSignature(provider, null);
                            type.Parameters = ParamNames(md, m);
                            type.HasReturn = sig.ReturnType != "System.Void";
                            type.Signature = "delegate " + Readable(sig.ReturnType) + " " + tn + "(" + string.Join(", ", sig.ParameterTypes.Select(Readable)) + ")";
                        }
                        continue;
                    }

                    var accessors = new HashSet<MethodDefinitionHandle>();
                    foreach (var ph in t.GetProperties())
                    {
                        var p = md.GetPropertyDefinition(ph);
                        var acc = p.GetAccessors();
                        var getter = acc.Getter.IsNil ? (MethodDefinition?)null : md.GetMethodDefinition(acc.Getter);
                        var setter = acc.Setter.IsNil ? (MethodDefinition?)null : md.GetMethodDefinition(acc.Setter);
                        if (!acc.Getter.IsNil) accessors.Add(acc.Getter);
                        if (!acc.Setter.IsNil) accessors.Add(acc.Setter);
                        bool visible = (getter.HasValue && IsVisible(getter.Value.Attributes)) || (setter.HasValue && IsVisible(setter.Value.Attributes));
                        if (!visible) continue;
                        var sig = p.DecodeSignature(provider, null);
                        string name = md.GetString(p.Name);
                        bool canRead = getter.HasValue && IsVisible(getter.Value.Attributes);
                        bool canWrite = setter.HasValue && IsVisible(setter.Value.Attributes);
                        bool isStatic = (getter ?? setter).Value.Attributes.HasFlag(MethodAttributes.Static);
                        string[] pnames = getter.HasValue ? ParamNames(md, getter.Value) : new string[0];
                        result.Add(new ApiMember
                        {
                            Id = "P:" + typeId + "." + name + ParamList(sig),
                            Kind = "property",
                            DeclaringType = typeId,
                            Parameters = pnames,
                            Signature = (isStatic ? "static " : "") + Readable(sig.ReturnType) + " " + name +
                                        (sig.ParameterTypes.Length > 0 ? "[" + string.Join(", ", sig.ParameterTypes.Select(Readable)) + "]" : "") +
                                        " { " + (canRead ? "get; " : "") + (canWrite ? "set; " : "") + "}",
                        });
                    }
                    foreach (var eh in t.GetEvents())
                    {
                        var e = md.GetEventDefinition(eh);
                        var acc = e.GetAccessors();
                        if (!acc.Adder.IsNil) accessors.Add(acc.Adder);
                        if (!acc.Remover.IsNil) accessors.Add(acc.Remover);
                        if (acc.Adder.IsNil || !IsVisible(md.GetMethodDefinition(acc.Adder).Attributes)) continue;
                        string handler = e.Type.Kind == HandleKind.TypeReference ? TypeRefName(md, (TypeReferenceHandle)e.Type)
                            : e.Type.Kind == HandleKind.TypeDefinition ? TypeName(md, (TypeDefinitionHandle)e.Type)
                            : md.GetTypeSpecification((TypeSpecificationHandle)e.Type).DecodeSignature(provider, null);
                        string name = md.GetString(e.Name);
                        result.Add(new ApiMember { Id = "E:" + typeId + "." + name, Kind = "event", DeclaringType = typeId,
                                                   Signature = "event " + Readable(handler) + " " + name });
                    }
                    foreach (var fh in t.GetFields())
                    {
                        var f = md.GetFieldDefinition(fh);
                        if (!IsVisible(f.Attributes) || f.Attributes.HasFlag(FieldAttributes.SpecialName)) continue;
                        string name = md.GetString(f.Name);
                        string ft = f.DecodeSignature(provider, null);
                        string mods = f.Attributes.HasFlag(FieldAttributes.Literal) ? "const " : f.Attributes.HasFlag(FieldAttributes.Static) ? "static " : "";
                        result.Add(new ApiMember { Id = "F:" + typeId + "." + name, Kind = kind == "enum" ? "enum value" : "field",
                                                   DeclaringType = typeId, Signature = kind == "enum" ? name : mods + Readable(ft) + " " + name });
                    }
                    foreach (var mh in t.GetMethods())
                    {
                        if (accessors.Contains(mh)) continue;
                        var m = md.GetMethodDefinition(mh);
                        if (!IsVisible(m.Attributes)) continue;
                        string name = md.GetString(m.Name);
                        if (name == ".cctor") continue;
                        var sig = m.DecodeSignature(provider, null);
                        int arity = m.GetGenericParameters().Count;
                        string idName = name.Replace('.', '#') + (arity > 0 ? "``" + arity : "");
                        string id = "M:" + typeId + "." + idName + ParamList(sig);
                        if (name == "op_Implicit" || name == "op_Explicit") id += "~" + sig.ReturnType;
                        string[] pnames = ParamNames(md, m);
                        string display = name == ".ctor" ? tn.Substring(tn.LastIndexOf('.') + 1) : name;
                        var parts = new List<string>();
                        for (int i = 0; i < sig.ParameterTypes.Length; i++)
                            parts.Add(Readable(sig.ParameterTypes[i]) + (i < pnames.Length ? " " + pnames[i] : ""));
                        result.Add(new ApiMember
                        {
                            Id = id,
                            Kind = name == ".ctor" ? "constructor" : name.StartsWith("op_") ? "operator" : "method",
                            DeclaringType = typeId,
                            Parameters = pnames,
                            TypeParameters = GenericNames(md, m.GetGenericParameters()),
                            HasReturn = sig.ReturnType != "System.Void" && name != ".ctor",
                            Signature = (m.Attributes.HasFlag(MethodAttributes.Static) ? "static " : "") +
                                        (name == ".ctor" ? "" : Readable(sig.ReturnType) + " ") + display + "(" + string.Join(", ", parts) + ")",
                        });
                    }
                }
            }
            return result;
        }

        static string Json(string s)
        {
            var sb = new StringBuilder("\"");
            foreach (char c in s)
            {
                if (c == '"' || c == '\\') sb.Append('\\').Append(c);
                else if (c < 0x20) sb.AppendFormat("\\u{0:x4}", (int)c);
                else sb.Append(c);
            }
            return sb.Append('"').ToString();
        }

        // One JSON object per line: easy to grep and to load.
        public static void WriteJsonLines(IEnumerable<ApiMember> members, string path)
        {
            using (var w = new StreamWriter(path, false, new UTF8Encoding(false)))
            {
                foreach (var m in members)
                {
                    w.WriteLine("{\"id\":" + Json(m.Id) + ",\"kind\":" + Json(m.Kind) + ",\"type\":" + Json(m.DeclaringType) +
                                ",\"signature\":" + Json(m.Signature) +
                                ",\"params\":[" + string.Join(",", m.Parameters.Select(Json)) + "]" +
                                ",\"typeparams\":[" + string.Join(",", m.TypeParameters.Select(Json)) + "]" +
                                ",\"returns\":" + (m.HasReturn ? "true" : "false") + "}");
                }
            }
        }
    }
}
