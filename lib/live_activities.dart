import 'package:live_activities/models/activity_update.dart';
import 'package:live_activities/models/live_activity_state.dart';
import 'package:live_activities/models/url_scheme_data.dart';
import 'package:live_activities/services/app_groups_image_service.dart';

import 'live_activities_platform_interface.dart';

class LiveActivities {
  final AppGroupsImageService _appGroupsImageService = AppGroupsImageService();

  /// This is required to initialize the plugin.
  /// Create an App Group inside "Runner" target & "Extension" in Xcode.
  /// Be sure to set the *SAME* App Group in both targets.
  Future init({required String appGroupId}) {
    _appGroupsImageService.appGroupId = appGroupId;
    return LiveActivitiesPlatform.instance.init(appGroupId);
  }

  /// Create an iOS 16.1+ live activity.
  /// When the activity is created, an activity id is returned.
  /// Data is a map of key/value pairs that will be transmitted to your iOS extension widget.
  /// Image are limited by size, be sure to pass only small images (you can use ```resizeFactor```).
  Future<String?> createActivity(
    Map<String, dynamic> data, {
    bool removeWhenAppIsKilled = false,
  }) async {
    await _appGroupsImageService.sendImageToAppGroups(data);
    return LiveActivitiesPlatform.instance.createActivity(
      data,
      removeWhenAppIsKilled: removeWhenAppIsKilled,
    );
  }

  /// Update an iOS 16.1+ live activity.
  /// You can get an activity id by calling [createActivity].
  /// Data is a map of key/value pairs that will be transmitted to your iOS extension widget.
  /// Map is limited to String keys and values for now.
  Future updateActivity(String activityId, Map<String, dynamic> data) async {
    await _appGroupsImageService.sendImageToAppGroups(data);
    return LiveActivitiesPlatform.instance.updateActivity(activityId, data);
  }

  /// End an iOS 16.1+ live activity.
  /// You can get an activity id by calling [createActivity].
  Future endActivity(String activityId) {
    return LiveActivitiesPlatform.instance.endActivity(activityId);
  }

  /// Get the activity state.
  Future<LiveActivityState> getActivityState(String activityId) {
    return LiveActivitiesPlatform.instance.getActivityState(activityId);
  }

  /// Get the push token.
  Future<String> getPushToken(String activityId) {
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

  /// Check if iOS 16.1+ live activities are enabled.
  Future<bool> areActivitiesEnabled() async {
    return LiveActivitiesPlatform.instance.areActivitiesEnabled();
  }

  /// Get a stream of url scheme data.
  /// Don't forget to add **CFBundleURLSchemes** to your Info.plist file.
  /// Return a Future of [scheme] [url] [host] [path] and [queryParameters].
  Stream<UrlSchemeData> urlSchemeStream() {
    return LiveActivitiesPlatform.instance.urlSchemeStream();
  }

  /// Remove all files copied in app group directory.
  /// This is recommended after you send image, files are stored but never deleted.
  /// You can set force param to remove **ALL** images in app group directory.
  Future<void> dispose({bool force = false}) async {
    if (force) {
      return _appGroupsImageService.removeAllImages();
    } else {
      return _appGroupsImageService.removeImagesSession();
    }
  }

  Stream<ActivityUpdate> get activityUpdateStream => LiveActivitiesPlatform.instance.activityUpdateStream;
}
