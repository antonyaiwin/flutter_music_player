import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../core/constants/color_constants.dart';
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
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: QueryArtworkWidget(
          id: album.id,
          type: ArtworkType.ALBUM,
          artworkBorder: BorderRadius.zero,
          nullArtworkWidget: Image.asset(
            ImageConstants.musicBg,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          keepOldArtwork: true,
        ),
      ),
      title: Text(
        album.album,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${album.numOfSongs} song${album.numOfSongs > 1 ? 's' : ''} • ${album.artist ?? ''}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorConstants.primaryWhite.withOpacity(0.6),
            ),
      ),
    );
  }
}
