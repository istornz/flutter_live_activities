import 'package:live_activities/models/live_activity_image.dart';

class FootballGameLiveActivityModel {
  final DateTime? matchStartDate;
  final DateTime? matchEndDate;
  final String? matchName;

  final String? teamAName;
  final String? teamAState;
  final int? teamAScore;
  final LiveActivityImageFromAsset? teamALogo;

  final String? teamBName;
  final String? teamBState;
  final int? teamBScore;
  final LiveActivityImageFromAsset? teamBLogo;

  FootballGameLiveActivityModel({
    this.teamAName,
    this.matchName,
    this.teamAState,
    this.teamAScore = 0,
    this.teamBScore = 0,
    this.teamALogo,
    this.teamBName,
    this.teamBState,
    this.teamBLogo,
    this.matchEndDate,
    this.matchStartDate,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'matchName': matchName,
      'teamAName': teamAName,
      'teamAState': teamAState,
      'teamALogo': teamALogo,
      'teamAScore': teamAScore,
      'teamBScore': teamBScore,
      'teamBName': teamBName,
      'teamBState': teamBState,
      'teamBLogo': teamBLogo,
      'matchStartDate': matchStartDate?.millisecondsSinceEpoch,
      'matchEndDate': matchEndDate?.millisecondsSinceEpoch,
    };

    return map;
  }

  FootballGameLiveActivityModel copyWith({
    DateTime? matchStartDate,
    DateTime? matchEndDate,
    String? matchName,
    String? teamAName,
    String? teamAState,
    int? teamAScore,
    LiveActivityImageFromAsset? teamALogo,
    String? teamBName,
    String? teamBState,
    int? teamBScore,
    LiveActivityImageFromAsset? teamBLogo,
  }) {
    return FootballGameLiveActivityModel(
      matchStartDate: matchStartDate ?? this.matchStartDate,
      matchEndDate: matchEndDate ?? this.matchEndDate,
      matchName: matchName ?? this.matchName,
      teamAName: teamAName ?? this.teamAName,
      teamAState: teamAState ?? this.teamAState,
      teamAScore: teamAScore ?? this.teamAScore,
      teamALogo: teamALogo ?? this.teamALogo,
      teamBName: teamBName ?? this.teamBName,
      teamBState: teamBState ?? this.teamBState,
      teamBScore: teamBScore ?? this.teamBScore,
      teamBLogo: teamBLogo ?? this.teamBLogo,
    );
  }
}
