import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/add_to_playlist_bottom_sheet_controller.dart';
import 'package:flutter_music_player/controller/create_playlist_bottom_sheet_controller.dart';
import 'package:flutter_music_player/controller/songs_controller.dart';
import 'package:flutter_music_player/global_widgets/create_playlist_bottom_sheet.dart';
import 'package:provider/provider.dart';

class AddToPlaylistBottomSheetBody extends StatelessWidget {
  const AddToPlaylistBottomSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 30,
        ),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 34, 34, 34),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add to playlist',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Expanded(
              child: Consumer2<SongsController,
                  AddToPlaylistBottomSheetController>(
                builder:
                    (context, songsController, bottomSheetController, child) {
                  if (songsController.playlists.isEmpty) {
                    return const Center(child: Text('No Playlist Found'));
                  } else {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        var playlist = songsController.playlists[index];
                        return ListTile(
                          title: Text(
                            playlist.playlist,
                          ),
                          onTap: () async {
                            if (await _onPlaylistTap(songsController, index,
                                    bottomSheetController) &&
                                context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Song Added to ${playlist.playlist}'),
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
                          },
                        );
                      },
                      itemCount: songsController.playlists.length,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => ChangeNotifierProvider(
              create: (BuildContext context) =>
                  CreatePlaylistBottomSheetController(),
              child: const CreatePlaylistBottomSheet(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> _onPlaylistTap(SongsController songsController, int index,
      AddToPlaylistBottomSheetController bottomSheetController) {
    return songsController.addSongToPlaylist(
      playlistId: songsController.playlists[index].id,
      songId: bottomSheetController.song.id,
    );
  }
}
