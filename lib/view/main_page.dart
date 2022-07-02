import 'dart:async';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:voice_recorder/controller/audio_controller.dart';
import 'package:voice_recorder/view/sound_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isRecording = false;
  var record;
  Duration duration = const Duration();
  Timer? timer;

  void addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer() {
    timer!.cancel();
    duration = Duration();
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice Recorder"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Text(
            _printDuration(duration),
            style: const TextStyle(fontSize: 42),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  width: 60,
                ),
                isRecording
                    ? GestureDetector(
                        onTap: () async {
                          setState(() {
                            isRecording = !isRecording;
                            stopTimer();
                          });
                          AudioController().stopAudio(record);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.all(25),
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          setState(() {
                            isRecording = !isRecording;
                            startTimer();
                          });
                          record = await AudioController().recordAudio();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.all(25),
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SoundPage()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.folder,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
