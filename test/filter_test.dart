import 'package:flutter/material.dart';
import 'package:project1/models/image_processing_model.dart';
import 'package:project1/models/image_shape.dart';
import 'package:project1/models/shape.dart';
import 'package:test/test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('Filters Tests', () {
    test('Mean Filter Test', () async {
      final inputImage = createTestImage();
      final expectedOutput = applyManualMeanFilter();
      final result = ImageProcessor.applyMeanFilter(inputImage);

      expect(compareImages(result, expectedOutput), true);
    });

    test('Median Filter Test', () {
      final inputImage = createTestImage();
      final expectedOutput = applyManualMedianFilter();

      final result = ImageProcessor.applyMedianFilter(inputImage, 3);

      expect(compareImages(result, expectedOutput), true);
    });

    test('Sobel Filter Test', () {
      final inputImage = createTestImage();
      final expectedOutput = applyManualSobelFilter();

      final result = ImageProcessor.applySobelFilter(inputImage);

      expect(compareImages(result, expectedOutput), true);
    });

    test('Gaussian Blur Test', () {
      final inputImage = createTestImage();
      final expectedOutput = applyManualGaussianBlur();

      final result = ImageProcessor.applyGaussianBlur(inputImage);

      expect(compareImages(result, expectedOutput), true);
    });
  });
}

ImageShape createTestImage() {
  final pixels = List.generate(
    4,
    (i) => Pixel(
      Offset((i % 10).toDouble(), (i ~/ 10).toDouble()),
      Color.fromARGB(255, i % 2 == 0 ? 255 : 0, i % 2 == 0 ? 255 : 0,
          i % 2 == 0 ? 255 : 0),
    ),
  );
  return ImageShape(
    type: ShapeType.freeDraw,
    startPosition: Offset.zero,
    endPosition: const Offset(2, 2),
    pixels: pixels,
  );
}

bool compareImages(ImageShape img1, ImageShape img2) {
  if (img1.pixels.length != img2.pixels.length) return false;

  for (int i = 0; i < img1.pixels.length; i++) {
    if (img1.pixels[i].color.value != img2.pixels[i].color.value) {
      return false;
    }
  }

  return true;
}

ImageShape applyManualMeanFilter() {
  return ImageShape(
      type: ShapeType.freeDraw,
      startPosition: const Offset(0.0, 0.0),
      endPosition: const Offset(2.0, 2.0),
      pixels: [
        Pixel(const Offset(0.0, 0.0), const Color(0xff808080)),
        Pixel(const Offset(1.0, 0.0), const Color(0xff808080)),
        Pixel(const Offset(0.0, 1.0), const Color(0xff808080)),
        Pixel(const Offset(1.0, 1.0), const Color(0xff808080))
      ]);
}

ImageShape applyManualMedianFilter() {
  return ImageShape(
      type: ShapeType.freeDraw,
      startPosition: const Offset(0.0, 0.0),
      endPosition: const Offset(2.0, 2.0),
      pixels: [
        Pixel(const Offset(0.0, 0.0), const Color(0xffffffff)),
        Pixel(const Offset(1.0, 0.0), const Color(0xffffffff)),
        Pixel(const Offset(0.0, 1.0), const Color(0xffffffff)),
        Pixel(const Offset(1.0, 1.0), const Color(0xffffffff))
      ]);
}

ImageShape applyManualSobelFilter() {
  return ImageShape(
      type: ShapeType.freeDraw,
      startPosition: const Offset(0.0, 0.0),
      endPosition: const Offset(2.0, 2.0),
      pixels: [
        Pixel(const Offset(0.0, 0.0), const Color(0xff555555)),
        Pixel(const Offset(1.0, 0.0), const Color(0xff555555)),
        Pixel(const Offset(0.0, 1.0), const Color(0xff000000)),
        Pixel(const Offset(1.0, 1.0), const Color(0xff000000))
      ]);
}

ImageShape applyManualGaussianBlur() {
  return ImageShape(
      type: ShapeType.freeDraw,
      startPosition: const Offset(0.0, 0.0),
      endPosition: const Offset(2.0, 2.0),
      pixels: [
        Pixel(const Offset(0.0, 0.0), const Color(0xffaaaaaa)),
        Pixel(const Offset(1.0, 0.0), const Color(0xff555555)),
        Pixel(const Offset(0.0, 1.0), const Color(0xffaaaaaa)),
        Pixel(const Offset(1.0, 1.0), const Color(0xff555555))
      ]);
}
