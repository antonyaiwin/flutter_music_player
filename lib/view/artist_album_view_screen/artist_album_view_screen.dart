import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/artist_album_view_screen_controller.dart';
import 'package:flutter_music_player/global_widgets/song_list_item.dart';
import 'package:flutter_music_player/view/home_screen/widgets/music_player_widget.dart';
import 'package:provider/provider.dart';

import '../../controller/audio_player_controller.dart';
import '../../utils/functions/audio_more_functions.dart';

class ArtistAlbumViewScreen extends StatelessWidget {
  const ArtistAlbumViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<ArtistAlbumViewScreenController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(provider.album?.album ?? provider.artist?.artist ?? ''),
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
                  trailing: PopupMenuButton(
                    onSelected: (selectedIndex) => onPopupMenuItemClick(
                        context: context,
                        index: selectedIndex,
                        song: value.songList[index]),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 0, child: Text('Play next')),
                      const PopupMenuItem(
                          value: 1, child: Text('Add to queue')),
                      const PopupMenuItem(
                          value: 2, child: Text('Add to playlist')),
                    ],
                  ),
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
