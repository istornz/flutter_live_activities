import 'package:flutter_test/flutter_test.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities/live_activities_platform_interface.dart';
import 'package:live_activities/live_activities_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLiveActivitiesPlatform
    with MockPlatformInterfaceMixin
    implements LiveActivitiesPlatform {
  @override
  Future<String?> createActivity(Map<String, String> data) {
    return Future.value('ACTIVITY_ID');
  }

  @override
  Future endActivity(String activityId) {
    return Future.value();
  }

  @override
  Future updateActivity(String activityId, Map<String, String> data) {
    return Future.value();
  }
}

void main() {
  final LiveActivitiesPlatform initialPlatform =
      LiveActivitiesPlatform.instance;
  LiveActivities liveActivitiesPlugin = LiveActivities();
  MockLiveActivitiesPlatform fakePlatform = MockLiveActivitiesPlatform();
  LiveActivitiesPlatform.instance = fakePlatform;

  test('$MethodChannelLiveActivities is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLiveActivities>());
  });

  test('endActivity', () async {
    expect(await liveActivitiesPlugin.endActivity('ACTIVITY_ID'), null);
  });

  test('updateActivity', () async {
    expect(await liveActivitiesPlugin.updateActivity('ACTIVITY_ID', {}), null);
  });
}
