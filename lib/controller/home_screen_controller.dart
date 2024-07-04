import 'package:flutter/material.dart';
import 'package:flutter_music_player/view/home_screen/pages/playlist_page/playlist_page.dart';
import 'package:flutter_music_player/view/home_screen/pages/search_page/search_page.dart';

import '../utils/global_widgets/base_keep_alive_page.dart';
import '../view/home_screen/pages/home_page/home_page.dart';

class HomeScreenController extends ChangeNotifier {
  PageController pageController = PageController();
  List<Widget> pageList = [
    const BaseKeepAlivePage(child: HomePage()),
    const BaseKeepAlivePage(child: SearchPage()),
    const BaseKeepAlivePage(child: PlaylistPage()),
  ];
  int selectedPageIndex = 0;
  HomeScreenController();

  void changePage(int index) {
    selectedPageIndex = index;
    pageController.jumpToPage(selectedPageIndex);
    notifyListeners();
  }
}
