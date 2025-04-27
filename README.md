<div align="center">
  <img alt="flutter ios 16 live activities" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/logo.webp" />
</div>
<br />

<div align="center" style="display: flex;align-items: center;justify-content: center;">
  <a href="https://pub.dev/packages/live_activities"><img src="https://img.shields.io/pub/points/live_activities?style=for-the-badge" style="margin-right: 10px" /></a>
  <a href="https://pub.dev/packages/live_activities"><img src="https://img.shields.io/pub/likes/live_activities?style=for-the-badge" style="margin-right: 10px" /></a>
  <a href="https://pub.dev/packages/live_activities"><img src="https://img.shields.io/pub/v/live_activities?style=for-the-badge" style="margin-right: 10px" /></a>
  <a href="https://github.com/istornz/live_activities"><img src="https://img.shields.io/github/stars/istornz/live_activities?style=for-the-badge" /></a>
</div>
<br />

<div align="center">
  <a href="https://radion-app.com" target="_blank" alt="Radion - Ultimate gaming app">
    <img src="https://raw.githubusercontent.com/istornz/live_activities/main/images/radion.webp" width="600px" alt="Radion banner - Ultimate gaming app" />
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
    <img alt="flutter ios 16 live activities dynamic island" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/static/dynamic_island.webp" width="300px" style="margin-bottom: 20px" />
    <img alt="flutter ios 16 live activities lockscreen" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/static/lockscreen_live_activity.webp" width="300px" />
  </div>
  <img alt="flutter ios 16 live activities preview dynamic island" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/animations/create_live_activity.webp" width="250px" style="margin-right: 20px" />
  <img alt="flutter ios 16 live activities preview action" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/animations/update_live_activity.webp" width="250px" style="margin-right: 20px" />
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

<img alt="create widget extension xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/create_widget_extension.webp" width="700px" />

- Add the "Push Notifications" capabilities for the main `Runner` app **only**!.

  <img alt="enable push notification capabilities" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/push_capability.webp" width="700px" />

- Enable live activity by adding this line in `Info.plist` for both `Runner` and your `Widget Extension`.

```xml
<key>NSSupportsLiveActivities</key>
<true/>
```

  <img alt="enable live activities xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/enable_live_activities.webp" width="700px" />

- Add the "App Group" capability for both `Runner` and your widget extension.
  After you add the capability, check the checkmark next to the text field that contains an identifier of the form `group.example.myapp`.
  This identifier will be used later and refered to as `YOUR_GROUP_ID`.

  <img alt="enable live activity" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/app_group.webp" width="700px" />

  <br />

> ℹ️ You can check on this [resource](https://levelup.gitconnected.com/how-to-create-live-activities-widget-for-ios-16-2c07889f1235) or [here](https://betterprogramming.pub/create-live-activities-with-activitykit-on-ios-16-beta-4766a347035b) for more native informations.

- Inside your extension `ExtensionNameLiveActivity.swift` file, you need to create an `ActivityAttributes` called **EXACTLY** `LiveActivitiesAppAttributes` (if you rename, activity will be created but not appear!)

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

## Access Flutter files like pictures from Native 🧵

- In your map, send a `LiveActivityFileFromAsset`, `LiveActivityFileFromUrl` or `LiveActivityFileFromMemory` object:

You can use the factory `.image()` to use options like resizing image.

```dart
final Map<String, dynamic> activityModel = {
  'txtFile': LiveActivityFileFromAsset('assets/files/rules.txt'),
  'assetKey': LiveActivityFileFromAsset.image('assets/images/pizza_chorizo.png'),
  'url': LiveActivityFileFromUrl.image(
    'https://cdn.pixabay.com/photo/2015/10/01/17/17/car-967387__480.png',
    imageOptions: LiveActivityImageFileOptions(
      resizeFactor: 0.2
    )
  ),
};

_liveActivitiesPlugin.createActivity(activityModel);
```

ℹ️ Use `LiveActivityFileFromAsset` to load a file from your Flutter asset.

ℹ️ Use `LiveActivityFileFromUrl` to load a file from an external url.

ℹ️ Use `LiveActivityFileFromMemory` to load a file from the memory (from a `Uint8List` object).

> ⚠️ File like picture need to be in a small resolution to be displayed in your live activity/dynamic island, you can use `resizeFactor` to automatically resize the image 👍.

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

- To display a txt file content:

```swift
let ruleFile = sharedDefault.string(forKey: context.attributes.prefixedKey("txtFile"))! // <-- Put your key here
let rule = (try? String(contentsOfFile: ruleFile, encoding: .utf8)) ?? ""

// [...] display the rule txt string variable here
```

## Communicate between native 🧵 and Flutter 💙

In order to pass some useful **data** between your **native** live activity / dynamic island with your **Flutter** app you just need to setup **URL scheme**.

> ⚠️ It's recommended to set a custom scheme, in this example, `la` is used but keep in mind, you should use a more personalized scheme.

> **ex:** for an app named `Strava`, you could use `str`.

- Add a custom url scheme in Xcode by navigating to **Runner** > **Runner** > **URL Types** > **URL Schemes**

<img alt="add url scheme xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/url_scheme.webp" width="700px" />

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

## Push-to-Start Live Activities (iOS 17.2+) 🚀

iOS 17.2 introduces the ability
to [create Live Activities remotely](https://developer.apple.com/documentation/activitykit/starting-and-updating-live-activities-with-activitykit-push-notifications#Start-new-Live-Activities-with-ActivityKit-push-notifications)
via push notifications before the user has even
opened your app. This is called "push-to-start" functionality.

### Check Support

First, check if the device supports push-to-start:

```dart

final isPushToStartSupported = await _liveActivitiesPlugin.allowsPushStart();
if (isPushToStartSupported) {
  // Device supports push-to-start (iOS 17.2+)
}
```

### Listen for Push-to-Start Tokens

To use push-to-start, you need to listen for push-to-start tokens:

```dart
_liveActivitiesPlugin.pushToStartTokenUpdateStream.listen((token) {
  // Send this token to your server
  print('Received push-to-start token: $token');
    
  // Your server can use this token to create a Live Activity
  // without the user having to open your app first
});
```

### Server Implementation

On your server, you'll need to send a push notification with the following
payload [structure](https://developer.apple.com/documentation/activitykit/starting-and-updating-live-activities-with-activitykit-push-notifications#Construct-the-payload-that-starts-a-Live-Activity):

```json
{
  "aps": {
    "timestamp": 1234,
    "event": "start",
    "content-state": {
      "currentHealthLevel": 100,
      "eventDescription": "Adventure has begun!"
    },
    "attributes-type": "AdventureAttributes",
    "attributes": {
      "currentHealthLevel": 100,
      "eventDescription": "Adventure has begun!"
    },
    "alert": {
      "title": {
        "loc-key": "%@ is on an adventure!",
        "loc-args": [
          "Power Panda"
        ]
      },
      "body": {
        "loc-key": "%@ found a sword!",
        "loc-args": [
          "Power Panda"
        ]
      },
      "sound": "chime.aiff"
    }
  }
}
```

The push notification should be sent to the push-to-start token you received from the pushToStartTokenUpdateStream. Your
server needs to use Apple's APNs with the appropriate authentication to deliver these notifications.

## 📘 Documentation

| Name                            | Description                                                                                                                                 | Returned value                                                                                             |
|---------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| `.init()`                       | Initialize the Plugin by providing an App Group Id (see above)                                                                              | `Future` When the plugin is ready to create/update an activity                                             |
| `.createActivity()`             | Create an iOS live activity                                                                                                                 | `String` The activity identifier                                                                           |
| `.createOrUpdateActivity()`     | Create or updates an (existing) live activity based on the provided `UUID` via `customId`                                                   | `String` The activity identifier                                                                           |
| `.updateActivity()`             | Update the live activity data by using the `activityId` provided                                                                            | `Future` When the activity was updated                                                                     |
| `.endActivity()`                | End the live activity by using the `activityId` provided                                                                                    | `Future` When the activity was ended                                                                       |
| `.getAllActivitiesIds()`        | Get all activities ids created                                                                                                              | `Future<List<String>>` List of all activities ids                                                          |
| `.getAllActivities()`           | Get a Map of activitiyIds and the `ActivityState`                                                                                           | `Future<Map<String, LiveActivityState>>` Map of all activitiyId -> `LiveActivityState`                     |
| `.endAllActivities()`           | End all live activities of the app                                                                                                          | `Future` When all activities was ended                                                                     |
| `.areActivitiesEnabled()`       | Check if live activities feature are supported & enabled                                                                                    | `Future<bool>` Live activities supported or not                                                            |
| `.allowsPushStart()`            | Check if device supports push-to-start for Live Activities (iOS 17.2+)                                                                      | `Future<bool>` Whether push-to-start is supported                                                          |
| `.getActivityState()`           | Get the activity current state                                                                                                              | `Future<LiveActivityState?>` An enum to know the status of the activity (`active`, `dismissed` or `ended`) |
| `.getPushToken()`               | Get the activity push token synchronously (prefer using `activityUpdateStream` instead to keep push token up to date)                       | `String?` The activity push token (can be null)                                                            |
| `.getPushToStartToken()`        | Get the app-wide push-to-start token synchronously (iOS 17.2+ only, prefer `pushToStartTokenUpdateStream` for updates)                      | `String?` The push-to-start token in hexadecimal format (can be null)                                      |
| `.urlSchemeStream()`            | Subscription to handle every url scheme (ex: when the app is opened from a live activity / dynamic island button, you can pass data)        | `Future<UrlSchemeData>` Url scheme data which handle `scheme` `url` `host` `path` `queryItems`             |
| `.dispose()`                    | Remove all pictures passed in the AppGroups directory in the current session, you can use the `force` parameters to remove **all** pictures | `Future` Picture removed                                                                                   |
| `.activityUpdateStream`         | Get notified with a stream about live activity push token & status                                                                          | `Stream<ActivityUpdate>` Status updates for new push tokens or when the activity ends                      |
| `.pushToStartTokenUpdateStream` | Stream of push-to-start tokens for creating Live Activities remotely (iOS 17.2+)                                                            | `Stream<String>` Stream of tokens for push-to-start capability                                             |

<br />

## 🤔 Questions

### Do I have to code in Swift?

> Yes you need to implement your activity in Swift but no worries, there is a lot of cool tutorials:
> - [https://canopas.com/integrating-live-activity-and-dynamic-island-in-i-os-a-complete-guide](https://canopas.com/integrating-live-activity-and-dynamic-island-in-i-os-a-complete-guide)
> - [https://blorenzop.medium.com/live-activities-swift-6e95ee15863e](https://blorenzop.medium.com/live-activities-swift-6e95ee15863e)
> - [https://medium.com/kinandcartacreated/how-to-build-ios-live-activity-d1b2f238819e](https://medium.com/kinandcartacreated/how-to-build-ios-live-activity-d1b2f238819e)

### I have an issue when building my app on iOS: `Error (Xcode): Cycle inside Runner; building could produce unreliable results.`

> This error occurs due to a build script ordering issue. Follow [this guide](https://stackoverflow.com/a/77178579/5078902) to resolve it.

### I can't see my live activity when I create it...

> It can be related to multiple issues, please be sure to:
>
> - App Groups Capability: Set up the `App Groups` capability for **BOTH** the `Runner` and your `extension` targets.
> - Same App Group: Use the **SAME** app group for both the `Runner` and `extension` targets.
> - Push Notification Capability: Verify that the `Push Notification` capability is enabled for the `Runner` target.
> - ActivityAttributes Definition: In your extension’s `ExtensionNameLiveActivity.swift` file, ensure you create an ActivityAttributes named **EXACTLY** `LiveActivitiesAppAttributes`.
> - Asset Size Limit: Images in live activities **must be under or equal 4 KB**. Use the resize factor argument to reduce image size if necessary.
> - Supports Live Activities: Be sure to set the `NSSupportsLiveActivities` property to `true` in `Info.plist` files for **BOTH** `Runner` and your `extension`.
> - iOS Version Requirement: The device must run **iOS 16.1 or later**.
> - Device Activity Check: Confirm that the `areActivitiesEnabled()` method returns true on your device.
> - Minimum Deployment Target: Confirm that the `extensions` deployment target is not set lower than your devices. 

### Is Android supported?

> Currently, no, but the plugin does not crash when run on Android. This means you can safely install it in a hybrid app.
> 
> Simply call `areActivitiesEnabled()` before creating your activity to ensure it can be displayed on the user's device. 😊

## 👥 Contributions

Contributions are welcome. Contribute by creating a PR or an issue 🎉.

## 🎯 Roadmap

- [ ] Inject a Widget inside the notification with Flutter Engine?
- [x] Migrate to Swift Package Manager.
- [x] Support push token.
- [x] Pass media between extension & Flutter app.
- [x] Support multiple type instead of `String` (Date, Number etc.).
- [x] Pass data across native dynamic island and Flutter app.
- [x] Pass data across native live activity notification and Flutter app.
- [x] Cancel all activities.
- [x] Get all activities ids.
- [x] Check if live activities are supported.
