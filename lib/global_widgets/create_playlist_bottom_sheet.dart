import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/create_playlist_bottom_sheet_controller.dart';
import 'package:provider/provider.dart';

class CreatePlaylistBottomSheet extends StatelessWidget {
  const CreatePlaylistBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var provider = context.read<CreatePlaylistBottomSheetController>();
    return Container(
      padding: const EdgeInsets.all(20)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            provider.playlist == null
                ? 'Create new playlist'
                : 'Rename playlist',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Form(
            key: provider.formKey,
            child: TextFormField(
              controller: provider.nameController,
              decoration:
                  const InputDecoration(labelText: 'Enter playlist name'),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                }
                return 'Enter a valid name';
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (provider.playlist == null) {
                      provider.createPlaylist(context);
                    } else {
                      provider.renamePlaylist(context);
                    }
                  },
                  child: Text(provider.playlist == null ? 'Create' : 'Rename'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
