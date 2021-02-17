import 'package:flutter/material.dart';
import 'dart:math';

class WavePainter extends CustomPainter {
  final double _animValue;
  final Color color;
  final int wavePeriod;
  final int waveOffset;
  final int waveAmplitude;

  WavePainter(this._animValue, this.color, this.wavePeriod, this.waveOffset, this.waveAmplitude);

  final Path path = Path();


  int SEGMENTS_PER_PERIOD = 60;

  var TWO_PI = 2 * pi;

  double calculateOffsetRadians(double lineStart, double pointX) {
    final proportionOfPeriod = (pointX - lineStart) / wavePeriod;
    return proportionOfPeriod * TWO_PI;
  }


  @override
  void paint(Canvas canvas, Size size) {
    //print("---- ${_animValue}");

    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));

    final paint = Paint()
      ..color = this.color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final double lineStart = _animValue - size.width;
    final double lineEnd = size.width;

    final baseline = 30;

    // we need a point at least every segmentWidth, this defines the point
    final double segmentWidth = wavePeriod / SEGMENTS_PER_PERIOD;
    final int amountPoints =
    (((lineEnd - lineStart) ~/ segmentWidth) + 1).ceil();

    path.reset();

    var pointX = lineStart;

    for (int i = 0; i < amountPoints; i++) {
      final radiansX =
          calculateOffsetRadians(lineStart, pointX) + waveOffset;
      final offsetY = sin(radiansX) * waveAmplitude;
      final y = baseline + offsetY;

      if (i == 0) {
        path.moveTo(pointX, y);
      } else {
        path.lineTo(pointX, y);
      }

      pointX = pointX + (segmentWidth);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}