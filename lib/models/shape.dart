// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ShapeType { line, rectangle, ellipse, triangle, freeDraw, text}

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

  void move(Offset newPosition) {
    Offset offset = newPosition - startPosition;
    startPosition += offset;
    endPosition += offset;
    if (points.isNotEmpty) {
      points = points.map((point) => point + offset).toList();
    }
  }

  void resize(Offset newEndPosition) {
    endPosition = newEndPosition;
  }

  @override
  List<Object?> get props => [type, startPosition, endPosition, points, color, text];

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
