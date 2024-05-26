import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class TimerStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/timer.txt');
  }

  Future<int> readTimer() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If it was no data, return 60*3(3minutes)
      return 60 * 1;
    }
  }

  Future<File> writeTimer(int timer) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$timer');
  }
}