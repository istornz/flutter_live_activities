<div align="center">
  <img alt="flutter ios 16 live activities" src="https://raw.githubusercontent.com/istornz/live_activities/main/.github/images/logo.png" />
</div>

# Live Activities

A Flutter plugin to use iOS 16.1+ **Live Activities** & iPhone 14 Pro **Dynamic Island** features.

## 🧐 What is it ?

This plugin use [iOS ActivityKit API](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities).

**live_activities** can be used to show **dynamic live notification** & implement **dynamic island** feature on the iPhone 14 Pro / Max ⚫️

> ⚠️ **live_activities** is only intended to use with **iOS 16.1+** !
> It will simply do nothing on other platform & < iOS 16.1

<div align="center">
  <img alt="flutter ios 16 live activities logo" src="https://raw.githubusercontent.com/istornz/live_activities/main/.github/images/preview.gif" />
</div>

## 👻 Getting started

Due to some **technical restriction**, it's not currently possible to only use Flutter 🫣.

You need to **implement** in your Flutter iOS project a **Widget Extension** & develop in *Swift*/*Objective-C* your own **Live Activity** / **Dynamic Island** design.

> ℹ️ You can check into the [**example repository**](https://github.com/istornz/live_activities/tree/main/example) for a full example app using Live Activities & Dynamic Island

### 🧵 Native
- 📱 Create natively your Live Activity view [**tutorial**](https://levelup.gitconnected.com/how-to-create-live-activities-widget-for-ios-16-2c07889f1235)

  - ⚫️ (*Opt.*) Create natively a Dynamic Island [**tutorial**](https://medium.com/macoclock/how-to-create-dynamic-island-widgets-on-ios-16-1-or-above-dca0a7dd1483)

- 🛎 Enable push notification capabilities.

<img alt="enable push notification capabilities" src="https://raw.githubusercontent.com/istornz/live_activities/main/.github/images/tutorial/push_capability.png" width="400px" />

- ⛹️ Enable live activities for both your **app** & **widget extension**.

<img alt="enable live activity" src="https://raw.githubusercontent.com/istornz/live_activities/main/.github/images/tutorial/live_activity.png" width="400px" />

### 💙 Flutter

- 🔌 Import the plugin.

```dart
import 'package:live_activities/live_activities.dart';
```

- 📣 Create your dynamic activity.

```dart
final Map<String, String> activityModel = {
  'name': 'Margherita',
  'ingredient': 'tomato, mozzarella, basil',
  'quantity': '1',
};

_liveActivitiesPlugin.createActivity(activityModel.toMap());
```

> ⚠️ For now you can **only** pass values as ```String```.

## 📘 Documentation

| Name | Description | Returned value |
| ---- | ----------- | -------- |
| ```.createActivity()``` | Create an iOS live activity,  | ```String``` The activity identifier |
| ```.updateActivity()``` | Update the live activity data by using the ```activityId``` provided  | ```Future``` When the activity was updated |
| ```.endActivity()``` | End the live activity by using the ```activityId``` provided | ```Future``` When the activity was ended |

## 🎯 Roadmap

- [ ] Support multiple type instead of ```String``` (Date, Number etc.).
- [ ] Inject a Widget inside the notification with Flutter Engine ?