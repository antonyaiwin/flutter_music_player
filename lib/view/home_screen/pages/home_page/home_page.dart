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
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              tabAlignment: TabAlignment.start,
              dividerHeight: 0,
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
