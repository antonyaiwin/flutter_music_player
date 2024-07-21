import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_music_player/core/constants/color_constants.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../controller/home_screen_controller.dart';
import 'widgets/music_player_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<HomeScreenController>();
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          log('pop');
          if (context.read<HomeScreenController>().selectedPageIndex == 0) {
            SystemNavigator.pop();
          } else {
            context.read<HomeScreenController>().changePage(0);
          }
        },
        child: Stack(
          children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: context.read<HomeScreenController>().pageController,
              children: context.read<HomeScreenController>().pageList,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MusicPlayerWidget(),
                  Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: double.infinity,
                          height: kBottomNavigationBarHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                ColorConstants.primaryBlack.withOpacity(0.5),
                                ColorConstants.primaryBlack.withOpacity(0.6),
                                ColorConstants.primaryBlack.withOpacity(0.7),
                                ColorConstants.primaryBlack.withOpacity(0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: const Center(),
                        ),
                      ),
                      Consumer<HomeScreenController>(
                        builder: (context, value, child) => BottomNavigationBar(
                          currentIndex: provider.selectedPageIndex,
                          backgroundColor: Colors.transparent,
                          onTap: (value) {
                            provider.changePage(value);
                          },
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                          items: const [
                            BottomNavigationBarItem(
                              icon: Icon(Iconsax.home_2_outline),
                              activeIcon: Icon(Iconsax.home_2_bold),
                              label: '',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Iconsax.search_normal_1_outline),
                              activeIcon: Icon(Iconsax.search_normal_1_bold),
                              label: '',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Iconsax.music_playlist_outline),
                              activeIcon: Icon(Iconsax.music_playlist_bold),
                              label: '',
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
