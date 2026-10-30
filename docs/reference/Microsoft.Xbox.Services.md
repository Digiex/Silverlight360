# Microsoft.Xbox.Services

Assembly: `Microsoft.Xbox.dll`

| Type | Summary |
|---|---|
| [`AggregateRating`](#aggregaterating) | The community rating of a media item, returned by [`RatingsServiceClient.DownloadAggregateRatingsAsync`](Microsoft.Xbox.Services.md#ratingsserviceclient). |
| [`DeleteUserRatingCompletedEventArgs`](#deleteuserratingcompletedeventargs) | Provides data for the [`RatingsServiceClient.DeleteUserRatingCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient) event. |
| [`DownloadAggregateRatingsCompletedEventArgs`](#downloadaggregateratingscompletedeventargs) | Provides data for the [`RatingsServiceClient.DownloadAggregateRatingsCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient) event. |
| [`DownloadUserRatingCompletedEventArgs`](#downloaduserratingcompletedeventargs) | Provides data for the [`RatingsServiceClient.DownloadUserRatingCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient) event. |
| [`MediaType`](#mediatype) | The kind of media item reported to the usage service. |
| [`MediaUsageServiceClient`](#mediausageserviceclient) | Reports playback activity (play, pause, stop and so on) for media items to the Xbox LIVE media usage service. |
| [`RatingsServiceClient`](#ratingsserviceclient) | Reads and writes media ratings and reviews on the Xbox LIVE ratings service for a signed-in user. |
| [`ServiceClientOperationCompletedEventArgs`](#serviceclientoperationcompletedeventargs) | The raw result of an HTTP request made by the Xbox LIVE service clients. Used internally; the public service clients translate it into their own event data. |
| [`UploadMediaUsageCompletedEventArgs`](#uploadmediausagecompletedeventargs) | Provides data for the [`MediaUsageServiceClient.UploadMediaUsageCompleted`](Microsoft.Xbox.Services.md#mediausageserviceclient) event. |
| [`UploadUserRatingCompletedEventArgs`](#uploaduserratingcompletedeventargs) | Provides data for the [`RatingsServiceClient.UploadUserRatingCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient) event. |
| [`UsageEventType`](#usageeventtype) | Playback actions reported with [`MediaUsageServiceClient.UploadMediaUsageAsync`](Microsoft.Xbox.Services.md#mediausageserviceclient). |
| [`UserInterest`](#userinterest) | A user's stated interest in a media item, stored with their rating. |
| [`UserRating`](#userrating) | One user's rating, review and interest for a media item. |

## AggregateRating

`class Microsoft.Xbox.Services.AggregateRating`

The community rating of a media item, returned by [`RatingsServiceClient.DownloadAggregateRatingsAsync`](Microsoft.Xbox.Services.md#ratingsserviceclient).

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Services.UserRating UserRating { get; }` | Gets the requesting user's own rating of the item, or `null` if the service did not return one. |
| `System.DateTime LastUpdated { get; }` | Gets when the aggregate was last recalculated. |
| `System.Double AverageRating { get; }` | Gets the average of all user ratings, on the 0.0-1.0 scale used by [`UserRating.RatingValue`](Microsoft.Xbox.Services.md#userrating). |
| `System.Int32 RatingCount { get; }` | Gets the number of user ratings the average is based on. |
| `System.String MediaAssetId { get; }` | Gets the identifier of the rated media item. |

## DeleteUserRatingCompletedEventArgs

`class Microsoft.Xbox.Services.DeleteUserRatingCompletedEventArgs`

Provides data for the [`RatingsServiceClient.DeleteUserRatingCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient) event.

## DownloadAggregateRatingsCompletedEventArgs

`class Microsoft.Xbox.Services.DownloadAggregateRatingsCompletedEventArgs`

Provides data for the [`RatingsServiceClient.DownloadAggregateRatingsCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient) event.

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Services.AggregateRating Result { get; }` | Gets the downloaded rating, or `null` if the operation failed or the service is not available. |

## DownloadUserRatingCompletedEventArgs

`class Microsoft.Xbox.Services.DownloadUserRatingCompletedEventArgs`

Provides data for the [`RatingsServiceClient.DownloadUserRatingCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient) event.

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Services.UserRating Result { get; }` | Gets the user's rating, or `null` if the operation failed or the service is not available. |

## MediaType

`enum Microsoft.Xbox.Services.MediaType`

The kind of media item reported to the usage service.

**Values**

| | |
|---|---|
| `Audio` | Other audio content. |
| `GameTrailer` | A game trailer. |
| `Movie` | A movie. |
| `MovieTrailer` | A movie trailer. |
| `MusicVideo` | A music video. |
| `PodCast` | A podcast episode. |
| `Track` | A music track. |
| `TvEpisode` | A TV episode. |
| `Unknown` | The kind is not known. |
| `Video` | Other video content. |

## MediaUsageServiceClient

`class Microsoft.Xbox.Services.MediaUsageServiceClient`

Reports playback activity (play, pause, stop and so on) for media items to the Xbox LIVE media usage service.

Nothing is sent until [`MediaUsageServiceClient.UploadUsageEnabled`](Microsoft.Xbox.Services.md#mediausageserviceclient) is set to `true`. Events are queued (up to about 1,000) and posted in batches every 2 seconds by a UI-thread timer, using the Xbox LIVE token of the user at player index 0. Create the client on the UI thread.

**Constructors**

| | |
|---|---|
| `MediaUsageServiceClient()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean UploadUsageEnabled { get; set; }` | Gets or sets whether usage events are collected and uploaded. The default is `false`; while it is `false`, [`MediaUsageServiceClient.UploadMediaUsageAsync`](Microsoft.Xbox.Services.md#mediausageserviceclient) discards events. |
| `static System.String SignalsMediaServiceBaseUrl { get; }` | Gets the base URL of the media usage service for the environment the console is configured for, derived from [`NetworkSettings.ActiveServiceEndpoint`](Microsoft.Xbox.Net.md#networksettings) the first time it is read. |

**Methods**

| | |
|---|---|
| `System.Void UploadMediaUsageAsync(System.String mediaAssetId, Microsoft.Xbox.Services.UsageEventType eventType, Microsoft.Xbox.Services.MediaType mediaType, System.TimeSpan timelineEventTime, System.TimeSpan mediaLength)` | Queues a playback event for upload. The event is timestamped with the current UTC time and sent with the next batch. Does nothing if [`MediaUsageServiceClient.UploadUsageEnabled`](Microsoft.Xbox.Services.md#mediausageserviceclient) is `false`. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xbox.Services.UploadMediaUsageCompletedEventArgs> UploadMediaUsageCompleted` | Occurs after a batch of usage events has been posted, or when queuing or posting fails. Check `AsyncCompletedEventArgs.Error`. |

## RatingsServiceClient

`class Microsoft.Xbox.Services.RatingsServiceClient`

Reads and writes media ratings and reviews on the Xbox LIVE ratings service for a signed-in user.

Each call first resolves the service URL from the Xbox LIVE service directory (cached until it expires), then sends an HTTP request authorized with the user's Xbox LIVE token. Results arrive through the matching `...Completed` event; check `AsyncCompletedEventArgs.Error` before reading `Result`. Exceptions during the operation are reported through the event rather than thrown.

If the service directory has no entry for the operation, the event is raised with no error and a `null` `Result`.

**Constructors**

| | |
|---|---|
| `RatingsServiceClient(System.Int32 playerIndex)` | Creates a ratings client that acts on behalf of the specified user. |

**Methods**

| | |
|---|---|
| `System.Void DeleteUserRatingAsync(System.String mediaAssetId)` | Starts deleting the user's rating of a media item. Completion is reported by [`RatingsServiceClient.DeleteUserRatingCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient). |
| `System.Void DownloadAggregateRatingsAsync(System.String mediaAssetId)` | Starts downloading the community rating of a media item. The result is reported by [`RatingsServiceClient.DownloadAggregateRatingsCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient). |
| `System.Void DownloadUserRatingAsync(System.String mediaAssetId)` | Starts downloading the user's own rating of a media item. The result is reported by [`RatingsServiceClient.DownloadUserRatingCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient). |
| `System.Void UploadUserRatingAsync(System.String mediaAssetId, System.Double ratingValue, System.String reviewText)` | Starts saving the user's rating and optional review of a media item. Completion is reported by [`RatingsServiceClient.UploadUserRatingCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient). |
| `System.Void UploadUserRatingAsync(System.String mediaAssetId, System.Double ratingValue, System.String reviewText, Microsoft.Xbox.Services.UserInterest userInterest)` | Starts saving the user's rating, optional review and interest for a media item. Completion is reported by [`RatingsServiceClient.UploadUserRatingCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient). |
| `System.Void UploadUserRatingInterestAsync(System.String mediaAssetId, Microsoft.Xbox.Services.UserInterest userInterest)` | Starts saving only the user's interest in a media item, without a rating value. Completion is reported by [`RatingsServiceClient.UploadUserRatingCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient). |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xbox.Services.DeleteUserRatingCompletedEventArgs> DeleteUserRatingCompleted` | Occurs when [`RatingsServiceClient.DeleteUserRatingAsync`](Microsoft.Xbox.Services.md#ratingsserviceclient) finishes. Once the request has been sent, this event reports success even if the HTTP request failed; only errors while resolving the service URL are reported in `AsyncCompletedEventArgs.Error`. |
| `event System.EventHandler<Microsoft.Xbox.Services.DownloadAggregateRatingsCompletedEventArgs> DownloadAggregateRatingsCompleted` | Occurs when [`RatingsServiceClient.DownloadAggregateRatingsAsync`](Microsoft.Xbox.Services.md#ratingsserviceclient) finishes. |
| `event System.EventHandler<Microsoft.Xbox.Services.DownloadUserRatingCompletedEventArgs> DownloadUserRatingCompleted` | Occurs when [`RatingsServiceClient.DownloadUserRatingAsync`](Microsoft.Xbox.Services.md#ratingsserviceclient) finishes. |
| `event System.EventHandler<Microsoft.Xbox.Services.UploadUserRatingCompletedEventArgs> UploadUserRatingCompleted` | Occurs when an upload started with `UploadUserRatingAsync` or [`RatingsServiceClient.UploadUserRatingInterestAsync`](Microsoft.Xbox.Services.md#ratingsserviceclient) finishes. On success, `Result` holds the rating as stored by the service. |

## ServiceClientOperationCompletedEventArgs

`class Microsoft.Xbox.Services.ServiceClientOperationCompletedEventArgs`

The raw result of an HTTP request made by the Xbox LIVE service clients. Used internally; the public service clients translate it into their own event data.

**Properties**

| | |
|---|---|
| `System.String CacheHeader { get; set; }` | Gets or sets the response's `Expires` header when the response is marked cacheable (`Cache-Control: public` or `private`); otherwise `null`. |
| `System.String ResponseBody { get; }` | Gets the response body text, or `null` if the request failed. |

## UploadMediaUsageCompletedEventArgs

`class Microsoft.Xbox.Services.UploadMediaUsageCompletedEventArgs`

Provides data for the [`MediaUsageServiceClient.UploadMediaUsageCompleted`](Microsoft.Xbox.Services.md#mediausageserviceclient) event.

## UploadUserRatingCompletedEventArgs

`class Microsoft.Xbox.Services.UploadUserRatingCompletedEventArgs`

Provides data for the [`RatingsServiceClient.UploadUserRatingCompleted`](Microsoft.Xbox.Services.md#ratingsserviceclient) event.

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Services.UserRating Result { get; }` | Gets the rating as returned by the service, or `null` if the operation failed or the service is not available. |

## UsageEventType

`enum Microsoft.Xbox.Services.UsageEventType`

Playback actions reported with [`MediaUsageServiceClient.UploadMediaUsageAsync`](Microsoft.Xbox.Services.md#mediausageserviceclient).

**Values**

| | |
|---|---|
| `End` | Playback reached the end of the item. |
| `Forward` | The user fast-forwarded. |
| `Pause` | Playback was paused. |
| `Play` | Playback started. |
| `Resume` | Playback resumed after a pause. |
| `Rewind` | The user rewound. |
| `Skip` | The user skipped to another position or item. |
| `Stop` | The user stopped playback before the end. |

## UserInterest

`enum Microsoft.Xbox.Services.UserInterest`

A user's stated interest in a media item, stored with their rating.

**Values**

| | |
|---|---|
| `AlwaysInterested` | The user wants to see this kind of item. |
| `NotInterested` | The user does not want to see this kind of item. |
| `Undefined` | No preference. |

## UserRating

`class Microsoft.Xbox.Services.UserRating`

One user's rating, review and interest for a media item.

**Properties**

| | |
|---|---|
| `System.DateTime LastUpdated { get; }` | Gets when the rating was last changed. |
| `System.Nullable<Microsoft.Xbox.Services.UserInterest> UserInterest { get; }` | Gets the user's stated interest in the item, or `null` if none was recorded. |
| `System.Nullable<System.Double> RatingValue { get; }` | Gets the rating, from 0.0 to 1.0, or `null` if the user only recorded an interest. |
| `System.String MediaAssetId { get; }` | Gets the identifier of the rated media item. |
| `System.String ReviewText { get; }` | Gets the user's review text, or `null` if there is none. |

