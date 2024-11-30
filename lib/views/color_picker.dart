import 'package:flutter/material.dart';
import 'package:project1/models/header_model.dart';
import 'package:project1/viewmodels/color_converter_viewmodel.dart';
import 'package:provider/provider.dart';

class ColorPickerPage extends StatelessWidget {
  const ColorPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ColorConverterViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderModel(label: "RGB"),
                Row(
                  children: [
                    _buildTextField('Red (0-255)', viewModel.red, (value) {
                      viewModel.updateRgb(
                          double.tryParse(value) ?? viewModel.red,
                          viewModel.green,
                          viewModel.blue,
                          context);
                    }),
                    _buildTextField('Green (0-255)', viewModel.green, (value) {
                      viewModel.updateRgb(
                          viewModel.red,
                          double.tryParse(value) ?? viewModel.green,
                          viewModel.blue,
                          context);
                    }),
                    _buildTextField('Blue (0-255)', viewModel.blue, (value) {
                      viewModel.updateRgb(viewModel.red, viewModel.green,
                          double.tryParse(value) ?? viewModel.blue, context);
                    }),
                  ],
                ),
                const HeaderModel(label: "CMYK"),
                Row(
                  children: [
                    _buildTextField('Cyan (0-100)', viewModel.cyan * 100,
                        (value) {
                      viewModel.updateCmyk(
                          (double.tryParse(value) ?? viewModel.cyan * 100) /
                              100,
                          viewModel.magenta,
                          viewModel.yellow,
                          viewModel.black,
                          context);
                    }),
                    _buildTextField('Magenta (0-100)', viewModel.magenta * 100,
                        (value) {
                      viewModel.updateCmyk(
                          viewModel.cyan,
                          (double.tryParse(value) ?? viewModel.magenta * 100) /
                              100,
                          viewModel.yellow,
                          viewModel.black,
                          context);
                    }),
                    _buildTextField('Yellow (0-100)', viewModel.yellow * 100,
                        (value) {
                      viewModel.updateCmyk(
                          viewModel.cyan,
                          viewModel.magenta,
                          (double.tryParse(value) ?? viewModel.yellow * 100) /
                              100,
                          viewModel.black,
                          context);
                    }),
                    _buildTextField('Black (0-100)', viewModel.black * 100,
                        (value) {
                      viewModel.updateCmyk(
                          viewModel.cyan,
                          viewModel.magenta,
                          viewModel.yellow,
                          (double.tryParse(value) ?? viewModel.black * 100) /
                              100,
                          context);
                    }),
                  ],
                ),
                const HeaderModel(label: "HSV"),
                Row(
                  children: [
                    _buildTextField('Hue (0-360)', viewModel.hue, (value) {
                      viewModel.updateHsv(
                          double.tryParse(value) ?? viewModel.hue,
                          viewModel.saturation,
                          viewModel.value,
                          context);
                    }),
                    _buildTextField(
                        'Saturation (0-100)', viewModel.saturation * 100,
                        (value) {
                      viewModel.updateHsv(
                          viewModel.hue,
                          (double.tryParse(value) ??
                                  viewModel.saturation * 100) /
                              100,
                          viewModel.value,
                          context);
                    }),
                    _buildTextField('Value (0-100)', viewModel.value * 100,
                        (value) {
                      viewModel.updateHsv(
                          viewModel.hue,
                          viewModel.saturation,
                          (double.tryParse(value) ?? viewModel.value * 100) /
                              100,
                          context);
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 80,
                  color: Color.fromARGB(255, viewModel.red.round(),
                      viewModel.green.round(), viewModel.blue.round()),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'RGB(${viewModel.red.round()}, ${viewModel.green.round()}, ${viewModel.blue.round()})',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'CMYK(${(viewModel.cyan * 100).toStringAsFixed(0)}%, ${(viewModel.magenta * 100).toStringAsFixed(0)}%, ${(viewModel.yellow * 100).toStringAsFixed(0)}%, ${(viewModel.black * 100).toStringAsFixed(0)}%)',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'HSV(${viewModel.hue.round()}°, ${(viewModel.saturation * 100).toStringAsFixed(0)}%, ${(viewModel.value * 100).toStringAsFixed(0)}%)',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, double value, Function(String) onChanged) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          controller: TextEditingController(text: value.toStringAsFixed(2)),
          onSubmitted: onChanged,
        ),
      ),
    );
  }
}
