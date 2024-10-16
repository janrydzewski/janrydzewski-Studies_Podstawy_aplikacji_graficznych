// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'shape_cubit.dart';

class ShapeState extends Equatable {
  final ShapeType shapeType;
  final Color color;

  const ShapeState({required this.shapeType, required this.color});

  @override
  List<Object?> get props => [shapeType, color];

  ShapeState copyWith({
    ShapeType? shapeType,
    Color? color,
  }) {
    return ShapeState(
      shapeType: shapeType ?? this.shapeType,
      color: color ?? this.color,
    );
  }
}
