import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'songs_controller.dart';

class CreatePlaylistBottomSheetController extends ChangeNotifier {
  PlaylistModel? playlist;
  CreatePlaylistBottomSheetController({
    this.playlist,
  }) {
    if (playlist != null) {
      nameController.text = playlist!.playlist;
    }
  }
  final TextEditingController nameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();

  Future<void> createPlaylist(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      String message = '';
      if (await context
              .read<SongsController>()
              .createPlaylist(nameController.text) &&
          context.mounted) {
        Navigator.pop(context);
        message = 'Playlist created successfully';
      } else {
        message = 'Error creating playlist';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  Future<void> renamePlaylist(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      String message = '';
      if (await context.read<SongsController>().renamePlaylist(
              newName: nameController.text, playlistId: playlist!.id) &&
          context.mounted) {
        Navigator.pop(context);
        message = 'Playlist renamed successfully';
      } else {
        message = 'Error renaming playlist';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }
}
