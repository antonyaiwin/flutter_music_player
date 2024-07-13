import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_music_player/controller/audio_player_controller.dart';
import 'package:provider/provider.dart';

import '../utils/global_widgets/base_keep_alive_page.dart';
import '../view/music_player_screen/widgets/artwork_carousel_view.dart';
import '../view/music_player_screen/widgets/current_playlist_list_view.dart';

class MusicPlayerScreenController extends ChangeNotifier {
  List<Widget> playerWidgets = [
    BaseKeepAlivePage(
      key: GlobalKey(),
      child: const CurrentPlaylistListView(),
    ),
    ArtworkCarouselView(
      key: GlobalKey(),
    ),
  ];
  GlobalKey currentPlayingSongKey = GlobalKey();
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController(
    initialPage: 1,
  );
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
    pageController.jumpToPage(!isPlaylistVisible ? 1 : 0);

    notifyListeners();
    if (isPlaylistVisible) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => scrollToSong(),
      );
    }
  }

  void scrollToSong() {
    log('scroll to song');
    // var context = currentPlayingSongKey.currentContext;
    // if (context == null) {
    //   log('scroll to song null context');

    //   return;
    // }
    // var box = context.findRenderObject() as RenderBox;
    // var offset = box.localToGlobal(
    //   Offset.zero,
    //   ancestor:
    //       context.findRenderObject()?.parent?.parent?.parent as RenderObject,
    // );
    // log(offset.toString());
    // scrollController.jumpTo(offset.dy);

    double offsetv =
        72.0 * (context.read<AudioPlayerController>().currentIndex ?? 0);
    if (scrollController.hasClients) {
      scrollController.animateTo(
        offsetv,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }
}
