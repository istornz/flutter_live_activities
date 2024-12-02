import 'package:flutter/cupertino.dart';
import 'package:live_activities/models/live_activity_state.dart';

/// Abstract class to represent an activity update
abstract class ActivityUpdate {
  /// The id of the activity
  ActivityUpdate({required this.activityId});

  /// The id of the activity
  final String activityId;

  /// Factory to create an activity update from a map
  factory ActivityUpdate.fromMap(Map<String, dynamic> map) {
    final status = LiveActivityState.values.byName(map['status']);
    final activityId = map['activityId'] as String;
    switch (status) {
      case LiveActivityState.active:
        return ActiveActivityUpdate(
            activityId: activityId, activityToken: map['token'] as String);
      case LiveActivityState.ended:
      case LiveActivityState.dismissed:
        return EndedActivityUpdate(activityId: activityId);
      case LiveActivityState.stale:
        return StaleActivityUpdate(activityId: activityId);
      case LiveActivityState.unknown:
        return UnknownActivityUpdate(activityId: activityId);
    }
  }

  /// Map the activity update to a specific type
  TResult map<TResult extends Object?>({
    required TResult Function(ActiveActivityUpdate value) active,
    required TResult Function(EndedActivityUpdate value) ended,
    required TResult Function(StaleActivityUpdate value) stale,
    required TResult Function(UnknownActivityUpdate value) unknown,
  });

  /// Map the activity update to a specific type or return null
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

/// Class to represent an active activity update
class ActiveActivityUpdate extends ActivityUpdate {
  /// Constructor for an active activity update
  @visibleForTesting
  ActiveActivityUpdate({
    required super.activityId,
    required this.activityToken,
  });

  /// The token of the activity
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

/// Class to represent an ended activity update
class EndedActivityUpdate extends ActivityUpdate {
  /// Constructor for an ended activity update
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

/// Class to represent a stale activity update
class StaleActivityUpdate extends ActivityUpdate {
  /// Constructor for a stale activity update
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

/// Class to represent an unknown activity update
class UnknownActivityUpdate extends ActivityUpdate {
  /// Constructor for an unknown activity update
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
