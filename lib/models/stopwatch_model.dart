import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_stopwatch/utils/duration_format_ext.dart';

class StopWatchModel extends ChangeNotifier {
  final Stopwatch _watch = Stopwatch();
  // Could be a list of Duration if formatting in UI class
  final List<String> laps = [];
  Timer? _timer;
  Duration time = Duration.zero;
  String minute = Duration.zero.getMinute();
  String second = Duration.zero.getSecond();
  String millisecond = Duration.zero.getMillisecond();

  Timer? get timer => _timer;
  bool get isRunning => _watch.isRunning;

  void onStart() {
    _watch.start();
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 0), (Timer t) async {
      if (_watch.isRunning) {
        time = _watch.elapsed;
        minute = time.getMinute();
        second = time.getSecond();
        millisecond = time.getMillisecond();
        notifyListeners();
      }
    });
  }

  void onStop() {
    _watch.stop();
    _timer?.cancel();
    notifyListeners();
  }

  void onLap() {
    if (_watch.isRunning) {
      laps.insert(0, _watch.elapsed.format());
      notifyListeners();
    }
  }

  void onReset() {
    _watch.reset();
    time = Duration.zero;
    minute = time.getMinute();
    second = time.getSecond();
    millisecond = time.getMillisecond();
    laps.clear();
    notifyListeners();
  }

}
