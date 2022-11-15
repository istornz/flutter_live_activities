import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'live_activities_platform_interface.dart';

/// An implementation of [LiveActivitiesPlatform] that uses method channels.
class MethodChannelLiveActivities extends LiveActivitiesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('live_activities');

  @override
  Future<String?> createActivity(Map<String, String> data) async {
    return methodChannel.invokeMethod<String>('createActivity', {
      'data': data,
    });
  }

  @override
  Future updateActivity(String activityId, Map<String, String> data) async {
    return methodChannel.invokeMethod('updateActivity', {
      'activityId': activityId,
      'data': data,
    });
  }

  @override
  Future endActivity(String activityId) async {
    return methodChannel.invokeMethod('endActivity', {
      'activityId': activityId,
    });
  }
}
