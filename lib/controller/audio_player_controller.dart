import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioPlayerController extends ChangeNotifier {
  int? currentSongindex;
  List<SongModel> currentPlaylist = [];
  final AudioPlayer _player = AudioPlayer();

  AudioPlayerController();

  Future<void> onAudioTouch(int index, List<SongModel> songList) async {
    // log(item.data);
    currentPlaylist = songList;
    currentSongindex = index;
    // Define the playlist
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: false,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: songList
          .map(
            (e) => AudioSource.file(e.data, tag: e.id),
          )
          .toList(),
    );
    await _player.setAudioSource(
      playlist,
      initialIndex: index,
    );
    _player.play();
    notifyListeners();
  }

  bool get isPlaying => _player.playing;

  int? get previousIndex => _player.previousIndex;
  int? get currentIndex => _player.currentIndex;
  int? get nextIndex => _player.nextIndex;
  SongModel? get currentSong {
    if (currentSongindex != null &&
        currentSongindex! < currentPlaylist.length) {
      return currentPlaylist[currentSongindex!];
    } else {
      return null;
    }
  }

  void togglePlayPause() {
    if (isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
    notifyListeners();
  }

  Future<void> nextAudio() async {
    await _player.seekToNext();
    refreshSongDetails();
  }

  Future<void> previousAudio() async {
    await _player.seekToPrevious();
    refreshSongDetails();
  }

  refreshSongDetails() {
    currentSongindex = currentIndex;
    notifyListeners();
  }
}
