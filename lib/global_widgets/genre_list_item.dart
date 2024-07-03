import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../core/constants/image_constants.dart';

class GenreListItem extends StatelessWidget {
  const GenreListItem({
    super.key,
    required this.genre,
    this.onTap,
  });

  final GenreModel genre;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: QueryArtworkWidget(
        id: genre.id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Image.asset(
          ImageConstants.musicBg,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(genre.genre),
    );
  }
}
