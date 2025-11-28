import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_activities/live_activities_method_channel.dart';

void main() {
  MethodChannelLiveActivities platform = MethodChannelLiveActivities();
  const MethodChannel channel = MethodChannel('live_activities');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    handler(MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'createActivity':
          return 'ACTIVITY_ID';
        case 'getAllActivitiesIds':
          return ['ACTIVITY_ID'];
        case 'getActivityState':
          return 'dismissed';
        default:
      }
      return null;
    }

    TestWidgetsFlutterBinding.ensureInitialized();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, handler);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('createActivity', () async {
    expect(await platform.createActivity('ACTIVITY_ID', {}), 'ACTIVITY_ID');
  });

  test('updateActivity', () async {
    expect(await platform.updateActivity('ACTIVITY_ID', {}), null);
  });

  test('endActivity', () async {
    expect(await platform.endActivity('ACTIVITY_ID'), null);
  });

  test('endAllActivities', () async {
    expect(await platform.endAllActivities(), null);
  });

  test('init', () async {
    expect(await platform.init('APP_GROUP_ID', urlScheme: 'URL_SCHEME'), null);
  });

  test('getAllActivities', () async {
    expect(await platform.getAllActivitiesIds(), ['ACTIVITY_ID']);
  });

  test('areActivitiesSupported', () async {
    expect(await platform.areActivitiesSupported(), false);
  });

  test('areActivitiesEnabled', () async {
    expect(await platform.areActivitiesEnabled(), false);
  });

  test('getActivityState', () async {
    expect(await platform.getActivityState('ACTIVITY_ID'), null);
  });
}
