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
          title: const Text('Live Activities'),
        ),
        body: Column(
          children: [
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
