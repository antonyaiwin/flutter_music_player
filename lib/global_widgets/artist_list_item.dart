import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../core/constants/color_constants.dart';
import '../core/constants/image_constants.dart';

class ArtistListItem extends StatelessWidget {
  const ArtistListItem({
    super.key,
    required this.artist,
    this.onTap,
  });

  final ArtistModel artist;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: QueryArtworkWidget(
          id: artist.id,
          type: ArtworkType.ARTIST,
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
      title: Text(artist.artist),
      subtitle: Text(
        artist.numberOfTracks != null
            ? '${artist.numberOfTracks} song${artist.numberOfTracks! > 1 ? 's' : ''}'
            : '',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorConstants.primaryWhite.withOpacity(0.6),
            ),
      ),
    );
  }
}
