# Microsoft.Xbox

Assembly: `Microsoft.Xbox.dll`, `System.Core.dll`, `mscorlib.dll`

| Type | Summary |
|---|---|
| [`ALU`](#alu) | Exposes Xbox 360 (PowerPC) integer instructions as methods that the JIT compiler emits inline. |
| [`Cache`](#cache) | Exposes Xbox 360 (PowerPC) data cache control instructions as methods that the JIT compiler emits inline. |
| [`Companion`](#companion) | Exchanges messages with SmartGlass companion devices (phones, tablets, PCs) that are connected to the console. |
| [`CompanionConnectedEventArgs`](#companionconnectedeventargs) | Provides data for the [`Companion.Connected`](Microsoft.Xbox.md#companion) event. |
| [`CompanionConnectionProtocol`](#companionconnectionprotocol) | Identifies the transport used by a companion device connection. |
| [`CompanionDisconnectedEventArgs`](#companiondisconnectedeventargs) | Provides data for the [`Companion.Disconnected`](Microsoft.Xbox.md#companion) event. |
| [`CompanionEventArgs`](#companioneventargs) | Base class for the data of [`Companion`](Microsoft.Xbox.md#companion) events; identifies the companion client and the console user it belongs to. |
| [`CompanionFailedEventArgs`](#companionfailedeventargs) | Provides data for the [`Companion.Failed`](Microsoft.Xbox.md#companion) event. |
| [`CompanionFailure`](#companionfailure) | Describes why a companion operation failed. |
| [`CompanionKeyboardTextChangedArgs`](#companionkeyboardtextchangedargs) | Provides the new text when a SmartGlass companion keyboard edits the text of the focused on-screen keyboard (`Rune`) control. |
| [`CompanionReceivedEventArgs`](#companionreceivedeventargs) | Provides data for the [`Companion.ReceivedMessage`](Microsoft.Xbox.md#companion) event. |
| [`CompanionSendCompletedEventArgs`](#companionsendcompletedeventargs) | Provides data for the [`Companion.SendMessageCompleted`](Microsoft.Xbox.md#companion) event. |
| [`FPU`](#fpu) | Exposes Xbox 360 (PowerPC) floating-point instructions as methods that the JIT compiler emits inline. |
| [`MethodExtensions`](#methodextensions) | Provides extension methods for `Thread` that query and set which Xbox 360 hardware thread a managed thread runs on. |
| [`RuntimeHelpers`](#runtimehelpers) | Provides Xbox 360 runtime services: console language and locale, processor affinity, ahead-of-time compilation of call graphs, and resource helpers. |

## ALU

`class Microsoft.Xbox.ALU`

Exposes Xbox 360 (PowerPC) integer instructions as methods that the JIT compiler emits inline.

**Methods**

| | |
|---|---|
| `static System.Int64 mulh(System.Int64 a, System.Int64 b)` | Returns the high 64 bits of the 128-bit signed product of two 64-bit integers. |
| `static System.UInt32 cntlzd(System.Int64 b)` | Counts the leading zero bits of a 64-bit value. |
| `static System.UInt32 cntlzw(System.Int32 b)` | Counts the leading zero bits of a 32-bit value. |
| `static System.UInt64 umulh(System.UInt64 a, System.UInt64 b)` | Returns the high 64 bits of the 128-bit unsigned product of two 64-bit integers. |

## Cache

`class Microsoft.Xbox.Cache`

Exposes Xbox 360 (PowerPC) data cache control instructions as methods that the JIT compiler emits inline.

Each method addresses the cache block containing the address `_base + offset`. These methods are security critical and take unmanaged pointers, so they are not available to application code.

**Methods**

| | |
|---|---|
| `static System.Void dcbf(System.Int32 offset, System.Void* _base)` | Writes the cache block containing the specified address back to memory if it was modified and removes it from the cache. |
| `static System.Void dcbst(System.Int32 offset, System.Void* _base)` | Writes the cache block containing the specified address back to memory if it was modified, keeping it in the cache. |
| `static System.Void dcbt(System.Int32 offset, System.Void* _base)` | Hints that the cache block containing the specified address will be read soon, so it can be prefetched. |
| `static System.Void dcbz(System.Int32 offset, System.Void* _base)` | Zeroes the data cache block that contains the specified address without reading it from memory first. |
| `static System.Void dcbz128(System.Int32 offset, System.Void* _base)` | Zeroes the 128-byte cache line that contains the specified address without reading it from memory first. |

## Companion

`class Microsoft.Xbox.Companion`

Exchanges messages with SmartGlass companion devices (phones, tablets, PCs) that are connected to the console.

The companion session starts when the first handler is attached to any of this class's events and stops, discarding pending send contexts, when the last handler is removed. Keep at least one handler attached for as long as you want to receive companion traffic. All events are posted to the UI thread through the main `Dispatcher`. A message is a flat set of string key/value pairs; nested JSON is not supported.

**Methods**

| | |
|---|---|
| `static System.Void SendMessage(System.Int32 clientId, System.Collections.Generic.Dictionary<System.String,System.String> msg, System.Object context)` | Sends a key/value message to a connected companion device using reliable delivery. The call returns immediately; completion is reported through [`Companion.SendMessageCompleted`](Microsoft.Xbox.md#companion) or [`Companion.Failed`](Microsoft.Xbox.md#companion). Attach a handler to at least one [`Companion`](Microsoft.Xbox.md#companion) event first so that the companion service is running. |

**Events**

| | |
|---|---|
| `event Microsoft.Xbox.CompanionEventHandler<Microsoft.Xbox.CompanionConnectedEventArgs> Connected` | Occurs when a companion device connects to the application. Raised on the UI thread. Attaching the first handler to any [`Companion`](Microsoft.Xbox.md#companion) event starts the companion service. |
| `event Microsoft.Xbox.CompanionEventHandler<Microsoft.Xbox.CompanionDisconnectedEventArgs> Disconnected` | Occurs when a companion device disconnects. Raised on the UI thread. |
| `event Microsoft.Xbox.CompanionEventHandler<Microsoft.Xbox.CompanionFailedEventArgs> Failed` | Occurs when a companion connection, send or receive operation fails, or when a received message cannot be converted to a key/value dictionary. Raised on the UI thread. For a failed send, [`CompanionFailedEventArgs.SendContext`](Microsoft.Xbox.md#companionfailedeventargs) holds the context object that was passed to [`Companion.SendMessage`](Microsoft.Xbox.md#companion). |
| `event Microsoft.Xbox.CompanionEventHandler<Microsoft.Xbox.CompanionReceivedEventArgs> ReceivedMessage` | Occurs when a message arrives from a companion device. Raised on the UI thread. If the incoming message contains a duplicate key, this event is not raised; [`Companion.Failed`](Microsoft.Xbox.md#companion) is raised with [`CompanionFailure.ReceivedUnsupportedJSon`](Microsoft.Xbox.md#companionfailure) instead. |
| `event Microsoft.Xbox.CompanionEventHandler<Microsoft.Xbox.CompanionSendCompletedEventArgs> SendMessageCompleted` | Occurs when a message sent with [`Companion.SendMessage`](Microsoft.Xbox.md#companion) has been delivered. Raised on the UI thread. |

## CompanionConnectedEventArgs

`class Microsoft.Xbox.CompanionConnectedEventArgs`

Provides data for the [`Companion.Connected`](Microsoft.Xbox.md#companion) event.

**Constructors**

| | |
|---|---|
| `CompanionConnectedEventArgs()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.CompanionConnectionProtocol Protocol { get; }` | Gets the transport the companion device connected over. |

## CompanionConnectionProtocol

`enum Microsoft.Xbox.CompanionConnectionProtocol`

Identifies the transport used by a companion device connection.

**Values**

| | |
|---|---|
| `Cloud` | A connection relayed through the online service. |
| `None` | No transport, or the transport is not known. |
| `Tcp` | A direct TCP connection over the local network. |

## CompanionDisconnectedEventArgs

`class Microsoft.Xbox.CompanionDisconnectedEventArgs`

Provides data for the [`Companion.Disconnected`](Microsoft.Xbox.md#companion) event.

**Constructors**

| | |
|---|---|
| `CompanionDisconnectedEventArgs()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.CompanionConnectionProtocol Protocol { get; }` | Gets the transport the companion device was connected over. |

## CompanionEventArgs

`class Microsoft.Xbox.CompanionEventArgs`

Base class for the data of [`Companion`](Microsoft.Xbox.md#companion) events; identifies the companion client and the console user it belongs to.

**Constructors**

| | |
|---|---|
| `CompanionEventArgs()` |  |

**Properties**

| | |
|---|---|
| `System.Int32 ClientId { get; }` | Gets the identifier of the companion client that the event relates to. Pass this value to [`Companion.SendMessage`](Microsoft.Xbox.md#companion) to reply. |
| `System.Int32 PlayerIndex { get; }` | Gets the index (0-3) of the signed-in console user associated with the companion client. |

## CompanionFailedEventArgs

`class Microsoft.Xbox.CompanionFailedEventArgs`

Provides data for the [`Companion.Failed`](Microsoft.Xbox.md#companion) event.

**Constructors**

| | |
|---|---|
| `CompanionFailedEventArgs()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.CompanionFailure Failure { get; }` | Gets the category of the failure. |
| `System.Int32 UnderlyingCode { get; }` | Gets the raw HRESULT reported by the companion service, for logging and diagnostics. |
| `System.Object SendContext { get; }` | Gets the context object passed to [`Companion.SendMessage`](Microsoft.Xbox.md#companion) when the failure relates to a send; otherwise `null`. |

## CompanionFailure

`enum Microsoft.Xbox.CompanionFailure`

Describes why a companion operation failed.

**Values**

| | |
|---|---|
| `ConnectedUnexpected` | An error occurred while a companion device was connecting. |
| `DisconnectedUnexpected` | An error occurred while a companion device was disconnecting. |
| `ReceiveProcessingAllocationFailure` | The console ran out of memory while processing a received message. |
| `ReceivedInvalidJson` | A received message was not valid JSON. |
| `ReceivedUnexpected` | Receiving a message failed for another reason; see [`CompanionFailedEventArgs.UnderlyingCode`](Microsoft.Xbox.md#companionfailedeventargs). |
| `ReceivedUnsupportedJSon` | A received message was valid JSON but could not be represented as a flat string dictionary (for example, it repeated a key). |
| `SendFailed` | A message could not be delivered to the companion device. |
| `SendUnexpected` | Sending a message failed for another reason; see [`CompanionFailedEventArgs.UnderlyingCode`](Microsoft.Xbox.md#companionfailedeventargs). |
| `Unknown` | The failure could not be classified. |

## CompanionKeyboardTextChangedArgs

`class Microsoft.Xbox.CompanionKeyboardTextChangedArgs`

Provides the new text when a SmartGlass companion keyboard edits the text of the focused on-screen keyboard (`Rune`) control.

**Constructors**

| | |
|---|---|
| `CompanionKeyboardTextChangedArgs()` |  |

**Properties**

| | |
|---|---|
| `System.String Text { get; }` | Gets the complete text entered on the companion keyboard. |

## CompanionReceivedEventArgs

`class Microsoft.Xbox.CompanionReceivedEventArgs`

Provides data for the [`Companion.ReceivedMessage`](Microsoft.Xbox.md#companion) event.

**Constructors**

| | |
|---|---|
| `CompanionReceivedEventArgs()` |  |

**Properties**

| | |
|---|---|
| `System.Collections.Generic.Dictionary<System.String,System.String> Message { get; }` | Gets the received message as string key/value pairs. |

## CompanionSendCompletedEventArgs

`class Microsoft.Xbox.CompanionSendCompletedEventArgs`

Provides data for the [`Companion.SendMessageCompleted`](Microsoft.Xbox.md#companion) event.

**Constructors**

| | |
|---|---|
| `CompanionSendCompletedEventArgs()` |  |

**Properties**

| | |
|---|---|
| `System.Object SendContext { get; }` | Gets the context object that was passed to [`Companion.SendMessage`](Microsoft.Xbox.md#companion), or `null` if none was supplied. |

## FPU

`class Microsoft.Xbox.FPU`

Exposes Xbox 360 (PowerPC) floating-point instructions as methods that the JIT compiler emits inline.

These methods let performance-sensitive code use hardware operations such as branch-free selection and fast reciprocal estimates. Estimate instructions trade precision for speed. The conversion methods follow the processor's register conventions: integer results are returned in the bit pattern of a double.

**Methods**

| | |
|---|---|
| `static System.Double fabs(System.Double b)` | Returns the absolute value of a double-precision value. |
| `static System.Double fcfid(System.Double b)` | Converts a 64-bit integer, stored in the bit pattern of a double, to a floating-point value. |
| `static System.Double fctid(System.Double b)` | Converts a value to a 64-bit integer using the current floating-point rounding mode. |
| `static System.Double fctidz(System.Double b)` | Converts a value to a 64-bit integer, rounding toward zero. |
| `static System.Double fctiw(System.Double b)` | Converts a value to a 32-bit integer using the current floating-point rounding mode. |
| `static System.Double fctiwz(System.Double b)` | Converts a value to a 32-bit integer, rounding toward zero. |
| `static System.Double fpmax(System.Double a, System.Double b)` | Returns the larger of two values using branch-free selection. |
| `static System.Double fpmin(System.Double a, System.Double b)` | Returns the smaller of two values using branch-free selection. |
| `static System.Double frnd(System.Double b)` | Applies the processor's floating-point rounding instruction to a value. Verify on the console whether the rounding you need (to an integer or to single precision) matches before relying on this method. |
| `static System.Double frsqrte(System.Double b)` | Computes a fast estimate of the reciprocal square root (1/sqrt(b)). |
| `static System.Double fsel(System.Double comparand, System.Double ge, System.Double lt)` | Selects one of two values according to the sign of a comparand, without branching. |
| `static System.Double fsqrt(System.Double b)` | Computes the square root of a double-precision value. |
| `static System.Single fpmax(System.Single a, System.Single b)` | Returns the larger of two single-precision values using branch-free selection. |
| `static System.Single fpmin(System.Single a, System.Single b)` | Returns the smaller of two single-precision values using branch-free selection. |
| `static System.Single fres(System.Double b)` | Computes a fast single-precision estimate of the reciprocal (1/b). |
| `static System.Single fself(System.Single comparand, System.Single ge, System.Single lt)` | Selects one of two single-precision values according to the sign of a comparand, without branching. |
| `static System.Single fsqrts(System.Single b)` | Computes the square root of a single-precision value. |

## MethodExtensions

`class Microsoft.Xbox.MethodExtensions`

Provides extension methods for `Thread` that query and set which Xbox 360 hardware thread a managed thread runs on.

Both methods operate only on the calling thread; passing any other thread throws `InvalidOperationException`.

**Methods**

| | |
|---|---|
| `static System.Int32 GetCurrentProcessorNumber(System.Threading.Thread thread)` | Returns the number of the hardware thread the calling thread is currently running on. |
| `static System.Void SetProcessorAffinity(System.Threading.Thread thread, System.Int32[] cpus)` | Moves the calling thread to the specified hardware thread. Throws `ArgumentException` if `cpus` is null, and `InvalidOperationException` if it does not contain exactly one value in the range 0 to 5, if `thread` is not the current thread, or if the affinity cannot be set. |

## RuntimeHelpers

`class Microsoft.Xbox.RuntimeHelpers`

Provides Xbox 360 runtime services: console language and locale, processor affinity, ahead-of-time compilation of call graphs, and resource helpers.

Several members are security critical or reserved for the platform and cannot be called from application code. Applications can use [`RuntimeHelpers.GetLanguage`](Microsoft.Xbox.md#runtimehelpers) and [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers), and the extension methods in Microsoft.Xbox.MethodExtensions (System.Core) for processor affinity.

**Methods**

| | |
|---|---|
| `static System.Globalization.CultureInfo CreateCustomCultureInfoForResources(System.String name)` | Creates a culture with the specified name for use in resource lookup. Reserved for platform code. The culture only affects which resources are found; formatting follows the invariant culture. |
| `static System.Int32 GetCurrentProcessorNumber(System.Threading.Thread thread)` | Returns the number of the hardware thread the specified thread is running on. Reserved for platform code. Applications call the GetCurrentProcessorNumber extension method in Microsoft.Xbox.MethodExtensions instead. |
| `static System.Int32 SetProcessorAffinity(System.Threading.Thread thread, System.Int32 cpu)` | Sets the hardware thread the specified thread runs on. Reserved for platform code. Applications call the SetProcessorAffinity extension method in Microsoft.Xbox.MethodExtensions instead. |
| `static System.Resources.ResourceManager CreateFileBasedResourceManager(System.String baseName, System.String resourceDir, System.Type usingResourceSet)` | Creates a resource manager that reads .resources files from a directory instead of from assembly manifests. Reserved for platform code. |
| `static System.UInt32 GetLanguage()` | Returns the language selected in the console's system settings. |
| `static System.UInt32 GetLocale()` | Returns the country or region selected in the console's system settings. |
| `static System.Void CompileCallGraph(System.RuntimeMethodHandle method)` | Compiles the specified method and the methods it calls before they are first executed. Security critical; reserved for platform code. |
| `static System.Void CompileCallGraph(System.RuntimeMethodHandle method, System.RuntimeTypeHandle[] instantiation)` | Compiles the specified generic method instantiation and the methods it calls before they are first executed. Security critical; reserved for platform code. |

**Fields**

| | |
|---|---|
| `const System.UInt32 XC_LANGUAGE_ENGLISH` | Value returned by [`RuntimeHelpers.GetLanguage`](Microsoft.Xbox.md#runtimehelpers) when the console language is English. |
| `const System.UInt32 XC_LANGUAGE_FRENCH` | Value returned by [`RuntimeHelpers.GetLanguage`](Microsoft.Xbox.md#runtimehelpers) when the console language is French. |
| `const System.UInt32 XC_LANGUAGE_GERMAN` | Value returned by [`RuntimeHelpers.GetLanguage`](Microsoft.Xbox.md#runtimehelpers) when the console language is German. |
| `const System.UInt32 XC_LANGUAGE_ITALIAN` | Value returned by [`RuntimeHelpers.GetLanguage`](Microsoft.Xbox.md#runtimehelpers) when the console language is Italian. |
| `const System.UInt32 XC_LANGUAGE_JAPANESE` | Value returned by [`RuntimeHelpers.GetLanguage`](Microsoft.Xbox.md#runtimehelpers) when the console language is Japanese. |
| `const System.UInt32 XC_LANGUAGE_KOREAN` | Value returned by [`RuntimeHelpers.GetLanguage`](Microsoft.Xbox.md#runtimehelpers) when the console language is Korean. |
| `const System.UInt32 XC_LANGUAGE_POLISH` | Value returned by [`RuntimeHelpers.GetLanguage`](Microsoft.Xbox.md#runtimehelpers) when the console language is Polish. |
| `const System.UInt32 XC_LANGUAGE_PORTUGUESE` | Value returned by [`RuntimeHelpers.GetLanguage`](Microsoft.Xbox.md#runtimehelpers) when the console language is Portuguese. |
| `const System.UInt32 XC_LANGUAGE_RUSSIAN` | Value returned by [`RuntimeHelpers.GetLanguage`](Microsoft.Xbox.md#runtimehelpers) when the console language is Russian. |
| `const System.UInt32 XC_LANGUAGE_SCHINESE` | Value returned by [`RuntimeHelpers.GetLanguage`](Microsoft.Xbox.md#runtimehelpers) when the console language is Simplified Chinese. |
| `const System.UInt32 XC_LANGUAGE_SPANISH` | Value returned by [`RuntimeHelpers.GetLanguage`](Microsoft.Xbox.md#runtimehelpers) when the console language is Spanish. |
| `const System.UInt32 XC_LANGUAGE_TCHINESE` | Value returned by [`RuntimeHelpers.GetLanguage`](Microsoft.Xbox.md#runtimehelpers) when the console language is Traditional Chinese. |
| `const System.UInt32 XC_LOCALE_AUSTRALIA` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Australia. |
| `const System.UInt32 XC_LOCALE_AUSTRIA` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Austria. |
| `const System.UInt32 XC_LOCALE_BELGIUM` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Belgium. |
| `const System.UInt32 XC_LOCALE_BRAZIL` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Brazil. |
| `const System.UInt32 XC_LOCALE_CANADA` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Canada. |
| `const System.UInt32 XC_LOCALE_CHILE` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Chile. |
| `const System.UInt32 XC_LOCALE_CHINA` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is China. |
| `const System.UInt32 XC_LOCALE_COLOMBIA` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Colombia. |
| `const System.UInt32 XC_LOCALE_CZECH_REPUBLIC` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Czech Republic. |
| `const System.UInt32 XC_LOCALE_DENMARK` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Denmark. |
| `const System.UInt32 XC_LOCALE_FINLAND` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Finland. |
| `const System.UInt32 XC_LOCALE_FRANCE` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is France. |
| `const System.UInt32 XC_LOCALE_GERMANY` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Germany. |
| `const System.UInt32 XC_LOCALE_GREAT_BRITAIN` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Great Britain. |
| `const System.UInt32 XC_LOCALE_GREECE` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Greece. |
| `const System.UInt32 XC_LOCALE_HONG_KONG` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Hong Kong. |
| `const System.UInt32 XC_LOCALE_HUNGARY` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Hungary. |
| `const System.UInt32 XC_LOCALE_INDIA` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is India. |
| `const System.UInt32 XC_LOCALE_IRELAND` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Ireland. |
| `const System.UInt32 XC_LOCALE_ITALY` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Italy. |
| `const System.UInt32 XC_LOCALE_JAPAN` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Japan. |
| `const System.UInt32 XC_LOCALE_KOREA` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Korea. |
| `const System.UInt32 XC_LOCALE_MEXICO` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Mexico. |
| `const System.UInt32 XC_LOCALE_NETHERLANDS` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Netherlands. |
| `const System.UInt32 XC_LOCALE_NEW_ZEALAND` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is New Zealand. |
| `const System.UInt32 XC_LOCALE_NORWAY` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Norway. |
| `const System.UInt32 XC_LOCALE_POLAND` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Poland. |
| `const System.UInt32 XC_LOCALE_PORTUGAL` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Portugal. |
| `const System.UInt32 XC_LOCALE_SINGAPORE` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Singapore. |
| `const System.UInt32 XC_LOCALE_SLOVAK_REPUBLIC` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Slovak Republic. |
| `const System.UInt32 XC_LOCALE_SOUTH_AFRICA` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is South Africa. |
| `const System.UInt32 XC_LOCALE_SPAIN` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Spain. |
| `const System.UInt32 XC_LOCALE_SWEDEN` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Sweden. |
| `const System.UInt32 XC_LOCALE_SWITZERLAND` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Switzerland. |
| `const System.UInt32 XC_LOCALE_TAIWAN` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is Taiwan. |
| `const System.UInt32 XC_LOCALE_UNITED_STATES` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is United States. |
| `const System.UInt32 XC_LOCALE_UNKNOWN` | Value returned by [`RuntimeHelpers.GetLocale`](Microsoft.Xbox.md#runtimehelpers) when the console country or region is not set or not recognized. |

