import 'dart:async'; // Az aszinkron műveletekhez szükséges csomag importálása
import 'package:flutter/material.dart'; // A Flutter keretrendszer alapvető csomagjának importálása
import 'analog_clock.dart'; // Az analóg óra widget importálása

class StopwatchHome extends StatefulWidget {
  const StopwatchHome({Key? key});

  @override
  _StopwatchHomeState createState() => _StopwatchHomeState();
}

// Az állapotot kezelő osztály létrehozása a stopperhez
class _StopwatchHomeState extends State<StopwatchHome> {
  late Stopwatch _stopwatch; // Stopper példányosítása
  late Timer _timer; // Időzítő a stopper frissítéséhez
  final _elapsedTime =
      ValueNotifier<Duration>(Duration.zero); // Az eltelt idő figyeléséhez
  final List<Duration> _laps = []; // A köridők tárolása
  bool _isRunning = false; // A stopper állapotának figyelése (fut-e vagy sem)
  final TextStyle _bigTextStyle = const TextStyle(
      fontSize: 48, fontWeight: FontWeight.bold); // Nagy méretű szöveg stílusa
  final TextStyle _buttonTextStyle = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold); // Gombok szövegének stílusa
  final TextStyle _lapTitleTextStyle =
      const TextStyle(fontWeight: FontWeight.bold); // Köridő címének stílusa

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch(); // Stopper inicializálása
  }

  // Stopper elindítása vagy megállítása
  void _toggleStartPause() {
    if (_isRunning) {
      _pause(); // Ha a stopper fut, akkor megállítjuk
    } else {
      _start(); // Ha a stopper áll, akkor elindítjuk
    }
  }

  // Stopper indítása
  void _start() {
    _stopwatch.start(); // Stopper indítása
    _isRunning = true; // Állapot beállítása, hogy a stopper fut
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _elapsedTime.value =
          _stopwatch.elapsed; // Az eltelt idő frissítése 16 ms-onként
    });
    setState(() {}); // Az állapot frissítése a widget újrarajzolásához
  }

  // Stopper megállítása
  void _pause() {
    _stopwatch.stop(); // Stopper megállítása
    _isRunning = false; // Állapot beállítása, hogy a stopper áll
    _timer.cancel(); // Időzítő leállítása
    setState(() {}); // Az állapot frissítése a widget újrarajzolásához
  }

  // Stopper visszaállítása
  void _reset() {
    _stopwatch.reset(); // Stopper visszaállítása
    _stopwatch.stop(); // Stopper megállítása

    _elapsedTime.value = Duration.zero; // Az eltelt idő nullázása
    _isRunning = false; // Állapot beállítása, hogy a stopper áll
    _timer.cancel(); // Időzítő leállítása
    setState(() {}); // Az állapot frissítése a widget újrarajzolásához
  }

  // Köridő rögzítése
  void _lap() {
    _laps.add(_stopwatch
        .elapsed); // Az aktuális eltelt idő hozzáadása a köridők listájához
    setState(() {}); // Az állapot frissítése a widget újrarajzolásához
  }

  // Köridők törlése
  void _clearLaps() {
    _laps.clear(); // Köridők listájának törlése
    setState(() {}); // Az állapot frissítése a widget újrarajzolásához
  }

  @override
  void dispose() {
    _timer.cancel(); // Időzítő leállítása
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context)
            .height, // A teljes képernyő magasságának beállítása
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
              Colors.green
            ], // Hátter színátmenet beállítása
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
                          10), // Kártya lekerekített sarkai
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
                                '$minutes:$seconds.$milliseconds', // Az eltelt idő megjelenítése
                                style: _bigTextStyle,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          AnalogClock(
                              elapsedTime:
                                  _elapsedTime), // Az analóg óra widget beillesztése
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
                            _toggleStartPause, // Gomb megnyomásakor a stopper indítása vagy megállítása
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRunning
                              ? Colors.red
                              : Colors
                                  .green, // A gomb színének beállítása az állapottól függően
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          textStyle: _buttonTextStyle,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(_isRunning
                            ? 'Pause'
                            : 'Start'), // A gomb szövegének beállítása az állapottól függően
                      ),
                      ElevatedButton(
                        onPressed: _stopwatch.elapsed == Duration.zero
                            ? null
                            : _reset, // Gomb inaktiválása, ha az eltelt idő nulla
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
                            : _lap, // Gomb inaktiválása, ha az eltelt idő nulla
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
                            : _clearLaps, // Gomb inaktiválása, ha nincs köridő
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
                        const NeverScrollableScrollPhysics(), // A listview görgethetőségének letiltása
                    shrinkWrap: true,
                    itemCount: _laps.length, // A köridők számának megadása
                    itemBuilder: (context, index) {
                      final lap = _laps.reversed.toList()[
                          index]; // Az egyes köridők visszafele történő megjelenítése
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
                              10), // Kártya lekerekített sarkai
                        ),
                        child: ListTile(
                          leading: const Icon(
                              Icons.flag_circle), // Ikon a listaelem elején
                          title: Text('Lap ${_laps.length - index}',
                              style: _lapTitleTextStyle), // Köridő címe
                          trailing: Text(
                              '$minutes:$seconds.$milliseconds'), // Köridő megjelenítése
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
