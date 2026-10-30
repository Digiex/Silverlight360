# Microsoft.Xbox.Net

Assembly: `Microsoft.Xbox.dll`

| Type | Summary |
|---|---|
| [`DeviceDiscovery`](#devicediscovery) | Discovers UPnP devices (such as media servers) on the local network. |
| [`DeviceDiscoveryEventArgs`](#devicediscoveryeventargs) | Provides data for the [`DeviceDiscovery.DeviceAdded`](Microsoft.Xbox.Net.md#devicediscovery) and [`DeviceDiscovery.DeviceRemoved`](Microsoft.Xbox.Net.md#devicediscovery) events. |
| [`NetworkLinkStatusFlags`](#networklinkstatusflags) | Describes the console's network link. Several flags can be combined. |
| [`NetworkPerfCounters`](#networkperfcounters) | A snapshot of the console HTTP stack's counters, returned by [`NetworkSettings.GetNetworkPerfCounters`](Microsoft.Xbox.Net.md#networksettings). Useful for diagnostics and bandwidth display. |
| [`NetworkSettings`](#networksettings) | Reads and adjusts console network settings used by the application's HTTP requests. |
| [`UpnpDevice`](#upnpdevice) | A UPnP device found by [`DeviceDiscovery`](Microsoft.Xbox.Net.md#devicediscovery). |

## DeviceDiscovery

`class Microsoft.Xbox.Net.DeviceDiscovery`

Discovers UPnP devices (such as media servers) on the local network.

Call [`DeviceDiscovery.Start`](Microsoft.Xbox.Net.md#devicediscovery) on the UI thread. While discovery runs, the device list is polled every 3 seconds on the UI thread and [`DeviceDiscovery.DeviceAdded`](Microsoft.Xbox.Net.md#devicediscovery) and [`DeviceDiscovery.DeviceRemoved`](Microsoft.Xbox.Net.md#devicediscovery) are raised for the differences. Call [`DeviceDiscovery.Stop`](Microsoft.Xbox.Net.md#devicediscovery) when you no longer need results.

**Properties**

| | |
|---|---|
| `static System.Boolean IsStarted { get; }` | Gets whether a discovery session is running. Must be read on the UI thread. |

**Methods**

| | |
|---|---|
| `static System.Boolean Start(System.String target)` | Starts searching the local network for UPnP devices of the specified type. Must be called on the UI thread. |
| `static System.Void Stop()` | Stops device discovery and forgets the devices found so far. No [`DeviceDiscovery.DeviceRemoved`](Microsoft.Xbox.Net.md#devicediscovery) events are raised for them. Must be called on the UI thread. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xbox.Net.DeviceDiscoveryEventArgs> DeviceAdded` | Occurs on the UI thread when a device matching the search target is found. Devices whose description URL is not a valid URI are skipped. |
| `event System.EventHandler<Microsoft.Xbox.Net.DeviceDiscoveryEventArgs> DeviceRemoved` | Occurs on the UI thread when a previously found device is no longer reported. |

## DeviceDiscoveryEventArgs

`class Microsoft.Xbox.Net.DeviceDiscoveryEventArgs`

Provides data for the [`DeviceDiscovery.DeviceAdded`](Microsoft.Xbox.Net.md#devicediscovery) and [`DeviceDiscovery.DeviceRemoved`](Microsoft.Xbox.Net.md#devicediscovery) events.

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Net.UpnpDevice Device { get; }` | Gets the device that was found or removed. |

## NetworkLinkStatusFlags

`enum Microsoft.Xbox.Net.NetworkLinkStatusFlags`

Describes the console's network link. Several flags can be combined.

**Values**

| | |
|---|---|
| `FullDuplex` | The link is full duplex. |
| `HalfDuplex` | The link is half duplex. |
| `Link100mbps` | The wired link runs at 100 Mbps. |
| `Link10mbps` | The wired link runs at 10 Mbps. |
| `LinkActive` | A network link is active. |
| `LinkInactive` | No flags set: there is no active network link. |
| `LinkWireless` | The link is wireless. |

## NetworkPerfCounters

`struct Microsoft.Xbox.Net.NetworkPerfCounters`

A snapshot of the console HTTP stack's counters, returned by [`NetworkSettings.GetNetworkPerfCounters`](Microsoft.Xbox.Net.md#networksettings). Useful for diagnostics and bandwidth display.

**Fields**

| | |
|---|---|
| `System.Int32 ActiveConnectionHandleCount` | The number of open HTTP connection handles. |
| `System.Int32 ActiveRequestHandleCount` | The number of open HTTP request handles. |
| `System.Int32 ActiveSessionHandleCount` | The number of open HTTP session handles. |
| `System.Int64 TotalBytesReceived` | The total number of bytes received by the HTTP stack. |
| `System.Int64 TotalBytesSent` | The total number of bytes sent by the HTTP stack. |

## NetworkSettings

`class Microsoft.Xbox.Net.NetworkSettings`

Reads and adjusts console network settings used by the application's HTTP requests.

**Properties**

| | |
|---|---|
| `static System.Int32 ReceiveTimeout { get; set; }` | Gets or sets the time, in milliseconds, that HTTP requests wait for data from the server before failing. |
| `static System.String ActiveServiceEndpoint { get; }` | Gets the base URL of the online services environment the console is configured for (for example, the production or a test environment). |

**Methods**

| | |
|---|---|
| `static Microsoft.Xbox.Net.NetworkLinkStatusFlags GetNetworkLinkStatus()` | Gets the state of the console's network link (active, speed, duplex, wireless). Must be called on the UI thread. |
| `static Microsoft.Xbox.Net.NetworkPerfCounters GetNetworkPerfCounters()` | Gets the current HTTP stack counters. Must be called on the UI thread. |

## UpnpDevice

`class Microsoft.Xbox.Net.UpnpDevice`

A UPnP device found by [`DeviceDiscovery`](Microsoft.Xbox.Net.md#devicediscovery).

**Properties**

| | |
|---|---|
| `System.String Id { get; }` | Gets the unique identifier the device announced (its USN). |
| `System.Uri DescriptionUri { get; }` | Gets the HTTP URL of the device's description document. Download it to learn the device's name and services. |

