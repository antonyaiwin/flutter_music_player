import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/songs_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

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
        child: FutureBuilder(
          future: getFirstSongWithArtistId(artist.id, context),
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
      title: Text(artist.artist),
      subtitle: Text(
        artist.numberOfTracks != null
            ? '${artist.numberOfTracks} song${artist.numberOfTracks! > 1 ? 's' : ''}'
            : '',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorConstants.hintColor,
            ),
      ),
    );
  }

  Future<int?> getFirstSongWithArtistId(int id, BuildContext context) async {
    var list = context.read<SongsController>().songs.where(
      (element) {
        return element.artistId == id;
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
