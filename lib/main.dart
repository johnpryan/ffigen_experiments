import 'dart:ffi';
import 'package:ffi_exp/avf_audio_bindings.dart';
import 'package:objective_c/objective_c.dart';

import 'package:flutter/material.dart';

const _dylibPath =
    '/System/Library/Frameworks/AVFAudio.framework/Versions/Current/AVFAudio';

void main() async {
  var args = ['test.mp3'];
  DynamicLibrary.open(_dylibPath);
  for (final file in args) {
    final fileStr = NSString(file);
    print('Loading $fileStr');
    final fileUrl = NSURL.fileURLWithPath(fileStr);
    final player = AVAudioPlayer.alloc().initWithContentsOfURL(
      fileUrl,
      error: nullptr,
    );
    if (player == null) {
      throw('AVAudioPlayer failed to initialize');
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
