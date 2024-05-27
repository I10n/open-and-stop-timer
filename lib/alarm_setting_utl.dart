import 'dart:io';

import 'package:alarm/model/alarm_settings.dart';

class AlarmSettingsProvider{
  final int id;
  AlarmSettingsProvider({required this.id});

  AlarmSettings provide(DateTime dateTime) {
    return AlarmSettings(
      id: id,
      dateTime: dateTime,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationTitle: 'noodle timer flutter',
      notificationBody: 'Now is time to eat noodle',
      enableNotificationOnKill: Platform.isAndroid,
      // enableNotificationOnKill: true,
    );
  }
}

