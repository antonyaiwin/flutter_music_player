import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                hintText: 'Search for songs, albumns and artist'),
          ),
        ],
      ),
    );
  }
}
