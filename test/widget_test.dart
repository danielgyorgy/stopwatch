import 'package:flutter/material.dart'; 
import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/analog_clock.dart';
import 'package:stopwatch/stopwatch.dart';

void main() {
  group('StopwatchHome widget tests', () {
  
    testWidgets('Test initial UI', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: StopwatchHome()));

      // Test the initial UI elements
      expect(find.text('00:00.00'), findsOneWidget);
      expect(find.byType(AnalogClock), findsOneWidget);
      expect(find.text('Start'), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);
      expect(find.text('Lap'), findsOneWidget);
      expect(find.text('Clear laps'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });

   
  });
}



