// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:project1/models/shape.dart';

// class ImageShape extends Shape {
//   final ui.Image image;

//   ImageShape({
//     required super.type,
//     required super.startPosition,
//     required super.endPosition,
//     required this.image,
//   });

//   @override
//   void draw(Canvas canvas) {
//     final src =
//         Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
//     final dst = Rect.fromLTWH(
//         startPosition.dx, startPosition.dy, endPosition.dx, endPosition.dy);
//     canvas.drawImageRect(image, src, dst, Paint());
//   }

//   @override
//   List<Object?> get props => super.props..add(image);
// }

class ImageShape extends Shape {
  final List<Pixel> pixels;
  final ui.Image? image;

  ImageShape({
    required super.type,
    required super.startPosition,
    required super.endPosition,
    super.points = const [],
    super.color = Colors.black,
    super.text = '',
    required this.pixels,
    this.image,
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

Future<ui.Image> pixelsToImage(
    List<Pixel> pixels, int width, int height) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(
      recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));

  final paint = Paint();
  for (final pixel in pixels) {
    paint.color = pixel.color;
    canvas.drawRect(
        Rect.fromLTWH(pixel.position.dx, pixel.position.dy, 1, 1), paint);
  }

  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  return image;
}
