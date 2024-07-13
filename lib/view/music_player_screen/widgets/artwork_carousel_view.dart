import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/controller/audio_player_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/image_constants.dart';

class ArtworkCarouselView extends StatelessWidget {
  const ArtworkCarouselView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Consumer<AudioPlayerController>(
        builder: (BuildContext context, AudioPlayerController value,
                Widget? child) =>
            CarouselSlider.builder(
          carouselController: value.carouselController,
          itemBuilder: (BuildContext context, int index, int realIndex) =>
              AnimatedScale(
            curve: value.isPlaying ? Curves.easeOutBack : Curves.easeInOut,
            duration: const Duration(milliseconds: 800),
            scale: value.isPlaying ? 0.9 : 0.6,
            child: FutureBuilder(
              future: value.fetchArtworkImage(index: index),
              builder: (context, snapshot) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? null
                      : snapshot.data == null
                          ? Image.asset(ImageConstants.musicBg)
                          : Image.memory(
                              snapshot.data ?? Uint8List(0),
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
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
              if (reason == CarouselPageChangedReason.manual) {
                value.seekToIndex(index);
              }
            },
          ),
        ),
      ),
    );
  }
}
