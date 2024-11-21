import 'package:flutter/material.dart';
import 'package:niramaya/notify_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  runApp(MyApp());
  tz.initializeTimeZones();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TrackerPage(),
    );
  }
}

DateTime scheduleTime = DateTime.now();

class TrackerPage extends StatefulWidget {
  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  final _medicationTimeController = TextEditingController();
  final _sleepTimeController = TextEditingController();
  final _wakeUpTimeController = TextEditingController();
  bool _isMedicationTaken = false;
  bool _isSlept = false;
  var medicationDateTime = DateTime.now();
  var sleepTime = DateTime.now();
  var wakeUpTime = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Health Monitor'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _medicationTimeController,
                decoration: InputDecoration(
                  labelText: 'Medication 1 Time',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (timeOfDay != null) {
                    setState(() {
                      _medicationTimeController.text =
                          '${timeOfDay.hour}:${timeOfDay.minute}';
                    });
                    medicationDateTime = DateTime.now().copyWith(
                      hour: timeOfDay.hour,
                      minute: timeOfDay.minute,
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _sleepTimeController,
                decoration: InputDecoration(
                  labelText: 'Sleep Time',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (timeOfDay != null) {
                    setState(() {
                      _sleepTimeController.text =
                          '${timeOfDay.hour}:${timeOfDay.minute}';
                    });
                    sleepTime = DateTime.now().copyWith(
                      hour: timeOfDay.hour,
                      minute: timeOfDay.minute,
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _wakeUpTimeController,
                decoration: InputDecoration(
                  labelText: 'Wake Up Time',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (timeOfDay != null) {
                    setState(() {
                      _wakeUpTimeController.text =
                          '${timeOfDay.hour}:${timeOfDay.minute}';
                    });
                    wakeUpTime = DateTime.now().copyWith(
                      hour: timeOfDay.hour,
                      minute: timeOfDay.minute,
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  debugPrint(_medicationTimeController.text);

                  print(medicationDateTime);

                  print(sleepTime);
                  debugPrint(_sleepTimeController.text);

                  print(wakeUpTime);
                  debugPrint(_wakeUpTimeController.text);
                },
                child: Text('Set Reminders'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isMedicationTaken = true;
                  });
                },
                child: Text('Medication Taken'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isSlept = true;
                  });
                },
                child: Text('Slept'),
              ),
              SizedBox(height: 20),
              Text(
                _isMedicationTaken
                    ? 'Medication taken'
                    : 'Medication not taken',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                _isSlept ? 'Slept' : 'Not slept',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        debugPrint('Notification Scheduled for $scheduleTime');
      },
    );
  }
}
