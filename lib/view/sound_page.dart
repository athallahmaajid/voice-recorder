import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_recorder/view/play_sound_page.dart';

class SoundPage extends StatefulWidget {
  const SoundPage({Key? key}) : super(key: key);

  @override
  State<SoundPage> createState() => _SoundPageState();
}

class _SoundPageState extends State<SoundPage> {
  //Declare Globaly
  List files = [];
  @override
  void initState() {
    _listofFiles();
    super.initState();
  }

  void _listofFiles() async {
    Directory directory = await getApplicationDocumentsDirectory();
    setState(() {
      files = [];
      List rawFiles = Directory("${directory.path}/records/").listSync();
      for (var i = 0; i < rawFiles.length; i++) {
        files.add(rawFiles[i].path);
      }
      files.sort((b, a) => a.compareTo(b));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Records",
        ),
      ),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          String fileName = files[index].split("/").last;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.3), offset: const Offset(0, 2)),
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PlaySoundPage(audio: files[index])));
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.play_arrow),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(fileName),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    File file = File(files[index]);
                    await file.delete();
                    _listofFiles();
                  },
                  child: const Icon(Icons.delete),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
