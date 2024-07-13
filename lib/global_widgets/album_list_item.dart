import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../controller/songs_controller.dart';
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
        child: FutureBuilder(
          future: getFirstSongIdWithAlbumnId(album.id, context),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Image.asset(
                ImageConstants.musicBg,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              );
            }
            return QueryArtworkWidget(
              id: snapshot.data!,
              type: ArtworkType.AUDIO,
              artworkBorder: BorderRadius.zero,
              nullArtworkWidget: Image.asset(
                ImageConstants.musicBg,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              keepOldArtwork: true,
            );
          },
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

  Future<int?> getFirstSongIdWithAlbumnId(int id, BuildContext context) async {
    var list = context.read<SongsController>().songs.where(
      (element) {
        return element.albumId == id;
      },
    );
    if (list.isNotEmpty) {
      for (var element in list) {
        var image =
            await context.read<SongsController>().getSongImage(element.id);
        if (image != null) {
          return element.id;
        }
      }
    }
    return null;
  }
}
