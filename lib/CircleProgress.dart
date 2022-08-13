import 'dart:math';
import 'package:flutter/material.dart';
import 'sizeConfig.dart';

class CircleProgress extends CustomPainter {
  double value;
  bool isTemp;
  bool isHum;
  bool isLux;
  bool isSoil;

  CircleProgress(this.value, this.isTemp, this.isHum, this.isLux, this.isSoil);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    int maximumValue;
    if(isTemp) {
      maximumValue = 50;
    }
    else if(isHum) {
      maximumValue = 100;
    }
    else if(isLux) {
      maximumValue = 100000;
    }
    else if (isSoil) {
      maximumValue = 100;
    }

    Paint outerCircle = Paint()
      ..strokeWidth = 14
      ..color = Color(0xFF9A67AC)
      ..style = PaintingStyle.stroke;

    Paint tempArc = Paint()
      ..strokeWidth = 14
      ..color = Color(0xFFF7941E)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint humidityArc = Paint()
      ..strokeWidth = 14
      ..color = Color(0xFF9CDBEE)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint luxArc = Paint()
      ..strokeWidth = 14
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint soilArc = Paint()
      ..strokeWidth = 14
      ..color = Color(0xFFC49A6C)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, 0.45*size.height);
    double radius = min(182 / 2, 182 / 2) - 14;
    canvas.drawCircle(center, radius, outerCircle);

    double angle = 2 * pi * (value / maximumValue);

    if(isTemp) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
      angle, false, tempArc);
    }
    else if(isHum) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
          angle, false, humidityArc);
    }
    else if(isLux) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
          angle, false, luxArc);
    }
    else if(isSoil) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
          angle, false, soilArc);
    }
  }
}
