import 'package:alarm/alarm.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:flutter/material.dart';
import 'package:noodle_timer_f/CONST.dart';
import 'package:noodle_timer_f/storage.dart';

class TimerSettingPage extends StatefulWidget {
  final TimerStorage timerStorage;
  final VoidCallback onStartTimer;

  const TimerSettingPage({super.key, required this.timerStorage, required this.onStartTimer});

  @override
  State<TimerSettingPage> createState() => _TimerSettingPageState();
}

class _TimerSettingPageState extends State<TimerSettingPage> {
  int time = 60 * 2;
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  
  @override
  void initState() {
    super.initState();
    widget.timerStorage.readTimer().then((int duration) =>
        setState(() {
          time = duration;
        }));
  }

  void durationSelect() async{
    // widget.timerStorage.writeTimer((duration.inSeconds * 60).toInt());
    widget.timerStorage.writeTimer(((_valueNotifier.value/10).toInt()*60).toInt());
  }

  @override
  void dispose() {
    //TODO dispose cannot wait for async durationSelect, dispose can await the function's execution?
    durationSelect();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Setting '),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                  child: Text("START"),
                  onPressed: () => {
                    widget.onStartTimer(),
                    durationSelect()
                  }
            ),
            SizedBox(height: 20,),
            CircularSeekBar(
              minProgress: 10,
                width: double.infinity,
                height: 250,
                progress: time / 6,
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
                        Text('${(value/10).toInt()}'),
                        Text('minutes'),
                      ],
                    )
                ),)),
            SizedBox(height: 20,),
            ElevatedButton(
                child: Text("STOP Alarm"),
                onPressed: () => Alarm.stop(ALARM_ID)
            ),
          
          ]
        ),
      )
    );
  }
}