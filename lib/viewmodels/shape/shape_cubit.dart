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

  void updateColor(double r, double g, double b) {
    final color = Color.fromRGBO(r.round(), g.round(), b.round(), 1);
    emit(state.copyWith(color: color));
  }

  void selectShape(Shape shape) {
    emit(state.copyWith(selectedShape: shape));
  }

  void startMoving() {
    emit(state.copyWith(isMoving: true));
  }

  void endMoving() {
    emit(state.copyWith(isMoving: false));
  }

  void startResizing() {
    emit(state.copyWith(isResizing: true));
  }

  void endResizing() {
    emit(state.copyWith(isResizing: false));
  }

  void startRotating() {
    emit(state.copyWith(isRotating: true));
  }

  void endRotating() {
    emit(state.copyWith(isRotating: false));
  }

  void endManipulation() {
    emit(state.copyWith(isMoving: false, isResizing: false, isRotating: false));
  }
}
