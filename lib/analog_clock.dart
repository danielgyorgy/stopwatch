import 'dart:math'; // Matematikai műveletekhez szükséges csomag importálása

import 'package:flutter/material.dart'; // A Flutter keretrendszer alapvető csomagjának importálása

// Az analóg óra widget definiálása
class AnalogClock extends StatelessWidget {
  final ValueNotifier<Duration> elapsedTime; // Az eltelt idő figyeléséhez szükséges változó

  const AnalogClock({super.key, required this.elapsedTime});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: elapsedTime,
      builder: (context, value, child) {
        final milliseconds = value.inMilliseconds; // Az eltelt idő milliszekundumban
        final seconds = milliseconds / 1000; // Az eltelt idő másodpercben
        final minutes = seconds / 60; // Az eltelt idő percekben
        final hours = minutes / 60; // Az eltelt idő órákban

        return SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(
            painter: ClockPainter(
              hours: hours,
              minutes: minutes,
              seconds: seconds,
            ),
          ),
        );
      },
    );
  }
}

// Az óra festéséhez szükséges osztály definiálása
class ClockPainter extends CustomPainter {
  final double hours;
  final double minutes;
  final double seconds;

  ClockPainter({required this.hours, required this.minutes, required this.seconds});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2); // Az óra középpontjának kiszámítása
    final radius = min(size.width / 2, size.height / 2); // Az óra sugarának meghatározása
    final paint = Paint()..color = Colors.black;

    // Óra háttér rajzolása színátmenettel
    final gradient = RadialGradient(
      colors: [Colors.grey[800]!, Colors.black],
      stops: const [0.9, 1.0],
    );
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradientPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawCircle(center, radius, gradientPaint);

    // Óra körének rajzolása
    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;
    canvas.drawCircle(center, radius, paint);

    // Óra órajelzéseinek rajzolása
    paint.strokeWidth = 2;
    for (int i = 0; i < 12; i++) {
      final angle = (pi / 6) * i;
      final start = center + Offset(radius * 0.8 * cos(angle), radius * 0.8 * sin(angle));
      final end = center + Offset(radius * 0.9 * cos(angle), radius * 0.9 * sin(angle));
      canvas.drawLine(start, end, paint);
    }

    // Óra percjelzéseinek rajzolása
    paint.strokeWidth = 1;
    for (int i = 0; i < 60; i++) {
      if (i % 5 != 0) {
        final angle = (pi / 30) * i;
        final start = center + Offset(radius * 0.85 * cos(angle), radius * 0.85 * sin(angle));
        final end = center + Offset(radius * 0.9 * cos(angle), radius * 0.9 * sin(angle));
        canvas.drawLine(start, end, paint);
      }
    }

    // Óra mutatóinak rajzolása
    // Óramutató
    paint.color = Colors.white;
    paint.strokeWidth = 6;
    final hourHandLength = radius * 0.5;
    final hourAngle = (pi / 6) * (hours % 12);
    _drawHand(canvas, center, hourHandLength, hourAngle, paint);

    // Percmutató
    paint.strokeWidth = 4;
    final minuteHandLength = radius * 0.7;
    final minuteAngle = (pi / 30) * (minutes % 60);
    _drawHand(canvas, center, minuteHandLength, minuteAngle, paint);

    // Másodpercmutató
    paint.color = Colors.red;
    paint.strokeWidth = 2;
    final secondHandLength = radius * 0.9;
    final secondAngle = (pi / 30) * (seconds % 60);
    _drawHand(canvas, center, secondHandLength, secondAngle, paint);

    // Középpont rajzolása
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, 5, paint);
  }

  // Segédfüggvény a mutatók rajzolásához
  void _drawHand(Canvas canvas, Offset center, double length, double angle, Paint paint) {
    final end = center + Offset(length * cos(angle - pi / 2), length * sin(angle - pi / 2));
    canvas.drawLine(center, end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Mindig újra kell festeni, ha változás történik
  }
}
