//新たなタイマーの実行，タイマー時間設定，タイマー時間保存　を行う画面を実装する

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:flutter/material.dart';
import 'package:noodle_timer_f/storage.dart';

class TimerSettingPage extends StatefulWidget {
  final TimerStorage timerStorage;//タイマー時間の書き込み・読み出しを手伝う
  final VoidCallback onStartTimer;//タイマーの実行としての画面遷移トリガー

  const TimerSettingPage({super.key, required this.timerStorage, required this.onStartTimer});

  @override
  State<TimerSettingPage> createState() => _TimerSettingPageState();
}

class _TimerSettingPageState extends State<TimerSettingPage> {
  int _duration = 60 * 3;//タイマー時間(sec)
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  
  @override
  void initState() {
    super.initState();
    //保存してあるタイマー時間（初期: 3分）を読み出す
    widget.timerStorage.readTimer().then((int duration) =>
        setState(() {
          _duration = duration;
        }));
  }

  void durationSelect() async{
    //タイマー時間を保存する
    await widget.timerStorage.writeTimer((_valueNotifier.value~/10*60).toInt());
  }

  @override
  void dispose() async{
    durationSelect();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Setting '),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                  child: const Text("START"),
                  onPressed: () => {
                    widget.onStartTimer(),
                    durationSelect()
                  }
            ),
            const SizedBox(height: 20,),
            CircularSeekBar(
              minProgress: 10,
                width: double.infinity,
                height: 250,
                progress: _duration / 6,
                barWidth: 8,
                startAngle: 90,
                sweepAngle: 360,
                strokeCap: StrokeCap.butt,
                progressColor: Colors.yellow.shade300,
                innerThumbRadius: 5,
                innerThumbStrokeWidth: 3,
                innerThumbColor: Colors.white,
                outerThumbRadius: 5,
                outerThumbStrokeWidth: 10,
                outerThumbColor: Colors.red.shade400,
                animation: false,
              valueNotifier: _valueNotifier,
              onEnd: durationSelect,
              child: Center(
                child: ValueListenableBuilder(
                    valueListenable: _valueNotifier,
                    builder: (_, double value, __) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${value~/10}'),
                        const Text('minutes'),
                      ],
                    )
                ),)),
            const SizedBox(height: 20,),
            ElevatedButton(
                child: const Text("STOP Alarm"),
                onPressed: () async => {
                  for(AlarmSettings settings in Alarm.getAlarms()){
                    Alarm.stop(settings.id)
                  }
                }
            ),
          ]
        ),
      )
    );
  }
}