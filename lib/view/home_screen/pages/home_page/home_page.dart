import 'package:flutter/material.dart';
import 'package:flutter_music_player/view/home_screen/pages/home_page/tabs/albums_tab.dart';
import 'package:flutter_music_player/view/home_screen/pages/home_page/tabs/artists_tab.dart';

import 'tabs/songs_tab.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  text: 'Songs',
                ),
                Tab(
                  text: 'Artists',
                ),
                Tab(
                  text: 'Albums',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SongsTab(),
                  ArtistsTab(),
                  AlbumsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
