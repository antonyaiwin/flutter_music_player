import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../core/constants/color_constants.dart';
import '../core/constants/image_constants.dart';

class PlaylistListItem extends StatelessWidget {
  const PlaylistListItem({
    super.key,
    required this.playlist,
    this.onTap,
  });

  final PlaylistModel playlist;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: QueryArtworkWidget(
          id: playlist.id,
          type: ArtworkType.PLAYLIST,
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
      title: Text(playlist.playlist),
      subtitle: Text(
        '${playlist.numOfSongs} song${playlist.numOfSongs > 1 ? 's' : ''}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorConstants.primaryWhite.withOpacity(0.6),
            ),
      ),
      trailing: const Icon(Iconsax.arrow_right_3_outline),
    );
  }
}
