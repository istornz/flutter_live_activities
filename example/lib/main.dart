import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities/models/live_activity_image.dart';
import 'package:live_activities/models/url_scheme_data.dart';
import 'package:live_activities_example/models/football_game_live_activity_model.dart';

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

  @override
  void initState() {
    super.initState();

    _liveActivitiesPlugin.init(
      appGroupId: 'group.dimitridessus.liveactivities',
    );

    urlSchemeSubscription =
        _liveActivitiesPlugin.urlSchemeStream().listen((schemeData) {
      setState(() {
        print(schemeData.host);
        print(schemeData.path);
        print(schemeData.queryParameters);
        print(schemeData.url);
        print(schemeData.scheme);
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
        title: const Text('Live Activities example'),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final activityModel = FootballGameLiveActivityModel(
                    matchName: 'World cup ⚽️',
                    teamAName: 'PSG',
                    teamAState: 'Home',
                    teamALogo:
                        LiveActivityImageFromAsset('assets/images/psg.png'),
                    teamBLogo:
                        LiveActivityImageFromAsset('assets/images/chelsea.png'),
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

                  _latestActivityId = await _liveActivitiesPlugin
                      .createActivity(activityModel.toMap());
                  setState(() {});
                },
                child: const Text('Create activity'),
              ),
              ElevatedButton(
                onPressed: () {
                  _liveActivitiesPlugin.endAllActivities();
                  _latestActivityId = null;
                  setState(() {});
                },
                child: const Text(
                  'End all activities',
                  textAlign: TextAlign.center,
                ),
              ),
              if (_latestActivityId != null)
                ElevatedButton(
                  onPressed: () {
                    final activityModel = FootballGameLiveActivityModel(
                      teamAScore: 3,
                      teamBScore: 1,
                    );

                    _liveActivitiesPlugin.updateActivity(
                      _latestActivityId!,
                      activityModel.toMap(),
                    );
                  },
                  child: Text(
                    'Update activity $_latestActivityId',
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
