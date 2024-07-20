import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/audio_player_controller.dart';
import 'package:flutter_music_player/controller/search_page_controller.dart';
import 'package:flutter_music_player/global_widgets/album_list_item.dart';
import 'package:flutter_music_player/global_widgets/artist_list_item.dart';
import 'package:flutter_music_player/global_widgets/song_list_item.dart';
import 'package:provider/provider.dart';

import '../../../../controller/artist_album_view_screen_controller.dart';
import '../../../artist_album_view_screen/artist_album_view_screen.dart';

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
              controller: provider.searchTextController,
              decoration: InputDecoration(
                hintText: 'Search for songs, albumns and artist',
                suffixIcon: Consumer<SearchPageController>(
                  builder: (context, value, child) => value.isSearchQueryEmpty
                      ? const SizedBox()
                      : IconButton(
                          onPressed: () {
                            value.clearSearch();
                          },
                          icon: const Icon(Icons.cancel),
                        ),
                ),
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
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 10),
                  ),
                  // Error widgets
                  Consumer<SearchPageController>(
                    builder: (BuildContext context, SearchPageController value,
                            Widget? child) =>
                        !value.isSearchQueryEmpty && !value.isResultsEmpty
                            ? const SliverToBoxAdapter()
                            : SliverFillRemaining(
                                child: Center(
                                  child: Text(
                                    value.isSearchQueryEmpty
                                        ? 'Enter a query to search.'
                                        : 'No songs found',
                                  ),
                                ),
                              ),
                  ),
                  // songs
                  Consumer<SearchPageController>(
                    builder: (BuildContext context, SearchPageController value,
                            Widget? child) =>
                        SliverToBoxAdapter(
                      child: value.songs.isNotEmpty &&
                              value.searchTextController.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 15, left: 10),
                              child: Text(
                                'Songs',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Consumer<SearchPageController>(
                    builder: (BuildContext context, SearchPageController value,
                            Widget? child) =>
                        SliverList.builder(
                      itemBuilder: (context, index) => SongListItem(
                        song: value.songs[index],
                        onTap: () {
                          context
                              .read<AudioPlayerController>()
                              .onAudioTouch(index, value.songs);
                        },
                      ),
                      itemCount: value.searchTextController.text.isEmpty
                          ? 0
                          : value.songs.length,
                    ),
                  ),

                  // Album
                  Consumer<SearchPageController>(
                    builder: (BuildContext context, SearchPageController value,
                            Widget? child) =>
                        SliverToBoxAdapter(
                      child: value.albums.isNotEmpty &&
                              value.searchTextController.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 15, left: 10),
                              child: Text(
                                'Albums',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Consumer<SearchPageController>(
                    builder: (BuildContext context, SearchPageController value,
                            Widget? child) =>
                        SliverList.builder(
                      itemBuilder: (context, index) => AlbumListItem(
                        album: value.albums[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (context) =>
                                    ArtistAlbumViewScreenController(
                                  context: context,
                                  album: value.albums[index],
                                ),
                                child: const ArtistAlbumViewScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      itemCount: value.searchTextController.text.isEmpty
                          ? 0
                          : value.albums.length,
                    ),
                  ),

                  // Artists
                  Consumer<SearchPageController>(
                    builder: (BuildContext context, SearchPageController value,
                            Widget? child) =>
                        SliverToBoxAdapter(
                      child: value.artists.isNotEmpty &&
                              value.searchTextController.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 15, left: 10),
                              child: Text(
                                'Artists',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Consumer<SearchPageController>(
                    builder: (BuildContext context, SearchPageController value,
                            Widget? child) =>
                        SliverList.builder(
                      itemBuilder: (context, index) => ArtistListItem(
                        artist: value.artists[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (context) =>
                                    ArtistAlbumViewScreenController(
                                  context: context,
                                  artist: value.artists[index],
                                ),
                                child: const ArtistAlbumViewScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      itemCount: value.searchTextController.text.isEmpty
                          ? 0
                          : value.artists.length,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 200),
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
