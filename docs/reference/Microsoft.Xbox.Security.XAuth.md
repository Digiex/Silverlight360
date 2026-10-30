# Microsoft.Xbox.Security.XAuth

Assembly: `Microsoft.Xbox.Services.dll`

| Type | Summary |
|---|---|
| [`XAuthCompletedEventArgs`](#xauthcompletedeventargs) | Provides data for the [`XAuthTokenRequest.Completed`](Microsoft.Xbox.Security.XAuth.md#xauthtokenrequest) event. |
| [`XAuthException`](#xauthexception) | The exception that is thrown when an Xbox LIVE token (XAuth) operation fails. |
| [`XAuthService`](#xauthservice) | Provides static methods that control the Xbox LIVE token (XAuth) service used by [`XAuthTokenRequest`](Microsoft.Xbox.Security.XAuth.md#xauthtokenrequest). |
| [`XAuthToken`](#xauthtoken) | Represents an Xbox LIVE security token issued for a signed-in user and a relying party (web service). |
| [`XAuthTokenRequest`](#xauthtokenrequest) | Requests an Xbox LIVE security token for a signed-in player and a web service URN, either synchronously or asynchronously. |
| [`XAuthXuid`](#xauthxuid) | Represents the Xbox user ID (XUID) of the gamer an Xbox LIVE token was issued for. |

## XAuthCompletedEventArgs

`class Microsoft.Xbox.Security.XAuth.XAuthCompletedEventArgs`

Provides data for the [`XAuthTokenRequest.Completed`](Microsoft.Xbox.Security.XAuth.md#xauthtokenrequest) event.

Check `AsyncCompletedEventArgs.Error` first; when it is not null it is an [`XAuthException`](Microsoft.Xbox.Security.XAuth.md#xauthexception) and [`XAuthCompletedEventArgs.Token`](Microsoft.Xbox.Security.XAuth.md#xauthcompletedeventargs) is null. The UserState property contains the request's [`XAuthTokenRequest.UserData`](Microsoft.Xbox.Security.XAuth.md#xauthtokenrequest).

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Security.XAuth.XAuthToken Token { get; }` | Gets the token that was obtained. |

## XAuthException

`class Microsoft.Xbox.Security.XAuth.XAuthException`

The exception that is thrown when an Xbox LIVE token (XAuth) operation fails.

The `Exception.HResult` property holds the failure code returned by the platform, and the message names the operation that failed together with that code in hexadecimal.

**Constructors**

| | |
|---|---|
| `XAuthException(System.String function, System.Int32 result)` | Initializes a new instance of the [`XAuthException`](Microsoft.Xbox.Security.XAuth.md#xauthexception) class for a failed operation. |

## XAuthService

`class Microsoft.Xbox.Security.XAuth.XAuthService`

Provides static methods that control the Xbox LIVE token (XAuth) service used by [`XAuthTokenRequest`](Microsoft.Xbox.Security.XAuth.md#xauthtokenrequest).

**Constructors**

| | |
|---|---|
| `XAuthService()` |  |

**Methods**

| | |
|---|---|
| `static System.Collections.Generic.Dictionary<System.String,System.String> LoadWhiteList()` | Returns the list of web service URLs this application may request tokens for. Throws [`XAuthException`](Microsoft.Xbox.Security.XAuth.md#xauthexception) if the list cannot be read. |
| `static System.Void ReleaseTokens()` | Clears all cached tokens and cancels pending asynchronous token requests. Each pending request receives a [`XAuthTokenRequest.Completed`](Microsoft.Xbox.Security.XAuth.md#xauthtokenrequest) callback whose Error is an [`XAuthException`](Microsoft.Xbox.Security.XAuth.md#xauthexception). Call this, for example, when the signed-in user changes. |
| `static System.Void Start(System.Boolean overRideBypass)` | Starts the Xbox LIVE token service for the application. Call once before requesting tokens. Throws [`XAuthException`](Microsoft.Xbox.Security.XAuth.md#xauthexception) if the service cannot be started. |

## XAuthToken

`class Microsoft.Xbox.Security.XAuth.XAuthToken`

Represents an Xbox LIVE security token issued for a signed-in user and a relying party (web service).

Tokens are obtained through [`XAuthTokenRequest`](Microsoft.Xbox.Security.XAuth.md#xauthtokenrequest) and cached by [`XAuthService`](Microsoft.Xbox.Security.XAuth.md#xauthservice). Two tokens are considered equal when they belong to the same user and the same relying party; the token bytes are not compared.

**Constructors**

| | |
|---|---|
| `XAuthToken()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Security.XAuth.XAuthXuid UserId { get; }` | Gets the Xbox user ID of the gamer the token was issued for. |
| `System.String AppliesTo { get; }` | Gets the relying-party identifier the token applies to. |

**Methods**

| | |
|---|---|
| `System.Boolean Equals(Microsoft.Xbox.Security.XAuth.XAuthToken other)` |  |
| `System.Boolean Equals(System.Object other)` |  |
| `System.Byte[] GetBytes()` | Returns a copy of the raw token data. Send the bytes to the relying party in the form that service expects, for example in an HTTP authorization header. |
| `System.Int32 CompareTo(Microsoft.Xbox.Security.XAuth.XAuthToken other)` | Compares this token with another token, ordering by user ID and then by relying-party identifier. |
| `System.Int32 GetHashCode()` |  |
| `System.String ToString()` |  |

**Operators**

| | |
|---|---|
| `static System.Boolean op_Equality(Microsoft.Xbox.Security.XAuth.XAuthToken t1, Microsoft.Xbox.Security.XAuth.XAuthToken t2)` | Determines whether two tokens refer to the same user and relying party. |
| `static System.Boolean op_Inequality(Microsoft.Xbox.Security.XAuth.XAuthToken t1, Microsoft.Xbox.Security.XAuth.XAuthToken t2)` | Determines whether two tokens refer to a different user or relying party. |

## XAuthTokenRequest

`class Microsoft.Xbox.Security.XAuth.XAuthTokenRequest`

Requests an Xbox LIVE security token for a signed-in player and a web service URN, either synchronously or asynchronously.

A request object can be used for one token request only; calling a Get method a second time throws `ArgumentException`. The user must be signed in to Xbox LIVE and the URN must be one the title is allowed to request tokens for (see [`XAuthService.LoadWhiteList`](Microsoft.Xbox.Security.XAuth.md#xauthservice)). Call [`XAuthService.Start`](Microsoft.Xbox.Security.XAuth.md#xauthservice) before requesting tokens.

**Constructors**

| | |
|---|---|
| `XAuthTokenRequest()` |  |

**Properties**

| | |
|---|---|
| `System.Object UserData { get; set; }` | Gets or sets an application-defined object that is returned in the completion event arguments. |

**Methods**

| | |
|---|---|
| `Microsoft.Xbox.Security.XAuth.XAuthToken GetToken(System.Int32 playerIndex, System.Uri urn)` | Obtains a token synchronously for the specified player and URN. This call blocks until the service responds, so avoid it on the UI thread. It throws `ArgumentException` if `urn` is null, if the request object was already used, or if a [`XAuthTokenRequest.Completed`](Microsoft.Xbox.Security.XAuth.md#xauthtokenrequest) handler is attached (use GetTokenAsync in that case). Platform failures are reported as [`XAuthException`](Microsoft.Xbox.Security.XAuth.md#xauthexception). |
| `System.Void GetTokenAsync(System.Int32 playerIndex, System.Uri urn)` | Starts an asynchronous request for a token for the specified player and URN. The result is delivered through [`XAuthTokenRequest.Completed`](Microsoft.Xbox.Security.XAuth.md#xauthtokenrequest). A token already in the cache is delivered immediately; requests made before the token service is ready are queued until it is. Throws `ArgumentException` if this request object was already used. |

**Fields**

| | |
|---|---|
| `System.EventHandler<Microsoft.Xbox.Security.XAuth.XAuthCompletedEventArgs> Completed` | Occurs when an asynchronous token request finishes, successfully or not. This is a public delegate field rather than an event; assign or combine handlers before calling [`XAuthTokenRequest.GetTokenAsync`](Microsoft.Xbox.Security.XAuth.md#xauthtokenrequest). If the token is already cached, the handler runs before GetTokenAsync returns. Otherwise it runs later, possibly on a thread other than the UI thread, so marshal UI updates through the Dispatcher. The sender argument is null. |

## XAuthXuid

`class Microsoft.Xbox.Security.XAuth.XAuthXuid`

Represents the Xbox user ID (XUID) of the gamer an Xbox LIVE token was issued for.

Instances are created by the platform and returned from [`XAuthToken.UserId`](Microsoft.Xbox.Security.XAuth.md#xauthtoken). Convert to `Int64` to read the numeric XUID.

**Operators**

| | |
|---|---|
| `static System.Int64 op_Implicit(Microsoft.Xbox.Security.XAuth.XAuthXuid x)` | Converts an [`XAuthXuid`](Microsoft.Xbox.Security.XAuth.md#xauthxuid) to its 64-bit numeric XUID. |

