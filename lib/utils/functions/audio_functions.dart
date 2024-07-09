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
