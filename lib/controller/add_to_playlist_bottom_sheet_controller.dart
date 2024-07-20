import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/songs_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AddToPlaylistBottomSheetController extends ChangeNotifier {
  BuildContext context;
  SongModel song;
  AddToPlaylistBottomSheetController({
    required this.context,
    required this.song,
  });

  Future<void> onPlaylistTap(PlaylistModel playlist) async {
    if (await _addSongToPlaylist(playlist.id) && context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Song Added to ${playlist.playlist}'),
        ),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong!'),
        ),
      );
    }
  }

  Future<bool> _addSongToPlaylist(int playlistId) {
    return context.read<SongsController>().addSongToPlaylist(
          playlistId: playlistId,
          songId: song.id,
        );
  }
}
