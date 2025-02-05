import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/audio_player_controller.dart';
import 'package:flutter_music_player/controller/music_player_screen_controller.dart';
import 'package:flutter_music_player/global_widgets/song_list_item.dart';
import 'package:provider/provider.dart';

class CurrentPlaylistListView extends StatelessWidget {
  CurrentPlaylistListView({
    super.key,
  });
  final pageBucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: pageBucket,
      child: Consumer<AudioPlayerController>(
        builder: (BuildContext context, AudioPlayerController value,
                Widget? child) =>
            ReorderableListView.builder(
          key: const PageStorageKey<String>(
            'pageOne',
          ), //  giving key to ListView Builder
          scrollController:
              context.read<MusicPlayerScreenController>().scrollController,
          itemBuilder: (context, index) {
            return Row(
              key: ValueKey(index),
              children: [
                const SizedBox(width: 15),
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
                Expanded(
                  child: SongListItem(
                    song: value.currentPlaylist[index],
                    onTap: () {
                      value.seekToIndex(index);
                    },
                    contentPadding: const EdgeInsets.only(
                      left: 15,
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Remove from queue'),
                          onTap: () {
                            value.removeItemFromQueue(
                              index,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          itemCount: value.currentPlaylist.length,
          onReorder: (int oldIndex, int newIndex) {
            value.reorderQueue(oldIndex, newIndex);
          },
        ),
      ),
    );
  }
}
