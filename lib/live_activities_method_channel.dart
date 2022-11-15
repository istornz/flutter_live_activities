import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'live_activities_platform_interface.dart';

/// An implementation of [LiveActivitiesPlatform] that uses method channels.
class MethodChannelLiveActivities extends LiveActivitiesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('live_activities');

  @override
  Future createActivity(Map<String, String> data) async {
    return methodChannel.invokeMethod('createActivity', {
      'data': data,
    });
  }

  @override
  Future updateActivity() async {
    return methodChannel.invokeMethod('updateActivity');
  }

  @override
  Future endActivity() async {
    return methodChannel.invokeMethod('endActivity');
  }
}
