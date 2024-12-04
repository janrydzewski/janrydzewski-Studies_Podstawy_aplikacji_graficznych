import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/common/spaced.dart';
import 'package:project1/viewmodels/color_converter_viewmodel.dart';
import 'package:project1/viewmodels/shape/shape_cubit.dart';
import 'package:provider/provider.dart';

class ColorsPickerWidget extends StatelessWidget {
  const ColorsPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShapeCubit, ShapeState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 250,
              height: 150,
              color: state.color,
            ),
            Wrap(
              children: [
                _ColorElement(color: Colors.white, shapeState: state),
                _ColorElement(color: Colors.black, shapeState: state),
                _ColorElement(color: Colors.red, shapeState: state),
                _ColorElement(color: Colors.green, shapeState: state),
                _ColorElement(color: Colors.blue, shapeState: state),
                _ColorElement(color: Colors.yellow, shapeState: state),
                _ColorElement(color: Colors.purple, shapeState: state),
                _ColorElement(color: Colors.teal, shapeState: state),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Consumer<ColorConverterViewModel>(
                builder: (context, viewModel, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("RGB"),
                      Row(
                        children: [
                          _buildTextField(viewModel.red, (value) {
                            viewModel.updateRgb(
                                double.tryParse(value) ?? viewModel.red,
                                viewModel.green,
                                viewModel.blue,
                                context);
                          }),
                          _buildTextField(viewModel.green, (value) {
                            viewModel.updateRgb(
                                viewModel.red,
                                double.tryParse(value) ?? viewModel.green,
                                viewModel.blue,
                                context);
                          }),
                          _buildTextField(viewModel.blue, (value) {
                            viewModel.updateRgb(
                                viewModel.red,
                                viewModel.green,
                                double.tryParse(value) ?? viewModel.blue,
                                context);
                          }),
                        ].spaced(5),
                      ),
                      const Text("CMYK"),
                      Row(
                        children: [
                          _buildTextField(viewModel.cyan * 100, (value) {
                            viewModel.updateCmyk(
                                (double.tryParse(value) ??
                                        viewModel.cyan * 100) /
                                    100,
                                viewModel.magenta,
                                viewModel.yellow,
                                viewModel.black,
                                context);
                          }),
                          _buildTextField(viewModel.magenta * 100, (value) {
                            viewModel.updateCmyk(
                                viewModel.cyan,
                                (double.tryParse(value) ??
                                        viewModel.magenta * 100) /
                                    100,
                                viewModel.yellow,
                                viewModel.black,
                                context);
                          }),
                          _buildTextField(viewModel.yellow * 100, (value) {
                            viewModel.updateCmyk(
                                viewModel.cyan,
                                viewModel.magenta,
                                (double.tryParse(value) ??
                                        viewModel.yellow * 100) /
                                    100,
                                viewModel.black,
                                context);
                          }),
                          _buildTextField(viewModel.black * 100, (value) {
                            viewModel.updateCmyk(
                                viewModel.cyan,
                                viewModel.magenta,
                                viewModel.yellow,
                                (double.tryParse(value) ??
                                        viewModel.black * 100) /
                                    100,
                                context);
                          }),
                        ].spaced(5),
                      ),
                      const Text("HSV"),
                      Row(
                        children: [
                          _buildTextField(viewModel.hue, (value) {
                            viewModel.updateHsv(
                                double.tryParse(value) ?? viewModel.hue,
                                viewModel.saturation,
                                viewModel.value,
                                context);
                          }),
                          _buildTextField(viewModel.saturation * 100, (value) {
                            viewModel.updateHsv(
                                viewModel.hue,
                                (double.tryParse(value) ??
                                        viewModel.saturation * 100) /
                                    100,
                                viewModel.value,
                                context);
                          }),
                          _buildTextField(viewModel.value * 100, (value) {
                            viewModel.updateHsv(
                                viewModel.hue,
                                viewModel.saturation,
                                (double.tryParse(value) ??
                                        viewModel.value * 100) /
                                    100,
                                context);
                          }),
                        ].spaced(5),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ColorElement extends StatelessWidget {
  const _ColorElement({required this.color, required this.shapeState});

  final Color color;
  final ShapeState shapeState;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
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

Widget _buildTextField(double value, Function(String) onChanged) {
  return Expanded(
    child: TextField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      style: const TextStyle(
          fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
      controller: TextEditingController(text: value.toStringAsFixed(0)),
      onSubmitted: onChanged,
    ),
  );
}
