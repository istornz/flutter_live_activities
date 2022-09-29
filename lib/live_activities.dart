
import 'live_activities_platform_interface.dart';

class LiveActivities {
  /// Create an iOS 16.1+ live activity.
  /// When the activity is created, an activity id is returned.
  /// Data is a map of key/value pairs that will be transmitted to your iOS extension widget.
  /// Map is limited to String keys and values for now.
  Future<String?> createActivity(Map<String, String> data) async {
    return LiveActivitiesPlatform.instance.createActivity(data);
  }

  /// Update an iOS 16.1+ live activity.
  /// You can get an activity id by calling [createActivity].
  /// Data is a map of key/value pairs that will be transmitted to your iOS extension widget.
  /// Map is limited to String keys and values for now.
  Future updateActivity(String activityId, Map<String, String> data) {
    return LiveActivitiesPlatform.instance.updateActivity(activityId, data);
  }

  /// End an iOS 16.1+ live activity.
  /// You can get an activity id by calling [createActivity].
  Future endActivity(String activityId) {
    return LiveActivitiesPlatform.instance.endActivity(activityId);
  }
}
