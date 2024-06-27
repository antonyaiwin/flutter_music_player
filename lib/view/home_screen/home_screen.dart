import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../controller/home_screen_controller.dart';
import 'widgets/music_player_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: context.read<HomeScreenController>().pageController,
              children: context.read<HomeScreenController>().pageList,
            ),
          ),
          const MusicPlayerWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home_1_outline),
            activeIcon: Icon(Iconsax.home_1_bold),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home_1_outline),
            activeIcon: Icon(Iconsax.home_1_bold),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home_1_outline),
            activeIcon: Icon(Iconsax.home_1_bold),
            label: '',
          ),
        ],
      ),
    );
  }
}
