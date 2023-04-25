import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities/models/live_activity_image.dart';
import 'package:live_activities/models/url_scheme_data.dart';
import 'package:live_activities_example/models/football_game_live_activity_model.dart';
import 'package:live_activities_example/widgets/score_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _liveActivitiesPlugin = LiveActivities();
  String? _latestActivityId;
  StreamSubscription<UrlSchemeData>? urlSchemeSubscription;
  FootballGameLiveActivityModel? _footballGameLiveActivityModel;

  int teamAScore = 0;
  int teamBScore = 0;

  String teamAName = 'PSG';
  String teamBName = 'Chelsea';

  @override
  void initState() {
    super.initState();

    _liveActivitiesPlugin.init(
      appGroupId: 'group.dimitridessus.liveactivities',
    );

    _liveActivitiesPlugin.activityUpdateStream.listen((event) {
      print('Activity update: $event');
    });

    urlSchemeSubscription =
        _liveActivitiesPlugin.urlSchemeStream().listen((schemeData) {
      setState(() {
        if (schemeData.path == '/stats') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Stats 📊'),
                content: Text(
                  'Now playing final world cup between $teamAName and $teamBName\n\n$teamAName score: $teamAScore\n$teamBName score: $teamBScore',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }

  @override
  void dispose() {
    urlSchemeSubscription?.cancel();
    _liveActivitiesPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Activities (Flutter)'),
        backgroundColor: Colors.green,
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_latestActivityId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Card(
                    child: SizedBox(
                      width: double.infinity,
                      height: 120,
                      child: Row(
                        children: [
                          Expanded(
                            child: ScoreWidget(
                              score: teamAScore,
                              teamName: teamAName,
                              onScoreChanged: (score) {
                                setState(() {
                                  teamAScore = score < 0 ? 0 : score;
                                });
                                _updateScore();
                              },
                            ),
                          ),
                          Expanded(
                            child: ScoreWidget(
                              score: teamBScore,
                              teamName: teamBName,
                              onScoreChanged: (score) {
                                setState(() {
                                  teamBScore = score < 0 ? 0 : score;
                                });
                                _updateScore();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (_latestActivityId == null)
                TextButton(
                  onPressed: () async {
                    _footballGameLiveActivityModel =
                        FootballGameLiveActivityModel(
                      matchName: 'World cup ⚽️',
                      teamAName: 'PSG',
                      teamAState: 'Home',
                      teamALogo:
                          LiveActivityImageFromAsset('assets/images/psg.png'),
                      teamBLogo: LiveActivityImageFromAsset(
                          'assets/images/chelsea.png'),
                      teamBName: 'Chelsea',
                      teamBState: 'Guest',
                      matchStartDate: DateTime.now(),
                      matchEndDate: DateTime.now().add(
                        const Duration(
                          minutes: 6,
                          seconds: 30,
                        ),
                      ),
                    );

                    final activityId =
                        await _liveActivitiesPlugin.createActivity(
                      _footballGameLiveActivityModel!.toMap(),
                    );
                    setState(() => _latestActivityId = activityId);
                  },
                  child: Column(
                    children: const [
                      Text('Start football match ⚽️'),
                      Text(
                        '(start a new live activity)',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              if (_latestActivityId == null)
                TextButton(
                  onPressed: () async {
                    final supported =
                        await _liveActivitiesPlugin.areActivitiesEnabled();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                            supported ? 'Supported' : 'Not supported',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Is live activities supported ? 🤔'),
                ),
              if (_latestActivityId != null)
                TextButton(
                  onPressed: () {
                    _liveActivitiesPlugin.endAllActivities();
                    _latestActivityId = null;
                    setState(() {});
                  },
                  child: Column(
                    children: const [
                      Text('Stop match ✋'),
                      Text(
                        '(end all live activities)',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future _updateScore() async {
    if (_footballGameLiveActivityModel == null) {
      return;
    }

    final data = _footballGameLiveActivityModel!.copyWith(
      teamAScore: teamAScore,
      teamBScore: teamBScore,
      // teamAName: null,
    );
    return _liveActivitiesPlugin.updateActivity(
      _latestActivityId!,
      data.toMap(),
    );
  }
}
