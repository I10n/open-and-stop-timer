//タイマーの表示・バックグラウンドでの動作　を実現する
//タイマーについて，
//  画面に表示するものをStopWatchTimer
//  バックグラウンドで実行・音を鳴らすものをAlarm　　と呼ぶ

import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:noodle_timer_f/alarm.dart';
import 'package:noodle_timer_f/permissions.dart';
import 'package:noodle_timer_f/stop_alarm_if_device_lifted_up.dart';
import 'package:noodle_timer_f/storage.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CountDownPage extends StatefulWidget {
  final TimerStorage timerStorage;//タイマー時間の保存を手伝うもの
  final VoidCallback onReset;//タイマーがResetされた際の画面遷移トリガー
  const CountDownPage({super.key, required this.timerStorage, required this.onReset});

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

const int LOADING = 3;//読み込み画面の表示時間
class _CountDownPageState extends State<CountDownPage> {
  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: LOADING),
        () => 'Data Loaded',
  );
  late List<AlarmSettings> alarms; //予定したAlarm（実際に操作するAlarmは一つだけ））
  late DateTime _dateTime; //StopWatchTimer終了・Alarmが鳴る 時刻
  static StreamSubscription<
      AlarmSettings>? subscription; //Alarmの鳴動時に生まれるStreamSubscription
  static StreamSubscription<
      UserAccelerometerEvent>? usubscription; //上のsubscription内で定義した定期加速度取得のため生まれるStreamSubscription
  final alarmSettingsHelper = AlarmSettingsHelper(); //AlarmSettingsの初期化を簡略にする
  late StopWatchTimer _stopWatchTimer; //予定したStopWatchTimer

  @override
  void initState() {
    super.initState();
    if (Alarm.android) { //Androidの権限リクエストする
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    // loadAlarms();

    //保存してあるタイマー時間（初期: 3分）を読み出す
    widget.timerStorage.readTimer()
        .then((int duration) =>
        setState(() {
          //タイマーの完了時刻を設定
          _dateTime = DateTime.now().add(Duration(seconds: duration - LOADING));
          //画面に表示するStopWatchTimerを設定
          _stopWatchTimer = StopWatchTimer(
            mode: StopWatchMode.countDown,
            presetMillisecond: 1000 * _dateTime
                .difference(DateTime.now())
                .inSeconds,
          );
          _stopWatchTimer.onStartTimer();
        })
    ).then((_) async { //Alarmが鳴った際の処理 TODO:２回目以降アラームが鳴った際の処理が動かない
      // Alarmの鳴りを停止できるStreamSubscriptionを初期化
      subscription ??=
          Alarm.ringStream.stream.listen((AlarmSettings alarmSettings) {
            //Alarmが鳴った際，加速度を感知すると{Alarm鳴りを停止, 画面遷移を行う}
            stopAlarm_if_DeviceLiftedUp(alarmSettings, prepareForDispose).then((
                StreamSubscription<
                    UserAccelerometerEvent> streamSubscription) async =>
            {
              //加速度を周期感知するStreamSubscriptionを初期化
              usubscription ??= streamSubscription,
            }
            );
          });
      //Alarmを予約する
      Alarm.set(alarmSettings: await alarmSettingsHelper.provide(_dateTime));
      loadAlarms();
    });
  }

  void loadAlarms() {
    alarms = Alarm.getAlarms();
    alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
  }

  void deleteStreams() {
    //各Streamの処理を終了する
    setState(() {
      usubscription?.cancel();
      subscription?.cancel();
    });
    loadAlarms();
  }

  void prepareForDispose() {
    deleteStreams();
    widget.onReset();
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    deleteStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: Theme
            .of(context)
            .textTheme
            .bodyLarge!,
        textAlign: TextAlign.center,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Ticking...'),
          ),
          body: Center(
            child: FutureBuilder<String>(
              future: _calculation,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                Widget child;
                if (snapshot.hasData) { //画面ロード完了時処理
                  child = Column(
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
                        onPressed: () async =>
                        {
                          for(AlarmSettings settings in Alarm.getAlarms()){
                            Alarm.stop(settings.id)
                          }
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) { // エラーが発生した場合の処理
                  child = ListView(
                      children: <Widget>[
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Error: ${snapshot.error}'),
                        ),
                      ]);
                } else { // 画面ロード中処理
                  child = const Center(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text('アラーム'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('が'),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text('開始されます'),
                            ),
                          ]));
                }
                return child;
              },
            ),
          ),
        )
    );
  }
}