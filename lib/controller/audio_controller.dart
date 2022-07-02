import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioController {
  Future<dynamic> recordAudio() async {
    final record = Record();
    if (await record.hasPermission()) {
      final Directory directory = await getApplicationDocumentsDirectory();
      DateTime dateToday = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd HHmmss');
      await record.start(
        path: "${directory.path}/records/${formatter.format(dateToday)}.mp3",
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
      );
      return record;
    }
  }

  void stopAudio(Record recorder) async {
    await recorder.stop();
  }
}
