import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

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
      leading: QueryArtworkWidget(
        id: artist.id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Image.asset(
          ImageConstants.musicBg,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(artist.artist),
    );
  }
}
