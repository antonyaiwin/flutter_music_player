import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/songs_controller.dart';
import '../../core/constants/image_constants.dart';

double getProgress(int position, int duration) {
  // log('position: $position , duration: $duration');

  return position / duration;
}

String getTimeFromDuration(Duration? duration) {
  if (duration == null) {
    return '--:--';
  } else {
    String minutes = intToTwoDigit(duration.inMinutes.remainder(60));
    String seconds = intToTwoDigit(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

String intToTwoDigit(int n) {
  return n.toString().padLeft(2, '0');
}

Future<Color> getColorFromAudioImage(BuildContext context, int songId) async {
  var image = await context.read<SongsController>().getSongImage(songId);
  Color color;
  ImageProvider imageProvider;
  if (image != null) {
    imageProvider = MemoryImage(image);
  } else {
    imageProvider = const AssetImage(ImageConstants.musicBg);
  }
  var colorScheme =
      await ColorScheme.fromImageProvider(provider: imageProvider);
  color = colorScheme.secondary;
  return color;
}
