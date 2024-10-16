import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project1/models/shape.dart';

part 'shape_state.dart';

class ShapeCubit extends Cubit<ShapeState> {
  ShapeCubit()
      : super(const ShapeState(shapeType: ShapeType.line, color: Colors.black));

  void changeShape(ShapeType shape) {
    emit(state.copyWith(shapeType: shape));
  }

  void changeColor(Color color) {
    emit(state.copyWith(color: color));
  }
}
