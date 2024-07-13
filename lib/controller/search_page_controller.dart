import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/songs_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SearchPageController extends ChangeNotifier {
  List<SongModel> songs = [];

  List<AlbumModel> albums = [];
  List<ArtistModel> artists = [];
  TextEditingController searchTextController = TextEditingController();

  onSearchQueryChanged({required BuildContext context, required String query}) {
    query = query.toLowerCase();
    // songs
    songs = context
        .read<SongsController>()
        .songs
        .where(
          (element) =>
              element.title.toLowerCase().contains(query) ||
              element.displayName.toLowerCase().contains(query),
        )
        .toList();

    // Albums
    albums = context
        .read<SongsController>()
        .albums
        .where(
          (element) => element.album.toLowerCase().contains(query),
        )
        .toList();

    // Artists
    artists = context
        .read<SongsController>()
        .artists
        .where(
          (element) => element.artist.toLowerCase().contains(query),
        )
        .toList();

    notifyListeners();
  }

  bool get isSearchQueryEmpty => searchTextController.text.isEmpty;

  bool get isResultsEmpty => songs.isEmpty && albums.isEmpty && artists.isEmpty;

  void clearSearch() {
    searchTextController.clear();
    notifyListeners();
  }
}
