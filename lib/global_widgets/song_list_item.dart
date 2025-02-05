import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/audio_player_controller.dart';
import 'package:flutter_music_player/core/constants/color_constants.dart';
import 'package:flutter_music_player/utils/functions/audio_functions.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../core/constants/image_constants.dart';

class SongListItem extends StatelessWidget {
  const SongListItem({
    super.key,
    required this.song,
    this.onTap,
    this.contentPadding,
    this.trailing,
  });

  final SongModel song;
  final void Function()? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: QueryArtworkWidget(
        id: song.id,
        type: ArtworkType.AUDIO,
        artworkBorder: BorderRadius.circular(5),
        nullArtworkWidget: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            ImageConstants.musicBg,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        keepOldArtwork: true,
      ),
      title: Consumer<AudioPlayerController>(
        builder: (context, value, child) => Row(
          children: [
            Expanded(
              child: Text(
                song.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: value.currentSong?.id == song.id
                      ? ColorConstants.primaryColor
                      : null,
                ),
              ),
            ),
            if (value.currentSong?.id == song.id) ...[
              const SizedBox(width: 5),
              MiniMusicVisualizer(
                color: ColorConstants.primaryColor,
                width: 4,
                height: 15,
                radius: 4,
                animate: value.isPlaying,
              ),
            ]
          ],
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            song.artist ?? '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorConstants.primaryWhite.withOpacity(0.6),
                ),
          ),
          Text(
            song.duration != null
                ? getTimeFromDuration(Duration(milliseconds: song.duration!))
                : '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorConstants.primaryWhite.withOpacity(0.6),
                ),
          ),
        ],
      ),
      contentPadding: contentPadding,
      trailing: trailing,
    );
  }
}
