// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'shape_cubit.dart';

class ShapeState extends Equatable {
  final ShapeType shapeType;
  final Color color;
  final Shape? selectedShape;
  final bool isMoving;
  final bool isResizing;
  final bool isRotating;

  const ShapeState({
    required this.shapeType,
    required this.color,
    this.selectedShape,
    this.isMoving = false,
    this.isResizing = false,
    this.isRotating = false,
  });

  @override
  List<Object?> get props =>
      [shapeType, color, selectedShape, isMoving, isResizing, isRotating];

  ShapeState copyWith({
    ShapeType? shapeType,
    Color? color,
    Shape? selectedShape,
    bool? isMoving,
    bool? isResizing,
    bool? isRotating,
  }) {
    return ShapeState(
      shapeType: shapeType ?? this.shapeType,
      color: color ?? this.color,
      selectedShape: selectedShape ?? this.selectedShape,
      isMoving: isMoving ?? this.isMoving,
      isResizing: isResizing ?? this.isResizing,
      isRotating: isRotating ?? this.isRotating,
    );
  }
}
