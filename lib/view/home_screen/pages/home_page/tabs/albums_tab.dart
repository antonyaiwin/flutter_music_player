import 'package:flutter/material.dart';
import 'package:flutter_music_player/global_widgets/album_list_item.dart';
import 'package:provider/provider.dart';

import '../../../../../controller/audio_player_controller.dart';
import '../../../../../controller/home_screen_controller.dart';
import '../../../../../controller/songs_controller.dart';

class AlbumsTab extends StatelessWidget {
  const AlbumsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeScreenController, SongsController>(
      builder: (context, home, songProvider, child) {
        if (songProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (songProvider.albums.isEmpty) {
          return const Center(
            child: Text('No Album found'),
          );
        }
        return ListView.builder(
          itemBuilder: (context, index) => AlbumListItem(
            album: songProvider.albums[index],
            onTap: () {
              context.read<AudioPlayerController>().onAudioTouch(
                    index,
                    songProvider.songs,
                  );
            },
          ),
          itemCount: songProvider.albums.length,
        );
      },
    );
  }
}
