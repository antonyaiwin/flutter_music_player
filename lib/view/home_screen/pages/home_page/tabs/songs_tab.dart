import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../controller/audio_player_controller.dart';
import '../../../../../controller/home_screen_controller.dart';
import '../../../../../controller/songs_controller.dart';
import '../../../../../global_widgets/song_list_item.dart';
import '../../../../../utils/functions/audio_more_functions.dart';

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
          padding: const EdgeInsets.only(bottom: 200),
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
}
