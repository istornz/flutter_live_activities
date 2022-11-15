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
  String? _latestActivityId;

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
              onPressed: () async {
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

                _latestActivityId =
                    await _liveActivitiesPlugin.createActivity(activityModel.toMap());
                setState(() {});
              },
              child: const Text('Create activity'),
            ),
            if (_latestActivityId != null)
              ElevatedButton(
                onPressed: () {
                  final activityModel = PizzaLiveActivityModel(
                    name: 'Quiche',
                    description: 'Quiche description',
                    quantity: 76,
                    price: 23.0,
                    deliverName: 'Maryline',
                    deliverDate: DateTime.now().add(
                      const Duration(
                        seconds: 45,
                      ),
                    ),
                  );

                  _liveActivitiesPlugin.updateActivity(_latestActivityId!, activityModel.toMap());
                },
                child: Text('Update activity $_latestActivityId'),
              ),
            if (_latestActivityId != null)
            ElevatedButton(
              onPressed: () {
                _liveActivitiesPlugin.endActivity(_latestActivityId!);
              },
              child: Text('End activity $_latestActivityId'),
            ),
          ],
        ),
      ),
    );
  }
}
