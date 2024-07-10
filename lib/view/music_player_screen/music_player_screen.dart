import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/audio_player_controller.dart';
import 'package:flutter_music_player/controller/music_player_screen_controller.dart';
import 'package:flutter_music_player/controller/songs_controller.dart';
import 'package:flutter_music_player/core/constants/color_constants.dart';
import 'package:flutter_music_player/core/constants/image_constants.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import 'widgets/music_player_screen_body.dart';

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MusicPlayerScreenController(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Iconsax.arrow_down_1_outline),
          ),
          title: const Text('Now Playing'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Stack(
          children: [
            Consumer<AudioPlayerController>(
              builder: (BuildContext context, AudioPlayerController value,
                      Widget? child) =>
                  FutureBuilder(
                future: getBackgroundImage(context),
                builder: (context, snapshot) {
                  return AnimatedContainer(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: snapshot.data == null
                          ? null
                          : DecorationImage(
                              image: snapshot.data!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    duration: const Duration(seconds: 1),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5000,
                        sigmaY: 5000,
                        tileMode: TileMode.repeated,
                      ),
                      child: Container(
                        color: ColorConstants.primaryBlack.withOpacity(0.3),
                        child: const Center(),
                      ),
                    ),
                  );
                },
              ),
            ),
            const MusicPlayerScreenBody()
          ],
        ),
      ),
    );
  }

  Future<ImageProvider<Object>> getBackgroundImage(BuildContext context) async {
    int? id = context.read<AudioPlayerController>().currentSong?.id;
    if (id != null) {
      Uint8List? image = await context.read<SongsController>().getSongImage(id);
      if (image != null) {
        return MemoryImage(image);
      }
    }
    return const AssetImage(ImageConstants.musicBg);
  }
}
