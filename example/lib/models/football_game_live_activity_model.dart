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
    map.removeWhere((key, value) => value == null);

    return map;
  }
}
