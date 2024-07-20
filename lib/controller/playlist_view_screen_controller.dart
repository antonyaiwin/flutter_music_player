// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/songs_controller.dart';
import 'package:flutter_music_player/global_widgets/create_playlist_bottom_sheet.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'create_playlist_bottom_sheet_controller.dart';

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

  void onMenuItemClick(int value) {
    switch (value) {
      case 0:
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => ChangeNotifierProvider(
            create: (BuildContext context) =>
                CreatePlaylistBottomSheetController(playlist: playlist),
            child: const CreatePlaylistBottomSheet(),
          ),
        );
        break;
      case 1:
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Delete'),
            content: Text('Are you sure to delete ${playlist.playlist}'),
            actions: [
              TextButton(
                onPressed: () async {
                  var deleted = await context
                      .read<SongsController>()
                      .deletePlaylist(playlistId: playlist.id);
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          deleted
                              ? 'Playlist deleted successfully'
                              : 'Something went wrong',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
            ],
          ),
        );

        break;
    }
  }

  Future<void> removeSongFromPlaylist(SongModel song) async {
    await context
        .read<SongsController>()
        .removeSongFromPlaylist(playlistId: playlist.id, songId: song.id);
    _loadSongs();
  }
}
