import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/playlist_view_screen_controller.dart';
import 'package:flutter_music_player/controller/songs_controller.dart';
import 'package:flutter_music_player/global_widgets/playlist_list_item.dart';
import 'package:flutter_music_player/view/playlist_view_screen/playlist_view_screen.dart';
import 'package:provider/provider.dart';

import '../../../../global_widgets/add_playlist_bottom_sheet.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlayLists'),
      ),
      body: Consumer<SongsController>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (value.playlists.isEmpty) {
            return const Center(
              child: Text('No playlist found!'),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              var playlist = value.playlists[index];
              return PlaylistListItem(
                playlist: playlist,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => PlaylistViewScreenController(
                            context: context, playlist: playlist),
                        child: const PlaylistViewScreen(),
                      ),
                    ),
                  );
                },
              );
            },
            itemCount: value.playlists.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddPlaylistBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
