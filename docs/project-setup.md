# Projects and Visual Studio

## The project file

An app is a Silverlight 3 class library that imports the SDK's targets instead of Silverlight's:

```xml
<Project ToolsVersion="4.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <PropertyGroup>
    <Configuration Condition=" '$(Configuration)' == '' ">Release</Configuration>
    <OutputType>Library</OutputType>
    <AssemblyName>MyApp</AssemblyName>
    <RootNamespace>MyApp</RootNamespace>
    <SilverlightAppEntry>MyApp.App</SilverlightAppEntry>
    <OutputPath>bin\$(Configuration)\</OutputPath>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="mscorlib" />
    <Reference Include="System" />
    <Reference Include="System.Core" />
    <Reference Include="System.Windows" />
    <Reference Include="System.Windows.Controls.Navigation" />  <!-- pages and Frame -->
    <Reference Include="Microsoft.Xbox" />                       <!-- Xbox controls -->
    <Reference Include="Microsoft.Xbox.Core" />                  <!-- XNA basics, PlayerIndex -->
    <Reference Include="Microsoft.Xbox.Services" />              <!-- gamer services -->
    <Reference Include="Microsoft.Xbox.Storage" />              <!-- storage and cache containers -->
  </ItemGroup>
  <ItemGroup>
    <ApplicationDefinition Include="App.xaml"><Generator>MSBuild:Compile</Generator></ApplicationDefinition>
    <Page Include="MainPage.xaml"><Generator>MSBuild:Compile</Generator></Page>
    <Compile Include="App.xaml.cs"><DependentUpon>App.xaml</DependentUpon></Compile>
    <Compile Include="MainPage.xaml.cs"><DependentUpon>MainPage.xaml</DependentUpon></Compile>
  </ItemGroup>
  <Import Project="path\to\Silverlight360\msbuild\XboxSilverlight.targets" />
</Project>
```

References name assemblies only. The SDK resolves them from the runtime profile's `reference` folder, never from desktop Silverlight, so the Xbox additions (`UIElement.GamePadButtonDown`, `Application.Shutdown`, ...) are there to compile against.

Available assemblies:

| Assembly | What's in it |
|---|---|
| `mscorlib`, `System`, `System.Core`, `System.Net`, `System.Xml` | The .NET base, with Xbox additions (see the reference). `System.Core` has LINQ, `Action<T1,T2>` and `Func<>`. |
| `System.Windows` | Silverlight 3 UI, plus controller input, media commands and the Xbox `MediaElement` and `Button` additions. |
| `System.Windows.Controls.Navigation` | `Frame`, `Page`, `NavigationService`. |
| `System.Xml.Linq` | LINQ to XML. |
| `System.Windows.Interactivity` | Blend behaviors and triggers. |
| `Microsoft.Xbox` | Xbox controls (`XboxApplicationFrame`, `Pivot`, `Rune`, `Legend`, `MediaTransport`, ...), Kinect, speech, SmartGlass, transitions. |
| `Microsoft.Xbox.Core` | XNA framework basics: `PlayerIndex`, math types, `FrameworkDispatcher`, sound effects. |
| `Microsoft.Xbox.Services` | XNA gamer services: signed-in gamers, the Guide, presence, XAuth tokens. |
| `Microsoft.Xbox.Storage` | XNA storage: `StorageDevice`, `StorageContainer`, `CacheContainer`. |
| `Microsoft.Web.Media.SmoothStreaming` | The Smooth Streaming player. |

## Build properties

| Property | Default | |
|---|---|---|
| `XboxRuntimeProfile` | `runtime\plex-2015` | Profile to compile against and package with. |
| `XboxPackageDir` | `bin\<Configuration>\xbox\` | Package output. |
| `XboxSplashScreen`, `XboxSplashScreen480` | `templates\*.jpg` | 1280x720 and 640x480 JPEG splash screens. |

## What goes into the package

The core framework (`mscorlib`, `System`, `System.Core`, `System.Net`, `System.Windows`, `System.Windows.RuntimeHost`, `System.Xml`) comes with the runtime and isn't listed in the app's manifest. Every other library, the Xbox ones included, is copied next to your assembly and listed in `AppManifest.xaml`, the way the shipped apps do it. XAML can only resolve types from assemblies the manifest lists: a page using `xbox:Pivot` fails to load with a `XamlParseException` (error 2255) if `Microsoft.Xbox` isn't there.

```
bin\Release\xbox\
  default.xex                  the host (XamlHost), from the profile
  xcoreclr.dll agcore.dll npctrl.dll ...   the runtime, from the profile
  *.dll *.ni.dll ...           framework assemblies and native images, from the profile
  AppManifest.xaml             generated: entry point and assembly parts
  XboxAppManifest.xml          resolutions and splash screens
  SplashScreenImage.jpg  SplashScreenImage480.jpg
  MyApp.dll                    your code (IL)
```

Your assemblies stay IL; the platform's CLR compiles them when they load. Native images aren't needed.

## Language

C# 3 and Silverlight 3, with what the Xbox runtime adds on top. XAML can't use `x:String`; declare `xmlns:sys="clr-namespace:System;assembly=mscorlib"` and use `sys:String`. `Dispatcher.BeginInvoke` takes a `Delegate`, so anonymous methods need a cast: `Dispatcher.BeginInvoke((Action)delegate { ... })`, or reference `System.Core` and pass a lambda.

## Visual Studio

The projects have no Silverlight project type GUID, so Visual Studio opens them as plain C# projects. Visual Studio 2026's MSBuild builds them unchanged, as long as the Silverlight 3 build targets and Windows SDK 7.0A are installed. Building from the IDE produces the same `bin\Release\xbox` package.

The first build needs `TargetPlatformSdkPath` when Windows SDK 7.0A isn't at the default path. `Build-XboxApp.ps1` passes it; in the IDE, add it to the project or set it as an environment variable.

## IntelliSense

Visual Studio shows IntelliSense text for a referenced assembly from an `<Assembly>.xml` next to it. `tools\Install-ApiDocs.ps1` writes those files into the profile's `reference` folder. Each member's text comes from the first of these that documents it:

1. The SDK's own documentation (`docs\api\*.xml`): every Xbox-specific type and member, and the Xbox additions to the standard assemblies.
2. Documentation already installed on your machine for the APIs the platform shares with them: the Silverlight 3 and 4 SDKs, the .NET Framework reference assemblies, and XNA Game Studio 4.
3. Standard patterns: dependency property identifiers, default constructors, standard overrides.

The script prints how much of each assembly is documented. With Silverlight 3 and XNA Game Studio 4 installed, every public member of every assembly in the default profile is covered.

The installed files are copied into the profile only. The profile stays local like the rest of it, so nothing of Microsoft's is redistributed.

To check the SDK's files after editing them:

```powershell
.\tools\Test-ApiDocs.ps1
```

It reports unknown member IDs, parameter names that don't match, missing summaries and `cref` links that don't resolve. `tools\new_api_reference.py` regenerates the Markdown [API reference](reference/README.md) from the same files.
