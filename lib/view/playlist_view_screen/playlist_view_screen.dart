import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/audio_player_controller.dart';
import 'package:flutter_music_player/controller/playlist_view_screen_controller.dart';
import 'package:flutter_music_player/core/constants/color_constants.dart';
import 'package:flutter_music_player/global_widgets/song_list_item.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_marquee/text_marquee.dart';

import '../../core/constants/image_constants.dart';

class PlaylistViewScreen extends StatelessWidget {
  const PlaylistViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<PlaylistViewScreenController>();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(child: Text('Edit name')),
                    const PopupMenuItem(child: Text('Delete playlist')),
                  ],
                ),
              ],
              expandedHeight: 350,
              flexibleSpace: FlexibleSpaceBar(
                background: QueryArtworkWidget(
                  id: provider.playlist.id,
                  type: ArtworkType.PLAYLIST,
                  artworkBorder: BorderRadius.circular(5),
                  artworkHeight: double.infinity,
                  artworkWidth: double.infinity,
                  nullArtworkWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      ImageConstants.musicBg,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  keepOldArtwork: true,
                ),
                expandedTitleScale: 1,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: TextMarquee(provider.playlist.playlist)),
                    IconButton.filled(
                      onPressed: provider.songList.isEmpty
                          ? null
                          : () {
                              context
                                  .read<AudioPlayerController>()
                                  .onAudioTouch(0, provider.songList);
                            },
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          ColorConstants.primaryBlue,
                        ),
                      ),
                      icon: const Icon(MingCute.play_fill),
                      color: ColorConstants.primaryWhite,
                    ),
                    const SizedBox(width: 55),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Consumer<PlaylistViewScreenController>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (value.songList.isEmpty) {
              return const Center(child: Text('No songs found'));
            }
            return ListView.builder(
              itemBuilder: (context, index) =>
                  SongListItem(song: value.songList[index]),
              itemCount: value.songList.length,
            );
          },
        ),
      ),
    );
  }
}
