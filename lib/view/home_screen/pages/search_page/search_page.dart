import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/search_page_controller.dart';
import 'package:flutter_music_player/global_widgets/album_list_item.dart';
import 'package:flutter_music_player/global_widgets/artist_list_item.dart';
import 'package:flutter_music_player/global_widgets/song_list_item.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<SearchPageController>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search for songs, albumns and artist',
              ),
              onChanged: (value) {
                provider.onSearchQueryChanged(
                  context: context,
                  query: value,
                );
              },
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // songs
                  const SliverToBoxAdapter(
                    child: Text('Songs'),
                  ),
                  Consumer<SearchPageController>(
                    builder: (BuildContext context, SearchPageController value,
                            Widget? child) =>
                        SliverList.builder(
                      itemBuilder: (context, index) =>
                          SongListItem(song: value.songs[index]),
                      itemCount: value.songs.length,
                    ),
                  ),

                  // Album
                  const SliverToBoxAdapter(
                    child: Text('Albums'),
                  ),
                  Consumer<SearchPageController>(
                    builder: (BuildContext context, SearchPageController value,
                            Widget? child) =>
                        SliverList.builder(
                      itemBuilder: (context, index) =>
                          AlbumListItem(album: value.albums[index]),
                      itemCount: value.albums.length,
                    ),
                  ),

                  // Artists
                  const SliverToBoxAdapter(
                    child: Text('Artists'),
                  ),
                  Consumer<SearchPageController>(
                    builder: (BuildContext context, SearchPageController value,
                            Widget? child) =>
                        SliverList.builder(
                      itemBuilder: (context, index) =>
                          ArtistListItem(artist: value.artists[index]),
                      itemCount: value.artists.length,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
