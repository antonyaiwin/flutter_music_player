import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioPlayerController extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();

  AudioPlayerController();

  Future<void> onAudioTouch(SongModel item) async {
    log(item.data);
    await player.setFilePath(item.data);
    await player.play();
  }
}
