import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/songs_controller.dart';

class AddPlaylistBottomSheet extends StatefulWidget {
  AddPlaylistBottomSheet({
    super.key,
  });
  final TextEditingController nameController = TextEditingController();

  @override
  State<AddPlaylistBottomSheet> createState() => _AddPlaylistBottomSheetState();
}

class _AddPlaylistBottomSheetState extends State<AddPlaylistBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    log('message');
    return Container(
      padding: const EdgeInsets.all(20)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Create new playlist',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Form(
            key: formKey,
            child: TextFormField(
              controller: widget.nameController,
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
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      String message = '';
                      if (await context
                              .read<SongsController>()
                              .createPlaylist(widget.nameController.text) &&
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
                  },
                  child: const Text('Create'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
