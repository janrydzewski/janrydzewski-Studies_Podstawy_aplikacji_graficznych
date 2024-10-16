// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'board_cubit.dart';

class BoardState extends Equatable {
  final List<Shape> shapes;
  final Shape? currentShape;

  const BoardState({this.shapes = const [], this.currentShape});

  BoardState copyWith({List<Shape>? shapes, Shape? currentShape}) {
    return BoardState(
      shapes: shapes ?? this.shapes,
      currentShape: currentShape,
    );
  }

  @override
  List<Object?> get props => [shapes, currentShape];
}
