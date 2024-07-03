import 'package:flutter/material.dart';
import 'package:flutter_music_player/global_widgets/genre_list_item.dart';
import 'package:provider/provider.dart';

import '../../../../../controller/audio_player_controller.dart';
import '../../../../../controller/home_screen_controller.dart';
import '../../../../../controller/songs_controller.dart';

class GenresTab extends StatelessWidget {
  const GenresTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeScreenController, SongsController>(
      builder: (context, home, songProvider, child) {
        if (songProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (songProvider.genres.isEmpty) {
          return const Center(
            child: Text('No Genres found'),
          );
        }
        return ListView.builder(
          itemBuilder: (context, index) => GenreListItem(
            genre: songProvider.genres[index],
            onTap: () {
              context
                  .read<AudioPlayerController>()
                  .onAudioTouch(index, songProvider.songs);
            },
          ),
          itemCount: songProvider.genres.length,
        );
      },
    );
  }
}
