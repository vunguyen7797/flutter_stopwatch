extension FormatDurationExtension on Duration {
  String getMinute(){
    return inMinutes.remainder(60).toString().padLeft(2, '0');
  }

  String getSecond(){
    return inSeconds.remainder(60).toString().padLeft(2, '0');
  }

  String getMillisecond(){
    return (inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
  }

  String format(){
    final minutes = getMinute();
    final seconds = getSecond();
    final milliseconds = getMillisecond();
    return '$minutes:$seconds.$milliseconds';
  }
}