import 'package:flutter/material.dart';
import 'package:flutter_music_player/core/constants/color_constants.dart';
import 'package:flutter_music_player/utils/functions/audio_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../core/constants/image_constants.dart';

class SongListItem extends StatelessWidget {
  const SongListItem({
    super.key,
    required this.song,
    this.onTap,
  });

  final SongModel song;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: QueryArtworkWidget(
          id: song.id,
          type: ArtworkType.AUDIO,
          artworkBorder: BorderRadius.zero,
          nullArtworkWidget: Image.asset(
            ImageConstants.musicBg,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            song.artist ?? '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorConstants.hintColor,
                ),
          ),
          Text(
            song.duration != null
                ? getTimeFromDuration(Duration(milliseconds: song.duration!))
                : '',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorConstants.hintColor,
                ),
          ),
        ],
      ),
    );
  }
}
