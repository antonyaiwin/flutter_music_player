import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/audio_player_controller.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_marquee/text_marquee.dart';

import '../../../core/constants/image_constants.dart';

class MusicPlayerScreenBody extends StatefulWidget {
  const MusicPlayerScreenBody({
    super.key,
  });

  @override
  State<MusicPlayerScreenBody> createState() => _MusicPlayerScreenBodyState();
}

class _MusicPlayerScreenBodyState extends State<MusicPlayerScreenBody>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<AudioPlayerController>(
          builder: (context, value, child) {
            if (value.isPlaying) {
              animationController.forward();
            } else {
              animationController.reverse();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: QueryArtworkWidget(
                      id: value.currentSong!.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Image.asset(
                        ImageConstants.musicBg,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextMarquee(
                  value.currentSong!.displayName,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (value.currentSong!.artist != null)
                  TextMarquee(
                    value.currentSong!.artist!,
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                const SizedBox(height: 20),
                StreamBuilder(
                  stream: value.positionStream,
                  builder: (context, snapshot) {
                    {
                      return Column(
                        children: [
                          LinearProgressIndicator(
                            value: snapshot.hasData &&
                                    snapshot.data != null &&
                                    value.duration != null
                                ? getProgress(snapshot.data!.inSeconds,
                                    value.duration!.inSeconds)
                                : 0,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getTimeFromDuration(snapshot.data)),
                              Text(getTimeFromDuration(value.duration)),
                            ],
                          )
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Iconsax.repeate_one_outline,
                      ),
                    ),
                    IconButton(
                      onPressed: value.previousIndex == null
                          ? null
                          : () {
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
                        size: 35,
                      ),
                    ),
                    IconButton(
                      onPressed: value.nextIndex == null
                          ? null
                          : () {
                              value.nextAudio();
                            },
                      icon: const Icon(Iconsax.next_bold),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Iconsax.shuffle_outline,
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  double getProgress(int position, int duration) {
    log('position: $position , duration: $duration');

    return position / duration;
  }

  String getTimeFromDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    } else {
      String minutes = twoDigit(duration.inMinutes.remainder(60));
      String seconds = twoDigit(duration.inSeconds.remainder(60));
      return '$minutes:$seconds';
    }
  }

  String twoDigit(int n) {
    return n.toString().padLeft(2, '0');
  }
}
