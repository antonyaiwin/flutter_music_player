import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchPageController extends ChangeNotifier {
  List<SongModel> songs = [];

  List<AlbumModel> albums = [];
  List<ArtistModel> artist = [];
}
