import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:project1/models/shape.dart';
import 'package:project1/viewmodels/board/board_cubit.dart';
import 'package:project1/viewmodels/shape/shape_cubit.dart';
import 'package:project1/views/painter.dart';
import 'package:project1/widgets/appbar_widget.dart';
import 'package:project1/widgets/dialog.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(() => saveImage()),
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
            return RepaintBoundary(
              key: globalKey,
              child: CustomPaint(
                painter: BoardPainter(state.shapes, state.currentShape),
                child: Container(),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> saveImage() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final directory = (await getApplicationDocumentsDirectory()).path;
      File imgFile = File('$directory/screenshot.png');
      await imgFile.writeAsBytes(byteData.buffer.asUint8List());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved to $directory/screenshot.png')),
      );
    }
  }
}
