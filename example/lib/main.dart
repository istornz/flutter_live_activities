import 'package:flutter/material.dart';
import 'package:live_activities/live_activities.dart';
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
  final _liveActivitiesPlugin = LiveActivities();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                final activityModel = PizzaLiveActivityModel(
                  name: 'Pizza',
                  description: 'Pizza description',
                  quantity: 1,
                  price: 10.0,
                  deliverName: 'John Doe',
                  deliverDate: DateTime.now().add(
                    const Duration(
                      hours: 1,
                      seconds: 30,
                    ),
                  ),
                );

                _liveActivitiesPlugin.createActivity(activityModel.toMap());
              },
              child: const Text('Create activity'),
            ),
            ElevatedButton(
              onPressed: () {
                _liveActivitiesPlugin.updateActivity();
              },
              child: const Text('Update activity'),
            ),
            ElevatedButton(
              onPressed: () {
                _liveActivitiesPlugin.endActivity();
              },
              child: const Text('End activity'),
            ),
          ],
        ),
      ),
    );
  }
}
