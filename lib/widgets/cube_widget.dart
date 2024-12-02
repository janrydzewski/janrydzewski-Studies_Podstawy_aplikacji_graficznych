import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project1/cube/model/cube_model.dart';
import 'package:project1/cube/model/face_model.dart';
import 'package:project1/cube/view_model/painters.dart';
import 'package:vector_math/vector_math_64.dart';

class CubeWidget extends StatefulWidget {
  const CubeWidget({super.key});

  @override
  State<CubeWidget> createState() => _CubeWidgetState();
}

class _CubeWidgetState extends State<CubeWidget> {
  double _rx = pi / 5, _ry = pi / 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCube(
          delta: Vector2(_rx, _ry),
          size: 100,
          left: FaceModel(painter: RGBPainterLeft()),
          front: FaceModel(painter: RGBPainterFront()),
          back: FaceModel(painter: RGBPainterBack()),
          top: FaceModel(painter: RGBPainterTop()),
          bottom: FaceModel(painter: RGBPainterBottom()),
          right: FaceModel(painter: RGBPainterRight()),
        ),
        const SizedBox(
          height: 20,
        ),
        Slider(
          value: _rx,
          min: pi / -2,
          max: pi,
          onChanged: (value) => setState(() {
            _rx = value;
          }),
        ),
        Slider(
          value: _ry,
          min: pi / -2,
          max: pi,
          onChanged: (value) => setState(() {
            _ry = value;
          }),
        ),
      ],
    );
  }
}
