// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/songs_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlaylistViewScreenController extends ChangeNotifier {
  final PlaylistModel playlist;
  BuildContext context;
  bool isLoading = true;

  List<SongModel> songList = [];

  PlaylistViewScreenController({
    required this.context,
    required this.playlist,
  }) {
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    songList =
        await context.read<SongsController>().getSongsFromPlaylist(playlist.id);
    isLoading = false;
    notifyListeners();
  }
}
