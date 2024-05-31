//Utility for using Alarm library

import 'dart:io';

import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

//alarmSetting を一つ決定・保持します
class AlarmSettingsHelper{
  late AlarmSettings alarmSettings;
  Future<AlarmSettings> provide(DateTime dateTime) async{
    alarmSettings = AlarmSettings(
        id: DateTime.now().millisecondsSinceEpoch % 10000,
        dateTime: dateTime,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        volume: await FlutterVolumeController.getVolume(),
        notificationTitle: 'noodle timer flutter',
        notificationBody: 'Now is time to eat noodle',
        enableNotificationOnKill: Platform.isIOS
    );
    return alarmSettings;
  }
}