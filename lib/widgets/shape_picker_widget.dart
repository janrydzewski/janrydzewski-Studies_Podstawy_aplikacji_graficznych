import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/models/image_processing_model.dart';
import 'package:project1/models/shape.dart';
import 'package:project1/viewmodels/board/board_cubit.dart';
import 'package:project1/viewmodels/shape/shape_cubit.dart';
import 'package:project1/views/filter_selector.dart';
import 'package:project1/widgets/cube_widget.dart';

class ShapePickerWidget extends StatelessWidget {
  const ShapePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShapeCubit, ShapeState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                _ShapeElement(shapeType: ShapeType.ellipse, shapeState: state),
                _ShapeElement(
                    shapeType: ShapeType.rectangle, shapeState: state),
                _ShapeElement(shapeType: ShapeType.triangle, shapeState: state),
                _ShapeElement(shapeType: ShapeType.line, shapeState: state),
                _ShapeElement(shapeType: ShapeType.freeDraw, shapeState: state),
                _ShapeElement(shapeType: ShapeType.polygon, shapeState: state),
                _ShapeElement(shapeType: ShapeType.text, shapeState: state),
                IconButton(
                    onPressed: () async {
                      final filterResult = await showFilterDialog(context);
                      SelectedFilter.filter = filterResult ?? 0;
                      if (filterResult != null) {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['ppm', 'pgm', 'pbm', 'png'],
                        );

                        if (result != null &&
                            result.files.single.path != null) {
                          final cubit = context.read<BoardCubit>();
                          cubit.loadImageFile(result.files.single.path!);
                        }
                      }
                    },
                    icon: const Icon(Icons.image)),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const CubeWidget(),
          ],
        );
      },
    );
  }
}

class _ShapeElement extends StatelessWidget {
  const _ShapeElement({required this.shapeType, required this.shapeState});

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
      case ShapeType.polygon:
        return const Icon(Icons.square_foot_rounded);
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
            width: 4,
            color: shapeState.shapeType == shapeType
                ? Colors.black
                : Colors.transparent),
      ),
      child: IconButton(
        onPressed: () => context.read<ShapeCubit>().changeShape(shapeType),
        icon: icon,
      ),
    );
  }
}
