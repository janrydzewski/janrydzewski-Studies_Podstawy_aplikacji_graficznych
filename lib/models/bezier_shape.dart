import 'package:flutter/material.dart';
import 'package:project1/models/shape.dart';

class BezierShape extends Shape {
  final List<Offset> controlPoints;

  BezierShape({
    required super.type,
    required super.startPosition,
    required super.endPosition,
    required super.color,
    required this.controlPoints,
  });

  @override
  List<Object?> get props => [];
}
