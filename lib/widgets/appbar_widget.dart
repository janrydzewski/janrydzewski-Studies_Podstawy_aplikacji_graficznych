import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/cube/view/cube_page.dart';
import 'package:project1/models/image_processing_model.dart';
import 'package:project1/viewmodels/board/board_cubit.dart';
import 'package:project1/viewmodels/shape/shape_cubit.dart';
import 'package:project1/models/shape.dart';
import 'package:project1/views/color_picker.dart';
import 'package:project1/views/filter_selector.dart';
import 'package:project1/views/home.dart';

AppBar appBar(Function(String val) func, BuildContext context) => AppBar(
      toolbarHeight: 150,
      flexibleSpace: SizedBox(
        height: 180,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  const Text('Project 1 - Jan Rydzewski'),
                  TextButton(
                    onPressed: () => saveImage(context, "P1"),
                    child: const Text("P1"),
                  ),
                  TextButton(
                    onPressed: () => saveImage(context, "P2"),
                    child: const Text("P2"),
                  ),
                  TextButton(
                    onPressed: () => saveImage(context, "P3"),
                    child: const Text("P3"),
                  ),
                  TextButton(
                    onPressed: () => saveImage(context, "P4"),
                    child: const Text("P4"),
                  ),
                  TextButton(
                    onPressed: () => saveImage(context, "P5"),
                    child: const Text("P5"),
                  ),
                  TextButton(
                    onPressed: () => saveImage(context, "P6"),
                    child: const Text("P6"),
                  ),
                ],
              ),
              BlocBuilder<ShapeCubit, ShapeState>(
                builder: (context, state) => Column(
                  children: [
                    Row(
                      children: [
                        _AppBarElement(
                            shapeType: ShapeType.ellipse, shapeState: state),
                        _AppBarElement(
                            shapeType: ShapeType.rectangle, shapeState: state),
                        _AppBarElement(
                            shapeType: ShapeType.triangle, shapeState: state),
                        _AppBarElement(
                            shapeType: ShapeType.line, shapeState: state),
                        _AppBarElement(
                            shapeType: ShapeType.freeDraw, shapeState: state),
                        _AppBarElement(
                            shapeType: ShapeType.text, shapeState: state),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const CubePage())),
                          child: const Text("3D Cube"),
                        ),
                        IconButton(
                            onPressed: () async {
                              final filterResult =
                                  await showFilterDialog(context);
                              SelectedFilter.filter = filterResult ?? 0;
                              log(SelectedFilter.filter.toString());
                              if (filterResult != null) {
                                final result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    'ppm',
                                    'pgm',
                                    'pbm',
                                    'png'
                                  ],
                                );

                                if (result != null &&
                                    result.files.single.path != null) {
                                  final cubit = context.read<BoardCubit>();
                                  cubit
                                      .loadImageFile(result.files.single.path!);
                                }
                              }
                            },
                            icon: const Icon(Icons.image))
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
                        IconButton(
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                          value: context.read<ShapeCubit>(),
                                          child: const ColorPickerPage(),
                                        ))),
                            icon: const Icon(Icons.color_lens)),
                        // Spacer(),
                        IconButton(
                            onPressed: () => context.read<BoardCubit>().clear(),
                            icon: const Icon(Icons.clear))
                      ],
                    ),
                  ],
                ),
              ),
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
