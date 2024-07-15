import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/playlist_view_screen_controller.dart';
import 'package:flutter_music_player/controller/songs_controller.dart';
import 'package:flutter_music_player/global_widgets/playlist_list_item.dart';
import 'package:flutter_music_player/view/playlist_view_screen/playlist_view_screen.dart';
import 'package:provider/provider.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlayLists'),
      ),
      body: Consumer<SongsController>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (value.playlists.isEmpty) {
            return const Center(
              child: Text('No playlist found!'),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              var playlist = value.playlists[index];
              return PlaylistListItem(
                playlist: playlist,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => PlaylistViewScreenController(
                            context: context, playlist: playlist),
                        child: const PlaylistViewScreen(),
                      ),
                    ),
                  );
                },
              );
            },
            itemCount: value.playlists.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddPlaylistBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
                      context.read<SongsController>().refreshPlaylists();
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
