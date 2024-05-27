import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:noodle_timer_f/CONST.dart';
import 'package:noodle_timer_f/alarm_setting_utl.dart';
import 'package:noodle_timer_f/storage.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:async/async.dart';

class CountDownPage extends StatefulWidget {
  final TimerStorage timerStorage;
  final VoidCallback onReset;
  final void Function(AlarmSettings) onAlarmSet;
  final StreamSubscription<AlarmSettings> onRingAlarm;
  const CountDownPage({super.key, required this.timerStorage, required this.onReset, required this.onAlarmSet, required this.onRingAlarm});

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> {
  // final String concat = "null : null";

  static StreamSubscription<AlarmSettings>? subscription;
  final alarmSettingsProvider = AlarmSettingsProvider(id: ALARM_ID);
  late StopWatchTimer _stopWatchTimer;

  @override
  void initState() {
    super.initState();
    subscription ??= widget.onRingAlarm;
    // final concat = StreamZip([Alarm.ringStream.stream,userAccelerometerEventStream(samplingPeriod: SensorInterval.uiInterval)]);
    widget.timerStorage.readTimer().then((int duration) =>
        setState(() {
          widget.onAlarmSet(alarmSettingsProvider.provide(DateTime.now().add(Duration(seconds: duration))));
          _stopWatchTimer = StopWatchTimer(
              mode: StopWatchMode.countDown,
              presetMillisecond: 1000 * duration,
              onEnded: widget.onReset
          );
          _stopWatchTimer.onStartTimer();
        })
    );
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
              onPressed: widget.onReset,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}