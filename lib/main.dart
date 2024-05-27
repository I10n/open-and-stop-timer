import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noodle_timer_f/CONST.dart';
import 'package:noodle_timer_f/stop_alarm_if_device_lifted_up.dart';
import 'package:noodle_timer_f/storage.dart';
import 'package:noodle_timer_f/timer_display.dart';
import 'package:noodle_timer_f/timer_setting_display.dart';



import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

// import 'package:flutter_test/flutter_test.dart';

// void main() async {
//   test('completer', () async {
//     Completer completer = Completer();//2
//
//     List result = [];
//
//     // 1
//     Future.delayed(const Duration(seconds: 1)).then((value) {
//       result.add('delayed');
//       expect(completer.isCompleted, false);
//       completer.complete('delay finished');//3
//       expect(completer.isCompleted, true);
//     });
//
//     result.add('before future');
//     result.add(await completer.future); //4
//     result.add('after future');
//
//     expect(result.length, 4);
//     expect(result[0], 'before future');
//     expect(result[1], 'delayed');
//     expect(result[2], 'delay finished');
//     expect(result[3], 'after future');
//   });
// }


//TODO: use "complete" for get enough time to display timer 参考https://flutter.salon/dart/completer/
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
  );
  await Alarm.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // final TimerStorage timerStorage;
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            CountDownPage(
                timerStorage: TimerStorage(),
                onReset: () => Navigator.of(context).pushNamedAndRemoveUntil('/timer_setting',(_)=>false),
                onAlarmSet: (AlarmSettings settings) => Alarm.set(alarmSettings: settings),
                onRingAlarm: Alarm.ringStream.stream.listen((_) => stopAlarm_if_DeviceLiftedUp(() async => await Alarm.stop(ALARM_ID)))
            ),
        '/timer_setting': (context) =>
            TimerSettingPage(
                timerStorage: TimerStorage(),
                onStartTimer: () => Navigator.of(context).pushNamed('/'),
            )
      }
    );
  }
}

//Flutter Demo
// class FlutterDemo extends StatefulWidget {
//   const FlutterDemo({super.key, required this.storage});
//
//   final TimerStorage storage;
//
//   @override
//   State<FlutterDemo> createState() => _FlutterDemoState();
// }
//
// class _FlutterDemoState extends State<FlutterDemo> {
//   int _counter = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     widget.storage.readTimer().then((value) {
//       setState(() {
//         _counter = value;
//       });
//     });
//   }
//
//   Future<File> _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//
//     // Write the variable as a string to the file.
//     return widget.storage.writeTimer(_counter);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reading and Writing Files'),
//       ),
//       body: Center(
//         child: Text(
//           'Button tapped $_counter time${_counter == 1 ? '' : 's'}.',
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }