import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_recorder/view/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Directory directory = await getApplicationDocumentsDirectory();
  if (!Directory('${directory.path}/records/').existsSync()) {
    Directory('${directory.path}/records/').createSync();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
