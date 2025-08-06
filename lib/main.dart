import 'dart:ffi';
import 'package:ffi_exp/avf_audio_bindings.dart';
import 'package:flutter/services.dart';
import 'package:objective_c/objective_c.dart';

import 'package:flutter/material.dart';

const _avfAudioDylibPath =
    '/System/Library/Frameworks/AVFAudio.framework/Versions/Current/AVFAudio';
const _foundationDylibPath =
    '/System/Library/Frameworks/Foundation.framework/Foundation';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var fileData = await loadAsset('assets/test.mp3');
  var uint8Data = fileData.buffer.asUint8List();
  DynamicLibrary.open(_avfAudioDylibPath);

  final player = AVAudioPlayer.alloc().initWithData(
    uint8Data.toNSData(),
    error: nullptr,
  );
  if (player == null) {
    throw ('AVAudioPlayer failed to initialize');
  }
  final durationSeconds = player.duration.ceil();
  print('$durationSeconds sec');
  final status = player.play();
  if (status) {
    print('Playing...');
    await Future<void>.delayed(Duration(seconds: durationSeconds));
  } else {
    print('Failed to play audio.');
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}

Future<ByteData> loadAsset(String path) async {
  return await rootBundle.load(path);
}
