import 'dart:ffi';
import 'package:ffi_exp/avf_audio_bindings.dart';
import 'package:flutter/services.dart';
import 'package:objective_c/objective_c.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var fileData = await loadAsset('assets/test.mp3');
  var uint8Data = fileData.buffer.asUint8List();

  // Use .executable() to look for the AVFAudio library in the app's process
  // space.
  //
  // This works for AVFAudio on macOS and iOS.
  DynamicLibrary.executable();

  final player = AVAudioPlayer.alloc().initWithData(
    uint8Data.toNSData(),
    error: nullptr,
  );
  if (player == null) {
    throw ('AVAudioPlayer failed to initialize');
  }
  runApp(MainApp(player: player,));
}

class MainApp extends StatelessWidget {
  final AVAudioPlayer player;

  const MainApp({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              player.play();
            },
            child: Text('Play'),
          ),
        ),
      ),
    );
  }
}

Future<ByteData> loadAsset(String path) async {
  return await rootBundle.load(path);
}
