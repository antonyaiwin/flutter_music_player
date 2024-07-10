import 'package:flutter/material.dart';

class MusicPlayerScreenController extends ChangeNotifier {
  bool isPlaylistVisible = false;

  void togglePlaylistVisible() {
    isPlaylistVisible = !isPlaylistVisible;
    notifyListeners();
  }
}
