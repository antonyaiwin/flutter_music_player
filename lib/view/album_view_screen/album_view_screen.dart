import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/album_view_screen_controller.dart';
import 'package:flutter_music_player/global_widgets/song_list_item.dart';
import 'package:flutter_music_player/view/home_screen/widgets/music_player_widget.dart';
import 'package:provider/provider.dart';

import '../../controller/audio_player_controller.dart';

class AlbumViewScreen extends StatelessWidget {
  const AlbumViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<ArtistAlbumViewScreenController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(provider.album?.album ?? ''),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ArtistAlbumViewScreenController>(
              builder: (BuildContext context, value, Widget? child) =>
                  ListView.builder(
                itemBuilder: (context, index) => SongListItem(
                  song: value.songList[index],
                  onTap: () => context
                      .read<AudioPlayerController>()
                      .onAudioTouch(index, value.songList),
                ),
                itemCount: value.songList.length,
              ),
            ),
          ),
          const MusicPlayerWidget(),
        ],
      ),
    );
  }
}
