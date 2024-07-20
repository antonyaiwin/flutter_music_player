import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsController extends ChangeNotifier {
  SongsController() {
    checkAndRequestPermissions();
  }
  final OnAudioQuery _audioQuery = OnAudioQuery();

  //  Songs List
  List<SongModel> _songs = [];
  List<SongModel> get songs => _songs.toList();

  //  Albums List
  List<AlbumModel> albums = [];

  //  Albums List
  List<ArtistModel> artists = [];

  // Playlist List
  List<PlaylistModel> playlists = [];

  bool isLoading = false;
  bool _hasPermission = false;

  Future<void> getAudio() async {
    _audioQuery.scanMedia('/storage/emulated/0/');

    // Query Audios
    _songs = await _audioQuery.querySongs();

    // Query Albums
    albums = await _audioQuery.queryAlbums();

    // Query Artists
    artists = await _audioQuery.queryArtists();

    // Query Playlist
    playlists = await _audioQuery.queryPlaylists();
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

  Future<List<SongModel>> getSongsFromPlaylist(int id) async {
    return await _audioQuery.queryAudiosFrom(AudiosFromType.PLAYLIST, id);
  }

  Future<bool> createPlaylist(String name) async {
    return await _audioQuery.createPlaylist(name).whenComplete(
          () => _refreshPlaylists(),
        );
  }

  Future<bool> deletePlaylist({required int playlistId}) async {
    return await _audioQuery.removePlaylist(playlistId).whenComplete(
          () => _refreshPlaylists(),
        );
  }

  Future<bool> renamePlaylist(
      {required int playlistId, required String newName}) async {
    return await _audioQuery.renamePlaylist(playlistId, newName).whenComplete(
          () => _refreshPlaylists(),
        );
  }

  Future<bool> addSongToPlaylist(
      {required int playlistId, required int songId}) async {
    return await _audioQuery.addToPlaylist(playlistId, songId).whenComplete(
          () => _refreshPlaylists(),
        );
  }

  Future<bool> removeSongFromPlaylist(
      {required int playlistId, required int songId}) async {
    return await _audioQuery
        .removeFromPlaylist(playlistId, songId)
        .whenComplete(
          () => _refreshPlaylists(),
        );
  }

  Future<void> _refreshPlaylists() async {
    playlists = await _audioQuery.queryPlaylists();
    notifyListeners();
  }
}
