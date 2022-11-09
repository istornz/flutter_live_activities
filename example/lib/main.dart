import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities/models/url_scheme_data.dart';
import 'package:live_activities_example/models/pizza_live_activity_model.dart';

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
  List<String> _allActivitiesIds = [];
  UrlSchemeData? schemeData;
  StreamSubscription<UrlSchemeData>? urlSchemeSubscription;

  @override
  void initState() {
    super.initState();

    urlSchemeSubscription =
        _liveActivitiesPlugin.urlSchemeStream().listen((schemeData) {
      setState(() {
        this.schemeData = schemeData;
      });
    });
  }

  @override
  void dispose() {
    urlSchemeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Activities'),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (schemeData != null)
                Column(
                  children: [
                    Text('Url: ${schemeData!.url}'),
                    Text('Host: ${schemeData!.host}'),
                    Text('Path: ${schemeData!.path}'),
                    Text('Scheme: ${schemeData!.scheme}'),
                    Text(
                      'Params: ${schemeData!.queryParameters.map((e) => e["value"]).toList().join(',')}',
                    ),
                  ],
                ),
              ElevatedButton(
                onPressed: () async {
                  final activityModel = PizzaLiveActivityModel(
                    name: 'Margherita',
                    description: 'Tomato, mozzarella, basil',
                    quantity: 1,
                    price: 10.0,
                    deliverName: 'John Doe',
                    deliverDate: DateTime.now().add(
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
                  _allActivitiesIds = [];
                  setState(() {});
                },
                child: const Text(
                  'End all activities',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result =
                      await _liveActivitiesPlugin.areActivitiesEnabled();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Are activities enabled?'),
                        content: Text(result ? 'Yes' : 'No'),
                      );
                    },
                  );
                },
                child: const Text(
                  'Check if live activities are enabled',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final ids = await _liveActivitiesPlugin.getAllActivitiesIds();

                  setState(() {
                    _allActivitiesIds = ids;
                  });
                },
                child: const Text(
                  'Get all activities ids',
                  textAlign: TextAlign.center,
                ),
              ),
              if (_latestActivityId != null)
                ElevatedButton(
                  onPressed: () {
                    final activityModel = PizzaLiveActivityModel(
                      name: 'Romana',
                      description: 'Tomato, mozzarella, oregano',
                      quantity: 2,
                      price: 13.0,
                      deliverName: 'Maryline',
                      deliverDate: DateTime.now().add(
                        const Duration(
                          minutes: 14,
                        ),
                      ),
                    );

                    _liveActivitiesPlugin.updateActivity(
                        _latestActivityId!, activityModel.toMap());
                  },
                  child: Text(
                    'Update activity $_latestActivityId',
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_latestActivityId != null)
                ElevatedButton(
                  onPressed: () {
                    _liveActivitiesPlugin.endActivity(_latestActivityId!);
                  },
                  child: Text(
                    'End activity $_latestActivityId',
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: _allActivitiesIds.length,
                  itemBuilder: (context, index) {
                    final activityId = _allActivitiesIds[index];
                    return Text(activityId);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
