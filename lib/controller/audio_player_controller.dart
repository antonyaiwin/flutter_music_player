import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioPlayerController extends ChangeNotifier {
  int? currentSongindex;
  List<SongModel> currentPlaylist = [];
  final AudioPlayer _player = AudioPlayer();
  bool wasPlaying = false;

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
  Duration? get duration => _player.duration;
  Stream<Duration> get positionStream => _player.positionStream;
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

  void onSlideStart() {
    if (_player.playing) {
      wasPlaying = true;
      _player.pause();
    } else {
      wasPlaying = false;
    }
  }

  void onSlideChanged(Duration value) {
    _player.seek(value);
  }

  void onSlideEnd() {
    if (wasPlaying) {
      _player.play();
    }
  }

  LoopMode get loopMode => _player.loopMode;
  bool get shuffleModeEnabled => _player.shuffleModeEnabled;

  Future<void> toggleLoopMode() async {
    if (loopMode == LoopMode.off) {
      await _player.setLoopMode(LoopMode.one);
    } else if (loopMode == LoopMode.one) {
      await _player.setLoopMode(LoopMode.all);
    } else {
      await _player.setLoopMode(LoopMode.off);
    }
    notifyListeners();
  }

  void toggleShuffleMode() {
    if (_player.shuffleModeEnabled) {
      _player.setShuffleModeEnabled(false);
    } else {
      _player.setShuffleModeEnabled(true);
    }
    notifyListeners();
  }
}
