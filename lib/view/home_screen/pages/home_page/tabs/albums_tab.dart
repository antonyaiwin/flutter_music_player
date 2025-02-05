import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/artist_album_view_screen_controller.dart';
import 'package:flutter_music_player/global_widgets/album_list_item.dart';
import 'package:flutter_music_player/view/artist_album_view_screen/artist_album_view_screen.dart';
import 'package:provider/provider.dart';

import '../../../../../controller/home_screen_controller.dart';
import '../../../../../controller/songs_controller.dart';

class AlbumsTab extends StatelessWidget {
  const AlbumsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeScreenController, SongsController>(
      builder: (context, home, songProvider, child) {
        if (songProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (songProvider.albums.isEmpty) {
          return const Center(
            child: Text('No Album found'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 200),
          itemBuilder: (context, index) => AlbumListItem(
            album: songProvider.albums[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) => ArtistAlbumViewScreenController(
                      context: context,
                      album: songProvider.albums[index],
                    ),
                    child: const ArtistAlbumViewScreen(),
                  ),
                ),
              );
            },
          ),
          itemCount: songProvider.albums.length,
        );
      },
    );
  }
}
