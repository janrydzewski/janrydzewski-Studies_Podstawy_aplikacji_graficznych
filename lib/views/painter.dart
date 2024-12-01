import 'package:flutter/material.dart';
import 'package:project1/models/image_processing_model.dart';
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

  void _drawShape(Canvas canvas, Shape shape) {
    if (shape is ImageShape) {
      final double originalWidth = shape.endPosition.dx;
      final double originalHeight = shape.endPosition.dy;

      const double maxWidth = 300;
      const double maxHeight = 300;

      double scaleX = maxWidth / originalWidth;
      double scaleY = maxHeight / originalHeight;

      double scale = 1.0;
      if (scaleX < scaleY) {
        scale = scaleX;
      } else {
        scale = scaleY;
      }

      const int pixelSize = 1;

      if (SelectedFilter.filter < 7) {
        final newPixels = getFilterA(shape.pixels);
        for (var pixel in newPixels) {
          final paint = Paint()..color = pixel.color;

          final scaledPosition = Offset(
            pixel.position.dx * scale,
            pixel.position.dy * scale,
          );

          final rect = Rect.fromLTWH(
            scaledPosition.dx,
            scaledPosition.dy,
            pixelSize.toDouble() * scale,
            pixelSize.toDouble() * scale,
          );
          canvas.drawRect(rect, paint);
        }
      } else {
        final newShape = getFilterB(shape);
        for (var pixel in newShape.pixels) {
          final paint = Paint()..color = pixel.color;

          final scaledPosition = Offset(
            pixel.position.dx * scale,
            pixel.position.dy * scale,
          );

          final rect = Rect.fromLTWH(
            scaledPosition.dx,
            scaledPosition.dy,
            pixelSize.toDouble() * scale,
            pixelSize.toDouble() * scale,
          );
          canvas.drawRect(rect, paint);
        }
      }

      // for (var pixel in newPixels) {
      //   final paint = Paint()..color = pixel.color;

      //   final scaledPosition = Offset(
      //     pixel.position.dx * scale,
      //     pixel.position.dy * scale,
      //   );

      //   final rect = Rect.fromLTWH(
      //     scaledPosition.dx,
      //     scaledPosition.dy,
      //     pixelSize.toDouble() * scale,
      //     pixelSize.toDouble() * scale,
      //   );
      //   canvas.drawRect(rect, paint);
      // }
    } else {
      final paint = Paint()
        ..color = shape.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      switch (shape.type) {
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
