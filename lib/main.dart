// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart'; // Importing the core Flutter framework package

import 'stopwatch.dart'; // Importing the stopwatch widget

// The main function that starts the application
void main() {
  runApp(const StopwatchApp());
}

// The main widget of the application
class StopwatchApp extends StatelessWidget {
  const StopwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removing the debug banner
      theme: ThemeData.light(), // Setting the light theme
      darkTheme: ThemeData.dark(), // Setting the dark theme
      themeMode: ThemeMode.system, // Setting the theme based on system settings
      home: const StopwatchHome(), // Setting the home page to the stopwatch widget
    );
  }
}
