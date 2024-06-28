import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsController extends ChangeNotifier {
  SongsController() {
    checkAndRequestPermissions();
  }
  final OnAudioQuery _audioQuery = OnAudioQuery();

  //  Songs List
  List<SongModel> songs = [];

  //  Albums List
  List<AlbumModel> albums = [];

  bool isLoading = false;
  bool _hasPermission = false;

  Future<void> getAudio() async {
    // await _audioQuery.scanMedia('/storage/emulated/0/Download/Umbayi/');

    // Query Audios
    songs = await _audioQuery.querySongs();

    // Query Albums
    albums = await _audioQuery.queryAlbums();
    isLoading = false;
    notifyListeners();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    isLoading = true;
    notifyListeners();
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission ? getAudio(/* RequestType.audio */) : null;
  }

  Future<Uint8List?> getSongImage(int id) async {
    return await _audioQuery.queryArtwork(id, ArtworkType.AUDIO);
  }
}
