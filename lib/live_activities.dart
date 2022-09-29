
import 'live_activities_platform_interface.dart';

class LiveActivities {
  Future<String?> getPlatformVersion() {
    return LiveActivitiesPlatform.instance.getPlatformVersion();
  }
}
