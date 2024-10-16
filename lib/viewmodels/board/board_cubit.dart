import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project1/models/shape.dart';

part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit() : super(const BoardState());

  void startDrawing(Shape shape) {
    emit(state.copyWith(currentShape: shape));
  }

  void updateDrawing(Offset position) {
    if (state.currentShape != null) {
      if (state.currentShape!.type == ShapeType.freeDraw) {
        final updatedPoints = List<Offset>.from(state.currentShape!.points)
          ..add(position);
        emit(state.copyWith(
          currentShape: state.currentShape!.copyWith(points: updatedPoints),
        ));
      } else {
        emit(state.copyWith(
          currentShape: state.currentShape!.copyWith(endPosition: position),
        ));
      }
    }
  }

  void endDrawing() {
    if (state.currentShape != null) {
      emit(state.copyWith(
        shapes: List.from(state.shapes)..add(state.currentShape!),
        currentShape: null,
      ));
    }
  }
}
