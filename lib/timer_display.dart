import 'dart:async';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:noodle_timer_f/alarm.dart';
import 'package:noodle_timer_f/permissions.dart';
import 'package:noodle_timer_f/stop_alarm_if_device_lifted_up.dart';
import 'package:noodle_timer_f/storage.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:async/async.dart';

class CountDownPage extends StatefulWidget {
  final TimerStorage timerStorage;
  final VoidCallback onReset;
  const CountDownPage({super.key, required this.timerStorage, required this.onReset});

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> {
  late List<AlarmSettings> alarms;
  late int _duration;
  late DateTime _dateTime;
  static StreamSubscription<AlarmSettings>? subscription;
  final alarmSettingsProvider = AlarmSettingsProvider();
  late StopWatchTimer _stopWatchTimer;

  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    loadAlarms();
    // final concat = StreamZip([Alarm.ringStream.stream,userAccelerometerEventStream(samplingPeriod: SensorInterval.uiInterval)]);
    widget.timerStorage.readTimer().then((int duration) =>
        setState(() {
          _duration = duration;
          _dateTime = DateTime.now().add(Duration(seconds: _duration));
          _stopWatchTimer = StopWatchTimer(
              mode: StopWatchMode.countDown,
              presetMillisecond: 1000 * duration,
              onEnded: widget.onReset
          );
          _stopWatchTimer.onStartTimer();
        })
    ).then((_) async {
      subscription ??= Alarm.ringStream.stream.listen((AlarmSettings alarmSettings) => stopAlarm_if_DeviceLiftedUp(alarmSettings));
      loadAlarms();
      await setAlarm(alarmSettingsProvider.provide(_dateTime));
      loadAlarms();
      });
    }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stop Watch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snapshot) {
                final displayTime = StopWatchTimer.getDisplayTime(
                  snapshot.data!,
                );
                return Center(
                  child: SizedBox(
                    width: 144,
                    child: Text(
                      displayTime,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              // onPressed: widget.onReset,
              // onPressed: () async => await Alarm.stop(alarms[0].id).then((_) => {
              onPressed: () async => await Alarm.stop(42).then((_) => {
                for(AlarmSettings timer in alarms) print(timer.id)
              }),
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}