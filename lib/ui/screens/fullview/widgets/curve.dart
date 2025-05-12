
import 'dart:ui';

import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  List<List<Offset>> points;

  WaveClipper({required this.points});

  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(0, size.height);
    path.lineTo(0, 0);

    for (var pair in points) {
      for (int i = 0; i < pair.length - 1; i += 2) {
        var control = pair[i];
        var end = pair[i + 1];

        path.quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
      }
    }

    path.lineTo(size.width, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WaveBorderPainter extends CustomPainter {
  final List<List<Offset>> points;
  final Color borderColor;

  WaveBorderPainter({required this.points, this.borderColor = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke;

    Offset currentStart = const Offset(0, 0);

    for (var pair in points) {
      for (int i = 0; i < pair.length - 1; i += 2) {
        final control = pair[i];
        final end = pair[i + 1];

        const int segments = 40;
        Offset prevPoint = currentStart;

        for (int j = 1; j <= segments; j++) {
          final t = j / segments;

          final x =
              (1 - t) * (1 - t) * currentStart.dx +
              2 * (1 - t) * t * control.dx +
              t * t * end.dx;
          final y =
              (1 - t) * (1 - t) * currentStart.dy +
              2 * (1 - t) * t * control.dy +
              t * t * end.dy;

          final point = Offset(x, y);

          double relativeT = (t - 0.5).abs() * 2;
          double strokeWidth = lerpDouble(7.0, 1.0, relativeT)!;

          paint.strokeWidth = strokeWidth;
          canvas.drawLine(prevPoint, point, paint);

          prevPoint = point;
        }

        currentStart = end;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
