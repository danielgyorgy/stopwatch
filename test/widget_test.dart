import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/stopwatch.dart';

void main() {
  testWidgets('Test reset functionality', (WidgetTester tester) async {
    await tester.pumpWidget(const StopwatchHome());

    // Start the stopwatch
    await tester.tap(find.byKey(const Key('start_pause_button')));
    await tester.pump();

    // Reset the stopwatch
    await tester.tap(find.byKey(const Key('reset_button')));
    await tester.pump();

    // Verify that the stopwatch is not running
    expect(find.text('Start'), findsOneWidget);

    // Verify that the elapsed time is zero
    expect(find.text('00:00.00'), findsOneWidget);
  });

  testWidgets('Test lap functionality', (WidgetTester tester) async {
    await tester.pumpWidget(const StopwatchHome());

    // Start the stopwatch
    await tester.tap(find.byKey(const Key('start_pause_button')));
    await tester.pump();

    // Wait for some time
    await tester.pump(const Duration(seconds: 1));

    // Add a lap
    await tester.tap(find.byKey(const Key('lap_button')));
    await tester.pump();

    // Verify that a lap is recorded
    expect(find.text('Lap 1'), findsOneWidget);

    // Stop the stopwatch
    await tester.tap(find.byKey(const Key('start_pause_button')));
    await tester.pump();

    // Add another lap
    await tester.tap(find.byKey(const Key('lap_button')));
    await tester.pump();

    // Verify that the second lap is recorded
    expect(find.text('Lap 2'), findsOneWidget);

    // Verify that laps are in descending order
    expect(find.byType(ListTile), findsNWidgets(2));
  });

  testWidgets('Test clear laps functionality', (WidgetTester tester) async {
    await tester.pumpWidget(const StopwatchHome());

    // Start the stopwatch
    await tester.tap(find.byKey(const Key('start_pause_button')));
    await tester.pump();

    // Add a lap
    await tester.tap(find.byKey(const Key('lap_button')));
    await tester.pump();

    // Clear the laps
    await tester.tap(find.byKey(const Key('clear_laps_button')));
    await tester.pump();

    // Verify that there are no laps recorded
    expect(find.byType(ListTile), findsNothing);
  });
}
