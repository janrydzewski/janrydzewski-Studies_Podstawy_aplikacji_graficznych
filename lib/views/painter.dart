import 'package:flutter/material.dart';
import 'package:project1/models/bezier_shape.dart';
import 'package:project1/models/image_shape.dart';
import 'package:project1/models/shape.dart';

class BoardPainter extends CustomPainter {
  final List<Shape> shapes;
  final Shape? currentShape;

  BoardPainter(this.shapes, this.currentShape);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    for (var shape in shapes) {
      _drawShape(canvas, shape);
    }

    if (currentShape != null) {
      _drawShape(canvas, currentShape!);
    }
    canvas.restore();
  }

  void _drawShape(Canvas canvas, Shape shape) async {
    if (shape is ImageShape) {
      final double originalWidth = shape.image.width.toDouble();
      final double originalHeight = shape.image.height.toDouble();

      const double maxWidth = 300;
      const double maxHeight = 300;

      double scaleX = maxWidth / originalWidth;
      double scaleY = maxHeight / originalHeight;

      double scale = scaleX < scaleY ? scaleX : scaleY;

      final offset = Offset(
        shape.startPosition.dx,
        shape.startPosition.dy,
      );

      final rect = Rect.fromLTWH(
        offset.dx,
        offset.dy,
        originalWidth * scale,
        originalHeight * scale,
      );

      canvas.drawImageRect(
        shape.image,
        Rect.fromLTWH(0, 0, originalWidth, originalHeight),
        rect,
        Paint(),
      );
    } else if (shape is BezierShape) {
      final paint = Paint()
        ..color = shape.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final points = [
        shape.startPosition,
        ...shape.controlPoints,
        shape.endPosition
      ];

      final path = Path();
      path.moveTo(shape.startPosition.dx, shape.startPosition.dy);

      for (int i = 1; i < points.length - 2; i++) {
        path.cubicTo(points[i].dx, points[i].dy, points[i + 1].dx,
            points[i + 1].dy, points[i + 2].dx, points[i + 2].dy);
      }

      if (points.length == 4) {
        path.quadraticBezierTo(
            points[1].dx, points[1].dy, points[2].dx, points[2].dy);
      }

      canvas.drawPath(path, paint);
    } else {
      final paint = Paint()
        ..color = shape.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      switch (shape.type) {
        case ShapeType.bezier:
          break;
        case ShapeType.pointer:
          break;
        case ShapeType.rectangle:
          final rect = Rect.fromPoints(shape.startPosition, shape.endPosition);
          canvas.drawRect(rect, paint);
          break;
        case ShapeType.ellipse:
          final rect = Rect.fromPoints(shape.startPosition, shape.endPosition);
          canvas.drawOval(rect, paint);
          break;
        case ShapeType.triangle:
          final path = Path();
          path.moveTo(shape.startPosition.dx, shape.startPosition.dy);
          path.lineTo(shape.endPosition.dx, shape.endPosition.dy);
          path.lineTo(shape.startPosition.dx * 2 - shape.endPosition.dx,
              shape.endPosition.dy);
          path.close();
          canvas.drawPath(path, paint);
          break;
        case ShapeType.line:
          canvas.drawLine(shape.startPosition, shape.endPosition, paint);
          break;
        case ShapeType.freeDraw:
          if (shape.points.isNotEmpty) {
            for (int i = 0; i < shape.points.length - 1; i++) {
              canvas.drawLine(shape.points[i], shape.points[i + 1], paint);
            }
          }
          break;
        case ShapeType.polygon:
          if (shape.points.isNotEmpty) {
            for (int i = 0; i < shape.points.length - 1; i++) {
              canvas.drawLine(shape.points[i], shape.points[i + 1], paint);
            }
            if (shape.type == ShapeType.polygon) {
              canvas.drawLine(shape.points.last, shape.points.first, paint);
            }
          }
          break;
        case ShapeType.text:
          final textPainter = TextPainter(
            text: TextSpan(
              text: shape.text,
              style: TextStyle(color: shape.color, fontSize: 20),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(canvas, shape.startPosition);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

void _drawImage(Canvas canvas, ImageShape imageShape) {
  final src = Rect.fromLTWH(0, 0, imageShape.image.width.toDouble(),
      imageShape.image.height.toDouble());
  final dst = Rect.fromLTWH(
      imageShape.startPosition.dx,
      imageShape.startPosition.dy,
      imageShape.endPosition.dx,
      imageShape.endPosition.dy);
  canvas.drawImageRect(imageShape.image, src, dst, Paint());
}
