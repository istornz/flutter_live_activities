import 'package:live_activities/live_activities_platform_interface.dart';
import 'package:live_activities/models/activity_update.dart';
import 'package:live_activities/models/alert_config.dart';
import 'package:live_activities/models/live_activity_state.dart';
import 'package:live_activities/models/url_scheme_data.dart';
import 'package:live_activities/services/app_groups_file_service.dart';

class LiveActivities {
  final AppGroupsFileService _appGroupsFileService = AppGroupsFileService();

  /// This is required to initialize the plugin.
  /// Create an App Group inside "Runner" target & "Extension" in Xcode.
  /// Be sure to set the *SAME* App Group in both targets.
  /// [urlScheme] is optional and is the scheme sub-component of the URL.
  /// [appGroupId] is the App Group identifier.
  Future init({required String appGroupId, String? urlScheme}) {
    _appGroupsFileService.init(appGroupId: appGroupId);
    return LiveActivitiesPlatform.instance.init(
      appGroupId,
      urlScheme: urlScheme,
    );
  }

  /// Create an iOS 16.1+ live activity.
  /// When the activity is created, an activity id is returned.
  /// Data is a map of key/value pairs that will be transmitted to your iOS extension widget.
  /// Files like images are limited by size,
  /// be sure to pass only small file size (you can use ```resizeFactor``` for images).
  ///
  /// [StaleIn] indicates if a StaleDate should be added to the activity. If the value is null or the Duration
  /// is less than 1 minute then no staleDate will be used. The parameter only affects the live activity on
  /// iOS 16.2+ and does nothing on on iOS 16.1
  Future<String?> createActivity(
    Map<String, dynamic> data, {
    bool removeWhenAppIsKilled = false,
    Duration? staleIn,
  }) async {
    await _appGroupsFileService.sendFilesToAppGroups(data);
    return LiveActivitiesPlatform.instance.createActivity(
      data,
      removeWhenAppIsKilled: removeWhenAppIsKilled,
      staleIn: staleIn,
    );
  }

  /// Update an iOS 16.1+ live activity.
  /// You can get an activity id by calling [createActivity].
  /// Data is a map of key/value pairs that will be transmitted to your iOS extension widget.
  /// Map is limited to String keys and values for now.
  Future updateActivity(String activityId, Map<String, dynamic> data,
      [AlertConfig? alertConfig]) async {
    await _appGroupsFileService.sendFilesToAppGroups(data);
    return LiveActivitiesPlatform.instance
        .updateActivity(activityId, data, alertConfig);
  }

  Future createOrUpdateActivity(
    String customId,
    Map<String, dynamic> data, {
    bool removeWhenAppIsKilled = false,
    Duration? staleIn,
  }) async {
    await _appGroupsFileService.sendFilesToAppGroups(data);
    return LiveActivitiesPlatform.instance.createOrUpdateActivity(
        customId, data,
        removeWhenAppIsKilled: removeWhenAppIsKilled, staleIn: staleIn);
  }

  /// End an iOS 16.1+ live activity.
  /// You can get an activity id by calling [createActivity].
  Future endActivity(String activityId) {
    return LiveActivitiesPlatform.instance.endActivity(activityId);
  }

  /// Get the activity state.
  /// If the activity is not found, `null` is returned.
  Future<LiveActivityState?> getActivityState(String activityId) {
    return LiveActivitiesPlatform.instance.getActivityState(activityId);
  }

  /// Get synchronously the push token.
  /// Prefer using the stream [activityUpdateStream] to keep push token up to date.
  Future<String?> getPushToken(String activityId) {
    return LiveActivitiesPlatform.instance.getPushToken(activityId);
  }

  /// Get all iOS 16.1+ live activity ids.
  /// You can get an activity id by calling [createActivity].
  Future<List<String>> getAllActivitiesIds() {
    return LiveActivitiesPlatform.instance.getAllActivitiesIds();
  }

  /// End all iOS 16.1+ live activities.
  Future endAllActivities() {
    return LiveActivitiesPlatform.instance.endAllActivities();
  }

  /// Get all iOS 16.1+ live activities and their state.
  Future<Map<String, LiveActivityState>> getAllActivities() {
    return LiveActivitiesPlatform.instance.getAllActivities();
  }

  /// Check if iOS 16.1+ live activities are enabled.
  Future<bool> areActivitiesEnabled() {
    return LiveActivitiesPlatform.instance.areActivitiesEnabled();
  }

  /// Checks if iOS 17.2+ which allows push start for live activities.
  Future<bool> allowsPushStart() {
    return LiveActivitiesPlatform.instance.allowsPushStart();
  }

  /// Get a stream of url scheme data.
  /// Don't forget to add **CFBundleURLSchemes** to your Info.plist file.
  /// Return a Future of [scheme] [url] [host] [path] and [queryParameters].
  Stream<UrlSchemeData> urlSchemeStream() {
    return LiveActivitiesPlatform.instance.urlSchemeStream();
  }

  /// Remove all files copied in app group directory.
  /// This is recommended after you send files, files are stored but never deleted.
  /// You can set force param to remove **ALL** files in app group directory.
  Future<void> dispose({bool force = false}) async {
    if (force) {
      return _appGroupsFileService.removeAllFiles();
    } else {
      return _appGroupsFileService.removeFilesSession();
    }
  }

  /// A stream of activity updates.
  /// An event is emitted onto this stream each time a pushTokenUpdate occurs. The operating system can decide
  /// to update a push token at any time. An update can also mean that the activity has ended or it became stale
  ///
  /// You can map out each type of update to respond to it
  ///
  /// ```dart
  /// activityUpdateStream.listen((event) => event.map(
  ///   active: (state) { ... },
  ///   ended: (state) { ... },
  ///   stale: (state) { ... },
  ///   unknown: (state) { ... },
  /// ))
  /// ```
  ///
  /// or if you only want to react to limited updates you can use mapOrNull
  ///
  /// ```dart
  /// activityUpdateStream.listen((event) => event.mapOrNull(
  ///   active: (state) { ... },
  /// ))
  /// ```
  Stream<ActivityUpdate> get activityUpdateStream =>
      LiveActivitiesPlatform.instance.activityUpdateStream;

  /// A stream of push-to-start tokens for iOS 17.2+ Live Activities.
  /// This stream emits tokens that can be used to start a Live Activity remotely via push notifications.
  ///
  /// When iOS generates or updates a push-to-start token, it will be emitted through this stream.
  /// You should send this token to your push notification server to enable remote Live Activity creation.
  ///
  /// Example usage:
  /// ```dart
  /// liveActivities.pushToStartTokenUpdateStream.listen((token) {
  ///   // Send token to your server
  ///   print('Received push-to-start token: $token');
  /// });
  /// ```
  ///
  /// This feature is only available on iOS 17.2 and later. Use [allowsPushStart] to check support.
  Stream<String> get pushToStartTokenUpdateStream async* {
    final allowed = await allowsPushStart();

    if (!allowed) {
      throw Exception('Push-to-start is not allowed on this device');
    }

    yield* LiveActivitiesPlatform.instance.pushToStartTokenUpdateStream;
  }
}
