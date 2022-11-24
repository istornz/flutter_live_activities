<div align="center">
  <img alt="flutter ios 16 live activities" src="https://raw.githubusercontent.com/istornz/live_activities/main/.github/images/logo.jpg" />
</div>

<br />

A Flutter plugin to use iOS 16.1+ **Live Activities** & iPhone 14 Pro **Dynamic Island** features.

## 🧐 What is it ?

This plugin use [iOS ActivityKit API](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities).

**live_activities** can be used to show **dynamic live notification** & implement **dynamic island** feature on the iPhone 14 Pro / Max ⚫️

> ⚠️ **live_activities** is only intended to use with **iOS 16.1+** !
> It will simply do nothing on other platform & < iOS 16.1

<div align="center">
  <img alt="flutter ios 16 live activities preview dynamic island" src="https://raw.githubusercontent.com/istornz/live_activities/main/.github/images/preview_live_activities.gif" width="200px" style="margin-right: 8px" />
  <img alt="flutter ios 16 live activities preview action" src="https://raw.githubusercontent.com/istornz/live_activities/main/.github/images/preview_action.gif" width="200px" style="margin-right: 8px" />
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
  
<img alt="create widget extension xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/.github/images/tutorial/create_widget_extension.gif" width="700px" />

  - Enable push notification capabilities on the main ```Runner``` app **only**!.

  <img alt="enable push notification capabilities" src="https://raw.githubusercontent.com/istornz/live_activities/main/.github/images/tutorial/push_capability.gif" width="700px" />

  - Enable live activity by adding this line in ```Info.plist``` for both ```Runner``` & your ```Widget Extension```.

```plist
<key>NSSupportsLiveActivities</key>
<true/>
```

  <img alt="enable live activities xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/.github/images/tutorial/enable_live_activities.gif" width="700px" />

  - Create App Group for both ```Runner``` & your ```Widget Extension```.

  <img alt="enable live activity" src="https://raw.githubusercontent.com/istornz/live_activities/main/.github/images/tutorial/app_group.gif" width="700px" />

  <br />

> ℹ️ You can check on this [ressource](https://levelup.gitconnected.com/how-to-create-live-activities-widget-for-ios-16-2c07889f1235) or [here](https://betterprogramming.pub/create-live-activities-with-activitykit-on-ios-16-beta-4766a347035b) for more native informations.

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
let pizzaName = sharedDefault.string(forKey: "name")! // put the same key as your Dart map
let pizzaPrice = sharedDefault.float(forKey: "price")
let quantity = sharedDefault.integer(forKey: "quantity")
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

<img alt="add url scheme xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/.github/images/tutorial/url_scheme.png" width="700px" />

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
| ```.urlSchemeStream()``` | Subscription to handle every url scheme (ex: when the app is opened from a live activity / dynamic island button, you can pass data) | ```Future<UrlSchemeData>``` Url scheme data which handle ```scheme``` ```url``` ```host``` ```path``` ```queryItems``` |
| ```.dispose()``` | Remove all pictures passed in the AppGroups directory in the current session, you can use the ```force``` parameters to remove **all** pictures | ```Future``` Picture removed |

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
