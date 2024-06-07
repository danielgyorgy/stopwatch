import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test stopwatch functionality', () {
    // Create a stopwatch
    final stopwatch = Stopwatch();

    // Start the stopwatch
    stopwatch.start();

    // Wait for some time
    Future.delayed(const Duration(seconds: 1));

    // Stop the stopwatch
    stopwatch.stop();

    // Verify that elapsed time is greater than zero
    expect(stopwatch.elapsed, greaterThan(Duration.zero));

    // Reset the stopwatch
    stopwatch.reset();

    // Verify that elapsed time is zero after resetting
    expect(stopwatch.elapsed, Duration.zero);
  });
}
