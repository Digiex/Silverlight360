# The common library

`library\Silverlight360.Common` is a class library of what apps and libraries for the platform share, in namespace `Silverlight360`. Every project that imports `msbuild\XboxSilverlight.targets` references it: the targets add the project reference, so a project needs nothing of its own for it.

| | |
|---|---|
| `NativeBuffer` | A pinned block of memory for the console's kernel and system library, with big-endian reads and writes, and the strings and pointers in returned buffers ([Native code](native-code.md#structures-and-pointers)) |
| `BigEndian` | Big-endian reads and writes on byte arrays, and NUL-terminated UTF-16BE and single-byte strings |
| `DebugLog` | Debug output through the kernel's `DbgPrint`, which xenia logs as `(DbgPrint) ...` ([Testing](testing.md#debug-output)) |
| `DirectionalFocus` | Focus moved by the D-pad and the left stick outside a `Pivot` ([Input and focus](input-and-focus.md)) |
| `Screenshot` | What the app shows, saved as `game:\<name>.argb`, for test scripts |

```csharp
using Silverlight360;

DebugLog.WriteLine("Loaded {0} items", items.Count);
using (NativeBuffer buffer = new NativeBuffer(16))
{
    // Hand buffer.Address to a native function that fills it in, then read it.
    uint size = buffer.U32(0);
    string text = buffer.Ansi(4, 12);
}
```

In XAML it's another assembly, so its namespace names it:

```xml
<UserControl xmlns:s360="clr-namespace:Silverlight360;assembly=Silverlight360.Common" ...>
  <Grid s360:DirectionalFocus.IsEnabled="True">
```

## In the package

`Silverlight360.Common.dll` goes beside the app's own assembly, in its XAP and its package, and `AppManifest.xaml` lists it. `Build-XboxApp.ps1` makes its native image with the app's own, from the manifest, and `-AppOnly` hands it out with them: it's part of the app's own files, not the runtime's. It's built with the app, from the SDK's source, so each app's copy is the one its image was made from.

A project that doesn't want it sets `XboxCommonLibrary` to `false`:

```xml
<XboxCommonLibrary>false</XboxCommonLibrary>
```

## Class libraries of your own

A project with `XboxLibrary` set to `true` is a class library: its assembly and its XML documentation for IntelliSense (`bin\<Configuration>\<AssemblyName>.xml`, from its `///` comments), and no XAP or package. It compiles against the same runtime profile as an app and references Silverlight360.Common too. An app references it with a `ProjectReference`, and its DLL then goes in the app's package beside the app's own:

```xml
<!-- MyLibrary.csproj -->
<PropertyGroup>
  <OutputType>Library</OutputType>
  <AssemblyName>MyLibrary</AssemblyName>
  <OutputPath>bin\$(Configuration)\</OutputPath>
  <XboxLibrary>true</XboxLibrary>
</PropertyGroup>
...
<Import Project="$(Silverlight360Dir)msbuild\XboxSilverlight.targets" />

<!-- MyApp.csproj -->
<ItemGroup>
  <ProjectReference Include="..\MyLibrary\MyLibrary.csproj" />
</ItemGroup>
```

`Build-XboxApp.ps1 -Project MyLibrary.csproj` builds a library alone, with no package and so no native images: those are made in the package of the app that references it. A library handed out as a DLL needs `Silverlight360.Common.dll` beside it, which the app's build puts there when the app imports the SDK's targets.
