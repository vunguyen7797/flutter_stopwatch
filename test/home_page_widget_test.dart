import 'package:flutter/material.dart';
import 'package:flutter_stopwatch/models/stopwatch_model.dart';
import 'package:flutter_stopwatch/ui/home_page.dart';
import 'package:flutter_stopwatch/widgets/dub_button_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('HomePage', () {
    testWidgets('should display elapsed time text widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => StopWatchModel(),
            child: const HomePage(),
          ),
        ),
      );
      expect(find.byKey(const Key('ElapsedTimeText')), findsOneWidget);
    });

    testWidgets('should display lap time list widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => StopWatchModel(),
            child: const HomePage(),
          ),
        ),
      );
      expect(find.byKey(const Key('LapTimeList')), findsOneWidget);
    });

    testWidgets('should display button slab widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => StopWatchModel(),
            child: const HomePage(),
          ),
        ),
      );
      expect(find.byKey(const Key('ButtonSlab')), findsOneWidget);
    });
  });

  group('_ElapsedTimeText', () {
    late StopWatchModel stopwatch;

    setUp(() {
      stopwatch = StopWatchModel();
    });

    testWidgets('should display minute:seconds text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: stopwatch,
            child: const HomePage(),
          ),
        ),
      );

      final text = '${stopwatch.minute}:${stopwatch.second}';
      expect(find.text(text), findsOneWidget);
    });

    testWidgets('should display millisecond text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: stopwatch,
            child: const HomePage(),
          ),
        ),
      );

      final text = '.${stopwatch.millisecond}';
      expect(find.text(text), findsOneWidget);
    });
  });

  group('_ButtonSlab', () {
    late StopWatchModel stopwatch;

    setUp(() {
      stopwatch = StopWatchModel();
    });

    testWidgets('should display and trigger methods correctly on tap depending on the current state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: stopwatch,
            child: const HomePage(),
          ),
        ),
      );

      // Verify initial buttons
      final startButton = find.widgetWithText(DubButton, 'Start');
      final stopButton = find.widgetWithText(DubButton, 'Stop');
      final resetButton = find.widgetWithText(DubButton, 'Reset');
      final lapButton = find.widgetWithText(DubButton, 'Lap');

      expect(find.byType(DubButton), findsNWidgets(2));
      expect(
        tester.widget(startButton),
        isA<DubButton>().having((t) => t.onTap, 'onTap', equals(stopwatch.onStart)),
      );
      expect(
        tester.widget(lapButton),
        isA<DubButton>().having((t) => t.onTap, 'onTap', isNull),
      );

      // Tap Start button
      await tester.tap(startButton);
      await tester.pump();

      // Verify buttons after tapping Start button
      expect(find.byType(DubButton), findsNWidgets(2));
      expect(startButton, findsNothing);
      expect(
        tester.widget(lapButton),
        isA<DubButton>().having((t) => t.onTap, 'onTap',  equals(stopwatch.onLap)),
      );
      expect(
        tester.widget(stopButton),
        isA<DubButton>().having((t) => t.onTap, 'onTap', equals(stopwatch.onStop)),
      );

      // Tap Lap button
      await tester.tap(lapButton);
      await tester.pump();

      // Verify buttons after tapping Lap button
      expect(find.byType(DubButton), findsNWidgets(2));
      expect(startButton, findsNothing);
      expect(
        tester.widget(lapButton),
        isA<DubButton>().having((t) => t.onTap, 'onTap',  equals(stopwatch.onLap)),
      );
      expect(
        tester.widget(stopButton),
        isA<DubButton>().having((t) => t.onTap, 'onTap', equals(stopwatch.onStop)),
      );

      // Tap Stop button
      await tester.tap(stopButton);
      await tester.pump();

      // Verify buttons after tapping Stop button
      expect(find.byType(DubButton), findsNWidgets(2));
      expect(stopButton, findsNothing);
      expect(lapButton, findsNothing);
      expect(
        tester.widget(startButton),
        isA<DubButton>().having((t) => t.onTap, 'onTap',  equals(stopwatch.onStart)),
      );
      expect(
        tester.widget(resetButton),
        isA<DubButton>().having((t) => t.onTap, 'onTap', equals(stopwatch.onReset)),
      );

      // Tap Reset button
      await tester.tap(resetButton);
      await tester.pump();

      // Verify buttons after tapping Reset button
      expect(find.byType(DubButton), findsNWidgets(2));
      expect(stopButton, findsNothing);
      expect(resetButton, findsNothing);
      expect(
        tester.widget(startButton),
        isA<DubButton>().having((t) => t.onTap, 'onTap',  equals(stopwatch.onStart)),
      );
      expect(
        tester.widget(lapButton),
        isA<DubButton>().having((t) => t.onTap, 'onTap', isNull),
      );

      // Tap Lap button when it's disabled
      await tester.tap(lapButton);
      await tester.pump();

      // Verify buttons after tapping disabled Lap button
      expect(find.byType(DubButton), findsNWidgets(2));
      expect(resetButton, findsNothing);
      expect(stopButton, findsNothing);
      expect(
        tester.widget(startButton),
        isA<DubButton>().having((t) => t.onTap, 'onTap',  equals(stopwatch.onStart)),
      );
      expect(
        tester.widget(lapButton),
        isA<DubButton>().having((t) => t.onTap, 'onTap', isNull),
      );

    });
  });

  group('_LapTimeList', () {
    late StopWatchModel stopwatch;

    setUp(() {
      stopwatch = StopWatchModel();
    });

    testWidgets('should renders lap times correctly', (tester) async {
      stopwatch.laps.addAll(['00:10.00', '00:20.00', '00:30.00']);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: stopwatch,
            child: const HomePage(),
          ),
        ),
      );

      // Verify that the lap times are rendered correctly
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(2));
      expect(find.text('Lap 1'), findsOneWidget);
      expect(find.text('00:10.00'), findsOneWidget);
      expect(find.text('Lap 2'), findsOneWidget);
      expect(find.text('00:20.00'), findsOneWidget);
      expect(find.text('Lap 3'), findsOneWidget);
      expect(find.text('00:30.00'), findsOneWidget);
    });

  });
}
