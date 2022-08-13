import 'package:flutter/material.dart';
import 'sizeConfig.dart';

class CustomBorderCenter extends ShapeBorder {
  const CustomBorderCenter();

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection textDirection }) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection textDirection }) {
    return Path()
      ..moveTo(rect.left + rect.width / 2, rect.top)
      ..lineTo(rect.right - rect.width / 4, rect.top)
      ..lineTo(rect.right - rect.width / 8, rect.top + rect.height / 4.0)
      ..lineTo(rect.right, rect.top + rect.height / 4.0)
      ..lineTo(rect.right, rect.bottom - rect.height / 4.0)
      ..lineTo(rect.right  - rect.width / 8, rect.bottom - rect.height / 4.0)
      ..lineTo(rect.right - rect.width / 4, rect.bottom)
      ..lineTo(rect.left + rect.width/4,rect.bottom)
      ..lineTo(rect.left + rect.width/8, rect.bottom - rect.height / 4.0)
      ..lineTo(rect.left, rect.bottom - rect.height / 4.0)
      ..lineTo(rect.left, rect.top + rect.height / 4.0)
      ..lineTo(rect.left + rect.width/8, rect.top + rect.height / 4)
      ..lineTo(rect.left + rect.width/4, rect.top)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection textDirection }) {}

  // This border doesn't support scaling.
  @override
  ShapeBorder scale(double t) {
    return null;
  }
}

class CustomBorderRight extends ShapeBorder {
  const CustomBorderRight();

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection textDirection }) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection textDirection }) {
    return Path()
      ..moveTo(rect.left + rect.width / 2, rect.top)
      ..lineTo(rect.right - rect.width / 4, rect.top)
      ..lineTo(rect.right - rect.width / 8, rect.top + rect.height / 4.0)
      ..lineTo(rect.right, rect.top + rect.height / 4.0)
      ..lineTo(rect.right, rect.bottom - rect.height / 4.0)
      ..lineTo(rect.right  - rect.width / 8, rect.bottom - rect.height / 4.0)
      ..lineTo(rect.right - rect.width / 4, rect.bottom)
      ..lineTo(rect.left + rect.width/4,rect.bottom)
      ..lineTo(rect.left + rect.width/8, rect.bottom - rect.height / 4.0)
      ..lineTo(rect.left + rect.width/8, rect.top + rect.height / 4.0)
      ..lineTo(rect.left, rect.top + rect.height / 4.0)
      ..lineTo(rect.left + rect.width/8, rect.top + rect.height / 4)
      ..lineTo(rect.left + rect.width/4, rect.top)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection textDirection }) {}

  // This border doesn't support scaling.
  @override
  ShapeBorder scale(double t) {
    return null;
  }
}