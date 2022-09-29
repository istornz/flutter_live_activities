
import 'live_activities_platform_interface.dart';

class LiveActivities {
  Future<String?> createActivity(Map<String, String> data) async {
    return LiveActivitiesPlatform.instance.createActivity(data);
  }

  Future updateActivity(String activityId, Map<String, String> data) {
    return LiveActivitiesPlatform.instance.updateActivity(activityId, data);
  }

  Future endActivity(String activityId) {
    return LiveActivitiesPlatform.instance.endActivity(activityId);
  }
}
