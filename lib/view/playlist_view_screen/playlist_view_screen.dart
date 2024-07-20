import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/audio_player_controller.dart';
import 'package:flutter_music_player/controller/playlist_view_screen_controller.dart';
import 'package:flutter_music_player/core/constants/color_constants.dart';
import 'package:flutter_music_player/global_widgets/song_list_item.dart';
import 'package:flutter_music_player/view/home_screen/widgets/music_player_widget.dart';
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
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  actions: [
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 0, child: Text('Edit name')),
                        const PopupMenuItem(
                            value: 1, child: Text('Delete playlist')),
                      ],
                      onSelected: (value) => provider.onMenuItemClick(value),
                    ),
                  ],
                  expandedHeight: 350,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        QueryArtworkWidget(
                          id: provider.playlist.id,
                          type: ArtworkType.PLAYLIST,
                          quality: 100,
                          size: 500,
                          artworkBorder: BorderRadius.circular(5),
                          artworkHeight: double.infinity,
                          artworkWidth: double.infinity,
                          artworkQuality: FilterQuality.high,
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
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    expandedTitleScale: 1,
                    titlePadding: const EdgeInsets.only(
                      left: 70,
                      bottom: 3,
                      right: 55,
                    ),
                    title: Consumer<PlaylistViewScreenController>(
                      builder: (BuildContext context,
                              PlaylistViewScreenController value,
                              Widget? child) =>
                          Row(
                        children: [
                          Expanded(
                              child: TextMarquee(provider.playlist.playlist)),
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
                        ],
                      ),
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
                  itemBuilder: (context, index) => SongListItem(
                    song: value.songList[index],
                    onTap: () {
                      context
                          .read<AudioPlayerController>()
                          .onAudioTouch(index, value.songList);
                    },
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Remove from playlist'),
                          onTap: () {
                            provider
                                .removeSongFromPlaylist(value.songList[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                  itemCount: value.songList.length,
                );
              },
            ),
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: MusicPlayerWidget(),
          ),
        ],
      ),
    );
  }
}
