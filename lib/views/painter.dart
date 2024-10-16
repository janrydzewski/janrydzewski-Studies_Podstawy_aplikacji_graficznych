import 'package:flutter/material.dart';
import 'package:project1/models/shape.dart';

class BoardPainter extends CustomPainter {
  final List<Shape> shapes;
  final Shape? currentShape;

  BoardPainter(this.shapes, this.currentShape);

  @override
  void paint(Canvas canvas, Size size) {
    for (var shape in shapes) {
      _drawShape(canvas, shape);
    }

    if (currentShape != null) {
      _drawShape(canvas, currentShape!);
    }
  }

  void _drawShape(Canvas canvas, Shape shape) {
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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
