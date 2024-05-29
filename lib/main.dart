import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        // useMaterial3: false,
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>
            CountDownPage(
                timerStorage: TimerStorage(),
                onReset: () => Navigator.of(context).pushNamedAndRemoveUntil('/timer_setting',(_)=>false),
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