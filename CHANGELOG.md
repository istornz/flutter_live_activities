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

* ✨ Add url scheme optional argument.
* ✨ Add sinks unregister on engine end (thanks @ggirotto 👍).
* 🐛 Fix example images size.
* ⬆️ Upgrade dependencies.

## 1.7.5

* 🚨 Lint some code.
* 🐛 Fix deprecated tests.
* ⬆️ Upgrade dependencies.

## 1.7.4

* 🐛 Method `areActivitiesEnabled()` are now callable on iOS < 16.1
* ✨ Creating an activity can now use stale-date (thanks @arnar-steinthors 👍).

## 1.7.3
* ✨ ActivityUpdate subclasses are now public along with a new MapOrNull method (thanks @arnar-steinthors 👍).

## 1.7.2
* ✨ Add missing "stale" activity status.
* 🐛 When value set to null in map, value is removed from live activity.

## 1.7.1
* 🐛 Fix missing `activityUpdateStream` implementation channel on native part.

## 1.7.0
* ✨🐛 Change method `getPushToken()` to be synchronous.
* ⬆️ Upgrade dependencies.

## 1.6.0

* ✨ Add a way to track push token and the activity status (thanks @arnar-steinthors 👍).
* ♻️ Format code.

## 1.5.0

* ✨ Add method to get push token (thanks to @jolamar 👍).
* ♻️ Rework Swift code.

## 1.4.2+1

* 📝 Add screenshots in pubspec.yaml

## 1.4.2

* ✨ End live activity when the app is terminated (thanks to @JulianBissekkou 👍).

## 1.4.1

* 🐛 Fix a bug where init never completes (thanks to @JulianBissekkou 👍).

## 1.4.0

* ✨ Can now pass assets between Flutter & Native.
* 📝 Update README.md.

## 1.3.0+1

* 📝 Update README.md.

## 1.3.0

* ✨ Now using [App Groups](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_application-groups) to pass typed data across Flutter & Native !
* 🗑️ Remove unused code in example.
* 📝 Improve README.md.

## 1.2.1

* ✨ Add method to get the activity state (active, ended or dismissed).

## 1.2.0

* ✨ Add stream to handle url scheme from live activities &/or dynamic island.
* 📝 Improve README.md
* ♻️ Rework example

## 1.1.0

* ✨ Add method to check if live activities are enabled.
* ✨ Add method to get all activities ids created.
* ✨ Add method to cancel all activities.
* 🐛 Fix add result to all methods.

## 1.0.0

* 🎉 Initial release.
