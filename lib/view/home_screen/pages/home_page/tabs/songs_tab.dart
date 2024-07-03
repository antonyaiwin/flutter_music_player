import 'package:flutter/material.dart';
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
          ),
          itemCount: songProvider.songs.length,
        );
      },
    );
  }
}
