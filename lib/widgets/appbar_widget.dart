import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/viewmodels/shape/shape_cubit.dart';
import 'package:project1/models/shape.dart';

AppBar appBar(Function() func) => AppBar(
      toolbarHeight: 85,
      flexibleSpace: SizedBox(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: BlocBuilder<ShapeCubit, ShapeState>(
                  builder: (context, state) => Column(
                    children: [
                      Row(
                        children: [
                          _AppBarElement(
                              shapeType: ShapeType.ellipse, shapeState: state),
                          _AppBarElement(
                              shapeType: ShapeType.rectangle,
                              shapeState: state),
                          _AppBarElement(
                              shapeType: ShapeType.triangle, shapeState: state),
                          _AppBarElement(
                              shapeType: ShapeType.line, shapeState: state),
                          _AppBarElement(
                              shapeType: ShapeType.freeDraw, shapeState: state),
                          _AppBarElement(
                              shapeType: ShapeType.text, shapeState: state),
                        ],
                      ),
                      Row(
                        children: [
                          _AppBarColorElement(
                              color: Colors.black, shapeState: state),
                          _AppBarColorElement(
                              color: Colors.red, shapeState: state),
                          _AppBarColorElement(
                              color: Colors.green, shapeState: state),
                          _AppBarColorElement(
                              color: Colors.blue, shapeState: state),
                          _AppBarColorElement(
                              color: Colors.yellow, shapeState: state),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Text('Project 1 - Jan Rydzewski'),
              Expanded(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: func, icon: const Icon(Icons.save)))),
            ],
          ),
        ),
      ),
    );

class _AppBarElement extends StatelessWidget {
  const _AppBarElement({required this.shapeType, required this.shapeState});

  final ShapeType shapeType;
  final ShapeState shapeState;

  Icon get icon {
    switch (shapeType) {
      case ShapeType.ellipse:
        return const Icon(Icons.circle_outlined);
      case ShapeType.rectangle:
        return const Icon(Icons.crop_square);
      case ShapeType.triangle:
        return const Icon(Icons.change_history);
      case ShapeType.line:
        return const Icon(Icons.linear_scale);
      case ShapeType.freeDraw:
        return const Icon(Icons.edit_outlined);
      case ShapeType.text:
        return const Icon(Icons.abc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: shapeState.shapeType == shapeType
                ? Colors.grey
                : Colors.transparent),
      ),
      child: IconButton(
        onPressed: () => context.read<ShapeCubit>().changeShape(shapeType),
        icon: icon,
      ),
    );
  }
}

class _AppBarColorElement extends StatelessWidget {
  const _AppBarColorElement({required this.color, required this.shapeState});

  final Color color;
  final ShapeState shapeState;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color:
                shapeState.color == color ? Colors.grey : Colors.transparent),
      ),
      child: IconButton(
        onPressed: () => context.read<ShapeCubit>().changeColor(color),
        icon: Icon(
          Icons.circle,
          color: color,
        ),
      ),
    );
  }
}
