// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart'; // A Flutter keretrendszer alapvető csomagjának importálása

import 'stopwatch.dart'; // A stopper widget importálása

// A fő függvény, amely elindítja az alkalmazást
void main() {
  runApp(const StopwatchApp());
}

// Az alkalmazás fő widgetje
class StopwatchApp extends StatelessWidget {
  const StopwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Fejlesztési banner eltávolítása
      theme: ThemeData.light(), // Világos téma beállítása
      darkTheme: ThemeData.dark(), // Sötét téma beállítása
      themeMode: ThemeMode.system, // A téma beállítása a rendszer beállításaihoz képest
      home: const StopwatchHome(), // A főoldal beállítása a stopper widgetre
    );
  }
}
