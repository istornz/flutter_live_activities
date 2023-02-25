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

A Flutter plugin to use iOS 16.1+ **Live Activities** & iPhone 14 Pro **Dynamic Island** features.

## 🧐 What is it ?

This plugin use [iOS ActivityKit API](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities).

**live_activities** can be used to show **dynamic live notification** & implement **dynamic island** feature on the iPhone 14 Pro / Max 🏝️

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

Due to some **technical restriction**, it's not currently possible to only use Flutter 🫣.

You need to **implement** in your Flutter iOS project a **Widget Extension** & develop in *Swift*/*Objective-C* your own **Live Activity** / **Dynamic Island** design.

> ℹ️ You can check into the [**example repository**](https://github.com/istornz/live_activities/tree/main/example) for a full example app using Live Activities & Dynamic Island

- ## 📱 Native
  - Open the Xcode workspace project ```ios/Runner.xcworkspace```.
  - Click on ```File``` -> ```New``` -> ```Target...```
    - Select ```Widget Extension``` & click on **Next**.
    - Specify the product name (*MyApp*Widget for eg.) & be sure to select "**Runner**" in "Embed in Application" dropdown.
    - Click on **Finish**.
    - When selecting Finish, an alert will appear, you will need to click on **Activate**.
  
<img alt="create widget extension xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/create_widget_extension.gif" width="700px" />

  - Enable push notification capabilities on the main ```Runner``` app **only**!.

  <img alt="enable push notification capabilities" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/push_capability.gif" width="700px" />

  - Enable live activity by adding this line in ```Info.plist``` for both ```Runner``` & your ```Widget Extension```.

```xml
<key>NSSupportsLiveActivities</key>
<true/>
```

  <img alt="enable live activities xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/enable_live_activities.gif" width="700px" />

  - Create App Group for both ```Runner``` & your ```Widget Extension```.

  <img alt="enable live activity" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/app_group.gif" width="700px" />

  <br />

> ℹ️ You can check on this [resource](https://levelup.gitconnected.com/how-to-create-live-activities-widget-for-ios-16-2c07889f1235) or [here](https://betterprogramming.pub/create-live-activities-with-activitykit-on-ios-16-beta-4766a347035b) for more native informations.

  - In your extension, you need to create an ```ActivityAttributes``` called **EXACTLY** ```LiveActivitiesAppAttributes``` (if you rename, activity will be created but not appear!)

```swift
struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
  public typealias LiveDeliveryData = ContentState // don't forget to add this line, otherwise, live activity will not display it.

  public struct ContentState: Codable, Hashable { }
  
  var sharedId: String
  var id = UUID()
}
```

  - Create an ```UserDefaults``` with your group id to access Flutter data in your Swift code.

```swift
// Create shared default with custom group
let sharedDefault = UserDefaults(suiteName: "YOUR_GROUP_ID")!

struct FootballMatchApp: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
      // create your live activity widget extension here
      // to access Flutter properties:
      let myVariableFromFlutter = sharedDefault.string(forKey: "\(context.attributes.sharedId)myVariableFromFlutter")!

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
  _liveActivitiesPlugin.init(appGroupId: "YOUR_CREATED_APP_ID");
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

  > You can pass all type of data you want but keep it mind it should be compatible with [```UserDefaults```](https://developer.apple.com/documentation/foundation/userdefaults)

  <br />
  
## Access Flutter basic data from Native 🧵

- In your Swift extension, you need to create an ```UserDefaults``` instance to access data:
```swift
let sharedDefault = UserDefaults(suiteName: "YOUR_CREATED_APP_ID")!
```
> ⚠️ Be sure to use the **SAME** group id in your Swift extension and your Flutter app!

- Access to your typed data:

```swift
let pizzaName = sharedDefault.string(forKey: "\(context.attributes.sharedId)name")! // put the same key as your Dart map
let pizzaPrice = sharedDefault.float(forKey: "\(context.attributes.sharedId)price")
let quantity = sharedDefault.integer(forKey: "\(context.attributes.sharedId)quantity")
// [...]
```

## Access Flutter picture from Native 🧵

- In your map, send a ```LiveActivityImageFromAsset``` or ```LiveActivityImageFromUrl``` object:
  
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

ℹ️ Use ```LiveActivityImageFromAsset``` to load an image from your Flutter asset.

ℹ️ Use ```LiveActivityImageFromUrl``` to load an image from an external url.

> ⚠️ Image need to be in a small resolution to be displayed in your live activity/dynamic island, you can use ```resizeFactor``` to automatically resize the image 👍.

- In your Swift extension, display the image:

```swift
if let assetImage = sharedDefault.string(forKey: "assetKey"), // <-- Put your key here
  let uiImage = UIImage(contentsOfFile: shop) {
  Image(uiImage: uiImage)
      .resizable()
      .frame(width: 53, height: 53)
      .cornerRadius(13)
} else {
  Text("Loading")
}
```

## Communicate over Native 🧵 and Flutter 💙

In order to pass some useful **data** between your **native** live activity / dynamic island with your **Flutter** app you just need to setup **URL scheme**.

- Add a custom url scheme in Xcode by navigating to **Runner** > **Runner** > **URL Types** > **URL Schemes**

<img alt="add url scheme xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/url_scheme.png" width="700px" />

- In your Swift code, just create a new **link** and open to your custom **URL Scheme**

```swift
Link(destination: URL(string: "la://my.app/order?=123")!) { // Replace "la" with your scheme
  Text("See order")
}
```

> ⚠️ Don't forget to put the **URL Scheme** you have typed in the **previous step**.

- In your Flutter App, you just need to listen on the **url scheme Scheme**

```dart
_liveActivitiesPlugin.urlSchemeStream().listen((schemeData) {
  // do what do you want here 🤗
});
```

<br />

## 📘 Documentation

| Name | Description | Returned value |
| ---- | ----------- | -------- |
| ```.init()``` | Initialize the Plugin by providing an App Group Id (see above)  | ```Future``` When the plugin is ready to create/update an activity |
| ```.createActivity()``` | Create an iOS live activity  | ```String``` The activity identifier |
| ```.updateActivity()``` | Update the live activity data by using the ```activityId``` provided  | ```Future``` When the activity was updated |
| ```.endActivity()``` | End the live activity by using the ```activityId``` provided | ```Future``` When the activity was ended |
| ```.getAllActivitiesIds()``` | Get all activities ids created | ```Future<List<String>>``` List of all activities ids |
| ```.endAllActivities()``` | End all live activities of the app | ```Future``` When all activities was ended |
| ```.areActivitiesEnabled()``` | Check if live activities feature are supported & enabled | ```Future<bool>``` Live activities supported or not |
| ```.getActivityState()``` | Get the activity current state | ```Future<LiveActivityState>``` An enum to know the status of the activity (```active```, ```dismissed``` or ```ended```) |
| ```.getPushToken()``` | Get the activity push token | ```String``` The activity push token |
| ```.urlSchemeStream()``` | Subscription to handle every url scheme (ex: when the app is opened from a live activity / dynamic island button, you can pass data) | ```Future<UrlSchemeData>``` Url scheme data which handle ```scheme``` ```url``` ```host``` ```path``` ```queryItems``` |
| ```.dispose()``` | Remove all pictures passed in the AppGroups directory in the current session, you can use the ```force``` parameters to remove **all** pictures | ```Future``` Picture removed |
| ```.activityUpdateStream``` | Get notified with a stream about live activity push token & status | ```Stream<ActivityUpdate>``` Status updates for new push tokens or when the activity ends |

<br />

## 👥 Contributions

Contributions are welcome. Contribute by creating a PR or create an issue 🎉.

## 🎯 Roadmap

- [ ] Inject a Widget inside the notification with Flutter Engine ?
- [x] Pass media between extension & Flutter app.
- [x] Support multiple type instead of ```String``` (Date, Number etc.).
- [x] Pass data across native dynamic island and Flutter app.
- [x] Pass data across native live activity notification and Flutter app.
- [x] Cancel all activities.
- [x] Get all activities ids.
- [x] Check if live activities are supported.  
