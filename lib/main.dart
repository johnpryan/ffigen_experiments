import 'dart:ffi';

import 'package:ffi_exp/avf_audio_bindings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:objective_c/objective_c.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var fileData = await loadAsset('assets/test.mp3');
  var uint8Data = fileData.buffer.asUint8List();

  final player = AVAudioPlayer.alloc().initWithData(
    uint8Data.toNSData(),
    error: nullptr,
  );
  if (player == null) {
    throw ('AVAudioPlayer failed to initialize');
  }
  runApp(MainApp(player: player));
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
