<div align="center">
  <img alt="flutter ios 16 live activities" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/logo.jpg" />
</div>
<br />

<div align="center" style="display: flex;align-items: center;justify-content: center;">
  <a href="https://pub.dev/packages/live_activities"><img src="https://img.shields.io/pub/points/live_activities?style=for-the-badge" style="margin-right: 10px" /></a>
  <a href="https://pub.dev/packages/live_activities"><img src="https://img.shields.io/pub/likes/live_activities?style=for-the-badge" style="margin-right: 10px" /></a>
  <a href="https://pub.dev/packages/live_activities"><img src="https://img.shields.io/pub/popularity/live_activities?style=for-the-badge" style="margin-right: 10px" /></a>
  <a href="https://pub.dev/packages/live_activities"><img src="https://img.shields.io/pub/v/live_activities?style=for-the-badge" style="margin-right: 10px" /></a>
  <a href="https://github.com/istornz/live_activities"><img src="https://img.shields.io/github/stars/istornz/live_activities?style=for-the-badge" /></a>
</div>
<br />

<div align="center">
  <a href="https://radion-app.com" target="_blank" alt="Radion - Ultimate gaming app">
    <img src="https://raw.githubusercontent.com/istornz/live_activities/main/images/radion.png" width="600px" alt="Radion banner - Ultimate gaming app" />
  </a>
</div>
<br />

A Flutter plugin to use iOS 16.1+ **Live Activities** & iPhone 14 Pro **Dynamic Island** features.

## 🧐 What is it ?

This plugin uses the [iOS ActivityKit API](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities).

**live_activities** can be used to show **dynamic live notification** & implement **dynamic island** feature on iPhones that support it 🏝️

> ⚠️ **live_activities** is only intended to use with **iOS 16.1+** !
> It will simply do nothing on other platform & < iOS 16.1

<br />
<div align="center" style="display: flex;align-items: center;justify-content: center;">
  <div align="center" style="display: flex;flex-direction: column; align-items: center;justify-content: center;margin-right: 20px">
    <img alt="flutter ios 16 live activities dynamic island" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/static/dynamic_island.png" width="300px" style="margin-bottom: 20px" />
    <img alt="flutter ios 16 live activities lockscreen" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/static/lockscreen_live_activity.png" width="300px" />
  </div>
  <img alt="flutter ios 16 live activities preview dynamic island" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/animations/create_live_activity.gif" width="250px" style="margin-right: 20px" />
  <img alt="flutter ios 16 live activities preview action" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/animations/update_live_activity.gif" width="250px" style="margin-right: 20px" />
</div>
<br />

## 👻 Getting started

Due to **technical restriction**, it's not currently possible to only use Flutter 🫣.

You need to **implement** in your Flutter iOS project a **Widget Extension** & develop in _Swift_/_Objective-C_ your own **Live Activity** / **Dynamic Island** design.

> ℹ️ You can check into the [**example repository**](https://github.com/istornz/live_activities/tree/main/example) for a full example app using Live Activities & Dynamic Island

- ## 📱 Native
  - Open the Xcode workspace project `ios/Runner.xcworkspace`.
  - Click on `File` -> `New` -> `Target...`
    - Select `Widget Extension` & click on **Next**.
    - Specify the product name (e.g., `MyAppWidget`) and be sure to select "**Runner**" in "Embed in Application" dropdown.
    - Click on **Finish**.
    - When selecting Finish, an alert will appear, you will need to click on **Activate**.

<img alt="create widget extension xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/create_widget_extension.gif" width="700px" />

- Add the "Push Notifications" capabilities for the main `Runner` app **only**!.

  <img alt="enable push notification capabilities" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/push_capability.gif" width="700px" />

- Enable live activity by adding this line in `Info.plist` for both `Runner` and your `Widget Extension`.

```xml
<key>NSSupportsLiveActivities</key>
<true/>
```

  <img alt="enable live activities xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/enable_live_activities.gif" width="700px" />

- Add the "App Group" capability for both `Runner` and your widget extension.
  After you add the capability, check the checkmark next to the text field that contains an identifier of the form `group.example.myapp`.
  This identifier will be used later and refered to as `YOUR_GROUP_ID`.

  <img alt="enable live activity" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/app_group.gif" width="700px" />

  <br />

> ℹ️ You can check on this [resource](https://levelup.gitconnected.com/how-to-create-live-activities-widget-for-ios-16-2c07889f1235) or [here](https://betterprogramming.pub/create-live-activities-with-activitykit-on-ios-16-beta-4766a347035b) for more native informations.

- In your extension, you need to create an `ActivityAttributes` called **EXACTLY** `LiveActivitiesAppAttributes` (if you rename, activity will be created but not appear!)

```swift
struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
  public typealias LiveDeliveryData = ContentState // don't forget to add this line, otherwise, live activity will not display it.

  public struct ContentState: Codable, Hashable { }

  var id = UUID()
}
```

- Create a Swift extension to handle prefixed keys at the end of the file.

```swift
extension LiveActivitiesAppAttributes {
  func prefixedKey(_ key: String) -> String {
    return "\(id)_\(key)"
  }
}
```

- Create an `UserDefaults` with your group id to access Flutter data in your Swift code.

```swift
// Create shared default with custom group
let sharedDefault = UserDefaults(suiteName: "YOUR_GROUP_ID")!

struct FootballMatchApp: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
      // create your live activity widget extension here
      // to access Flutter properties:
      let myVariableFromFlutter = sharedDefault.string(forKey: context.attributes.prefixedKey("myVariableFromFlutter"))!

      // [...]
    }
  }
}
```

- ## 💙 Flutter

  - Import the plugin.

  ```dart
  import 'package:live_activities/live_activities.dart';
  ```

  - Initialize the Plugin by passing the created **App Group Id** (created above).

  ```dart
  final _liveActivitiesPlugin = LiveActivities();
  _liveActivitiesPlugin.init(appGroupId: "YOUR_GROUP_ID");
  ```

  - Create your dynamic activity.

  ```dart
  final Map<String, dynamic> activityModel = {
    'name': 'Margherita',
    'ingredient': 'tomato, mozzarella, basil',
    'quantity': 1,
  };

  _liveActivitiesPlugin.createActivity(activityModel);
  ```

  > You can pass all type of data you want but keep it mind it should be compatible with [`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults)

  <br />

## Access Flutter basic data from Native 🧵

- In your Swift extension, you need to create an `UserDefaults` instance to access data:

```swift
let sharedDefault = UserDefaults(suiteName: "YOUR_GROUP_ID")!
```

> ⚠️ Be sure to use the **SAME** group id in your Swift extension and your Flutter app!

- Access to your typed data:

```swift
let pizzaName = sharedDefault.string(forKey: context.attributes.prefixedKey("name"))! // put the same key as your Dart map
let pizzaPrice = sharedDefault.float(forKey: context.attributes.prefixedKey("price"))
let quantity = sharedDefault.integer(forKey: context.attributes.prefixedKey("quantity"))
// [...]
```

## Access Flutter picture from Native 🧵

- In your map, send a `LiveActivityImageFromAsset` or `LiveActivityImageFromUrl` object:

```dart
final Map<String, dynamic> activityModel = {
  'assetKey': LiveActivityImageFromAsset('assets/images/pizza_chorizo.png'),
  'url': LiveActivityImageFromUrl(
    'https://cdn.pixabay.com/photo/2015/10/01/17/17/car-967387__480.png',
    resizeFactor: 0.3,
  ),
};

_liveActivitiesPlugin.createActivity(activityModel);
```

ℹ️ Use `LiveActivityImageFromAsset` to load an image from your Flutter asset.

ℹ️ Use `LiveActivityImageFromUrl` to load an image from an external url.

> ⚠️ Image need to be in a small resolution to be displayed in your live activity/dynamic island, you can use `resizeFactor` to automatically resize the image 👍.

- In your Swift extension, display the image:

```swift
if let assetImage = sharedDefault.string(forKey: context.attributes.prefixedKey("assetKey")), // <-- Put your key here
  let uiImage = UIImage(contentsOfFile: shop) {
  Image(uiImage: uiImage)
      .resizable()
      .frame(width: 53, height: 53)
      .cornerRadius(13)
} else {
  Text("Loading")
}
```

## Communicate between native 🧵 and Flutter 💙

In order to pass some useful **data** between your **native** live activity / dynamic island with your **Flutter** app you just need to setup **URL scheme**.

> ⚠️ It's recommended to set a custom scheme, in this example, `la` is used but keep in mind, you should use a more personalized scheme.

> **ex:** for an app named `Strava`, you could use `str`.

- Add a custom url scheme in Xcode by navigating to **Runner** > **Runner** > **URL Types** > **URL Schemes**

<img alt="add url scheme xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/url_scheme.png" width="700px" />

- In your Swift code, just create a new **link** and open to your custom **URL Scheme**

```swift
Link(destination: URL(string: "la://my.app/order?=123")!) { // Replace "la" with your scheme
  Text("See order")
}
```

> ⚠️ Don't forget to put the **URL Scheme** you have typed in the **previous step**. (`str://` in the previous example)

- In your Flutter App, you need to init the custom scheme you provided before

```dart
_liveActivitiesPlugin.init(
  appGroupId: 'your.group.id', // replace here with your custom app group id
  urlScheme: 'str' // replace here with your custom app scheme
);
```

- Finally, on the Flutter App too, you just need to listen on the **url scheme Scheme**

```dart
_liveActivitiesPlugin.urlSchemeStream().listen((schemeData) {
  // do what do you want here 🤗
});
```

## Update Live Activity with push notification 🎯

You can update live activity directly in your app using the `updateActivity()` method, but if your app was killed or in the background, you can’t update the notification...

To do this, you can update it using Push Notification on a server.

- Get the push token:
  - Listen on the activity updates (recommended):
    ```dart
    _liveActivitiesPlugin.activityUpdateStream.listen((event) {
      event.map(
        active: (activity) {
          // Get the token
          print(activity.activityToken);
        },
        ended: (activity) {},
        unknown: (activity) {},
      );
    });
    ```
  - Get directly the push token (not recommended, because the token may change in the future):
    ```dart
    final activityToken = await _liveActivitiesPlugin.getPushToken(_latestActivityId!);
    print(activityToken);
    ```
- Update your activity with the token on your server (more information can be [**found here**](https://ohdarling88.medium.com/update-dynamic-island-and-live-activity-with-push-notification-38779803c145)).

To set `matchName` for a specific notification, you just need to grab the notification id you want (ex. `35253464632`) and concatenate with your key by adding a `_`, example: `35253464632_matchName`.

That's it 😇

<br />

## 📘 Documentation

| Name                      | Description                                                                                                                                 | Returned value                                                                                             |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `.init()`                 | Initialize the Plugin by providing an App Group Id (see above)                                                                              | `Future` When the plugin is ready to create/update an activity                                             |
| `.createActivity()`       | Create an iOS live activity                                                                                                                 | `String` The activity identifier                                                                           |
| `.updateActivity()`       | Update the live activity data by using the `activityId` provided                                                                            | `Future` When the activity was updated                                                                     |
| `.endActivity()`          | End the live activity by using the `activityId` provided                                                                                    | `Future` When the activity was ended                                                                       |
| `.getAllActivitiesIds()`  | Get all activities ids created                                                                                                              | `Future<List<String>>` List of all activities ids                                                          |
| `.endAllActivities()`     | End all live activities of the app                                                                                                          | `Future` When all activities was ended                                                                     |
| `.areActivitiesEnabled()` | Check if live activities feature are supported & enabled                                                                                    | `Future<bool>` Live activities supported or not                                                            |
| `.getActivityState()`     | Get the activity current state                                                                                                              | `Future<LiveActivityState?>` An enum to know the status of the activity (`active`, `dismissed` or `ended`) |
| `.getPushToken()`         | Get the activity push token synchronously (prefer using `activityUpdateStream` instead to keep push token up to date)                       | `String?` The activity push token (can be null)                                                            |
| `.urlSchemeStream()`      | Subscription to handle every url scheme (ex: when the app is opened from a live activity / dynamic island button, you can pass data)        | `Future<UrlSchemeData>` Url scheme data which handle `scheme` `url` `host` `path` `queryItems`             |
| `.dispose()`              | Remove all pictures passed in the AppGroups directory in the current session, you can use the `force` parameters to remove **all** pictures | `Future` Picture removed                                                                                   |
| `.activityUpdateStream`   | Get notified with a stream about live activity push token & status                                                                          | `Stream<ActivityUpdate>` Status updates for new push tokens or when the activity ends                      |

<br />

## 👥 Contributions

Contributions are welcome. Contribute by creating a PR or an issue 🎉.

## 🎯 Roadmap

- [ ] Inject a Widget inside the notification with Flutter Engine ?
- [x] Support push token.
- [x] Pass media between extension & Flutter app.
- [x] Support multiple type instead of `String` (Date, Number etc.).
- [x] Pass data across native dynamic island and Flutter app.
- [x] Pass data across native live activity notification and Flutter app.
- [x] Cancel all activities.
- [x] Get all activities ids.
- [x] Check if live activities are supported.
