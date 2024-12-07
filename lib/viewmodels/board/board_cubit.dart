import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project1/models/image_processing_model.dart';
import 'package:project1/models/image_shape.dart';
import 'package:project1/models/shape.dart';
import 'package:image/image.dart' as img;

part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit() : super(BoardState(drawingQueue: Queue()));

  Future<void> loadImageFile(String filePath, int selectedFilter) async {
    log("Rozpoczęcie ładowania pliku obrazu: $filePath");
    final shape = await _parseImageFile(filePath);
    final generatedShape =
        await applySelectedFilterAndGenerateImageShape(shape!, selectedFilter);
    if (generatedShape != null) {
      emit(state.copyWith(
        drawingQueue: Queue.from(state.drawingQueue)..add(generatedShape),
      ));
      log("Dodano kształt z pliku obrazu do kolejki");
      processNextShape();
    } else {
      log("Nie udało się przetworzyć pliku obrazu");
    }
  }

  Future<ImageShape?> applySelectedFilterAndGenerateImageShape(
      ImageShape shape, int selectedFilter) async {
    List<Pixel> newPixels;

    if (selectedFilter < 7) {
      newPixels = getFilterA(shape.pixels, selectedFilter);
    } else {
      newPixels = getFilterB(shape, selectedFilter).pixels;
    }

    final image = await pixelsToImage(
        newPixels, shape.endPosition.dx.toInt(), shape.endPosition.dy.toInt());

    return ImageShape(
      type: shape.type,
      startPosition: shape.startPosition,
      endPosition: shape.endPosition,
      pixels: newPixels,
      image: image,
    );
  }

  Future<ImageShape?> _parseImageFile(String filePath) async {
    final file = File(filePath);
    final content = await file.readAsBytes();
    // Rozpoznanie formatu na podstawie nagłówka
    final header = String.fromCharCodes(content.take(8));
    if (header.startsWith('P')) {
      // Obsługa formatu PNM
      return _parsePNMFile(content);
    } else if (content.length > 8 &&
        content[0] == 0x89 &&
        content[1] == 0x50 &&
        content[2] == 0x4E &&
        content[3] == 0x47) {
      // Obsługa formatu PNG
      return _parsePNG(content);
    } else {
      log("Nieobsługiwany format pliku: $header");
    }
    return null;
  }

  Future<ImageShape?> _parsePNMFile(Uint8List content) async {
    final header = String.fromCharCodes(content.take(2));
    switch (header) {
      case 'P1':
        return _parseP1(content);
      case 'P2':
        return _parseP2(content);
      case 'P3':
        return _parseP3(content);
      case 'P4':
        return _parseP4(content);
      case 'P5':
        return _parseP5(content);
      case 'P6':
        return _parseP6(content);
      default:
        log("Niewspierany format PNM: $header");
    }
    return null;
  }

  Future<ImageShape?> _parsePNG(Uint8List content) async {
    final image = img.decodeImage(content);
    if (image == null) {
      log("Nie udało się zdekodować obrazu PNG");
      return null;
    }
    final pixels = <Pixel>[];
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final color = Color.fromARGB(
            pixel.a.toInt(), pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());
        pixels.add(Pixel(Offset(x.toDouble(), y.toDouble()), color));
      }
    }
    return ImageShape(
      type: ShapeType.freeDraw,
      startPosition: Offset.zero,
      endPosition: Offset(image.width.toDouble(), image.height.toDouble()),
      pixels: pixels,
    );
  }

  Future<ImageShape> _parseP1(Uint8List content) async {
    final contentString = String.fromCharCodes(content);
    final lines = contentString.split('\n').map((line) => line.trim()).toList();
    lines.removeWhere((line) => line.startsWith('#') || line.isEmpty);
    final dimensions = lines[1]
        .split(RegExp(r'\s+'))
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .toList();
    final width = dimensions[0];
    final height = dimensions[1];
    final pixelData = lines.sublist(3).expand((line) {
      return line.split(RegExp(r'\s+')).map(int.tryParse).whereType<int>();
    }).toList();
    final pixels = <Pixel>[];
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final index = (y * width + x);
        final color = pixelData[index] == 1
            ? Color.fromARGB(255, 0, 0, 0)
            : Color.fromARGB(255, 255, 255, 255);
        pixels.add(Pixel(Offset(x.toDouble(), y.toDouble()), color));
      }
    }
    return ImageShape(
      type: ShapeType.freeDraw,
      startPosition: Offset.zero,
      endPosition: Offset(width.toDouble(), height.toDouble()),
      pixels: pixels,
    );
  }

  Future<ImageShape> _parseP2(Uint8List content) async {
    final contentString = String.fromCharCodes(content);
    final lines = contentString.split('\n').map((line) => line.trim()).toList();
    lines.removeWhere((line) => line.startsWith('#') || line.isEmpty);
    final dimensions = lines[1]
        .split(RegExp(r'\s+'))
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .toList();
    final width = dimensions[0];
    final height = dimensions[1];
    final maxColorValue = int.tryParse(lines[2]) ?? 255;
    final pixelData = lines.sublist(3).expand((line) {
      return line.split(RegExp(r'\s+')).map(int.tryParse).whereType<int>();
    }).toList();
    final pixels = <Pixel>[];
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final index = (y * width + x);
        final grayValue = (pixelData[index] * 255 / maxColorValue).round();
        final color = Color.fromARGB(255, grayValue, grayValue, grayValue);
        pixels.add(Pixel(Offset(x.toDouble(), y.toDouble()), color));
      }
    }
    return ImageShape(
      type: ShapeType.freeDraw,
      startPosition: Offset.zero,
      endPosition: Offset(width.toDouble(), height.toDouble()),
      pixels: pixels,
    );
  }

  Future<ImageShape> _parseP3(Uint8List content) async {
    final contentString = String.fromCharCodes(content);
    final lines = contentString.split('\n').map((line) => line.trim()).toList();
    lines.removeWhere((line) => line.startsWith('#') || line.isEmpty);
    final dimensions = lines[1]
        .split(RegExp(r'\s+'))
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .toList();
    final width = dimensions[0];
    final height = dimensions[1];
    final maxColorValue = int.tryParse(lines[2]) ?? 255;
    final pixelData = lines.sublist(3).expand((line) {
      return line.split(RegExp(r'\s+')).map(int.tryParse).whereType<int>();
    }).toList();
    final pixels = <Pixel>[];
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final index = (y * width + x) * 3;
        final r = (pixelData[index] * 255 / maxColorValue).round();
        final g = (pixelData[index + 1] * 255 / maxColorValue).round();
        final b = (pixelData[index + 2] * 255 / maxColorValue).round();
        final color = Color.fromARGB(255, r, g, b);
        pixels.add(Pixel(Offset(x.toDouble(), y.toDouble()), color));
      }
    }
    return ImageShape(
      type: ShapeType.freeDraw,
      startPosition: Offset.zero,
      endPosition: Offset(width.toDouble(), height.toDouble()),
      pixels: pixels,
    );
  }

  Future<ImageShape> _parseP4(Uint8List content) async {
    final lines = String.fromCharCodes(content)
        .split('\n')
        .map((line) => line.trim())
        .toList();
    lines.removeWhere((line) => line.startsWith('#') || line.isEmpty);
    final dimensions = lines[1]
        .split(RegExp(r'\s+'))
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .toList();
    final width = dimensions[0];
    final height = dimensions[1];
    final pixelData = content.sublist(3);
    final pixels = <Pixel>[];
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final index = (y * width + x) ~/ 8;
        final bit = (pixelData[index] >> (7 - (x % 8))) & 1;
        final color = bit == 1
            ? Color.fromARGB(255, 0, 0, 0)
            : Color.fromARGB(255, 255, 255, 255);
        pixels.add(Pixel(Offset(x.toDouble(), y.toDouble()), color));
      }
    }
    return ImageShape(
      type: ShapeType.freeDraw,
      startPosition: Offset.zero,
      endPosition: Offset(width.toDouble(), height.toDouble()),
      pixels: pixels,
    );
  }

  Future<ImageShape> _parseP5(Uint8List content) async {
    final lines = String.fromCharCodes(content)
        .split('\n')
        .map((line) => line.trim())
        .toList();
    lines.removeWhere((line) => line.startsWith('#') || line.isEmpty);
    final dimensions = lines[1]
        .split(RegExp(r'\s+'))
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .toList();
    final width = dimensions[0];
    final height = dimensions[1];
    final pixelData = content.sublist(3);
    final pixels = <Pixel>[];
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final index = (y * width + x);
        final grayValue = pixelData[index];
        final color = Color.fromARGB(255, grayValue, grayValue, grayValue);
        pixels.add(Pixel(Offset(x.toDouble(), y.toDouble()), color));
      }
    }
    return ImageShape(
      type: ShapeType.freeDraw,
      startPosition: Offset.zero,
      endPosition: Offset(width.toDouble(), height.toDouble()),
      pixels: pixels,
    );
  }

  ImageShape _parseP6(Uint8List content) {
    final lines = String.fromCharCodes(content)
        .split('\n')
        .map((line) => line.trim())
        .toList();
    lines.removeWhere((line) => line.startsWith('#') || line.isEmpty);
    final dimensions = lines[1]
        .split(RegExp(r'\s+'))
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .toList();
    final width = dimensions[0];
    final height = dimensions[1];
    final pixelDataStartIndex = content.indexOf(
            0x0A, content.indexOf(0x0A, content.indexOf(0x0A) + 1) + 1) +
        1;
    final pixelData = content.sublist(pixelDataStartIndex);
    final pixels = <Pixel>[];
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final index = (y * width + x) * 3;
        final r = pixelData[index];
        final g = pixelData[index + 1];
        final b = pixelData[index + 2];
        final color = Color.fromARGB(255, r, g, b);
        pixels.add(Pixel(Offset(x.toDouble(), y.toDouble()), color));
      }
    }
    return ImageShape(
      type: ShapeType.freeDraw,
      startPosition: Offset.zero,
      endPosition: Offset(width.toDouble(), height.toDouble()),
      pixels: pixels,
    );
  }

  void startDrawing(Shape shape) {
    log("Rozpoczęto rysowanie kształtu: ${shape.type}");
    emit(state.copyWith(currentShape: shape));
  }

  void updateDrawing(Offset position) {
    if (state.currentShape != null) {
      if (state.currentShape!.type == ShapeType.freeDraw ||
          state.currentShape!.type == ShapeType.polygon) {
        final updatedPoints = List<Offset>.from(state.currentShape!.points)
          ..add(position);
        emit(state.copyWith(
          currentShape: state.currentShape!.copyWith(points: updatedPoints),
        ));
      } else {
        emit(state.copyWith(
          currentShape: state.currentShape!.copyWith(endPosition: position),
        ));
      }
    }
  }

  void addPolygonPoint(Offset position) {
    if (state.currentShape != null &&
        state.currentShape!.type == ShapeType.polygon) {
      final updatedPoints = List<Offset>.from(state.currentShape!.points)
        ..add(position);
      emit(state.copyWith(
        currentShape: state.currentShape!.copyWith(points: updatedPoints),
      ));
    }
  }

  void finalizePolygon() {
    if (state.currentShape != null &&
        state.currentShape!.type == ShapeType.polygon) {
      emit(state.copyWith(
        shapes: List<Shape>.from(state.shapes)..add(state.currentShape!),
        currentShape: null,
      ));
    }
  }

  void endDrawing() {
    if (state.currentShape != null &&
        state.currentShape!.type != ShapeType.polygon) {
      emit(state.copyWith(
        shapes: List<Shape>.from(state.shapes)..add(state.currentShape!),
        currentShape: null,
      ));
    }
  }

  void clear() => emit(BoardState(drawingQueue: Queue(), shapes: []));

  void processNextShape() {
    if (state.drawingQueue.isNotEmpty) {
      final shape = state.drawingQueue.removeFirst();
      emit(state.copyWith(
        shapes: List.from(state.shapes)..add(shape),
        drawingQueue: state.drawingQueue,
      ));
      log("Wykonano zadanie: Rysowanie kształtu ${shape.type}");
    } else {
      log("Brak zadań w kolejce do wykonania");
    }
  }

  void addShape(Shape shape) {
    emit(state.copyWith(
      shapes: List.from(state.shapes)..add(shape),
    ));
  }

  void removeShape(Shape shape) {
    emit(state.copyWith(
      shapes: List.from(state.shapes)..remove(shape),
    ));
  }
}
