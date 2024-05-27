import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/widgets.dart';
import 'package:noodle_timer_f/CONST.dart';
import 'package:sensors_plus/sensors_plus.dart';

//TODO if the value have changed rather than the previous execution (about UI(66ms) before), STOPTIMER
void stopAlarm_if_DeviceLiftedUp(VoidCallback onStopTimer) {
  double y_accel = 0;
  Stream<UserAccelerometerEvent>? _userAccelerometerEvent;
  //Calculate acceleration change
  final subscription = userAccelerometerEventStream(
      samplingPeriod: SensorInterval.uiInterval).listen(
          (UserAccelerometerEvent event) async{
            y_accel = event.y;
            print(y_accel);

            if(y_accel.abs() > 1) {
              // await Alarm.stop(ALARM_ID);
              onStopTimer();
            }
          });

  // subscription.cancel();
  //if device listed up
  //  onStopRinging();
}