import 'package:flutter/material.dart';
import 'package:flutter_music_player/global_widgets/artist_list_item.dart';
import 'package:provider/provider.dart';

import '../../../../../controller/artist_album_view_screen_controller.dart';
import '../../../../../controller/home_screen_controller.dart';
import '../../../../../controller/songs_controller.dart';
import '../../../../artist_album_view_screen/artist_album_view_screen.dart';

class ArtistsTab extends StatelessWidget {
  const ArtistsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeScreenController, SongsController>(
      builder: (context, home, songProvider, child) {
        if (songProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (songProvider.artists.isEmpty) {
          return const Center(
            child: Text('No Artists found'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 200),
          itemBuilder: (context, index) {
            var listItem = ArtistListItem(
              artist: songProvider.artists[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => ArtistAlbumViewScreenController(
                        context: context,
                        artist: songProvider.artists[index],
                      ),
                      child: const ArtistAlbumViewScreen(),
                    ),
                  ),
                );
              },
            );

            if (index != 0) {
              var artist = songProvider.artists[index];
              var prevArtist = songProvider.artists[index - 1];
              if (artist.artist.isNotEmpty &&
                  prevArtist.artist.isNotEmpty &&
                  artist.artist[0] != prevArtist.artist[0]) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, bottom: 10, top: 20),
                      child: Text(artist.artist[0]),
                    ),
                    listItem,
                  ],
                );
              }
            }
            return listItem;
          },
          itemCount: songProvider.artists.length,
        );
      },
    );
  }
}
