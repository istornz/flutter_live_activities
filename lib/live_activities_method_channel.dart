import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:live_activities/live_activities_platform_interface.dart';
import 'package:live_activities/models/activity_update.dart';
import 'package:live_activities/models/alert_config.dart';
import 'package:live_activities/models/live_activity_state.dart';
import 'package:live_activities/models/url_scheme_data.dart';

/// An implementation of [LiveActivitiesPlatform] that uses method channels.
class MethodChannelLiveActivities extends LiveActivitiesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('live_activities');

  @visibleForTesting
  final activityStatusChannel =
      const EventChannel('live_activities/activity_status');

  @visibleForTesting
  final EventChannel urlSchemeChannel =
      const EventChannel('live_activities/url_scheme');

  @override
  Future init(String appGroupId, {String? urlScheme}) async {
    await methodChannel.invokeMethod('init', {
      'appGroupId': appGroupId,
      'urlScheme': urlScheme,
    });
  }

  @override
  Future<String?> createActivity(
    Map<String, dynamic> data, {
    bool removeWhenAppIsKilled = false,
    Duration? staleIn,
  }) async {
    // If the duration is less than 1 minute then pass a null value instead of using 0 minutes
    final staleInMinutes =
        (staleIn?.inMinutes ?? 0) >= 1 ? staleIn?.inMinutes : null;
    return methodChannel.invokeMethod<String>('createActivity', {
      'data': data,
      'removeWhenAppIsKilled': removeWhenAppIsKilled,
      'staleIn': staleInMinutes,
    });
  }

  @override
  Future updateActivity(String activityId, Map<String, dynamic> data,
      [AlertConfig? alertConfig]) async {
    return methodChannel.invokeMethod('updateActivity', {
      'activityId': activityId,
      'data': data,
      'alertConfig': alertConfig?.toMap()
    });
  }

  @override
  Future createOrUpdateActivity(
    String customId,
    Map<String, dynamic> data, {
    bool removeWhenAppIsKilled = false,
    Duration? staleIn,
  }) async {
    final staleInMinutes =
        (staleIn?.inMinutes ?? 0) >= 1 ? staleIn?.inMinutes : null;
    return methodChannel.invokeMethod('createOrUpdateActivity', {
      'customId': customId,
      'data': data,
      'removeWhenAppIsKilled': removeWhenAppIsKilled,
      'staleIn': staleInMinutes,
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
    final result =
        await methodChannel.invokeListMethod<String>('getAllActivitiesIds');
    return result ?? [];
  }

  @override
  Future<Map<String, LiveActivityState>> getAllActivities() async {
    final result =
        await methodChannel.invokeMapMethod<String, String>('getAllActivities');

    return result?.map((key, value) =>
            MapEntry(key, LiveActivityState.values.byName(value))) ??
        <String, LiveActivityState>{};
  }

  @override
  Future<bool> areActivitiesEnabled() async {
    if (!Platform.isIOS) {
      return false;
    }

    final result =
        await methodChannel.invokeMethod<bool>('areActivitiesEnabled');
    return result ?? false;
  }

  @override
  Stream<UrlSchemeData> urlSchemeStream() {
    return urlSchemeChannel.receiveBroadcastStream('urlSchemeStream').map(
          (dynamic event) =>
              UrlSchemeData.fromMap(Map<String, dynamic>.from(event)),
        );
  }

  @override
  Future<LiveActivityState?> getActivityState(String activityId) async {
    final result = await methodChannel.invokeMethod<String?>(
      'getActivityState',
      {
        'activityId': activityId,
      },
    );
    return result != null ? LiveActivityState.values.byName(result) : null;
  }

  @override
  Future<String?> getPushToken(String activityId) async {
    final result = await methodChannel.invokeMethod<String?>(
      'getPushToken',
      {
        'activityId': activityId,
      },
    );
    return result;
  }

  @override
  Stream<ActivityUpdate> get activityUpdateStream => activityStatusChannel
      .receiveBroadcastStream('activityUpdateStream')
      .distinct()
      .map((event) => ActivityUpdate.fromMap(Map<String, dynamic>.from(event)));
}
