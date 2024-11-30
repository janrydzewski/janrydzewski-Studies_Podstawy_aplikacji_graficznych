// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:project1/models/shape.dart';

class ImageShape extends Shape {
  final List<Pixel> pixels;

  ImageShape({
    required super.type,
    required super.startPosition,
    required super.endPosition,
    super.points = const [],
    super.color = Colors.black,
    super.text = '',
    required this.pixels,
  });

  @override
  List<Object?> get props => super.props..add(pixels);
}

class Pixel {
  final Offset position;
  final Color color;

  Pixel(this.position, this.color);

  @override
  String toString() => 'Pixel(position: $position, color: $color)';
}
