
import 'live_activities_platform_interface.dart';

class LiveActivities {
  Future createActivity(Map<String, String> data) async {
    return LiveActivitiesPlatform.instance.createActivity(data);
  }

  Future updateActivity() {
    return LiveActivitiesPlatform.instance.updateActivity();
  }

  Future endActivity() {
    return LiveActivitiesPlatform.instance.endActivity();
  }
}
