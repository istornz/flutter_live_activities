## 2.4.9
- 🐛 Improve initialization logic.

## 2.4.8
- 🐛 Fix example app which was not working anymore.
- ✨ Bump minimal Flutter SDK version to 3.41.0.

## 2.4.7

- 🐛 Fix UIScene iOS adoption.
- ✨ Introduce optional `activityTag` parameter to activity methods and update Android notification ID generation to consistently use `activityId` (thanks to @Dansp 👍).

## 2.4.6

- 🐛 Implement `createOrUpdateActivity` for Android.

## 2.4.5

- 🐛 Fix `removeWhenAppIsKilled` in release mode.

## 2.4.4

- ✨ Implement Android notification request by the plugin
- ✨ Add an option to disable iOS remote push update.

Eg.

```dart
createActivity(
  ...
  iOSEnableRemoteUpdates: false, // default is true
);
createOrUpdateActivity(
  ...
  iOSEnableRemoteUpdates: false, // default is true
);
```

- 🐛 Disable iOS push notification request as not needed for live activities.

## 2.4.3

- 🏗️ Migrating to UISceneDelegate (Flutter 3.38.x iOS breaking change).
- 🏗️ Default SDK environment is now 3.10.0 and Flutter SDK >= 3.38.0.
- 🏗️ Fix compile error Android example project (thanks to @trunghieuvn 👍).
- ✨🐛 (Android) Store notification IDs on app termination and return string IDs to Dart (thanks to @felixibel 👍).
- ✨ Add support for `getActivityState()` to detect activity by custom activity id (thanks to @reynirf 👍).
- ✨ Add option to control iOS notification permission request (thanks to @asmz 👍).

## 2.4.2

- ✨ New method `areActivitiesSupported()` ➡️ Check if live activities are supported on the current platform/OS version. (thanks to @MortadhaFadhlaoui 👍).
- 🏗️ Method `areActivitiesEnabled()` ➡️ Now only checks user settings without platform version validation. (thanks to @MortadhaFadhlaoui 👍).

## 2.4.1

- 🐛 Check for customId in endActivitiesWithId (thanks to @dkobia 👍).
- 🐛 Bugfix avoid remove all notifications (thanks to @EArminjon 👍).

## 2.4.0 - Live activity is now available for Android too!

- ✨ Add support for Android Live Activities (thanks to @EArminjon 👍).
- 🐛 Custom ID activities fail to end correctly (thanks to @charleyzhu 👍).
- 📝 Update README.md for local and remote Live activities.

**ℹ️ BREAKING CHANGES ℹ️**

- On both platforms, activityID is now a required parameter for `createActivity` and `createOrUpdateActivity()`.
- Bump **iOS** minimum version to **13**.

## 2.3.2

- ✨ Ability to get the "pushToStartToken" (thanks to @Clon1998 👍).
- ⬆️ Upgrade dependencies.

## 2.3.1

- 🐛 `LiveActivityFileFromMemory` can't share image with AppGroup (thanks to @EArminjon 👍).
- 📝 Added minor version check when not being able to see the Live Activity (thanks to @dasanten 👍).
- ⬆️ Upgrade dependencies.

## 2.3.0

- 🏗️ Move to Swift Package Manager.
- 🏗️ Regenerate example app.
- ⬆️ Upgrade dependencies.

## 2.2.0

- ✨ Added a new method `createOrUpdateActivity()`, you can use it to create or update by passing an activity ID (thanks to @Clon1998 👍).
- ⬆️ Upgrade dependencies.

## 2.1.0

- ✨ You can now send generic files instead of just pictures.

To send a file you can do the following on the Dart code:

```dart
LiveActivityFileFromAsset('assets/files/rules.txt')
```

And in your Swift code:

```swift
let ruleFile = sharedDefault.string(forKey: context.attributes.prefixedKey("yourFileKey"))!
let rule = (try? String(contentsOfFile: ruleFile, encoding: .utf8)) ?? ""
```

> Check the example for a full demo.

**BREAKING CHANGES**

You must replace your images to:

- `LiveActivityFileFromAsset.image()`
- `LiveActivityFileFromMemory.image()`
- `LiveActivityFileFromUrl.image()`

In order to use `resizeFactor` you must do the following now:

```dart
LiveActivityFileFromAsset.image(
  'assets/images/chelsea.png',
  imageOptions: LiveActivityImageFileOptions(
    resizeFactor: 0.2
  )
),
```

- 🐛 Example works again with scheme.

## 2.0.1

- 🐛 Fix channel message sent from native to Flutter on a non-platform thread (thanks to @aswanath 👍)
- 🗑️ Clean some code.

## 2.0.0

- ✨ Use new custom iOS [App Group Directory dependency](https://pub.dev/packages/flutter_app_group_directory) (this will fix namespace for Android gradle builds).
- ✨ Removed deprecated flutter_native_image dependency and replaced by image (thanks to @SnapDrive 👍)
- ⬆️ Upgrade dependencies.

## 1.9.5

- 🐛 Fix `areActivitiesEnabled()` on unsupported devices.

## 1.9.4

- 🍱 Convert images to webp.
- ⬆️ Upgrade dependencies.

## 1.9.3

- 🐛 Force returning false for `areActivitiesEnabled()` when no iOS devices.

## 1.9.2

- ✨ Simplified fetching of ActivityState of all created live activities (thanks to @Clon1998 👍).
- 🐛 Fixes background thread invocation of event streams (thanks to @ggirotto 👍).
- 🐛 Replaced getImageProperties with dart buffer and descriptor (thanks to @anumb 👍).
- 🐛 Fix tests.
- ⬆️ Upgrade dependencies.

## 1.9.1

- ✨ Add update with alert config (thanks @charlesRmajor 👍).
- ✨ Add an option to use preloaded images (thanks @Niklas-Sommer 👍).
- ✨ Add Android support - currently only used to check if live activities is supported (thanks @ggirotto 👍).
- ✨ Example app support Material 3.
- 🐛 Fix tests.
- 📝 Update README.md.
- ⬆️ Upgrade dependencies.

## 1.9.0

- ✨ **BREAKING CHANGE**: Add the ability to handle multiple live notification (thanks @Clon1998 👍).

Please follow this tutorial to add implement it:

- Add the following Swift extension at the end of your extension code:

```swift
extension LiveActivitiesAppAttributes {
  func prefixedKey(_ key: String) -> String {
    return "\(id)_\(key)"
  }
}
```

- For each keys on your native Swift code, please changes the following lines:

```swift
let myVariableFromFlutter = sharedDefault.string(forKey: "myVariableFromFlutter") // repleace this by ...
let myVariableFromFlutter = sharedDefault.string(forKey: context.attributes.prefixedKey("myVariableFromFlutter")) // <-- this
```

- 🐛 Fix stall state for unknown activityId (thanks @Clon1998 👍).
- 🐛 Now return `null` value when activity is not found in `getActivityState()`.

## 1.8.0

- ✨ Add url scheme optional argument.
- ✨ Add sinks unregister on engine end (thanks @ggirotto 👍).
- 🐛 Fix example images size.
- ⬆️ Upgrade dependencies.

## 1.7.5

- 🚨 Lint some code.
- 🐛 Fix deprecated tests.
- ⬆️ Upgrade dependencies.

## 1.7.4

- 🐛 Method `areActivitiesEnabled()` are now callable on iOS < 16.1
- ✨ Creating an activity can now use stale-date (thanks @arnar-steinthors 👍).

## 1.7.3

- ✨ ActivityUpdate subclasses are now public along with a new MapOrNull method (thanks @arnar-steinthors 👍).

## 1.7.2

- ✨ Add missing "stale" activity status.
- 🐛 When value set to null in map, value is removed from live activity.

## 1.7.1

- 🐛 Fix missing `activityUpdateStream` implementation channel on native part.

## 1.7.0

- ✨🐛 Change method `getPushToken()` to be synchronous.
- ⬆️ Upgrade dependencies.

## 1.6.0

- ✨ Add a way to track push token and the activity status (thanks @arnar-steinthors 👍).
- ♻️ Format code.

## 1.5.0

- ✨ Add method to get push token (thanks to @jolamar 👍).
- ♻️ Rework Swift code.

## 1.4.2+1

- 📝 Add screenshots in pubspec.yaml

## 1.4.2

- ✨ End live activity when the app is terminated (thanks to @JulianBissekkou 👍).

## 1.4.1

- 🐛 Fix a bug where init never completes (thanks to @JulianBissekkou 👍).

## 1.4.0

- ✨ Can now pass assets between Flutter & Native.
- 📝 Update README.md.

## 1.3.0+1

- 📝 Update README.md.

## 1.3.0

- ✨ Now using [App Groups](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_application-groups) to pass typed data across Flutter & Native !
- 🗑️ Remove unused code in example.
- 📝 Improve README.md.

## 1.2.1

- ✨ Add method to get the activity state (active, ended or dismissed).

## 1.2.0

- ✨ Add stream to handle url scheme from live activities &/or dynamic island.
- 📝 Improve README.md
- ♻️ Rework example

## 1.1.0

- ✨ Add method to check if live activities are enabled.
- ✨ Add method to get all activities ids created.
- ✨ Add method to cancel all activities.
- 🐛 Fix add result to all methods.

## 1.0.0

- 🎉 Initial release.
