import 'package:flutter/material.dart';

class FaceModel extends StatelessWidget {
  final CustomPainter painter;
  const FaceModel({super.key, required this.painter});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 256,
      height: 256,
      child: CustomPaint(
        painter: painter,
      ),
    );
  }
}
