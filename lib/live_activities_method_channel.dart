import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:live_activities/models/activity_update.dart';
import 'package:live_activities/models/live_activity_state.dart';
import 'package:live_activities/models/url_scheme_data.dart';

import 'live_activities_platform_interface.dart';

/// An implementation of [LiveActivitiesPlatform] that uses method channels.
class MethodChannelLiveActivities extends LiveActivitiesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('live_activities');

  @visibleForTesting
  final activityStatusChannel = const EventChannel('live_activities/token_channel');

  @visibleForTesting
  final EventChannel urlSchemeChannel = const EventChannel('live_activities/url_scheme');

  @override
  Future init(String appGroupId) async {
    await methodChannel.invokeMethod('init', {
      'appGroupId': appGroupId,
    });
  }

  @override
  Future<String?> createActivity(
    Map<String, dynamic> data, {
    bool removeWhenAppIsKilled = false,
  }) async {
    return methodChannel.invokeMethod<String>('createActivity', {
      'data': data,
      'removeWhenAppIsKilled': removeWhenAppIsKilled,
    });
  }

  @override
  Future updateActivity(String activityId, Map<String, dynamic> data) async {
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

  @override
  Future endAllActivities() async {
    return methodChannel.invokeMethod('endAllActivities');
  }

  @override
  Future<List<String>> getAllActivitiesIds() async {
    final result = await methodChannel.invokeListMethod<String>('getAllActivitiesIds');
    return result ?? [];
  }

  @override
  Future<bool> areActivitiesEnabled() async {
    final result = await methodChannel.invokeMethod<bool>('areActivitiesEnabled');
    return result ?? false;
  }

  @override
  Stream<UrlSchemeData> urlSchemeStream() {
    return urlSchemeChannel.receiveBroadcastStream('urlSchemeStream').map(
          (dynamic event) => UrlSchemeData.fromMap(Map<String, dynamic>.from(event)),
        );
  }

  @override
  Future<LiveActivityState> getActivityState(String activityId) async {
    final result = await methodChannel.invokeMethod<String>(
      'getActivityState',
      {
        'activityId': activityId,
      },
    );
    return LiveActivityState.values.byName(result ?? 'unknown');
  }

  @override
  Future<String> getPushToken(String activityId) async {
    final result = await methodChannel.invokeMethod<String>(
      'getPushToken',
      {
        'activityId': activityId,
      },
    );
    return result ?? '';
  }

  @override
  Stream<ActivityUpdate> get activityUpdateStream => activityStatusChannel
      .receiveBroadcastStream('activityUpdateStream')
      .distinct()
      .map((event) => ActivityUpdate.fromMap(Map<String, dynamic>.from(event)));
}
