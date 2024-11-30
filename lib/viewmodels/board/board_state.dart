part of 'board_cubit.dart';

class BoardState extends Equatable {
  final List<Shape> shapes;
  final Shape? currentShape;
  final Queue<Shape> drawingQueue;

  const BoardState({
    this.shapes = const [],
    this.currentShape,
    required this.drawingQueue,
  });

  BoardState copyWith({
    List<Shape>? shapes,
    Shape? currentShape,
    Queue<Shape>? drawingQueue,
  }) {
    return BoardState(
      shapes: shapes ?? this.shapes,
      currentShape: currentShape ?? this.currentShape,
      drawingQueue: drawingQueue ?? this.drawingQueue,
    );
  }

  @override
  List<Object?> get props => [shapes, currentShape, drawingQueue];
}
