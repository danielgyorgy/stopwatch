// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:async'; // Importing package required for asynchronous operations
import 'package:flutter/material.dart'; // Importing the core Flutter framework package
import 'analog_clock.dart'; // Importing the analog clock widget

class StopwatchHome extends StatefulWidget {
  const StopwatchHome({Key? key});

  @override
  _StopwatchHomeState createState() => _StopwatchHomeState();
}

// Creating the state management class for the stopwatch
class _StopwatchHomeState extends State<StopwatchHome> {
   Stopwatch _stopwatch = Stopwatch(); // Instantiating the stopwatch
   Timer _timer = Timer(const Duration(), () { }); // Timer for updating the stopwatch
  final _elapsedTime =
      ValueNotifier<Duration>(Duration.zero); // Watching the elapsed time
  final List<Duration> _laps = []; // Storing lap times
  bool _isRunning = false; // Monitoring the stopwatch state (running or not)
  final TextStyle _bigTextStyle = const TextStyle(
      fontSize: 48, fontWeight: FontWeight.bold); // Style for large text
  final TextStyle _buttonTextStyle = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold); // Style for button text
  final TextStyle _lapTitleTextStyle =
      const TextStyle(fontWeight: FontWeight.bold); // Style for lap title

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch(); // Initializing the stopwatch
  }

  // Starting or pausing the stopwatch
  void _toggleStartPause() {
    if (_isRunning) {
      _pause(); // If the stopwatch is running, pause it
    } else {
      _start(); // If the stopwatch is paused, start it
    }
  }

  // Starting the stopwatch
  void _start() {
    _stopwatch.start(); // Start the stopwatch
    _isRunning = true; // Set state to running
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _elapsedTime.value =
          _stopwatch.elapsed; // Update elapsed time every 16 ms
    });
    setState(() {}); // Update state to redraw the widget
  }

  // Pausing the stopwatch
  void _pause() {
    _stopwatch.stop(); // Stop the stopwatch
    _isRunning = false; // Set state to paused
    _timer.cancel(); // Cancel the timer
    setState(() {}); // Update state to redraw the widget
  }

  // Resetting the stopwatch
  void _reset() {
    _stopwatch.reset(); // Reset the stopwatch
    _stopwatch.stop(); // Stop the stopwatch

    _elapsedTime.value = Duration.zero; // Reset the elapsed time
    _isRunning = false; // Set state to paused
    _timer.cancel(); // Cancel the timer
    setState(() {}); // Update state to redraw the widget
  }

  // Recording a lap time
  void _lap() {
    _laps.add(_stopwatch
        .elapsed); // Add the current elapsed time to the lap times list
    setState(() {}); // Update state to redraw the widget
  }

  // Clearing lap times
  void _clearLaps() {
    _laps.clear(); // Clear the lap times list
    setState(() {}); // Update state to redraw the widget
  }
  

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context)
            .height, // Setting height to full screen height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
              Colors.green
            ], // Setting background gradient
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(
                          10), // Rounded corners for the card
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ValueListenableBuilder<Duration>(
                            valueListenable: _elapsedTime,
                            builder: (context, value, child) {
                              final minutes = value.inMinutes
                                  .remainder(60)
                                  .toString()
                                  .padLeft(2, '0');
                              final seconds = value.inSeconds
                                  .remainder(60)
                                  .toString()
                                  .padLeft(2, '0');
                              final milliseconds =
                                  (value.inMilliseconds.remainder(1000) ~/ 10)
                                      .toString()
                                      .padLeft(2, '0');
                              return Text(
                                '$minutes:$seconds.$milliseconds', // Displaying the elapsed time
                                style: _bigTextStyle,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          AnalogClock(
                              elapsedTime:
                                  _elapsedTime), // Embedding the analog clock widget
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed:
                            _toggleStartPause, // Start or pause the stopwatch on button press
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRunning
                              ? Colors.red
                              : Colors
                                  .green, // Setting button color based on state
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          textStyle: _buttonTextStyle,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(_isRunning
                            ? 'Pause'
                            : 'Start'), // Setting button text based on state
                      ),
                      ElevatedButton(
                        onPressed: _stopwatch.elapsed == Duration.zero
                            ? null
                            : _reset, // Disable button if elapsed time is zero
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          textStyle: _buttonTextStyle,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _stopwatch.elapsed == Duration.zero
                            ? null
                            : _lap, // Disable button if elapsed time is zero
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          textStyle: _buttonTextStyle,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Lap'),
                      ),
                      ElevatedButton(
                        onPressed: _laps.isEmpty
                            ? null
                            : _clearLaps, // Disable button if no lap times
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          textStyle: _buttonTextStyle,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Clear laps'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling for the list view
                    shrinkWrap: true,
                    itemCount: _laps.length, // Number of lap times
                    itemBuilder: (context, index) {
                      final lap = _laps.reversed.toList()[
                          index]; // Display lap times in reverse order
                      final minutes = lap.inMinutes
                          .remainder(60)
                          .toString()
                          .padLeft(2, '0');
                      final seconds = lap.inSeconds
                          .remainder(60)
                          .toString()
                          .padLeft(2, '0');
                      final milliseconds =
                          (lap.inMilliseconds.remainder(1000) ~/ 10)
                              .toString()
                              .padLeft(2, '0');
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(
                              10), // Rounded corners for the card
                        ),
                        child: ListTile(
                          leading: const Icon(
                              Icons.flag_circle), // Icon at the beginning of the list item
                          title: Text('Lap ${_laps.length - index}',
                              style: _lapTitleTextStyle), // Lap title
                          trailing: Text(
                              '$minutes:$seconds.$milliseconds'), // Displaying the lap time
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
