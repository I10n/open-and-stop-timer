import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:sensors_plus/sensors_plus.dart';

//TODO if the value have changed rather than the previous execution (about UI(66ms) before), STOPTIMER
Future<void> stopAlarm_if_DeviceLiftedUp(AlarmSettings alarm_settings) async {
  double y_accel = 0;
  Stream<UserAccelerometerEvent>? _userAccelerometerEvent;
  //Calculate acceleration change
  final subscription = userAccelerometerEventStream(
      samplingPeriod: SensorInterval.uiInterval).listen(
          (UserAccelerometerEvent event) async{
            y_accel = event.y;
            // print(y_accel);
            print(alarm_settings.id);

            if(y_accel.abs() > 1) {
              await Alarm.stop(alarm_settings.id);
            }
          });

  // subscription.cancel();
  //if device listed up
  //  onStopRinging();
}