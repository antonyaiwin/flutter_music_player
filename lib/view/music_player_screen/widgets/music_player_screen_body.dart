import 'dart:developer';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/audio_player_controller.dart';
import 'package:flutter_music_player/controller/music_player_screen_controller.dart';
import 'package:flutter_music_player/core/constants/color_constants.dart';
import 'package:flutter_music_player/global_widgets/song_list_item.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:text_marquee/text_marquee.dart';

import '../../../core/constants/image_constants.dart';
import '../../../utils/functions/audio_functions.dart';

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
      child: Consumer<AudioPlayerController>(
        builder: (context, value, child) {
          if (value.isPlaying) {
            animationController.forward();
          } else {
            animationController.reverse();
          }
          log('consumer rebuild ${value.imageArtwork == null}');
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<MusicPlayerScreenController>(
                builder: (
                  BuildContext context,
                  MusicPlayerScreenController musicPlayerScreenController,
                  Widget? child,
                ) =>
                    Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      child: musicPlayerScreenController.isPlaylistVisible
                          ? ReorderableListView.builder(
                              itemBuilder: (context, index) {
                                return Row(
                                  key: ValueKey(index),
                                  children: [
                                    const SizedBox(width: 5),
                                    ReorderableDragStartListener(
                                      index: index,
                                      child: const Icon(Icons.drag_handle),
                                    ),
                                    Expanded(
                                      child: SongListItem(
                                        song: value.currentPlaylist[index],
                                        onTap: () {
                                          value.seekToIndex(index);
                                        },
                                        onMoreTap: (context) {
                                          // Get the position of the button
                                          final RenderBox button = context
                                              .findRenderObject() as RenderBox;
                                          final RenderBox overlay =
                                              Overlay.of(context)
                                                      .context
                                                      .findRenderObject()
                                                  as RenderBox;
                                          final Offset position =
                                              button.localToGlobal(Offset.zero,
                                                  ancestor: overlay);

                                          showMenu(
                                            context: context,
                                            position: RelativeRect.fromRect(
                                              Rect.fromPoints(
                                                position,
                                                position.translate(
                                                    button.size.width,
                                                    button.size.height),
                                              ),
                                              Offset.zero & overlay.size,
                                            ),
                                            items: [
                                              PopupMenuItem(
                                                child: const Text(
                                                    'Remove from queue'),
                                                onTap: () {
                                                  value.removeItemFromQueue(
                                                      index);
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: value.currentPlaylist.length,
                              onReorder: (int oldIndex, int newIndex) {
                                value.reorderQueue(oldIndex, newIndex);
                              },
                            )
                          : AspectRatio(
                              aspectRatio: 1,
                              child: CarouselSlider.builder(
                                carouselController: value.carouselController,
                                itemBuilder: (BuildContext context, int index,
                                        int realIndex) =>
                                    AnimatedScale(
                                  curve: value.isPlaying
                                      ? Curves.easeOutBack
                                      : Curves.easeInOut,
                                  duration: const Duration(milliseconds: 800),
                                  scale: value.isPlaying ? 0.9 : 0.6,
                                  child: FutureBuilder(
                                    future:
                                        value.fetchArtworkImage(index: index),
                                    builder: (context, snapshot) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: snapshot.data == null
                                            ? Image.asset(
                                                ImageConstants.musicBg)
                                            : Image.memory(
                                                snapshot.data ?? Uint8List(0),
                                                fit: BoxFit.cover,
                                                filterQuality:
                                                    FilterQuality.high,
                                                gaplessPlayback: true,
                                              ),
                                      );
                                    },
                                  ),
                                ),
                                itemCount: value.currentPlaylist.length,
                                options: CarouselOptions(
                                  initialPage: value.currentIndex ?? 0,
                                  aspectRatio: 1,
                                  viewportFraction: 1,
                                  onPageChanged: (index, reason) {
                                    if (reason ==
                                        CarouselPageChangedReason.manual) {
                                      value.seekToIndex(index);
                                    }
                                  },
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextMarquee(
                      value.currentSong!.title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (value.currentSong!.artist != null)
                          Expanded(
                            child: TextMarquee(
                              value.currentSong!.artist!,
                              style: Theme.of(context).textTheme.bodyMedium!,
                            ),
                          ),
                        Consumer<MusicPlayerScreenController>(
                          builder: (
                            BuildContext context,
                            MusicPlayerScreenController
                                musicPlayerScreenController,
                            Widget? child,
                          ) =>
                              IconButton(
                            onPressed: () {
                              musicPlayerScreenController
                                  .togglePlaylistVisible();
                            },
                            icon: Icon(
                              musicPlayerScreenController.isPlaylistVisible
                                  ? MingCute.playlist_2_fill
                                  : MingCute.playlist_line,
                            ),
                            style: musicPlayerScreenController.isPlaylistVisible
                                ? ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      ColorConstants.primaryBlack
                                          .withOpacity(0.2),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder(
                      stream: value.positionStream,
                      builder: (context, snapshot) {
                        {
                          return Column(
                            children: [
                              SfSlider(
                                max: value.duration?.inSeconds ?? 1,
                                value: snapshot.hasData && snapshot.data != null
                                    ? snapshot.data!.inSeconds
                                    : 0,
                                // stepSize: 1,
                                activeColor: ColorConstants.primaryWhite,
                                inactiveColor: ColorConstants.primaryWhite
                                    .withOpacity(0.35),

                                onChangeStart: (_) {
                                  value.onSlideStart();
                                },
                                onChanged: (duration) {
                                  log('$duration');
                                  value.onSlideChanged(
                                    Duration(seconds: duration ~/ 1),
                                  );
                                },
                                onChangeEnd: (_) {
                                  value.onSlideEnd();
                                },
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                          onPressed: () {
                            value.toggleLoopMode();
                          },
                          icon: Icon(
                            getLoopIcon(value.loopMode),
                          ),
                          color: value.loopMode == LoopMode.off
                              ? null
                              : ColorConstants.blue,
                        ),
                        IconButton(
                          onPressed: value.previousIndex == null
                              ? null
                              : () {
                                  value.previousAudio();
                                },
                          icon: const Icon(Iconsax.previous_bold),
                        ),
                        IconButton.filled(
                          onPressed: () {
                            value.togglePlayPause();
                          },
                          icon: AnimatedIcon(
                            icon: AnimatedIcons.play_pause,
                            progress: animationController,
                            size: 55,
                            color: ColorConstants.primaryWhite,
                          ),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              ColorConstants.primaryBlack.withOpacity(0.2),
                            ),
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
                          onPressed: () {
                            value.toggleShuffleMode();
                          },
                          icon: const Icon(
                            Iconsax.shuffle_outline,
                          ),
                          color: value.shuffleModeEnabled
                              ? ColorConstants.blue
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData? getLoopIcon(LoopMode loopMode) {
    switch (loopMode) {
      case LoopMode.one:
        return Iconsax.repeate_one_outline;
      case LoopMode.all:
        return Iconsax.repeate_music_bold;
      default:
        return Iconsax.repeate_music_outline;
    }
  }
}
