part of 'board_cubit.dart';

class BoardState extends Equatable {
  final List<Shape> shapes;
  final Shape? currentShape;
  final Queue<Shape> drawingQueue;
  final Shape? lastChangedShape;
  final List<Shape> solidShapes;

  const BoardState({
    this.shapes = const [],
    this.currentShape,
    required this.drawingQueue,
    this.lastChangedShape,
    this.solidShapes = const [],
  });

  BoardState copyWith({
    List<Shape>? shapes,
    Shape? currentShape,
    Queue<Shape>? drawingQueue,
    Shape? lastChangedShape,
    List<Shape>? solidShapes,
  }) {
    return BoardState(
      shapes: shapes ?? this.shapes,
      currentShape: currentShape ?? this.currentShape,
      drawingQueue: drawingQueue ?? this.drawingQueue,
      lastChangedShape: lastChangedShape ?? this.lastChangedShape,
      solidShapes: solidShapes ?? this.solidShapes,
    );
  }

  @override
  List<Object?> get props =>
      [shapes, currentShape, drawingQueue, lastChangedShape, solidShapes];
}
