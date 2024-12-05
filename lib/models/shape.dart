// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ShapeType {
  line,
  rectangle,
  ellipse,
  triangle,
  freeDraw,
  text,
  polygon,
  bezier,
  pointer,
}

class Shape extends Equatable {
  final ShapeType type;
  Offset startPosition;
  Offset endPosition;
  List<Offset> points;
  Color color;
  String text;

  Shape(
      {required this.type,
      required this.startPosition,
      required this.endPosition,
      this.points = const [],
      this.color = Colors.black,
      this.text = ''});

  void move(Offset offset) {
    startPosition += offset;
    endPosition += offset;
    if (points.isNotEmpty) {
      points = points.map((point) => point + offset).toList();
    }
  }

  void resize(Offset newEndPosition) {
    endPosition = newEndPosition;
    if (points.isNotEmpty) {
      points = points
          .map((point) => point.scale(
                (newEndPosition.dx - startPosition.dx) /
                    (endPosition.dx - startPosition.dx),
                (newEndPosition.dy - startPosition.dy) /
                    (endPosition.dy - startPosition.dy),
              ))
          .toList();
    }
  }

  void rotate(double angle) {
    final center = Offset(
      (startPosition.dx + endPosition.dx) / 2,
      (startPosition.dy + endPosition.dy) / 2,
    );
    startPosition = _rotatePoint(startPosition, center, angle);
    endPosition = _rotatePoint(endPosition, center, angle);
    if (points.isNotEmpty) {
      points =
          points.map((point) => _rotatePoint(point, center, angle)).toList();
    }
  }

  Offset _rotatePoint(Offset point, Offset center, double angle) {
    double rad = angle * (3.141592653589793 / 180);
    double cosAngle = cos(rad);
    double sinAngle = sin(rad);

    double dx = point.dx - center.dx;
    double dy = point.dy - center.dy;

    double newX = center.dx + (dx * cosAngle - dy * sinAngle);
    double newY = center.dy + (dx * sinAngle + dy * cosAngle);

    return Offset(newX, newY);
  }

  void draw(Canvas canvas) {}

  @override
  List<Object?> get props =>
      [type, startPosition, endPosition, points, color, text];

  Shape copyWith({
    ShapeType? type,
    Offset? startPosition,
    Offset? endPosition,
    List<Offset>? points,
    Color? color,
    String? text,
  }) {
    return Shape(
      type: type ?? this.type,
      startPosition: startPosition ?? this.startPosition,
      endPosition: endPosition ?? this.endPosition,
      points: points ?? this.points,
      color: color ?? this.color,
      text: text ?? this.text,
    );
  }
}
