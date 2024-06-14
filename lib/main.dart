import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stopwatch_model.dart';
import 'analog_clock.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StopwatchModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StopwatchHomeMain(),
    );
  }
}

class StopwatchHomeMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white, Colors.green],
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
                      borderRadius: BorderRadiusDirectional.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Consumer<StopwatchModel>(
                            builder: (context, stopwatchModel, child) {
                              final elapsed = stopwatchModel.elapsedTime;
                              final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
                              final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
                              final milliseconds = (elapsed.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
                              return Text(
                                '$minutes:$seconds.$milliseconds',
                                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Consumer<StopwatchModel>(
                            builder: (context, stopwatchModel, child) {
                              return AnalogClock(elapsedTime: ValueNotifier(stopwatchModel.elapsedTime));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Consumer<StopwatchModel>(
                        builder: (context, stopwatchModel, child) {
                          return ElevatedButton(
                            onPressed: stopwatchModel.isRunning ? stopwatchModel.pause : stopwatchModel.start,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: stopwatchModel.isRunning ? Colors.red : Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(stopwatchModel.isRunning ? 'Pause' : 'Start'),
                          );
                        },
                      ),
                      Consumer<StopwatchModel>(
                        builder: (context, stopwatchModel, child) {
                          return ElevatedButton(
                            onPressed: stopwatchModel.elapsedTime == Duration.zero ? null : stopwatchModel.reset,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Reset'),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Consumer<StopwatchModel>(
                        builder: (context, stopwatchModel, child) {
                          return ElevatedButton(
                            onPressed: stopwatchModel.elapsedTime == Duration.zero ? null : stopwatchModel.lap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Lap'),
                          );
                        },
                      ),
                      Consumer<StopwatchModel>(
                        builder: (context, stopwatchModel, child) {
                          return ElevatedButton(
                            onPressed: stopwatchModel.laps.isEmpty ? null : stopwatchModel.clearLaps,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Clear laps'),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Consumer<StopwatchModel>(
                    builder: (context, stopwatchModel, child) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: stopwatchModel.laps.length,
                        itemBuilder: (context, index) {
                          final lap = stopwatchModel.laps.reversed.toList()[index];
                          final minutes = lap.inMinutes.remainder(60).toString().padLeft(2, '0');
                          final seconds = lap.inSeconds.remainder(60).toString().padLeft(2, '0');
                          final milliseconds = (lap.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusDirectional.circular(10),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.flag_circle),
                              title: Text('Lap ${stopwatchModel.laps.length - index}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              trailing: Text('$minutes:$seconds.$milliseconds'),
                            ),
                          );
                        },
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
