import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../core/constants/image_constants.dart';

class AlbumListItem extends StatelessWidget {
  const AlbumListItem({
    super.key,
    required this.album,
    this.onTap,
  });

  final AlbumModel album;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: QueryArtworkWidget(
        id: album.id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Image.asset(
          ImageConstants.musicBg,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(album.album),
    );
  }
}
