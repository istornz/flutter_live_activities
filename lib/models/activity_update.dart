import 'package:flutter/cupertino.dart';
import 'package:live_activities/models/live_activity_state.dart';

abstract class ActivityUpdate {
  ActivityUpdate({required this.activityId});

  final String activityId;

  factory ActivityUpdate.fromMap(Map<String, dynamic> map) {
    final status = LiveActivityState.values.byName(map['status']);
    final activityId = map['activityId'] as String;
    switch (status) {
      case LiveActivityState.active:
        return ActiveActivityUpdate(activityId: activityId, activityToken: map['token'] as String);
      case LiveActivityState.ended:
      case LiveActivityState.dismissed:
        return EndedActivityUpdate(activityId: activityId);
      case LiveActivityState.stale:
        return StaleActivityUpdate(activityId: activityId);
      case LiveActivityState.unknown:
        return UnknownActivityUpdate(activityId: activityId);
    }
  }

  TResult map<TResult extends Object?>({
    required TResult Function(ActiveActivityUpdate value) active,
    required TResult Function(EndedActivityUpdate value) ended,
    required TResult Function(StaleActivityUpdate value) stale,
    required TResult Function(UnknownActivityUpdate value) unknown,
  });

  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ActiveActivityUpdate value)? active,
    TResult Function(EndedActivityUpdate value)? ended,
    TResult Function(StaleActivityUpdate value)? stale,
    TResult Function(UnknownActivityUpdate value)? unknown,
  });

  @override
  String toString() {
    return '$runtimeType(activityId: $activityId)';
  }
}

class ActiveActivityUpdate extends ActivityUpdate {
  @visibleForTesting
  ActiveActivityUpdate({required super.activityId, required this.activityToken});

  final String activityToken;

  @override
  map<TResult extends Object?>({
    required TResult Function(ActiveActivityUpdate value) active,
    required TResult Function(EndedActivityUpdate value) ended,
    required TResult Function(StaleActivityUpdate value) stale,
    required TResult Function(UnknownActivityUpdate value) unknown,
  }) {
    return active(this);
  }

  @override
  String toString() {
    return '$runtimeType(activityId: $activityId, activityToken: $activityToken)';
  }

  @override
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ActiveActivityUpdate value)? active,
    TResult Function(EndedActivityUpdate value)? ended,
    TResult Function(StaleActivityUpdate value)? stale,
    TResult Function(UnknownActivityUpdate value)? unknown,
  }) {
    return active?.call(this);
  }
}

class EndedActivityUpdate extends ActivityUpdate {
  @visibleForTesting
  EndedActivityUpdate({required super.activityId});

  @override
  map<TResult extends Object?>({
    required TResult Function(ActiveActivityUpdate value) active,
    required TResult Function(EndedActivityUpdate value) ended,
    required TResult Function(StaleActivityUpdate value) stale,
    required TResult Function(UnknownActivityUpdate value) unknown,
  }) {
    return ended(this);
  }

  @override
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ActiveActivityUpdate value)? active,
    TResult Function(EndedActivityUpdate value)? ended,
    TResult Function(StaleActivityUpdate value)? stale,
    TResult Function(UnknownActivityUpdate value)? unknown,
  }) {
    return ended?.call(this);
  }
}

class StaleActivityUpdate extends ActivityUpdate {
  @visibleForTesting
  StaleActivityUpdate({required super.activityId});

  @override
  map<TResult extends Object?>({
    required TResult Function(ActiveActivityUpdate value) active,
    required TResult Function(EndedActivityUpdate value) ended,
    required TResult Function(StaleActivityUpdate value) stale,
    required TResult Function(UnknownActivityUpdate value) unknown,
  }) {
    return stale(this);
  }

  @override
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ActiveActivityUpdate value)? active,
    TResult Function(EndedActivityUpdate value)? ended,
    TResult Function(StaleActivityUpdate value)? stale,
    TResult Function(UnknownActivityUpdate value)? unknown,
  }) {
    return stale?.call(this);
  }
}

class UnknownActivityUpdate extends ActivityUpdate {
  @visibleForTesting
  UnknownActivityUpdate({required super.activityId});

  @override
  map<TResult extends Object?>({
    required TResult Function(ActiveActivityUpdate value) active,
    required TResult Function(EndedActivityUpdate value) ended,
    required TResult Function(StaleActivityUpdate value) stale,
    required TResult Function(UnknownActivityUpdate value) unknown,
  }) {
    return unknown(this);
  }

  @override
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ActiveActivityUpdate value)? active,
    TResult Function(EndedActivityUpdate value)? ended,
    TResult Function(StaleActivityUpdate value)? stale,
    TResult Function(UnknownActivityUpdate value)? unknown,
  }) {
    return unknown?.call(this);
  }
}
