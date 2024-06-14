import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch/main.dart';
import 'package:stopwatch/stopwatch_model.dart';


void main() {
  testWidgets('initial state is correct', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StopwatchModel()),
        ],
        child: MaterialApp(
          home: StopwatchHomeMain(),
        ),
      ),
    );

    expect(find.text('00:00.00'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Lap'), findsOneWidget);
    expect(find.text('Clear laps'), findsOneWidget);
  });

  testWidgets('start and pause stopwatch', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StopwatchModel()),
        ],
        child: MaterialApp(
          home: StopwatchHomeMain(),
        ),
      ),
    );

    expect(find.text('Start'), findsOneWidget);
    await tester.tap(find.text('Start'));
    await tester.pump();
    expect(find.text('Pause'), findsOneWidget);

    await tester.tap(find.text('Pause'));
    await tester.pump();
    expect(find.text('Start'), findsOneWidget);
  });

  testWidgets('reset stopwatch', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StopwatchModel()),
        ],
        child: MaterialApp(
          home: StopwatchHomeMain(),
        ),
      ),
    );

    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.tap(find.text('Pause'));
    await tester.pump();
    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(find.text('00:00.00'), findsOneWidget);
  });

  testWidgets('add and clear laps', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StopwatchModel()),
        ],
        child: MaterialApp(
          home: StopwatchHomeMain(),
        ),
      ),
    );

    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.tap(find.text('Pause'));
    await tester.pump();
    await tester.tap(find.text('Lap'));
    await tester.pump();
    expect(find.textContaining('Lap 1'), findsOneWidget);
    await tester.tap(find.text('Clear laps'));
    await tester.pump();
    expect(find.textContaining('Lap 1'), findsNothing);
  });
}
