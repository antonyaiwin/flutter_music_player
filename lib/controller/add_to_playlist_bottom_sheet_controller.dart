import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AddToPlaylistBottomSheetController extends ChangeNotifier {
  int? seletectedPlaylistId;
  BuildContext context;
  SongModel song;
  AddToPlaylistBottomSheetController({
    required this.context,
    required this.song,
  }) {}
}
