import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:project1/models/shape.dart';
import 'package:project1/viewmodels/board/board_cubit.dart';
import 'package:project1/viewmodels/shape/shape_cubit.dart';
import 'package:project1/views/painter.dart';
import 'package:project1/widgets/appbar_widget.dart';
import 'package:project1/widgets/colors_picker_widget.dart';
import 'package:project1/widgets/dialog.dart';
import 'package:project1/widgets/shape_picker_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => ShapeCubit(),
      ),
      BlocProvider(
        create: (context) => BoardCubit(),
      ),
    ], child: const _HomePage());
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  final GlobalKey globalKey = GlobalKey();
  int tapCount = 0;
  Timer? doubleTapTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar((
        val,
      ) {
        saveImage(context, val);
      }, context),
      body: GestureDetector(
        onTapUp: (details) async {
          final shapeCubit = context.read<ShapeCubit>();
          final boardCubit = context.read<BoardCubit>();

          if (shapeCubit.state.shapeType == ShapeType.text) {
            String? enteredText = await showTextInputDialog(context);
            if (enteredText != null && enteredText.isNotEmpty) {
              final shape = Shape(
                type: ShapeType.text,
                startPosition: details.localPosition,
                endPosition: details.localPosition,
                color: shapeCubit.state.color,
                text: enteredText,
              );
              boardCubit.startDrawing(shape);
              boardCubit.endDrawing();
            }
          } else if (shapeCubit.state.shapeType == ShapeType.polygon) {
            tapCount++;
            if (tapCount == 2) {
              doubleTapTimer?.cancel();
              boardCubit.finalizePolygon();
              tapCount = 0;
            } else {
              doubleTapTimer = Timer(const Duration(milliseconds: 300), () {
                boardCubit.addPolygonPoint(details.localPosition);
                tapCount = 0;
              });
            }
          }
        },
        onPanStart: (details) {
          final shapeCubit = context.read<ShapeCubit>();
          final boardCubit = context.read<BoardCubit>();

          final shape = Shape(
            type: shapeCubit.state.shapeType,
            startPosition: details.localPosition,
            endPosition: details.localPosition,
            color: shapeCubit.state.color,
            points: shapeCubit.state.shapeType == ShapeType.freeDraw
                ? [details.localPosition]
                : [],
          );

          boardCubit.startDrawing(shape);
        },
        onPanUpdate: (details) {
          context.read<BoardCubit>().updateDrawing(details.localPosition);
        },
        onPanEnd: (_) {
          context.read<BoardCubit>().endDrawing();
        },
        child: BlocBuilder<BoardCubit, BoardState>(
          builder: (context, state) {
            return Row(
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //       border: Border.all(color: Colors.black),
                //       gradient: const LinearGradient(
                //           colors: [Colors.grey, Colors.white])),
                //   width: 200,
                //   height: double.infinity,
                //   child: const ShapePickerWidget(),
                // ),
                Expanded(
                  child: Stack(
                    children: [
                      RepaintBoundary(
                        key: globalKey,
                        child: CustomPaint(
                          painter:
                              BoardPainter(state.shapes, state.currentShape),
                          child: Container(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      gradient: const LinearGradient(
                          colors: [Colors.grey, Colors.white])),
                  width: 200,
                  height: double.infinity,
                  child: Column(
                    children: [
                      const ColorsPickerWidget(),
                      const ShapePickerWidget()
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
}

Future<void> saveImage(BuildContext context, String type) async {
  log("Save");
  final shapes = context.read<BoardCubit>().state.shapes;

  final filePath = await getFilePath('output.ppm');

  await saveCanvasToPPM(filePath, type, 800, 600, shapes);
}

Future<String> getFilePath(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/$fileName';
}

Future<List<Color>> generatePixelData(
  int width,
  int height,
  List<Shape> shapes,
) async {
  final recorder = PictureRecorder();
  final canvas = Canvas(
      recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
  final painter = BoardPainter(shapes, null);

  painter.paint(canvas, Size(width.toDouble(), height.toDouble()));

  final image = await recorder.endRecording().toImage(width, height);
  final byteData = await image.toByteData(format: ImageByteFormat.rawRgba);

  final pixels = <Color>[];
  for (int i = 0; i < byteData!.lengthInBytes; i += 4) {
    final r = byteData.getUint8(i);
    final g = byteData.getUint8(i + 1);
    final b = byteData.getUint8(i + 2);
    pixels.add(Color.fromARGB(255, r, g, b));
  }

  return pixels;
}

Future<void> saveAsP1File(
    String filePath, int width, int height, List<Color> pixels) async {
  final buffer = StringBuffer();

  buffer.writeln('P1');
  buffer.writeln('$width $height');

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final index = y * width + x;
      final color = pixels[index];
      // Używamy prostego rozróżnienia na czarny (0) i biały (1)
      final pixelValue =
          (color.red + color.green + color.blue) ~/ 3 > 127 ? 1 : 0;
      buffer.write('$pixelValue ');
    }
    buffer.writeln();
  }

  final file = File(filePath);
  await file.writeAsString(buffer.toString());
}

Future<void> saveAsP2File(
    String filePath, int width, int height, List<Color> pixels) async {
  final buffer = StringBuffer();

  buffer.writeln('P2');
  buffer.writeln('$width $height');
  buffer.writeln('255');

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final index = y * width + x;
      final color = pixels[index];
      // Zapisujemy wartość szarości jako średnią z R, G i B
      final grayValue = (color.red + color.green + color.blue) ~/ 3;
      buffer.write('$grayValue ');
    }
    buffer.writeln();
  }

  final file = File(filePath);
  await file.writeAsString(buffer.toString());
}

Future<void> saveAsP3File(
    String filePath, int width, int height, List<Color> pixels) async {
  final buffer = StringBuffer();

  buffer.writeln('P3');
  buffer.writeln('$width $height');
  buffer.writeln('255');

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final index = y * width + x;
      final color = pixels[index];
      buffer.write('${color.red} ${color.green} ${color.blue} ');
    }
    buffer.writeln();
  }

  final file = File(filePath);
  await file.writeAsString(buffer.toString());
}

Future<void> saveAsP4File(
    String filePath, int width, int height, List<Color> pixels) async {
  final header = 'P4\n$width $height\n';
  final pixelData = <int>[];

  for (final color in pixels) {
    // Każdy piksel w formacie P4 zapisujemy jako bit (0 dla czarnego, 255 dla białego)
    final pixelValue =
        (color.red + color.green + color.blue) ~/ 3 > 127 ? 255 : 0;
    pixelData.add(pixelValue);
  }

  final file = File(filePath);
  await file.writeAsBytes([...header.codeUnits, ...pixelData]);
}

Future<void> saveAsP5File(
    String filePath, int width, int height, List<Color> pixels) async {
  final header = 'P5\n$width $height\n255\n';
  final pixelData = <int>[];

  for (final color in pixels) {
    // Zapisujemy wartość szarości (0-255)
    final grayValue = (color.red + color.green + color.blue) ~/ 3;
    pixelData.add(grayValue);
  }

  final file = File(filePath);
  await file.writeAsBytes([...header.codeUnits, ...pixelData]);
}

Future<void> saveAsP6File(
    String filePath, int width, int height, List<Color> pixels) async {
  final header = 'P6\n$width $height\n255\n';
  final pixelData = <int>[];

  for (final color in pixels) {
    pixelData.addAll([color.red, color.green, color.blue]);
  }

  final file = File(filePath);
  await file.writeAsBytes([...header.codeUnits, ...pixelData]);
}

Future<void> saveCanvasToPPM(
  String filePath,
  String format,
  int width,
  int height,
  List<Shape> shapes,
) async {
  final pixels = await generatePixelData(width, height, shapes);

  switch (format) {
    case 'P3':
      await saveAsP3File(filePath, width, height, pixels);
      break;
    case 'P6':
      await saveAsP6File(filePath, width, height, pixels);
      break;
    case 'P1':
      await saveAsP1File(filePath, width, height, pixels);
      break;
    case 'P2':
      await saveAsP2File(filePath, width, height, pixels);
      break;
    case 'P4':
      await saveAsP4File(filePath, width, height, pixels);
      break;
    case 'P5':
      await saveAsP5File(filePath, width, height, pixels);
      break;
    default:
      throw Exception('Nieobsługiwany format: $format');
  }
}
