import 'package:flutter/material.dart';
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
      leading: QueryArtworkWidget(
        id: song.id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Image.asset(
          ImageConstants.musicBg,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(song.title),
    );
  }
}
