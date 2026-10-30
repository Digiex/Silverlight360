# Microsoft.Xbox.Transitions

Assembly: `Microsoft.Xbox.dll`

| Type | Summary |
|---|---|
| [`FadeTransition`](#fadetransition) | A transition that fades the element in or out, using the built-in storyboard that matches [`FadeTransition.Mode`](Microsoft.Xbox.Transitions.md#fadetransition). |
| [`ITransition`](#itransition) | A running or ready-to-run transition animation, with storyboard-style playback control. |
| [`NavigationInTransition`](#navigationintransition) | The transitions a page plays when it is navigated to. Attach with `TransitionService.NavigationInTransition`. |
| [`NavigationOutTransition`](#navigationouttransition) | The transitions a page plays when it is navigated away from. Attach with `TransitionService.NavigationOutTransition`. |
| [`NavigationTransition`](#navigationtransition) | Pairs the transitions used for forward and backward navigation. Use the derived [`NavigationInTransition`](Microsoft.Xbox.Transitions.md#navigationintransition) or [`NavigationOutTransition`](Microsoft.Xbox.Transitions.md#navigationouttransition). |
| [`Transition`](#transition) | The standard [`ITransition`](Microsoft.Xbox.Transitions.md#itransition) implementation: wraps a `Storyboard` and makes the element ignore input while the animation runs. |
| [`TransitionElement`](#transitionelement) | Base class for a transition definition that can be used in XAML. Derive from it to create custom transitions. |
| [`TransitionEventArgs`](#transitioneventargs) | Provides data for the [`TransitionService`](Microsoft.Xbox.Transitions.md#transitionservice) events. |
| [`TransitionMode`](#transitionmode) | Selects the variant of a built-in transition animation by navigation direction and by whether the element is entering or leaving. |
| [`TransitionService`](#transitionservice) | Attached properties and events that control the animated transitions `XboxApplicationFrame` plays when navigating between pages. |
| [`ZIndexTransition`](#zindextransition) | The default page transition used by `XboxApplicationPage`: animates the element through a centered render transform, using the built-in storyboard that matches [`ZIndexTransition.Mode`](Microsoft.Xbox.Transitions.md#zindextransition). |

## FadeTransition

`class Microsoft.Xbox.Transitions.FadeTransition`

A transition that fades the element in or out, using the built-in storyboard that matches [`FadeTransition.Mode`](Microsoft.Xbox.Transitions.md#fadetransition).

**Constructors**

| | |
|---|---|
| `FadeTransition()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Transitions.TransitionMode Mode { get; set; }` | Gets or sets which fade animation is played. The default is [`TransitionMode.ForwardIn`](Microsoft.Xbox.Transitions.md#transitionmode). |

**Methods**

| | |
|---|---|
| `Microsoft.Xbox.Transitions.ITransition GetTransition(System.Windows.UIElement element, System.TimeSpan delay)` | Creates a fade animation for the element. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty ModeProperty` |  |

## ITransition

`interface Microsoft.Xbox.Transitions.ITransition`

A running or ready-to-run transition animation, with storyboard-style playback control.

**Methods**

| | |
|---|---|
| `System.TimeSpan GetCurrentTime()` | Gets the current position within the animation. |
| `System.Void Begin()` | Starts the animation. |
| `System.Void Pause()` | Pauses the animation. |
| `System.Void Resume()` | Resumes a paused animation. |
| `System.Void Seek(System.TimeSpan offset)` | Moves the animation to the specified position; takes effect on the next frame. |
| `System.Void SeekAlignedToLastTick(System.TimeSpan offset)` | Moves the animation to the specified position immediately. |
| `System.Void SkipToFill()` | Jumps to the end of the animation. |
| `System.Void Stop()` | Stops the animation and returns the animated properties to their original values. |
| `System.Windows.Duration GetStoryboardDuration()` | Gets the declared duration of the animation. |
| `System.Windows.Media.Animation.ClockState GetCurrentState()` | Gets the playback state of the animation. |

**Events**

| | |
|---|---|
| `event System.EventHandler Completed` | Occurs when the animation finishes. |

## NavigationInTransition

`class Microsoft.Xbox.Transitions.NavigationInTransition`

The transitions a page plays when it is navigated to. Attach with `TransitionService.NavigationInTransition`.

**Constructors**

| | |
|---|---|
| `NavigationInTransition()` |  |

## NavigationOutTransition

`class Microsoft.Xbox.Transitions.NavigationOutTransition`

The transitions a page plays when it is navigated away from. Attach with `TransitionService.NavigationOutTransition`.

**Constructors**

| | |
|---|---|
| `NavigationOutTransition()` |  |

## NavigationTransition

`class Microsoft.Xbox.Transitions.NavigationTransition`

Pairs the transitions used for forward and backward navigation. Use the derived [`NavigationInTransition`](Microsoft.Xbox.Transitions.md#navigationintransition) or [`NavigationOutTransition`](Microsoft.Xbox.Transitions.md#navigationouttransition).

Forward is used for new and forward navigations; Backward for back navigations. When you set one, set both: the frame does not check for a missing direction.

**Constructors**

| | |
|---|---|
| `NavigationTransition()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Transitions.TransitionElement Backward { get; set; }` | Gets or sets the transition used when navigating back. |
| `Microsoft.Xbox.Transitions.TransitionElement Forward { get; set; }` | Gets or sets the transition used when navigating to a new page or forward. |

**Events**

| | |
|---|---|
| `event System.Windows.RoutedEventHandler BeginTransition` | Intended to occur when this transition starts. The navigation frame does not raise it in this version; use [`TransitionService.TransitionInStarted`](Microsoft.Xbox.Transitions.md#transitionservice) or [`TransitionService.TransitionOutStarted`](Microsoft.Xbox.Transitions.md#transitionservice) instead. |
| `event System.Windows.RoutedEventHandler EndTransition` | Occurs when all animations of the page that this transition is attached to have finished. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty BackwardProperty` |  |
| `static System.Windows.DependencyProperty ForwardProperty` |  |

## Transition

`class Microsoft.Xbox.Transitions.Transition`

The standard [`ITransition`](Microsoft.Xbox.Transitions.md#itransition) implementation: wraps a `Storyboard` and makes the element ignore input while the animation runs.

Use it from a custom [`TransitionElement`](Microsoft.Xbox.Transitions.md#transitionelement) to return your own storyboard. The constructor does not set the storyboard target; set it yourself (for example with `Storyboard.SetTarget`).

**Constructors**

| | |
|---|---|
| `Transition(System.Windows.UIElement element, System.Windows.Media.Animation.Storyboard storyboard)` | Creates a transition that plays a storyboard on an element. |

**Methods**

| | |
|---|---|
| `System.TimeSpan GetCurrentTime()` | Gets the current position of the storyboard. |
| `System.Void Begin()` | Disables hit testing on the element and starts the storyboard. |
| `System.Void Pause()` | Pauses the storyboard. |
| `System.Void Resume()` | Resumes the paused storyboard. |
| `System.Void Seek(System.TimeSpan offset)` | Moves the storyboard to the specified position on the next frame. |
| `System.Void SeekAlignedToLastTick(System.TimeSpan offset)` | Moves the storyboard to the specified position immediately. |
| `System.Void SkipToFill()` | Advances the storyboard to the end of its active period. |
| `System.Void Stop()` | Stops the storyboard and restores hit testing on the element. [`Transition.Completed`](Microsoft.Xbox.Transitions.md#transition) is not raised. |
| `System.Windows.Duration GetStoryboardDuration()` | Gets the storyboard's `Duration` property. |
| `System.Windows.Media.Animation.ClockState GetCurrentState()` | Gets the playback state of the storyboard. |

**Events**

| | |
|---|---|
| `event System.EventHandler Completed` | Occurs when the storyboard completes, before hit testing is restored on the element. |

## TransitionElement

`class Microsoft.Xbox.Transitions.TransitionElement`

Base class for a transition definition that can be used in XAML. Derive from it to create custom transitions.

**Constructors**

| | |
|---|---|
| `TransitionElement()` |  |

**Methods**

| | |
|---|---|
| `Microsoft.Xbox.Transitions.ITransition GetTransition(System.Windows.UIElement element, System.TimeSpan delay)` | Creates the animation for a specific element. |

## TransitionEventArgs

`class Microsoft.Xbox.Transitions.TransitionEventArgs`

Provides data for the [`TransitionService`](Microsoft.Xbox.Transitions.md#transitionservice) events.

**Properties**

| | |
|---|---|
| `System.Windows.UIElement TargetElement { get; }` | Gets the page whose transition started or finished. Always `null` for the completed events in this version. |

## TransitionMode

`enum Microsoft.Xbox.Transitions.TransitionMode`

Selects the variant of a built-in transition animation by navigation direction and by whether the element is entering or leaving.

**Values**

| | |
|---|---|
| `BackwardIn` | The element enters during back navigation. |
| `BackwardOut` | The element leaves during back navigation. |
| `ForwardIn` | The element enters during forward navigation. |
| `ForwardOut` | The element leaves during forward navigation. |

## TransitionService

`class Microsoft.Xbox.Transitions.TransitionService`

Attached properties and events that control the animated transitions `XboxApplicationFrame` plays when navigating between pages.

Set `NavigationInTransition` and `NavigationOutTransition` on a page to choose its animations; `XboxApplicationPage` sets both to [`ZIndexTransition`](Microsoft.Xbox.Transitions.md#zindextransition) by default. A page without transitions is swapped instantly.

Elements inside a page marked with `TransitionTarget="True"` animate individually after the page, staggered by 160 ms per `TransitionOrder` step. They use their own transitions if set, otherwise the page's.

**Methods**

| | |
|---|---|
| `static Microsoft.Xbox.Transitions.NavigationInTransition GetNavigationInTransition(System.Windows.UIElement element)` | Gets the transitions played when the element is navigated to. |
| `static Microsoft.Xbox.Transitions.NavigationOutTransition GetNavigationOutTransition(System.Windows.UIElement element)` | Gets the transitions played when the element is navigated away from. |
| `static System.Boolean GetTransitionTarget(System.Windows.UIElement element)` | Gets whether the element is animated separately from its page. |
| `static System.Int32 GetTransitionOrder(System.Windows.UIElement element)` | Gets the element's position in the staggered transition sequence. |
| `static System.Void SetNavigationInTransition(System.Windows.UIElement element, Microsoft.Xbox.Transitions.NavigationInTransition value)` | Sets the transitions played when the element is navigated to. |
| `static System.Void SetNavigationOutTransition(System.Windows.UIElement element, Microsoft.Xbox.Transitions.NavigationOutTransition value)` | Sets the transitions played when the element is navigated away from. |
| `static System.Void SetTransitionOrder(System.Windows.DependencyObject obj, System.Int32 value)` | Sets the element's position in the staggered transition sequence. Each step adds 160 ms of delay. |
| `static System.Void SetTransitionTarget(System.Windows.DependencyObject obj, System.Boolean value)` | Marks or unmarks an element as animated separately from its page. |

**Events**

| | |
|---|---|
| `event System.EventHandler<Microsoft.Xbox.Transitions.TransitionEventArgs> TransitionInCompleted` | Occurs when all of the incoming page's transitions, including its transition targets, have finished and the page accepts input. In this version [`TransitionEventArgs.TargetElement`](Microsoft.Xbox.Transitions.md#transitioneventargs) is always `null` for this event. |
| `event System.EventHandler<Microsoft.Xbox.Transitions.TransitionEventArgs> TransitionInStarted` | Occurs when the incoming page's transitions start. [`TransitionEventArgs.TargetElement`](Microsoft.Xbox.Transitions.md#transitioneventargs) is the new page. |
| `event System.EventHandler<Microsoft.Xbox.Transitions.TransitionEventArgs> TransitionOutCompleted` | Occurs when all of the outgoing page's transitions have finished and the old page has been removed. In this version [`TransitionEventArgs.TargetElement`](Microsoft.Xbox.Transitions.md#transitioneventargs) is always `null` for this event. |
| `event System.EventHandler<Microsoft.Xbox.Transitions.TransitionEventArgs> TransitionOutStarted` | Occurs when the outgoing page's transitions start. [`TransitionEventArgs.TargetElement`](Microsoft.Xbox.Transitions.md#transitioneventargs) is the old page. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty NavigationInTransitionProperty` | Identifies the `TransitionService.NavigationInTransition` attached property: the animations played when the element is navigated to. |
| `static System.Windows.DependencyProperty NavigationOutTransitionProperty` | Identifies the `TransitionService.NavigationOutTransition` attached property: the animations played when the element is navigated away from. |
| `static System.Windows.DependencyProperty TransitionOrderProperty` | Identifies the `TransitionService.TransitionOrder` attached property: the position of a transition target in the staggered sequence. Each step delays the element's animation by 160 ms. The default is 0. |
| `static System.Windows.DependencyProperty TransitionTargetProperty` | Identifies the `TransitionService.TransitionTarget` attached property. When `true`, the element is animated separately from its page during navigation. The default is `false`. |

## ZIndexTransition

`class Microsoft.Xbox.Transitions.ZIndexTransition`

The default page transition used by `XboxApplicationPage`: animates the element through a centered render transform, using the built-in storyboard that matches [`ZIndexTransition.Mode`](Microsoft.Xbox.Transitions.md#zindextransition).

Replaces the element's `RenderTransform` with a new `CompositeTransform` centered on the element, so any existing render transform is lost.

**Constructors**

| | |
|---|---|
| `ZIndexTransition()` |  |

**Properties**

| | |
|---|---|
| `Microsoft.Xbox.Transitions.TransitionMode Mode { get; set; }` | Gets or sets which depth animation is played. The default is [`TransitionMode.ForwardIn`](Microsoft.Xbox.Transitions.md#transitionmode). |

**Methods**

| | |
|---|---|
| `Microsoft.Xbox.Transitions.ITransition GetTransition(System.Windows.UIElement element, System.TimeSpan delay)` | Creates a depth animation for the element. |

**Fields**

| | |
|---|---|
| `static System.Windows.DependencyProperty ModeProperty` |  |

