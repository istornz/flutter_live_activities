import 'package:flutter_test/flutter_test.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities/live_activities_platform_interface.dart';
import 'package:live_activities/live_activities_method_channel.dart';
import 'package:live_activities/models/live_activity_state.dart';
import 'package:live_activities/models/url_scheme_data.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLiveActivitiesPlatform
    with MockPlatformInterfaceMixin
    implements LiveActivitiesPlatform {
  @override
  Future init(String appGroupId) {
    return Future.value();
  }
  
  @override
  Future<String?> createActivity(Map<String, dynamic> data) {
    return Future.value('ACTIVITY_ID');
  }

  @override
  Future endActivity(String activityId) {
    return Future.value();
  }

  @override
  Future updateActivity(String activityId, Map<String, dynamic> data) {
    return Future.value();
  }

  @override
  Future<bool> areActivitiesEnabled() {
    return Future.value(true);
  }

  @override
  Future endAllActivities() {
    return Future.value();
  }

  @override
  Future<List<String>> getAllActivitiesIds() {
    return Future.value(['ACTIVITY_ID']);
  }

  @override
  Stream<UrlSchemeData> urlSchemeStream() {
    return Stream.value(UrlSchemeData(
      url: 'URL',
      scheme: 'SCHEME',
      host: 'HOST',
      path: 'PATH',
      queryParameters: [
        {'name': 'NAME', 'value': 'VALUE'},
      ],
    ));
  }

  @override
  Future<LiveActivityState> getActivityState(String activityId) {
    return Future.value(LiveActivityState.active);
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

  test('init', () async {
    expect(await liveActivitiesPlugin.init(appGroupId: 'APP_GROUP_ID'), null);
  });

  test('endActivity', () async {
    expect(await liveActivitiesPlugin.endActivity('ACTIVITY_ID'), null);
  });

  test('updateActivity', () async {
    expect(await liveActivitiesPlugin.updateActivity('ACTIVITY_ID', {}), null);
  });

  test('endAllActivities', () async {
    expect(await liveActivitiesPlugin.endAllActivities(), null);
  });

  test('getAllActivities', () async {
    expect(await liveActivitiesPlugin.getAllActivitiesIds(), ['ACTIVITY_ID']);
  });

  test('areActivitiesEnabled', () async {
    expect(await liveActivitiesPlugin.areActivitiesEnabled(), true);
  });

  test('urlSchemeStream', () async {
    final result = await liveActivitiesPlugin.urlSchemeStream().first;
    expect(result.host, 'HOST');
    expect(result.path, 'PATH');
    expect(result.scheme, 'SCHEME');
    expect(result.url, 'URL');
    expect(result.queryParameters.first['name'], 'NAME');
    expect(result.queryParameters.first['value'], 'VALUE');
  });

  test('getActivityState', () async {
    expect(
      await liveActivitiesPlugin.getActivityState('ACTIVITY_ID'),
      LiveActivityState.active,
    );
  });
}
