import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';

//デバイスが持ち上げられるような加速度を検知したときにonResetを実行するように，加速度を周期検知するようなStreamSubscriptionを返す関数
Future<StreamSubscription<UserAccelerometerEvent>> stopAlarm_if_DeviceLiftedUp(AlarmSettings alarmSettings, VoidCallback onReset) async{
  double yAccel = 0;

  //デバイス加速度を周期検知するStreamSubscription
  final subscription = userAccelerometerEventStream(
      samplingPeriod: SensorInterval.uiInterval).listen(
          (UserAccelerometerEvent event) async{
            yAccel = event.y;
            print(yAccel);
            // print(alarm_settings.id);

            if(yAccel.abs() > 1) {//持ち上げられるような加速度を検知したとき
              await Alarm.stop(alarmSettings.id).then((_) => onReset());
            }
          });
  return subscription;
}