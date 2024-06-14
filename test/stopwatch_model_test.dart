import 'package:flutter_test/flutter_test.dart';
import 'package:stopwatch/stopwatch_model.dart';

void main() {
  group('StopwatchModel', () {
    late StopwatchModel stopwatchModel;

    setUp(() {
      stopwatchModel = StopwatchModel();
    });

    test('initial values are correct', () {
      expect(stopwatchModel.elapsedTime, Duration.zero);
      expect(stopwatchModel.isRunning, false);
      expect(stopwatchModel.laps, []);
    });

    test('start and stop stopwatch', () {
      stopwatchModel.start();
      expect(stopwatchModel.isRunning, true);
      stopwatchModel.pause();
      expect(stopwatchModel.isRunning, false);
    });

    test('reset stopwatch', () {
      stopwatchModel.start();
      stopwatchModel.pause();
      stopwatchModel.reset();
      expect(stopwatchModel.elapsedTime, Duration.zero);
      expect(stopwatchModel.isRunning, false);
    });

    test('add and clear laps', () {
      stopwatchModel.start();
      Future.delayed(Duration(seconds: 1), () {
        stopwatchModel.lap();
        expect(stopwatchModel.laps.length, 1);
        stopwatchModel.clearLaps();
        expect(stopwatchModel.laps.length, 0);
      });
    });
  });
}
