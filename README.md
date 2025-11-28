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

A Flutter plugin that enables the use of Android (API level 24+) **RemoteViews** and
iOS (16.1+) **Live Activities**, including support for the **iPhone Dynamic
Island** features.

## 🧐 What is it ?

This plugin uses
the [iOS ActivityKit API](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities)
and
the [Android RemoteViews API](https://developer.android.com/reference/android/widget/RemoteViews)
to create **live activities** on iOS and **remote views** on Android.

**live_activities** can be used to show **dynamic live notification** &
implement **dynamic island** feature on iPhones that support it 🏝️

> ⚠️ **live_activities** is only intended to use with **iOS 16.1+** or Android
> **API 24+**.
> It will simply do nothing prior these versions.

### iOS

<div align="center" style="display: flex;align-items: center;justify-content: center;">
  <div align="center" style="display: flex;flex-direction: column; align-items: center;justify-content: center;margin-right: 20px">
    <img alt="flutter ios 16 live activities dynamic island" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/static/dynamic_island.webp" width="300px" style="margin-bottom: 20px" />
    <img alt="flutter ios 16 live activities lockscreen" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/static/lockscreen_live_activity.webp" width="300px" />
  </div>
  <img alt="flutter ios 16 live activities preview dynamic island" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/animations/create_live_activity.webp" width="250px" style="margin-right: 20px" />
  <img alt="flutter ios 16 live activities preview action" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/animations/update_live_activity.webp" width="250px" style="margin-right: 20px" />
</div>
<br />

### Android

<div align="center" style="display: flex;align-items: center;justify-content: center;">
  <div align="center" style="display: flex;flex-direction: column; align-items: center;justify-content: center;margin-right: 20px">
    <img alt="flutter android live activities collapsed" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/static/android_collapsed.png" width="300px" />
    <img alt="flutter android live activities expanded" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/static/android_expanded.png" width="300px" style="margin-bottom: 20px" />
  </div>
  <img alt="flutter ios 16 live activities preview dynamic island" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/showcase/animations/android-demo.gif" width="250px" style="margin-right: 20px" />
</div>
<br />

## 👻 Getting started

Due to **technical restriction**, it's not currently possible to only use
Flutter 🫣.

### iOS

You need to **implement** in your Flutter iOS project a **Widget Extension** &
develop in _Swift_/_Objective-C_ your own **Live Activity** / **Dynamic Island**
design.

> ℹ️ You can check into the **[example repository
> ](https://github.com/istornz/live_activities/tree/main/example)** for a full
> example app using Live Activities & Dynamic Island

- ## 📱 Native

  - Open the Xcode workspace project `ios/Runner.xcworkspace`.
  - Click on `File` -> `New` -> `Target...`
    - Select `Widget Extension` & click on **Next**.
    - Specify the product name (e.g., `MyAppWidget`) and be sure to select "
      **Runner**" in "Embed in Application" dropdown.
    - Click on **Finish**.
    - When selecting Finish, an alert will appear, you will need to click on
      **Activate**.

  <img alt="create widget extension xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/create_widget_extension.webp" width="700px" />

- Add the "Push Notifications" capabilities for the main `Runner` app **only**!.

  <img alt="enable push notification capabilities" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/push_capability.webp" width="700px" />

- Enable live activity by adding this line in `Info.plist` for both `Runner` and
  your `Widget Extension`.

  ```xml
  <key>NSSupportsLiveActivities</key>
  <true/>
  ```

  <img alt="enable live activities xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/enable_live_activities.webp" width="700px" />

- Add the "App Group" capability for both `Runner` and your widget extension.
  After you add the capability, check the checkmark next to the text field that
  contains an identifier of the form `group.example.myapp`.
  This identifier will be used later and refered to as `YOUR_GROUP_ID`.

  <img alt="enable live activity" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/app_group.webp" width="700px" />

  <br />

> ℹ️ You can check on this **[resource](https://levelup.gitconnected.com/how-to-create-live-activities-widget-for-ios-16-2c07889f1235)** or **[here](https://betterprogramming.pub/create-live-activities-with-activitykit-on-ios-16-beta-4766a347035b)** for more native informations.

- Inside your extension `ExtensionNameLiveActivity.swift` file, you need to
  create an `ActivityAttributes` called **EXACTLY**
  `LiveActivitiesAppAttributes` (if you rename, activity will be created but not
  appear!)

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

- Create an `UserDefaults` with your group id to access Flutter data in your
  Swift code.

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

### Android

You need to **implement** in your Flutter Android project a **CustomLiveActivityManager** which will extends plugin one & develop in
_Kotlin_ / _Java_ your own **RemoveView** logic and design.

Don't be afraid, you will just need to create one **XML** and one **Kotlin** files.

- ## 📱 Native
  - Open your MainActivity.kt inside
    `android/app/src/main/kotlin/.../MainActivity.kt`.
  - Give to `LiveActivityManagerHolder` an instance of `LiveActivityManager`,
    it will contain your logic.
  - Create the Kotlin file of your custom `LiveActivityManager`.
  - Create the XML file of your custom `RemoteView` inside
    `android/app/src/main/res/layout/live_activity.xml`.

`MainActivity.kt` example:

```kotlin
package your.package.name

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine

import com.example.live_activities.LiveActivityManagerHolder

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        LiveActivityManagerHolder.instance = CustomLiveActivityManager(this)
    }
}
```

`CustomLiveActivityManager.kt` example:

```kotlin
package your.package.name

import android.app.Notification
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.net.HttpURLConnection
import java.net.URL
import com.example.live_activities.LiveActivityManager

class CustomLiveActivityManager(context: Context) :
    LiveActivityManager(context) {
    private val context: Context = context.applicationContext
    private val pendingIntent = PendingIntent.getActivity(
        context, 200, Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_REORDER_TO_FRONT
        }, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    private val remoteViews = RemoteViews(
        context.packageName, R.layout.live_activity
    )

    // This function is not necessary
    // This function will load an image from a URL and resize it to 64dp
    suspend fun loadImageBitmap(imageUrl: String?): Bitmap? {
        // Convert 64dp to pixels based on device density
        val dp = context.resources.displayMetrics.density.toInt()

        return withContext(Dispatchers.IO) {
            if (imageUrl.isNullOrEmpty()) return@withContext null
            try {
                val url = URL(imageUrl)
                val connection = url.openConnection() as HttpURLConnection
                connection.doInput = true
                connection.connectTimeout = 3000
                connection.readTimeout = 3000
                connection.connect()
                connection.inputStream.use { inputStream ->
                    // Decode the bitmap from the input stream and resize it
                    val originalBitmap = BitmapFactory.decodeStream(inputStream)
                    originalBitmap?.let {
                        val targetSize = 64 * dp
                        val aspectRatio =
                            it.width.toFloat() / it.height.toFloat()
                        val (targetWidth, targetHeight) = if (aspectRatio > 1) {
                            targetSize to (targetSize / aspectRatio).toInt()
                        } else {
                            (targetSize * aspectRatio).toInt() to targetSize
                        }
                        Bitmap.createScaledBitmap(
                            it,
                            targetWidth,
                            targetHeight,
                            true
                        )
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
                null
            }
        }
    }

    // This function will update the RemoteViews with the data
    private suspend fun updateRemoteViews(
        team1Name: String,
        team1Score: Int,
        team2Name: String,
        team2Score: Int,
        timestamp: Long,
        team1ImageUrl: String?,
        team2ImageUrl: String?,
    ) {
        remoteViews.setTextViewText(R.id.team1_name, team1Name)
        remoteViews.setTextViewText(R.id.team2_name, team2Name)
        remoteViews.setTextViewText(R.id.score, "$team1Score : $team2Score")

        val elapsedRealtime = android.os.SystemClock.elapsedRealtime()
        val currentTimeMillis = System.currentTimeMillis()
        val base = elapsedRealtime - (currentTimeMillis - timestamp)

        remoteViews.setChronometer(R.id.match_time, base, null, true)

        val team1Image =
            if (!team1ImageUrl.isNullOrEmpty()) loadImageBitmap(
                team1ImageUrl
            ) else null
        val team2Image =
            if (!team2ImageUrl.isNullOrEmpty()) loadImageBitmap(
                team2ImageUrl
            ) else null

        team1Image?.let { image ->
            remoteViews.setImageViewBitmap(
                R.id.team1_image_placeholder,
                image,
            )
        }

        team2Image?.let { image ->
            remoteViews.setImageViewBitmap(
                R.id.team2_image_placeholder,
                image,
            )
        }
    }


    // This function will be called by the plugin to build the notification
    // [notification] is the Notification.Builder instance used by the plugin
    // [event] is the event type ("create" or "update")
    // [data] is the data passed to the plugin
    override suspend fun buildNotification(
        notification: Notification.Builder,
        event: String,
        data: Map<String, Any>
    ): Notification {
        val matchName = data["matchName"] as String
        val timestamp = data["matchStartDate"] as Long
        val team1Name = data["teamAName"] as String
        val team1Score = data["teamAScore"] as Int
        val team2Name = data["teamBName"] as String
        val team2Score = data["teamBScore"] as Int

        /// If the event is "update", skip images as previous notification already downloaded them
        val team1ImageUrl =
            if (event == "update") null else data["teamAImageUrl"] as String?
        val team2ImageUrl =
            if (event == "update") null else data["teamBImageUrl"] as String?

        updateRemoteViews(
            team1Name,
            team1Score,
            team2Name,
            team2Score,
            timestamp,
            team1ImageUrl,
            team2ImageUrl,
        )

        return notification
            .setSmallIcon(R.drawable.ic_notification)
            .setOngoing(true)
            .setContentTitle("$team1Name vs $team2Name")
            .setContentIntent(pendingIntent)
            .setContentText("$team1Score : $team2Score")
            .setStyle(Notification.DecoratedCustomViewStyle())
            .setCustomContentView(remoteViews) // Collapsed view
            .setCustomBigContentView(remoteViews) // Expanded view
            .setPriority(Notification.PRIORITY_LOW)
            .setCategory(Notification.CATEGORY_EVENT)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .build()
    }
}
```

`live_activity.xml` example:

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              android:orientation="vertical"
              android:layout_width="match_parent"
              android:layout_height="wrap_content"
              android:gravity="top|center_horizontal">

    <LinearLayout
            android:orientation="horizontal"
            android:gravity="top|center_horizontal"
            android:layout_width="match_parent"
            android:layout_height="wrap_content">

        <!-- Team 1 -->
        <LinearLayout
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:orientation="vertical"
                android:gravity="top|center_horizontal">

            <ImageView
                    android:id="@+id/team1_image_placeholder"
                    android:layout_width="64dp"
                    android:layout_height="64dp"
                    android:scaleType="centerCrop"
                    android:adjustViewBounds="true"/>

            <TextView
                    android:id="@+id/team1_name"
                    android:textColor="@color/text_primary"
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:text="Team 1"
                    android:textSize="10sp"
                    android:layout_marginTop="8dp"
                    android:ellipsize="end"
                    android:gravity="center"/>
        </LinearLayout>

        <!-- Score and Time -->
        <LinearLayout
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:orientation="vertical"
                android:gravity="top|center_horizontal"
                android:paddingStart="16dp"
                android:paddingEnd="16dp">

            <TextView
                    android:id="@+id/score"
                    android:textColor="@color/text_primary"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="0 : 0"
                    android:textSize="20sp"
                    android:textStyle="bold"/>

            <Chronometer
                    android:id="@+id/match_time"
                    android:textColor="@color/text_primary"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:textSize="14sp"
                    android:layout_marginTop="4dp"
                    android:format="%s"/>
        </LinearLayout>

        <!-- Team 2 -->
        <LinearLayout
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:orientation="vertical"
                android:gravity="top|center_horizontal">

            <ImageView
                    android:id="@+id/team2_image_placeholder"
                    android:layout_width="64dp"
                    android:layout_height="64dp"
                    android:scaleType="centerCrop"
                    android:adjustViewBounds="true"/>

            <TextView
                    android:id="@+id/team2_name"
                    android:textColor="@color/text_primary"
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:text="Team 2"
                    android:textSize="10sp"
                    android:layout_marginTop="8dp"
                    android:ellipsize="end"
                    android:gravity="center"/>
        </LinearLayout>
    </LinearLayout>
</LinearLayout>
```

- ## 💙 Flutter

  - Import the plugin.

  ```dart
  import 'package:live_activities/live_activities.dart';
  ```

  - Initialize the Plugin by passing the created **App Group Id** (created
    above).

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

  > You can pass all type of data you want but keep it mind it should be
  > compatible with [`UserDefaults`](https://developer.apple.com/documentation/foundation/userdefaults)
  > for iOS.

  <br />

## Access Flutter basic data from Native 🧵

- In your Swift extension, you need to create an `UserDefaults` instance to
  access data:

```swift
let sharedDefault = UserDefaults(suiteName: "YOUR_GROUP_ID")!
```

> ⚠️ Be sure to use the **SAME** group id in your Swift extension and your
> Flutter app!

- Access to your typed data:

```swift
let pizzaName = sharedDefault.string(forKey: context.attributes.prefixedKey("name"))! // put the same key as your Dart map
let pizzaPrice = sharedDefault.float(forKey: context.attributes.prefixedKey("price"))
let quantity = sharedDefault.integer(forKey: context.attributes.prefixedKey("quantity"))
// [...]
```

## Access Flutter files like pictures from Native 🧵

- In your map, send a `LiveActivityFileFromAsset`, `LiveActivityFileFromUrl` or
  `LiveActivityFileFromMemory` object:

You can use the factory `.image()` to use options like resizing image.

```dart

final Map<String, dynamic> activityModel = {
  'txtFile': LiveActivityFileFromAsset('assets/files/rules.txt'),
  'assetKey': LiveActivityFileFromAsset.image(
      'assets/images/pizza_chorizo.png'),
  'url': LiveActivityFileFromUrl.image(
      'https://cdn.pixabay.com/photo/2015/10/01/17/17/car-967387__480.png',
      imageOptions: LiveActivityImageFileOptions(
          resizeFactor: 0.2
      )
  ),
};

_liveActivitiesPlugin.createActivity
(
activityModel
);
```

ℹ️ Use `LiveActivityFileFromAsset` to load a file from your Flutter asset.

ℹ️ Use `LiveActivityFileFromUrl` to load a file from an external url.

ℹ️ Use `LiveActivityFileFromMemory` to load a file from the memory (from a
`Uint8List` object).

> ⚠️ File like picture need to be in a small resolution to be displayed in your
> live activity/dynamic island, you can use `resizeFactor` to automatically
> resize
> the image 👍.

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

In order to pass some useful **data** between your **native** live activity /
dynamic island with your **Flutter** app you just need to setup **URL scheme**.

> ⚠️ It's recommended to set a custom scheme, in this example, `la` is used but
> keep in mind, you should use a more personalized scheme.

> **ex:** for an app named `Strava`, you could use `str`.

- Add a custom url scheme in Xcode by navigating to **Runner** > **Runner** > \*
  \*URL Types** > **URL Schemes\*\*

<img alt="add url scheme xcode" src="https://raw.githubusercontent.com/istornz/live_activities/main/images/tutorial/url_scheme.webp" width="700px" />

- In your Swift code, just create a new **link** and open to your custom **URL
  Scheme**

```swift
Link(destination: URL(string: "la://my.app/order?=123")!) { // Replace "la" with your scheme
  Text("See order")
}
```

> ⚠️ Don't forget to put the **URL Scheme** you have typed in the **previous
> step**. (`str://` in the previous example)

- In your Flutter App, you need to init the custom scheme you provided before

```dart
_liveActivitiesPlugin.init(
  appGroupId: 'your.group.id', // replace here with your custom app group id
  urlScheme: 'str' // replace here with your custom app scheme
  requireNotificationPermission: true // if set to false, not request notification permission for iOS (default set to true)
);
```

- Finally, on the Flutter App too, you just need to listen on the **url scheme
  Scheme**

```dart
_liveActivitiesPlugin.urlSchemeStream().listen((schemeData) {
  // do what do you want here 🤗
});
```

## Update Live Activity with push notification 🎯

You can update live activity directly in your app using the `updateActivity()`
method, but if your app was killed or in the background, you can’t update the
notification...

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
  - Get directly the push token (not recommended, because the token may change
    in the future):
    ```dart
    final activityToken = await _liveActivitiesPlugin.getPushToken(_latestActivityId!);
    print(activityToken);
    ```
- Update your activity with the token on your server (more information can be [\*
  \*found here
  \*\*](https://ohdarling88.medium.com/update-dynamic-island-and-live-activity-with-push-notification-38779803c145)).

To set `matchName` for a specific notification, you just need to grab the
notification id you want (ex. `35253464632`) and concatenate with your key by
adding a `_`, example: `35253464632_matchName`.

That's it 😇

## Push-to-Start Live Activities (iOS 17.2+) 🚀

iOS 17.2 introduces the ability
to [create Live Activities remotely](https://developer.apple.com/documentation/activitykit/starting-and-updating-live-activities-with-activitykit-push-notifications#Start-new-Live-Activities-with-ActivityKit-push-notifications)
via push notifications before the user has even
opened your app. This is called "push-to-start" functionality.

However, we don't recommend to use this feature to manage Live Activities from
your server because, you will need to have on your server the live activity ID
and the user's pushToken.

We recommend to send a classic notification to yours users which invite them to
open your app. Then you can launch the live activity and send to your server the
necessary (activityID + PushToken).

- First, check if the device supports push-to-start:

```dart
final isPushToStartSupported = await _liveActivitiesPlugin.allowsPushStart();

if (isPushToStartSupported) {
  // Device supports push-to-start (iOS 17.2+)
}
```

- To use push-to-start, you need to listen for push-to-start tokens:

```dart
_liveActivitiesPlugin.pushToStartTokenUpdateStream.listen((String token) {
  // Send this token to your server
  print('Received push-to-start token: $token');

  // Your server can use this token to create a Live Activity
  // without the user having to open your app first
});
```

## Server Implementation

On your server, you'll need to send a push notification with the following
payload [structure](https://developer.apple.com/documentation/activitykit/starting-and-updating-live-activities-with-activitykit-push-notifications#Construct-the-payload-that-starts-a-Live-Activity):

FCM example payload :

```dart
{
  "token": "user_fcm_token",            // Replace with the user's FCM token
  "data": {                             // All fields inside data must be strings
    "timestamp": "1749113270446",       // Required, Must be in milliseconds since epoch
    "event": eventType,                 // Required, can be "start", "update" or "end"
    "content-state": JSON.stringify({   // Dynamic data to be passed to the Live Activity, must be stringified
    "activity-id": "live_activity_id",  // Required, it must be a String, you should use a something like match.id
    "teamAName": "Team A",
    "teamBName": "Team B",
    "teamAScore": 0,
    "teamBScore": 0,
    }),
  },
  "android": {
    "priority": "high"
  },
  "apns": {
    "live_activity_token": "user_push_token", // Replace with the user's Live Activity push token
    "headers": {
      "apns-priority": "10"
    },
    "payload": {
      "aps": {
        "timestamp": 1749113280,      // Required, Must be in seconds since epoch
        "dismissal-date": 1749113280  // Only for "end" event, must be in seconds since epoch
        "event": "start",             // Required, "start", "update", "end"
        "content-state": {            // Dynamic data to be passed to the Live Activity
          "teamAScore": 0,
          "teamBScore": 0,
        },
        "attributes-type": "AdventureAttributes",
        "attributes": {               // Static data to be passed to the Live Activity
          "teamAName": "Team A",
          "teamBName": "Team B",
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
          "sound": "chime.aiff"        // or "" to disable sound
        }
      }
    }
  }
}
```

The push notification should be sent to the push-to-start token you received
from the pushToStartTokenUpdateStream. Your
server needs to use Apple's APNs with the appropriate authentication to deliver
these notifications.

## 📘 Documentation

| Name                            | Description                                                                                                                                 | Returned value                                                                                             |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
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
| `.urlSchemeStream()`            | Subscription to handle every url scheme (ex: when the app is opened from a live activity / dynamic island button, you can pass data)        | `Future<UrlSchemeData>` Url scheme data which handle `scheme` `url` `host` `path` `queryItems`             |
| `.dispose()`                    | Remove all pictures passed in the AppGroups directory in the current session, you can use the `force` parameters to remove **all** pictures | `Future` Picture removed                                                                                   |
| `.activityUpdateStream`         | Get notified with a stream about live activity push token & status                                                                          | `Stream<ActivityUpdate>` Status updates for new push tokens or when the activity ends                      |
| `.pushToStartTokenUpdateStream` | Stream of push-to-start tokens for creating Live Activities remotely (iOS 17.2+)                                                            | `Stream<String>` Stream of tokens for push-to-start capability                                             |

<br />

## 🤔 Questions

### Do I have to code in Swift?

> Yes you need to implement your activity in Swift but no worries, there is a
> lot of cool tutorials:
>
> - [https://canopas.com/integrating-live-activity-and-dynamic-island-in-i-os-a-complete-guide](https://canopas.com/integrating-live-activity-and-dynamic-island-in-i-os-a-complete-guide)
> - [https://blorenzop.medium.com/live-activities-swift-6e95ee15863e](https://blorenzop.medium.com/live-activities-swift-6e95ee15863e)
> - [https://medium.com/kinandcartacreated/how-to-build-ios-live-activity-d1b2f238819e](https://medium.com/kinandcartacreated/how-to-build-ios-live-activity-d1b2f238819e)

### I have an issue when building my app on iOS:

`Error (Xcode): Cycle inside Runner; building could produce unreliable results.`

> This error occurs due to a build script ordering issue.
> Follow [this guide](https://stackoverflow.com/a/77178579/5078902) to resolve
> it.

### I can't see my live activity when I create it...

> It can be related to multiple issues, please be sure to:
>
> - App Groups Capability: Set up the `App Groups` capability for **BOTH** the

    `Runner` and your `extension` targets.

> - Same App Group: Use the **SAME** app group for both the `Runner` and

    `extension` targets.

> - Push Notification Capability: Verify that the `Push Notification` capability

    is enabled for the `Runner` target.

> - ActivityAttributes Definition: In your extension’s

    `ExtensionNameLiveActivity.swift` file, ensure you create an
    ActivityAttributes named **EXACTLY** `LiveActivitiesAppAttributes`.

> - Asset Size Limit: Images in live activities **must be under or equal 4 KB**.

    Use the resize factor argument to reduce image size if necessary.

> - Supports Live Activities: Be sure to set the `NSSupportsLiveActivities`

    property to `true` in `Info.plist` files for **BOTH** `Runner` and your
    `extension`.

> - iOS Version Requirement: The device must run **iOS 16.1 or later**.
> - Device Activity Check: Confirm that the `areActivitiesEnabled()` method

    returns true on your device.

> - Minimum Deployment Target: Confirm that the `extensions` deployment target

    is not set lower than your devices.

### Is Android supported?

> Yes but it's less mature than iOS for the moment. Android support is in beta.
>
> You can call `areActivitiesEnabled()` before creating your activity to ensure
> it can be displayed on the user's device. 😊

## 👥 Contributions

Contributions are welcome. Contribute by creating a PR or an issue 🎉.

## 🎯 Roadmap

- [ ] Inject a Widget inside the notification with Flutter Engine?
- [x] Android support.
- [x] Migrate to Swift Package Manager.
- [x] Support push token.
- [x] Pass media between extension & Flutter app.
- [x] Support multiple type instead of `String` (Date, Number etc.).
- [x] Pass data across native dynamic island and Flutter app.
- [x] Pass data across native live activity notification and Flutter app.
- [x] Cancel all activities.
- [x] Get all activities ids.
- [x] Check if live activities are supported.
