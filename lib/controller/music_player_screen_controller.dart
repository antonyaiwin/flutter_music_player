import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_music_player/controller/audio_player_controller.dart';
import 'package:provider/provider.dart';

import '../view/music_player_screen/widgets/artwork_carousel_view.dart';
import '../view/music_player_screen/widgets/current_playlist_list_view.dart';

class MusicPlayerScreenController extends ChangeNotifier {
  List<Widget> playerWidgets = [
    CurrentPlaylistListView(),
    const ArtworkCarouselView(),
  ];
  ScrollController scrollController = ScrollController();
  bool isPlaylistVisible = false;
  BuildContext context;
  MusicPlayerScreenController({
    required this.context,
  }) {
    context.read<AudioPlayerController>().addIndexListener(
      (index) {
        scrollToSong();
      },
    );
  }

  void togglePlaylistVisible() {
    isPlaylistVisible = !isPlaylistVisible;
    notifyListeners();
    if (isPlaylistVisible) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => scrollToSong(),
      );
    }
  }

  void scrollToSong() {
    double offsetv =
        72.0 * (context.read<AudioPlayerController>().currentIndex ?? 0);
    if (scrollController.hasClients) {
      scrollController.animateTo(
        min(offsetv, scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }
}
