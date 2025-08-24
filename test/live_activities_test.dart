import 'package:flutter_test/flutter_test.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities/live_activities_platform_interface.dart';
import 'package:live_activities/live_activities_method_channel.dart';
import 'package:live_activities/models/activity_update.dart';
import 'package:live_activities/models/alert_config.dart';
import 'package:live_activities/models/live_activity_state.dart';
import 'package:live_activities/models/url_scheme_data.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLiveActivitiesPlatform
    with MockPlatformInterfaceMixin
    implements LiveActivitiesPlatform {
  @override
  Future init(String appGroupId, {String? urlScheme}) {
    return Future.value();
  }

  @override
  Future<String?> createActivity(
    String activityId,
    Map<String, dynamic> data, {
    bool removeWhenAppIsKilled = false,
    Duration? staleIn,
  }) {
    return Future.value('ACTIVITY_ID');
  }

  @override
  Future endActivity(String activityId) {
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

  @override
  Future<String> getPushToken(String activityId) {
    return Future.value('PUSH_TOKEN');
  }

  @override
  Future<String> getPushToStartToken() {
    return Future.value('PUSH_TO_START_TOKEN');
  }

  @override
  Stream<ActivityUpdate> get activityUpdateStream {
    final map = <String, dynamic>{
      'status': 'active',
      'activityId': 'ACTIVITY_ID',
      'token': 'ACTIVITY_TOKEN',
    };
    return Stream.value(ActivityUpdate.fromMap(map));
  }

  @override
  Future updateActivity(String activityId, Map<String, dynamic> data,
      [AlertConfig? alertConfig]) {
    return Future.value();
  }

  @override
  Future<Map<String, LiveActivityState>> getAllActivities() {
    return Future.value({'ACTIVITY_ID': LiveActivityState.active});
  }

  @override
  Future createOrUpdateActivity(
    String customId,
    Map<String, dynamic> data, {
    bool removeWhenAppIsKilled = false,
    Duration? staleIn,
  }) {
    return Future.value();
  }

  @override
  Future<bool> allowsPushStart() {
    return Future.value(true);
  }

  @override
  Stream<String> get pushToStartTokenUpdateStream {
    return Stream.value('PUSH_TO_START_TOKEN');
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

  test('getAllActivitiesIds', () async {
    expect(await liveActivitiesPlugin.getAllActivitiesIds(), ['ACTIVITY_ID']);
  });

  test('getAllActivities', () async {
    expect(await liveActivitiesPlugin.getAllActivities(), {
      'ACTIVITY_ID': LiveActivityState.active,
    });
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

  test('getPushToken', () async {
    expect(
      await liveActivitiesPlugin.getPushToken('PUSH_TOKEN'),
      'PUSH_TOKEN',
    );
  });

  test('getPushToStartToken', () async {
    expect(
      await liveActivitiesPlugin.getPushToStartToken(),
      'PUSH_TO_START_TOKEN',
    );
  });

  test('activityUpdateStream', () async {
    final result = await liveActivitiesPlugin.activityUpdateStream.first;
    expect(result.activityId, 'ACTIVITY_ID');
    expect(
      result.map<String>(
        active: (state) => state.activityToken,
        ended: (_) => 'WRONG_TOKEN',
        stale: (_) => 'WRONG_TOKEN',
        unknown: (_) => 'WRONG_TOKEN',
      ),
      'ACTIVITY_TOKEN',
    );
  });

  test('activityUpdateStreamMapOrNullCorrectMapping', () async {
    final result = await liveActivitiesPlugin.activityUpdateStream.first;
    final wrongMappingIsNull = result.mapOrNull(ended: (_) => 'NOT_NULL');

    expect(wrongMappingIsNull, null);

    final correctMappingNotNull =
        result.mapOrNull(active: (state) => state.activityToken);

    expect(correctMappingNotNull, 'ACTIVITY_TOKEN');
  });

  test('allowsPushStart', () async {
    expect(await liveActivitiesPlugin.allowsPushStart(), true);
  });

  test('pushToStartTokenUpdateStream', () async {
    expect(
      await liveActivitiesPlugin.pushToStartTokenUpdateStream.first,
      'PUSH_TO_START_TOKEN',
    );
  });
}
