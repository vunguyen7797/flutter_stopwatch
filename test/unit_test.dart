import 'package:flutter_stopwatch/models/stopwatch_model.dart';
import 'package:flutter_stopwatch/utils/duration_format_ext.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StopWatchModel tests', () {
    late StopWatchModel stopwatch;

    setUp(() {
      stopwatch = StopWatchModel();
    });

    test('initial values are correct', () {
      expect(stopwatch.isRunning, isFalse);
      expect(stopwatch.time, equals(Duration.zero));
      expect(stopwatch.minute, equals(Duration.zero.getMillisecond()));
      expect(stopwatch.second, equals(Duration.zero.getSecond()));
      expect(stopwatch.millisecond, equals(Duration.zero.getMinute()));
      expect(stopwatch.laps, isEmpty);
    });

    test('onStart() should start the stopwatch and updates time', () async {
      expect(stopwatch.isRunning, isFalse);
      expect(stopwatch.time, equals(Duration.zero));
      expect(stopwatch.minute, equals(Duration.zero.getMillisecond()));
      expect(stopwatch.second, equals(Duration.zero.getSecond()));
      expect(stopwatch.millisecond, equals(Duration.zero.getMinute()));

      stopwatch.onStart();
      expect(stopwatch.isRunning, isTrue);
      expect(stopwatch.timer, isNotNull);

      await Future.delayed(const Duration(seconds: 1, milliseconds: 50));
      expect(stopwatch.time, isNot(equals(Duration.zero)));
      expect(stopwatch.minute, equals(Duration.zero.getMinute()));
      expect(stopwatch.second, isNot(equals(Duration.zero.getSecond())));
      expect(stopwatch.millisecond, isNot(equals(Duration.zero.getMillisecond())));

      stopwatch.onStop();
    });

    test('onStop() should stop the stopwatch', () {
      expect(stopwatch.isRunning, isFalse);
      stopwatch.onStart();
      expect(stopwatch.isRunning, isTrue);
      stopwatch.onStop();
      expect(stopwatch.isRunning, isFalse);
    });

    test('onLap() should add lap time when the stopwatch is running', () {
      stopwatch.onStart();
      expect(stopwatch.laps, isEmpty);
      stopwatch.onLap();
      expect(stopwatch.laps, isNotEmpty);
      expect(stopwatch.laps.first, equals(stopwatch.time.format()));
      stopwatch.onStop();
    });

    test('onLap() should not add lap time when the stopwatch is stopped', () {
      expect(stopwatch.isRunning, isFalse);
      expect(stopwatch.laps, isEmpty);
      stopwatch.onLap();
      expect(stopwatch.laps, isEmpty);
    });

    test('onReset() should reset the stopwatch and lap times', () {
      stopwatch.onStart();
      stopwatch.onLap();
      expect(stopwatch.laps, isNotEmpty);
      stopwatch.onStop();
      stopwatch.onReset();
      expect(stopwatch.isRunning, isFalse);
      expect(stopwatch.time, equals(Duration.zero));
      expect(stopwatch.laps, isEmpty);
    });
  });


  group('FormatDurationExtension tests', () {
    test('getMinute() should returns the minute value as a string', () {
      const duration = Duration(minutes: 1, seconds: 30);

      final minute = duration.getMinute();

      expect(minute, '01');
    });

    test('getSecond() should returns the second value as a string', () {
      const duration = Duration(minutes: 1, seconds: 30);

      final second = duration.getSecond();

      expect(second, '30');
    });

    test('getMillisecond() should returns the millisecond value as a string', () {
      const duration = Duration(minutes: 1, seconds: 30, milliseconds: 800);

      final millisecond = duration.getMillisecond();

      expect(millisecond, '80');
    });

    test('format() returns the duration formatted as a string', ()
    {
      const duration = Duration(minutes: 1, seconds: 30, milliseconds: 800);

      final elapsedTime = duration.format();

      expect(elapsedTime, '01:30.80');
    });

  });


}
