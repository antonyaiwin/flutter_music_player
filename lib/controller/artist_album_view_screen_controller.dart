// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/songs_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ArtistAlbumViewScreenController extends ChangeNotifier {
  final AlbumModel? album;
  final ArtistModel? artist;
  BuildContext context;
  List<SongModel> songList = [];

  ArtistAlbumViewScreenController({
    required this.context,
    this.album,
    this.artist,
  }) {
    _loadSongs();
    assert(
      album == null || artist == null,
      'Cannot provide both album and artist.',
    );
  }

  void _loadSongs() {
    songList = context.read<SongsController>().songs.where(
      (element) {
        if (artist != null) {
          return element.artistId == artist?.id;
        } else {
          return element.albumId == album?.id;
        }
      },
    ).toList();
    notifyListeners();
  }
}
