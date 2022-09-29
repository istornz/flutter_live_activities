import 'package:flutter_test/flutter_test.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities/live_activities_platform_interface.dart';
import 'package:live_activities/live_activities_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLiveActivitiesPlatform
    with MockPlatformInterfaceMixin
    implements LiveActivitiesPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LiveActivitiesPlatform initialPlatform = LiveActivitiesPlatform.instance;

  test('$MethodChannelLiveActivities is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLiveActivities>());
  });

  test('getPlatformVersion', () async {
    LiveActivities liveActivitiesPlugin = LiveActivities();
    MockLiveActivitiesPlatform fakePlatform = MockLiveActivitiesPlatform();
    LiveActivitiesPlatform.instance = fakePlatform;

    expect(await liveActivitiesPlugin.getPlatformVersion(), '42');
  });
}
