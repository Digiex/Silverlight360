# Performance

## How app code runs

The platform's runtime, `xcoreclr.dll`, has no JIT compiler on a retail console. Code runs one of two ways:

- **Precompiled.** The framework (`mscorlib`, `System`, `System.Core`, `System.Windows`, `System.Xml`, the `Microsoft.Xbox` libraries) ships as native images, the `.ni.dll` files next to each assembly. Their code runs as PowerPC code.
- **Interpreted.** Everything else, your app's assembly included, goes through the runtime's IL interpreter. A method the interpreter can't handle, and that isn't in a native image, stops the app with "Xbox 360 has encountered a method that it cannot compile or interpret."

The shipped apps' own assemblies have native images too (`XboxApplication.ni.dll`, `Newtonsoft.Json.ni.dll`, `Ninject.ni.dll` and others), made by Microsoft's build pipeline when the apps were published. Each is signed for its app and its load address, and no tool to make them ships with the platform, so a Silverlight360 app's code is interpreted.

## What it costs

Timed in xenia-edge with the Silverdash360 dashboard. A console is slower than a PC running xenia, so what matters here is the ratio between the columns; expect several times these times on hardware.

| Work | Interpreted app code | Framework code |
|---|---|---|
| Going through 1 MB of bytes | 1013 ms, a `for` loop | 0.75 ms, `Array.IndexOf` |
| Decoding a 30-character UTF-16BE name | 0.245 ms, a loop per character | 0.025 ms, `Encoding.BigEndianUnicode` |
| Sorting 1,500 strings | 115 ms, `List.Sort` with a lambda | 3.8 ms, `List.Sort` with `StringComparer`; 7.2 ms, `OrderBy` |
| Filtering 1,500 strings | 13 ms, `foreach` | 7.1 ms, `Where` with a lambda |

A call into the framework costs about what an interpreted call does; what the framework does inside it runs at full speed. So:

- **Leave loops over bytes and characters to the framework.** `Encoding.GetString`, `Array.IndexOf`, `Buffer.BlockCopy`, `String.IndexOf`, `BinaryReader` and `BinaryWriter` each do in one call what a loop of yours would do a thousand times slower.
- **Sort by a key, not a comparison.** `OrderBy` with a key lambda calls your code once an item; `List.Sort` with a `Comparison` lambda calls it for every pair. `List.Sort` with a framework comparer, such as `StringComparer.OrdinalIgnoreCase`, doesn't call your code at all.
- **LINQ is fine.** `System.Core` is precompiled, so `Where`, `Select` and `OrderBy` run natively and call your lambda once an item. A hand-written `foreach` over a `List<T>` was slower than `Where`, since its enumerator calls are interpreted too.
- **Do heavy work once, in the background.** Sort lists when the data changes rather than every time they're shown, and parse on a background thread (see [Threading](app-model.md#threading)).

## Runtime settings

`xcoreclr.dll` reads runtime settings from `Config\machine.config` in the package, as `<configuration><runtime><Name enabled="1" /></runtime></configuration>`; the profile's file sets `NGenEnableCreatePdb` that way. The interpreter has settings of its own (`InterpreterUseCaching`, `InterpreterJITThreshold`, `InterpreterLooseRules`, `InterpreterDoLoopMethods` and others), but none has been tried. In the later open-source CoreCLR interpreter these settings default to caching on, `InterpreterJITThreshold` matters only with a JIT compiler, and most are for debugging.
