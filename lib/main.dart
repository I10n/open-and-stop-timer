import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noodle_timer_f/storage.dart';
import 'package:noodle_timer_f/count_down_page.dart';
import 'package:noodle_timer_f/timer_setting_page.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();//main() async と使うために必要
  SystemChrome.setPreferredOrientations(//デバイスの加速度計を使うために必要
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
  );
  await Alarm.init();//Alarm library を使うために必要
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  // This widget is the root of this app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Noodle Timer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/timer_ticking',
      routes: {
        '/timer_ticking': (context) =>
            CountDownPage(//タイマーの表示・バックグラウンドでの動作　を実行します
                timerStorage: TimerStorage(),
                onReset: () => Navigator.of(context).pushNamedAndRemoveUntil('/timer_setting',(_)=>false),
            ),
        '/timer_setting': (context) =>
            TimerSettingPage(//新たなタイマーの実行，タイマー時間設定，タイマー時間保存　を行う画面を表示します
                timerStorage: TimerStorage(),
                onStartTimer: () => Navigator.of(context).pushNamedAndRemoveUntil('/timer_ticking', (_)=>false),
            ),
      }
    );
  }
}