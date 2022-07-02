import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlaySoundPage extends StatefulWidget {
  final String audio;
  const PlaySoundPage({Key? key, required this.audio}) : super(key: key);

  @override
  State<PlaySoundPage> createState() => _PlaySoundPageState();
}

class _PlaySoundPageState extends State<PlaySoundPage> {
  final player = AudioPlayer();
  Duration? currentPosition = Duration();
  double position = 0.0;
  Duration? duration;
  Duration stopWatch = Duration();
  Timer? timer;

  void startAudio() async {
    await player.play(DeviceFileSource(widget.audio));
    duration = await player.getDuration();
    player.onPositionChanged.listen(
      (Duration p) async {
        currentPosition = await player.getCurrentPosition();
        if (p.inSeconds == duration!.inSeconds) {
          player.pause();
          setState(() {});
        }
        if (mounted) {
          setState(() => {position = (p.inSeconds / duration!.inSeconds)});
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    startAudio();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void addTime() {
    setState(() {
      final seconds = stopWatch.inSeconds + 1;
      stopWatch = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    stopWatch = const Duration();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (player.state == PlayerState.playing) {
        addTime();
      }
    });
  }

  void stopTimer() {
    timer!.cancel();
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
        title: Text(widget.audio.split("/").last),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(),
          Column(
            children: [
              Text(
                _printDuration(currentPosition!),
                style: const TextStyle(fontSize: 42),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: LinearProgressIndicator(
                  value: position,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              if (player.state == PlayerState.playing) {
                player.pause();
              } else if (player.state == PlayerState.paused) {
                player.resume();
              }
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), offset: const Offset(1, 1))],
                borderRadius: BorderRadius.circular(100),
              ),
              child: player.state == PlayerState.playing ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
            ),
          )
        ],
      ),
    );
  }
}
