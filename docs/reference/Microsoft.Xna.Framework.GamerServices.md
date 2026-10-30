# Microsoft.Xna.Framework.GamerServices

Assembly: `Microsoft.Xbox.Services.dll`

| Type | Summary |
|---|---|
| [`AgeGroup`](#agegroup) | Specifies the age group of a gamer profile. |
| [`ContentAccessConfirmationCompletedEventArgs`](#contentaccessconfirmationcompletedeventargs) | Provides data for the [`ContentRating.AccessConfirmationCompleted`](Microsoft.Xna.Framework.GamerServices.md#contentrating) event. |
| [`ContentAccessType`](#contentaccesstype) | Specifies how content will be used when checking parental-control access with [`ContentRating.CanAccessAsync`](Microsoft.Xna.Framework.GamerServices.md#contentrating). |
| [`ContentRating`](#contentrating) | Represents a content rating (content type, rating system and level) and checks it against the parental-control settings of signed-in gamers. |
| [`GetSocialCapabilitiesCompletedEventArgs`](#getsocialcapabilitiescompletedeventargs) | Provides data for the `SignedInGamer.GetSocialCapabilitiesCompleted` event. |
| [`GetSocialNetworkTokenCompletedEventArgs`](#getsocialnetworktokencompletedeventargs) | Provides data for the `SignedInGamer.GetSocialNetworkTokenCompleted` event. |
| [`MessageBox`](#messagebox) | Displays a system message box with up to three buttons and reports the user's choice through an event. |
| [`MessageBoxCompletedEventArgs`](#messageboxcompletedeventargs) | Provides data for the [`MessageBox.Completed`](Microsoft.Xna.Framework.GamerServices.md#messagebox) event. |
| [`NuiControllerRequiredCompletedEventArgs`](#nuicontrollerrequiredcompletedeventargs) | Provides data for the [`NuiGuide.ShowControllerRequiredCompleted`](Microsoft.Xna.Framework.GamerServices.md#nuiguide) event. |
| [`NuiGuide`](#nuiguide) | Provides static methods that display the Kinect (NUI) versions of system Guide screens. |
| [`NuiHardwareRequiredCompletedEventArgs`](#nuihardwarerequiredcompletedeventargs) | Provides data for the [`NuiGuide.ShowHardwareRequiredCompleted`](Microsoft.Xna.Framework.GamerServices.md#nuiguide) event. |
| [`ShowGetSocialNetworkTokenCompletedEventArgs`](#showgetsocialnetworktokencompletedeventargs) | Provides data for the `SignedInGamer.ShowGetSocialNetworkTokenCompleted` event. |
| [`ShowParentControlPasscodeCompletedEventArgs`](#showparentcontrolpasscodecompletedeventargs) | Provides data for the `SignedInGamer.ShowParentControlPasscodeCompleted` event. |
| [`SocialNetworkImagePost`](#socialnetworkimagepost) | Posts an image, with a title, caption and description, to the gamer's linked social network account through system UI. |
| [`SocialNetworkLinkPost`](#socialnetworklinkpost) | Posts a link, with a title and picture, to the gamer's linked social network account through system UI. |
| [`SocialNetworkPostCompletedEventArgs`](#socialnetworkpostcompletedeventargs) | Provides data for the Completed events of [`SocialNetworkImagePost`](Microsoft.Xna.Framework.GamerServices.md#socialnetworkimagepost) and [`SocialNetworkLinkPost`](Microsoft.Xna.Framework.GamerServices.md#socialnetworklinkpost). |
| [`SoftwareKeyboardInput`](#softwarekeyboardinput) | Displays the system on-screen keyboard to collect a line of text from the user. |
| [`SoftwareKeyboardInputCompletedEventArgs`](#softwarekeyboardinputcompletedeventargs) | Provides data for the [`SoftwareKeyboardInput.Completed`](Microsoft.Xna.Framework.GamerServices.md#softwarekeyboardinput) event. |
| [`StringChecker`](#stringchecker) | Submits user-entered strings to the Xbox LIVE string verification service. |
| [`VideoSharing`](#videosharing) | Provides static methods that ask the system to confirm video sharing for a gamer. |
| [`VideoSharingConfirmationCompletedEventArgs`](#videosharingconfirmationcompletedeventargs) | Provides data for the [`VideoSharing.ConfirmationCompleted`](Microsoft.Xna.Framework.GamerServices.md#videosharing) event. |

## AgeGroup

`enum Microsoft.Xna.Framework.GamerServices.AgeGroup`

Specifies the age group of a gamer profile.

**Values**

| | |
|---|---|
| `Adult` | The profile belongs to an adult. |
| `Child` | The profile belongs to a child. |
| `Teen` | The profile belongs to a teenager. |

## ContentAccessConfirmationCompletedEventArgs

`class Microsoft.Xna.Framework.GamerServices.ContentAccessConfirmationCompletedEventArgs`

Provides data for the [`ContentRating.AccessConfirmationCompleted`](Microsoft.Xna.Framework.GamerServices.md#contentrating) event.

**Properties**

| | |
|---|---|
| `System.Boolean Result { get; }` | Gets whether access to the content was granted. |

## ContentAccessType

`enum Microsoft.Xna.Framework.GamerServices.ContentAccessType`

Specifies how content will be used when checking parental-control access with [`ContentRating.CanAccessAsync`](Microsoft.Xna.Framework.GamerServices.md#contentrating).

**Values**

| | |
|---|---|
| `Play` | The content will be played in full. |
| `Preview` | Only a preview (for example a trailer or clip) of the content will be shown. |

## ContentRating

`class Microsoft.Xna.Framework.GamerServices.ContentRating`

Represents a content rating (content type, rating system and level) and checks it against the parental-control settings of signed-in gamers.

Build a rating from the constants in the nested [`Type`](Microsoft.Xna.Framework.GamerServices.ContentRating.md#type), [`System`](Microsoft.Xna.Framework.GamerServices.ContentRating.md#system) and [`Level`](Microsoft.Xna.Framework.GamerServices.ContentRating.md#level) classes, then call CanAccess or CanAccessAsync before playing rated video. Use [`ContentRating.Unrated`](Microsoft.Xna.Framework.GamerServices.md#contentrating) for content without a rating.

**Constructors**

| | |
|---|---|
| `ContentRating(System.Int32 ratingType, System.Int32 ratingSystem, System.Int32 ratingLevel)` | Initializes a new rating from a content type, rating system and rating level. |

**Properties**

| | |
|---|---|
| `System.Int32 RatingLevel { get; }` | Gets the rating level within the rating system. |
| `System.Int32 RatingSystem { get; }` | Gets the rating system (country or board) of the rating. |
| `System.Int32 RatingType { get; }` | Gets the content type of the rating. |
| `System.Object Tag { get; set; }` | Gets or sets an application-defined object associated with the rating. |

**Methods**

| | |
|---|---|
| `static System.Boolean CanAccess(System.Collections.Generic.IEnumerable<Microsoft.Xna.Framework.GamerServices.SignedInGamer> gamers, Microsoft.Xna.Framework.GamerServices.ContentRating contentRating)` | Checks immediately whether the specified gamers may access content with a given rating under their parental-control settings. |
| `static System.Void CanAccessAsync(System.Collections.Generic.IEnumerable<Microsoft.Xna.Framework.GamerServices.SignedInGamer> gamers, Microsoft.Xna.Framework.GamerServices.ContentAccessType accessType, Microsoft.Xna.Framework.GamerServices.ContentRating contentRating, System.Object state)` | Starts an asynchronous parental-control check of whether the specified gamers may access content with a given rating. The result is reported through [`ContentRating.AccessConfirmationCompleted`](Microsoft.Xna.Framework.GamerServices.md#contentrating). Unlike CanAccess, this goes through the system's confirmation path, which can involve system UI. Throws `ArgumentNullException` if `gamers` is null. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xna.Framework.GamerServices.ContentAccessConfirmationCompletedEventArgs> AccessConfirmationCompleted` | Occurs when a [`ContentRating.CanAccessAsync`](Microsoft.Xna.Framework.GamerServices.md#contentrating) check completes. This is a static event; the sender is null. Raised on a background thread. |

**Fields**

| | |
|---|---|
| `static Microsoft.Xna.Framework.GamerServices.ContentRating Unrated` | A shared rating that represents unrated content. Its type is [`Type.Unrated`](Microsoft.Xna.Framework.GamerServices.ContentRating.md#type), its system is 0 and its level is 255. Do not modify its Tag, because the instance is shared. |

## GetSocialCapabilitiesCompletedEventArgs

`class Microsoft.Xna.Framework.GamerServices.GetSocialCapabilitiesCompletedEventArgs`

Provides data for the `SignedInGamer.GetSocialCapabilitiesCompleted` event.

**Properties**

| | |
|---|---|
| `System.Boolean CanPostImages { get; }` | Gets whether image posts to a social network are available. |
| `System.Boolean CanPostLinks { get; }` | Gets whether link posts to a social network are available. |

## GetSocialNetworkTokenCompletedEventArgs

`class Microsoft.Xna.Framework.GamerServices.GetSocialNetworkTokenCompletedEventArgs`

Provides data for the `SignedInGamer.GetSocialNetworkTokenCompleted` event.

**Properties**

| | |
|---|---|
| `System.String UserToken { get; }` | Gets the social network access token returned for the gamer. |

## MessageBox

`class Microsoft.Xna.Framework.GamerServices.MessageBox`

Displays a system message box with up to three buttons and reports the user's choice through an event.

Set [`MessageBox.Title`](Microsoft.Xna.Framework.GamerServices.md#messagebox), [`MessageBox.Text`](Microsoft.Xna.Framework.GamerServices.md#messagebox) and [`MessageBox.Buttons`](Microsoft.Xna.Framework.GamerServices.md#messagebox), subscribe to [`MessageBox.Completed`](Microsoft.Xna.Framework.GamerServices.md#messagebox), and call one of the OpenAsync overloads. Gamer services must be initialized (XboxApplicationFrame does this). Only one system UI can be shown at a time; opening a message box while another is visible throws `GuideAlreadyVisibleException`.

**Constructors**

| | |
|---|---|
| `MessageBox()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xna.Framework.GamerServices.MessageBoxIcon Icon { get; set; }` | Gets or sets the icon displayed in the message box. |
| `System.Collections.Generic.IEnumerable<System.String> Buttons { get; set; }` | Gets or sets the button labels. |
| `System.Int32 FocusButton { get; set; }` | Gets or sets the index of the button that has focus when the message box opens. |
| `System.String Text { get; set; }` | Gets or sets the message text. |
| `System.String Title { get; set; }` | Gets or sets the message box title. |

**Methods**

| | |
|---|---|
| `System.Void OpenAsync(Microsoft.Xna.Framework.PlayerIndex playerIndex, System.Object userState)` | Opens the message box for the specified player. Throws `ArgumentException` if the title, text or buttons are not valid, and `GuideAlreadyVisibleException` if other system UI is already displayed. |
| `System.Void OpenAsync(System.Int32 trackingId, Microsoft.Xna.Framework.PlayerIndex playerIndex, System.Object userState)` | Opens the Kinect-enabled version of the message box for a tracked user and the specified player. |
| `System.Void OpenAsync(System.Int32 trackingId, System.Object userState)` | Opens the Kinect-enabled version of the message box for a tracked user, allowing any player to respond. |
| `System.Void OpenAsync(System.Object userState)` | Opens the message box so that any player can respond to it. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xna.Framework.GamerServices.MessageBoxCompletedEventArgs> Completed` | Occurs when the message box closes. This event is raised on a background thread, not the UI thread. Use the Dispatcher to update the user interface from the handler. |

## MessageBoxCompletedEventArgs

`class Microsoft.Xna.Framework.GamerServices.MessageBoxCompletedEventArgs`

Provides data for the [`MessageBox.Completed`](Microsoft.Xna.Framework.GamerServices.md#messagebox) event.

If the user dismissed the message box without choosing a button, Cancelled is true and [`MessageBoxCompletedEventArgs.Result`](Microsoft.Xna.Framework.GamerServices.md#messageboxcompletedeventargs) is null.

**Properties**

| | |
|---|---|
| `System.Nullable<System.Int32> Result { get; }` | Gets the zero-based index of the button the user chose. |

## NuiControllerRequiredCompletedEventArgs

`class Microsoft.Xna.Framework.GamerServices.NuiControllerRequiredCompletedEventArgs`

Provides data for the [`NuiGuide.ShowControllerRequiredCompleted`](Microsoft.Xna.Framework.GamerServices.md#nuiguide) event.

**Properties**

| | |
|---|---|
| `System.Boolean Result { get; }` | Gets whether the controller-required screen completed with a selection. |

## NuiGuide

`class Microsoft.Xna.Framework.GamerServices.NuiGuide`

Provides static methods that display the Kinect (NUI) versions of system Guide screens.

Gamer services must be initialized. Completion events on this class are static and are raised on a background thread. Only one system UI can be shown at a time.

**Methods**

| | |
|---|---|
| `static System.Void Show(System.Int32 trackingId)` | Opens the Kinect Guide for a tracked user. |
| `static System.Void ShowControllerRequiredAsync(Microsoft.Xna.Framework.PlayerIndex playerIndex, System.Int32 trackingId, System.Object userState)` | Opens the controller-required screen for a tracked Kinect user and a specific player. |
| `static System.Void ShowControllerRequiredAsync(System.Int32 trackingId, System.Object userState)` | Opens the system screen telling a Kinect user that a controller is required for the next step. |
| `static System.Void ShowHardwareRequiredAsync()` | Opens the system screen telling the user that a Kinect sensor is required, without a state object. |
| `static System.Void ShowHardwareRequiredAsync(System.Object userState)` | Opens the system screen telling the user that a Kinect sensor is required. |
| `static System.Void ShowTroubleShooting()` | Opens the system Kinect troubleshooting screen. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xna.Framework.GamerServices.NuiControllerRequiredCompletedEventArgs> ShowControllerRequiredCompleted` | Occurs when a screen opened by ShowControllerRequiredAsync closes. The sender is null. Raised on a background thread. |
| `event System.EventHandler<Microsoft.Xna.Framework.GamerServices.NuiHardwareRequiredCompletedEventArgs> ShowHardwareRequiredCompleted` | Occurs when a screen opened by ShowHardwareRequiredAsync closes. The sender is null. Raised on a background thread. |

## NuiHardwareRequiredCompletedEventArgs

`class Microsoft.Xna.Framework.GamerServices.NuiHardwareRequiredCompletedEventArgs`

Provides data for the [`NuiGuide.ShowHardwareRequiredCompleted`](Microsoft.Xna.Framework.GamerServices.md#nuiguide) event.

**Properties**

| | |
|---|---|
| `System.Boolean Result { get; }` | Gets the outcome reported by the Kinect-required screen. |

## ShowGetSocialNetworkTokenCompletedEventArgs

`class Microsoft.Xna.Framework.GamerServices.ShowGetSocialNetworkTokenCompletedEventArgs`

Provides data for the `SignedInGamer.ShowGetSocialNetworkTokenCompleted` event.

**Properties**

| | |
|---|---|
| `System.String UserToken { get; }` | Gets the social network access token returned for the gamer. |

## ShowParentControlPasscodeCompletedEventArgs

`class Microsoft.Xna.Framework.GamerServices.ShowParentControlPasscodeCompletedEventArgs`

Provides data for the `SignedInGamer.ShowParentControlPasscodeCompleted` event.

**Properties**

| | |
|---|---|
| `System.Boolean PassCodeEntered { get; }` | Gets whether the correct parental-control passcode was entered. |

## SocialNetworkImagePost

`class Microsoft.Xna.Framework.GamerServices.SocialNetworkImagePost`

Posts an image, with a title, caption and description, to the gamer's linked social network account through system UI.

Set all properties and call [[M:Microsoft.Xna.Framework.GamerServices.SocialNetworkImagePost.SetPreviewImageData(System.Int32,System.Int32,System.Int32[])]] before calling PostAsync; missing values cause `ArgumentException` or `ArgumentNullException`. Use `SignedInGamer.GetSocialCapabilitiesAsync` to check that image posts are available. The gamer needs the social network privilege.

**Constructors**

| | |
|---|---|
| `SocialNetworkImagePost()` |  |

**Properties**

| | |
|---|---|
| `System.IO.Stream FullSizedImage { get; set; }` | Gets or sets a stream containing the full-size image to post. The setter reads the whole stream immediately and then closes it, so do not reuse the stream afterwards. |
| `System.String ImageCaption { get; set; }` | Gets or sets the caption shown with the image. |
| `System.String ImageDescription { get; set; }` | Gets or sets the description shown with the image. |
| `System.String Title { get; set; }` | Gets or sets the title of the post. |

**Methods**

| | |
|---|---|
| `System.Void PostAsync(Microsoft.Xna.Framework.GamerServices.SignedInGamer gamer)` | Shows the posting UI for the specified gamer. |
| `System.Void PostAsync(Microsoft.Xna.Framework.GamerServices.SignedInGamer gamer, System.Int32 trackingId)` | Shows the Kinect-enabled posting UI for the specified gamer. |
| `System.Void PostAsync(Microsoft.Xna.Framework.GamerServices.SignedInGamer gamer, System.Int32 trackingId, System.Object userState)` | Shows the Kinect-enabled posting UI for the specified gamer and associates a state object with the operation. |
| `System.Void PostAsync(Microsoft.Xna.Framework.GamerServices.SignedInGamer gamer, System.Object userState)` | Shows the posting UI for the specified gamer and associates a state object with the operation. |
| `System.Void SetPreviewImageData(System.Int32 width, System.Int32 height, System.Int32[] data)` | Sets the small preview image shown in the posting UI. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xna.Framework.GamerServices.SocialNetworkPostCompletedEventArgs> Completed` | Occurs when the post operation completes. Raised on a background thread. |

## SocialNetworkLinkPost

`class Microsoft.Xna.Framework.GamerServices.SocialNetworkLinkPost`

Posts a link, with a title and picture, to the gamer's linked social network account through system UI.

Set all properties and call [[M:Microsoft.Xna.Framework.GamerServices.SocialNetworkLinkPost.SetPreviewImageData(System.Int32,System.Int32,System.Int32[])]] before calling PostAsync; missing values cause `ArgumentException` or `ArgumentNullException`. Use `SignedInGamer.GetSocialCapabilitiesAsync` to check that link posts are available. The gamer needs the social network privilege.

**Constructors**

| | |
|---|---|
| `SocialNetworkLinkPost()` |  |

**Properties**

| | |
|---|---|
| `System.String PictureCaption { get; set; }` | Gets or sets the caption of the picture shown with the link. |
| `System.String PictureDescription { get; set; }` | Gets or sets the description of the picture shown with the link. |
| `System.String Title { get; set; }` | Gets or sets the title of the link. |
| `System.Uri PictureUri { get; set; }` | Gets or sets the address of the picture shown with the link. |
| `System.Uri TitleUri { get; set; }` | Gets or sets the address the link points to. |

**Methods**

| | |
|---|---|
| `System.Void PostAsync(Microsoft.Xna.Framework.GamerServices.SignedInGamer gamer)` | Shows the posting UI for the specified gamer. |
| `System.Void PostAsync(Microsoft.Xna.Framework.GamerServices.SignedInGamer gamer, System.Int32 trackingId)` | Shows the Kinect-enabled posting UI for the specified gamer. |
| `System.Void PostAsync(Microsoft.Xna.Framework.GamerServices.SignedInGamer gamer, System.Int32 trackingId, System.Object userState)` | Shows the Kinect-enabled posting UI for the specified gamer and associates a state object with the operation. |
| `System.Void PostAsync(Microsoft.Xna.Framework.GamerServices.SignedInGamer gamer, System.Object userState)` | Shows the posting UI for the specified gamer and associates a state object with the operation. |
| `System.Void SetPreviewImageData(System.Int32 width, System.Int32 height, System.Int32[] data)` | Sets the small preview image shown in the posting UI. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xna.Framework.GamerServices.SocialNetworkPostCompletedEventArgs> Completed` | Occurs when the post operation completes. Raised on a background thread. |

## SocialNetworkPostCompletedEventArgs

`class Microsoft.Xna.Framework.GamerServices.SocialNetworkPostCompletedEventArgs`

Provides data for the Completed events of [`SocialNetworkImagePost`](Microsoft.Xna.Framework.GamerServices.md#socialnetworkimagepost) and [`SocialNetworkLinkPost`](Microsoft.Xna.Framework.GamerServices.md#socialnetworklinkpost).

**Properties**

| | |
|---|---|
| `System.Boolean Result { get; }` | Gets whether the item was posted. |

## SoftwareKeyboardInput

`class Microsoft.Xna.Framework.GamerServices.SoftwareKeyboardInput`

Displays the system on-screen keyboard to collect a line of text from the user.

Set the text properties, subscribe to [`SoftwareKeyboardInput.Completed`](Microsoft.Xna.Framework.GamerServices.md#softwarekeyboardinput), then call OpenAsync. Gamer services must be initialized. Opening the keyboard while other system UI is visible throws `GuideAlreadyVisibleException`.

**Constructors**

| | |
|---|---|
| `SoftwareKeyboardInput()` |  |

**Properties**

| | |
|---|---|
| `System.Boolean UsePasswordMode { get; set; }` | Gets or sets whether the entered characters are masked, as for a password. |
| `System.String DefaultText { get; set; }` | Gets or sets the text initially shown in the input field. |
| `System.String Description { get; set; }` | Gets or sets the descriptive text that tells the user what to enter. |
| `System.String Title { get; set; }` | Gets or sets the title shown at the top of the keyboard screen. |

**Methods**

| | |
|---|---|
| `System.Void OpenAsync(Microsoft.Xna.Framework.PlayerIndex playerIndex)` | Opens the on-screen keyboard for the specified player. Throws `ArgumentException` if any of the text properties is 256 characters or longer. |
| `System.Void OpenAsync(Microsoft.Xna.Framework.PlayerIndex playerIndex, System.Object userState)` | Opens the on-screen keyboard for the specified player and associates a state object with the operation. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xna.Framework.GamerServices.SoftwareKeyboardInputCompletedEventArgs> Completed` | Occurs when the user accepts or cancels the keyboard. This event is raised on a background thread, not the UI thread. Use the Dispatcher to update the user interface from the handler. |

## SoftwareKeyboardInputCompletedEventArgs

`class Microsoft.Xna.Framework.GamerServices.SoftwareKeyboardInputCompletedEventArgs`

Provides data for the [`SoftwareKeyboardInput.Completed`](Microsoft.Xna.Framework.GamerServices.md#softwarekeyboardinput) event.

If the user cancelled the keyboard, Cancelled is true and [`SoftwareKeyboardInputCompletedEventArgs.Result`](Microsoft.Xna.Framework.GamerServices.md#softwarekeyboardinputcompletedeventargs) is null.

**Properties**

| | |
|---|---|
| `System.String Result { get; }` | Gets the text the user entered. |

## StringChecker

`class Microsoft.Xna.Framework.GamerServices.StringChecker`

Submits user-entered strings to the Xbox LIVE string verification service.

Each request accepts 1 to 10 strings, each non-empty and shorter than 256 characters. The service returns one Boolean result per string. Test with known acceptable and unacceptable strings to confirm which value indicates a rejected string before relying on it. The synchronous methods block until the service responds; prefer the Begin/End methods on the UI thread.

**Methods**

| | |
|---|---|
| `static System.Boolean CheckString(System.String value)` | Checks a single string with the verification service and waits for the result. |
| `static System.Boolean EndCheckString(System.IAsyncResult result)` | Ends an asynchronous single-string check. |
| `static System.Boolean[] CheckStrings(System.Collections.Generic.IEnumerable<System.String> strings)` | Checks up to ten strings with the verification service and waits for the results. |
| `static System.Boolean[] EndCheckStrings(System.IAsyncResult result)` | Ends an asynchronous multi-string check. |
| `static System.IAsyncResult BeginCheckString(System.String value, System.AsyncCallback callback, System.Object asyncState)` | Begins an asynchronous check of a single string. |
| `static System.IAsyncResult BeginCheckStrings(System.Collections.Generic.IEnumerable<System.String> strings, System.AsyncCallback callback, System.Object asyncState)` | Begins an asynchronous check of up to ten strings. |

## VideoSharing

`class Microsoft.Xna.Framework.GamerServices.VideoSharing`

Provides static methods that ask the system to confirm video sharing for a gamer.

Results are reported through the static [`VideoSharing.ConfirmationCompleted`](Microsoft.Xna.Framework.GamerServices.md#videosharing) event.

**Methods**

| | |
|---|---|
| `static System.Void ConfirmAsync(Microsoft.Xna.Framework.GamerServices.SignedInGamer gamer)` | Starts the video sharing confirmation for the specified gamer. |
| `static System.Void ConfirmAsync(Microsoft.Xna.Framework.GamerServices.SignedInGamer gamer, System.Int32 trackingId)` | Starts the Kinect-enabled video sharing confirmation for the specified gamer. |
| `static System.Void ConfirmAsync(Microsoft.Xna.Framework.GamerServices.SignedInGamer gamer, System.Int32 trackingId, System.Object userState)` | Starts the Kinect-enabled video sharing confirmation for the specified gamer and associates a state object with the operation. |
| `static System.Void ConfirmAsync(Microsoft.Xna.Framework.GamerServices.SignedInGamer gamer, System.Object userState)` | Starts the video sharing confirmation for the specified gamer and associates a state object with the operation. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xna.Framework.GamerServices.VideoSharingConfirmationCompletedEventArgs> ConfirmationCompleted` | Occurs when a video sharing confirmation completes. The sender is null. Raised on a background thread. |

## VideoSharingConfirmationCompletedEventArgs

`class Microsoft.Xna.Framework.GamerServices.VideoSharingConfirmationCompletedEventArgs`

Provides data for the [`VideoSharing.ConfirmationCompleted`](Microsoft.Xna.Framework.GamerServices.md#videosharing) event.

**Properties**

| | |
|---|---|
| `System.Boolean IsConfirmed { get; }` | Gets whether the user confirmed video sharing. |
| `System.Boolean IsEnabled { get; }` | Gets whether video sharing is enabled for the gamer. |

