import 'dart:math'; // Importing the package for mathematical operations

import 'package:flutter/material.dart'; // Importing the core Flutter framework package

// Defining the analog clock widget
class AnalogClock extends StatelessWidget {
  final ValueNotifier<Duration> elapsedTime; // Variable for tracking the elapsed time

  const AnalogClock({Key? key, required this.elapsedTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: elapsedTime,
      builder: (context, value, child) {
        final milliseconds = value.inMilliseconds; // Elapsed time in milliseconds
        final seconds = milliseconds / 1000; // Elapsed time in seconds
        final minutes = seconds / 60; // Elapsed time in minutes
        final hours = minutes / 60; // Elapsed time in hours

        return LayoutBuilder(
          builder: (context, constraints) {
            // Calculating the size of the clock widget based on the screen dimensions
            final size = constraints.biggest.shortestSide * 0.8;

            return SizedBox(
              width: size,
              height: size,
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
      },
    );
  }
}

// Defining the class for painting the clock
class ClockPainter extends CustomPainter {
  final double hours;
  final double minutes;
  final double seconds;

  ClockPainter({required this.hours, required this.minutes, required this.seconds});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2); // Calculating the center of the clock
    final radius = min(size.width / 2, size.height / 2); // Determining the radius of the clock
    final paint = Paint()..color = Colors.black;

    // Drawing the clock background with a gradient
    final gradient = RadialGradient(
      colors: [Colors.grey[800]!, Colors.black],
      stops: const [0.9, 1.0],
    );
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradientPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawCircle(center, radius, gradientPaint);

    // Drawing the clock's circle
    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;
    canvas.drawCircle(center, radius, paint);

    // Drawing the hour marks
    paint.strokeWidth = 2;
    for (int i = 0; i < 12; i++) {
      final angle = (pi / 6) * i;
      final start = center + Offset(radius * 0.8 * cos(angle), radius * 0.8 * sin(angle));
      final end = center + Offset(radius * 0.9 * cos(angle), radius * 0.9 * sin(angle));
      canvas.drawLine(start, end, paint);
    }

    // Drawing the minute marks
    paint.strokeWidth = 1;
    for (int i = 0; i < 60; i++) {
      if (i % 5 != 0) {
        final angle = (pi / 30) * i;
        final start = center + Offset(radius * 0.85 * cos(angle), radius * 0.85 * sin(angle));
        final end = center + Offset(radius * 0.9 * cos(angle), radius * 0.9 * sin(angle));
        canvas.drawLine(start, end, paint);
      }
    }

    // Drawing the clock hands
    // Hour hand
    paint.color = Colors.white;
    paint.strokeWidth = 6;
    final hourHandLength = radius * 0.5;
    final hourAngle = (pi / 6) * (hours % 12);
    _drawHand(canvas, center, hourHandLength, hourAngle, paint);

    // Minute hand
    paint.strokeWidth = 4;
    final minuteHandLength = radius * 0.7;
    final minuteAngle = (pi / 30) * (minutes % 60);
    _drawHand(canvas, center, minuteHandLength, minuteAngle, paint);

    // Second hand
    paint.color = Colors.red;
    paint.strokeWidth = 2;
    final secondHandLength = radius * 0.9;
    final secondAngle = (pi / 30) * (seconds % 60);
    _drawHand(canvas, center, secondHandLength, secondAngle, paint);

    // Drawing the center point
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, 5, paint);
  }

  // Helper function for drawing the hands
  void _drawHand(Canvas canvas, Offset center, double length, double angle, Paint paint) {
    final end = center + Offset(length * cos(angle - pi / 2), length * sin(angle - pi / 2));
    canvas.drawLine(center, end, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Always repaint when changes occur
  }
}
