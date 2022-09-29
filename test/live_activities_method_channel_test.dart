import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_activities/live_activities_method_channel.dart';

void main() {
  MethodChannelLiveActivities platform = MethodChannelLiveActivities();
  const MethodChannel channel = MethodChannel('live_activities');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'createActivity':
          return 'ACTIVITY_ID';
        default:
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('createActivity', () async {
    expect(await platform.createActivity({}), 'ACTIVITY_ID');
  });

  test('updateActivity', () async {
    expect(await platform.updateActivity('ACTIVITY_ID', {}), null);
  });

  test('endActivity', () async {
    expect(await platform.endActivity('ACTIVITY_ID'), null);
  });
}
