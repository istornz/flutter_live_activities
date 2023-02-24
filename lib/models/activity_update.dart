// ignore_for_file: library_private_types_in_public_api

import 'package:live_activities/models/live_activity_state.dart';

abstract class ActivityUpdate {
  ActivityUpdate({required this.activityId});

  final String activityId;

  factory ActivityUpdate.fromMap(Map<String, dynamic> map) {
    final status = LiveActivityState.values.byName(map['status']);
    final activityId = map['activityId'] as String;
    switch (status) {
      case LiveActivityState.active:
        return _ActiveActivityUpdate(
            activityId: activityId, activityToken: map['token'] as String);
      case LiveActivityState.ended:
      case LiveActivityState.dismissed:
        return _EndedActivityUpdate(activityId: activityId);
      case LiveActivityState.unknown:
        return _UnknownActivityUpdate(activityId: activityId);
    }
  }

  TResult map<TResult extends Object?>({
    required TResult Function(_ActiveActivityUpdate value) active,
    required TResult Function(_EndedActivityUpdate value) ended,
    required TResult Function(_UnknownActivityUpdate value) unknown,
  });

  @override
  String toString() {
    return '$runtimeType(activityId: $activityId)';
  }
}

class _ActiveActivityUpdate extends ActivityUpdate {
  _ActiveActivityUpdate(
      {required super.activityId, required this.activityToken});

  final String activityToken;

  @override
  map<TResult extends Object?>({
    required TResult Function(_ActiveActivityUpdate value) active,
    required TResult Function(_EndedActivityUpdate value) ended,
    required TResult Function(_UnknownActivityUpdate value) unknown,
  }) {
    return active(this);
  }

  @override
  String toString() {
    return '$runtimeType(activityId: $activityId, activityToken: $activityToken)';
  }
}

class _EndedActivityUpdate extends ActivityUpdate {
  _EndedActivityUpdate({required super.activityId});

  @override
  map<TResult extends Object?>({
    required TResult Function(_ActiveActivityUpdate value) active,
    required TResult Function(_EndedActivityUpdate value) ended,
    required TResult Function(_UnknownActivityUpdate value) unknown,
  }) {
    return ended(this);
  }
}

class _UnknownActivityUpdate extends ActivityUpdate {
  _UnknownActivityUpdate({required super.activityId});

  @override
  map<TResult extends Object?>({
    required TResult Function(_ActiveActivityUpdate value) active,
    required TResult Function(_EndedActivityUpdate value) ended,
    required TResult Function(_UnknownActivityUpdate value) unknown,
  }) {
    return unknown(this);
  }
}
