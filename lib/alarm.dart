import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';

class AlarmSettingsProvider{
  late AlarmSettings alarmSettings;
  //
  // AlarmSettings provide(DateTime dateTime) {
  //   return AlarmSettings(
  //     id: id,
  //     dateTime: dateTime,
  //     assetAudioPath: 'assets/alarm.mp3',
  //     loopAudio: true,
  //     vibrate: true,
  //     volume: 0.8,
  //     fadeDuration: 3.0,
  //     notificationTitle: 'noodle timer flutter',
  //     notificationBody: 'Now is time to eat noodle',
  //     enableNotificationOnKill: Platform.isIOS
  //     // enableNotificationOnKill: true,
  //   );
  // }

  AlarmSettings provide(DateTime dateTime) {
    alarmSettings = AlarmSettings(
        id: DateTime.now().millisecondsSinceEpoch % 10000,
        dateTime: dateTime,
        assetAudioPath: 'assets/alarm.mp3',
        // loopAudio: true,
        // vibrate: true,
        volume: 0.8,
        // fadeDuration: 3.0,
        notificationTitle: 'noodle timer flutter',
        notificationBody: 'Now is time to eat noodle',
        enableNotificationOnKill: Platform.isIOS
      // enableNotificationOnKill: true,
    );
    return alarmSettings;
  }
}


Future<void> setAlarm(AlarmSettings alarmSettings) async{
  await Alarm.set(alarmSettings: alarmSettings).then((value) => print(alarmSettings.id));
}