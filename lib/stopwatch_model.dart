import 'dart:async';
import 'package:flutter/foundation.dart';

class StopwatchModel with ChangeNotifier {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  bool _isRunning = false;
  final List<Duration> _laps = [];

  Duration get elapsedTime => _elapsedTime;
  bool get isRunning => _isRunning;
  List<Duration> get laps => List.unmodifiable(_laps);

  void start() {
    _stopwatch.start();
    _isRunning = true;
    _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      _elapsedTime = _stopwatch.elapsed;
      notifyListeners();
    });
    notifyListeners();
  }

  void pause() {
    _stopwatch.stop();
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    _stopwatch.reset();
    _stopwatch.stop();
    _elapsedTime = Duration.zero;
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void lap() {
    _laps.add(_stopwatch.elapsed);
    notifyListeners();
  }

  void clearLaps() {
    _laps.clear();
    notifyListeners();
  }
}
