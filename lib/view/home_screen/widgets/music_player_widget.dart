import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/audio_player_controller.dart';
import 'package:flutter_music_player/core/constants/color_constants.dart';
import 'package:flutter_music_player/core/constants/image_constants.dart';
import 'package:flutter_music_player/view/music_player_screen/music_player_screen.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:text_marquee/text_marquee.dart';

import '../../../utils/functions/audio_functions.dart';

class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({
    super.key,
  });

  @override
  State<MusicPlayerWidget> createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController rotationAnimationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    rotationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read<AudioPlayerController>();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MusicPlayerScreen(),
          ),
        );
      },
      child: Consumer<AudioPlayerController>(
        builder:
            (BuildContext context, AudioPlayerController value, Widget? child) {
          if (provider.currentIndex == null) {
            return const SizedBox();
          }
          log('isplaying ${value.isPlaying}');
          if (value.isPlaying) {
            animationController.forward();
            rotationAnimationController.repeat();
          } else {
            animationController.reverse();
            rotationAnimationController.stop();
          }
          return FutureBuilder(
            future: getColorFromAudioImage(context, value.currentSong!.id),
            builder: (context, snapshot) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                width: double.infinity,
                height: kToolbarHeight,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color:
                      snapshot.hasData ? snapshot.data : ColorConstants.black3c,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    RotationTransition(
                      turns: rotationAnimationController,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            const AssetImage(ImageConstants.recordDisc),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ClipOval(
                            child: value.imageArtwork == null
                                ? Image.asset(
                                    ImageConstants.musicBg,
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 50,
                                  )
                                : Image.memory(
                                    value.imageArtwork!,
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 50,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextMarquee(
                            value.currentSong!.displayName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (value.currentSong!.artist != null)
                            TextMarquee(
                              value.currentSong!.artist!,
                              style: Theme.of(context).textTheme.bodySmall!,
                            ),
                        ],
                      ),
                    ),
                    if (value.previousIndex != null)
                      IconButton(
                        onPressed: () {
                          value.previousAudio();
                        },
                        icon: const Icon(Iconsax.previous_bold),
                      ),
                    IconButton(
                      onPressed: () {
                        value.togglePlayPause();
                      },
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: animationController,
                      ),
                    ),
                    if (value.nextIndex != null)
                      IconButton(
                        onPressed: () {
                          value.nextAudio();
                        },
                        icon: const Icon(Iconsax.next_bold),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    rotationAnimationController.dispose();
    super.dispose();
  }
}
