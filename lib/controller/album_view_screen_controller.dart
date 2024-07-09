// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/songs_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AlbumViewScreenController extends ChangeNotifier {
  final AlbumModel album;
  BuildContext context;
  List<SongModel> songList = [];

  AlbumViewScreenController({
    required this.context,
    required this.album,
  }) {
    _loadSongs();
  }

  void _loadSongs() {
    songList = context
        .read<SongsController>()
        .songs
        .where(
          (element) => element.albumId == album.id,
        )
        .toList();
    notifyListeners();
  }
}
