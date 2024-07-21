import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../controller/add_to_playlist_bottom_sheet_controller.dart';
import '../../controller/audio_player_controller.dart';
import '../../global_widgets/add_to_playlist_bottom_sheet_body.dart';

void onPopupMenuItemClick({
  required BuildContext context,
  required int index,
  required SongModel song,
}) {
  log(song.displayName);
  switch (index) {
    case 0:
      context.read<AudioPlayerController>().addNextSongInQueue(song);
      break;
    case 1:
      context.read<AudioPlayerController>().addSongInQueue(song);
      break;
    case 2:
      showAddToPlaylistBottomSheet(context, song);
      break;
  }
}

void showAddToPlaylistBottomSheet(BuildContext context, SongModel song) {
  showModalBottomSheet(
    context: context,
    builder: (context) => ChangeNotifierProvider(
      create: (BuildContext context) => AddToPlaylistBottomSheetController(
        context: context,
        song: song,
      ),
      child: const AddToPlaylistBottomSheetBody(),
    ),
  );
}
