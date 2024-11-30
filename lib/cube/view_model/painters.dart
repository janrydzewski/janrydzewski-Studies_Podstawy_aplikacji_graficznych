import 'package:flutter/material.dart';

class RGBPainterBack extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (int x = 0; x < size.width; x++) {
      for (int y = 0; y < size.height; y++) {
        int red = (255 - (y * 255 / size.height)).toInt();
        int green = 0;
        int blue = (255 - (x * 255 / size.width)).toInt();

        Color color = Color.fromARGB(255, red, green, blue);

        Paint paint = Paint()..color = color;
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class RGBPainterBottom extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (int x = 0; x < size.width; x++) {
      for (int y = 0; y < size.height; y++) {
        int red = 0;
        int green = (255 - (y * 255 / size.width)).toInt();
        int blue = (x * 255 / size.height).toInt();

        Color color = Color.fromARGB(255, red, green, blue);

        Paint paint = Paint()..color = color;
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class RGBPainterRight extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (int x = 0; x < size.width; x++) {
      for (int y = 0; y < size.height; y++) {
        int red = (255 - (y * 255 / size.height)).toInt();
        int green = (255 - (x * 255 / size.width)).toInt();
        int blue = 255;

        Color color = Color.fromARGB(255, red, green, blue);

        Paint paint = Paint()..color = color;
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class RGBPainterFront extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (int x = 0; x < size.width; x++) {
      for (int y = 0; y < size.height; y++) {
        int red = (255 - (y * 255 / size.height)).toInt();
        int green = 255;
        int blue = (x * 255 / size.width).toInt();

        Color color = Color.fromARGB(255, red, green, blue);

        Paint paint = Paint()..color = color;
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class RGBPainterTop extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (int x = 0; x < size.width; x++) {
      for (int y = 0; y < size.height; y++) {
        int red = 255;
        int green = (y * 255 / size.width).toInt();
        int blue = (x * 255 / size.height).toInt();

        Color color = Color.fromARGB(255, red, green, blue);

        Paint paint = Paint()..color = color;
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class RGBPainterLeft extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (int x = 0; x < size.width; x++) {
      for (int y = 0; y < size.height; y++) {
        int red = (255 - (y * 255 / size.height)).toInt();
        int green = (x * 255 / size.width).toInt();
        int blue = 0;

        Color color = Color.fromARGB(255, red, green, blue);

        Paint paint = Paint()..color = color;
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

enum CubeFace { left, front, back, top, bottom, right }
