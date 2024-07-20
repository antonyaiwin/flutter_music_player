import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/add_to_playlist_bottom_sheet_controller.dart';
import 'package:flutter_music_player/global_widgets/add_to_playlist_bottom_sheet_body.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../../../controller/audio_player_controller.dart';
import '../../../../../controller/home_screen_controller.dart';
import '../../../../../controller/songs_controller.dart';
import '../../../../../global_widgets/song_list_item.dart';

class SongsTab extends StatelessWidget {
  const SongsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeScreenController, SongsController>(
      builder: (context, home, songProvider, child) {
        if (songProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (songProvider.songs.isEmpty) {
          return const Center(
            child: Text('No music found'),
          );
        }
        return ListView.builder(
          itemBuilder: (context, index) => SongListItem(
            song: songProvider.songs[index],
            onTap: () {
              context
                  .read<AudioPlayerController>()
                  .onAudioTouch(index, songProvider.songs);
            },
            trailing: PopupMenuButton(
              onSelected: (value) => onPopupMenuItemClick(
                  context: context,
                  index: value,
                  song: songProvider.songs[index]),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 0, child: Text('Play next')),
                const PopupMenuItem(value: 1, child: Text('Add to queue')),
                const PopupMenuItem(value: 2, child: Text('Add to playlist')),
              ],
            ),
          ),
          itemCount: songProvider.songs.length,
        );
      },
    );
  }

  void onPopupMenuItemClick({
    required BuildContext context,
    required int index,
    required SongModel song,
  }) {
    log(song.displayName);
    switch (index) {
      case 0:
        context.read<AudioPlayerController>().addNextSongInQueue(song);
        break;
      case 1:
        context.read<AudioPlayerController>().addSongInQueue(song);
        break;
      case 2:
        showAddToPlaylistBottomSheet(context, song);
        break;
    }
  }

  void showAddToPlaylistBottomSheet(BuildContext context, SongModel song) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ChangeNotifierProvider(
        create: (BuildContext context) => AddToPlaylistBottomSheetController(
          context: context,
          song: song,
        ),
        child: const AddToPlaylistBottomSheetBody(),
      ),
    );
  }
}
