import 'package:flutter/material.dart';

import '../utils/global_widgets/base_keep_alive_page.dart';
import '../view/home_screen/pages/home_page/home_page.dart';

class HomeScreenController extends ChangeNotifier {
  PageController pageController = PageController();
  List<Widget> pageList = [
    const BaseKeepAlivePage(child: HomePage()),
  ];
  int selectedPageIndex = 0;
  HomeScreenController();
}
