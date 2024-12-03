// import 'dart:developer';
// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:project1/models/image_shape.dart';
// import 'package:project1/models/shape.dart';

// class SelectedFilter {
//   static int filter = 0;
// }

// getFilterA(List<Pixel> pixels) {
//   switch (SelectedFilter.filter) {
//     case 0:
//       return pixels;
//     case 1:
//       return ImageProcessor.addRGB(pixels, 100, 100, 100);
//     case 2:
//       return ImageProcessor.subtractRGB(pixels, 100, 100, 100);
//     case 3:
//       return ImageProcessor.multiplyRGB(pixels, 10, 10, 10);
//     case 4:
//       return ImageProcessor.divideRGB(pixels, 10, 10, 10);
//     case 5:
//       return ImageProcessor.adjustBrightness(pixels, 80);
//     case 6:
//       return ImageProcessor.grayscale(pixels, GrayscaleMode.average);
//   }
// }

// ImageShape getFilterB(ImageShape imageShape) {
//   switch (SelectedFilter.filter) {
//     case 7:
//       return ImageProcessor.applyMeanFilter(imageShape);
//     case 8:
//       return ImageProcessor.applyMedianFilter(imageShape, 150);
//     case 9:
//       return ImageProcessor.applySobelFilter(imageShape);
//     case 10:
//       return ImageProcessor.applySharpeningFilter(imageShape);
//     case 11:
//       return ImageProcessor.applyGaussianBlur(imageShape);
//     case 12:
//       return ImageProcessor.applyCustomFilter(
//         imageShape,
//         [
//           [1 / 16, 2 / 16, 1 / 16],
//           [2 / 16, 4 / 16, 2 / 16],
//           [1 / 16, 2 / 16, 1 / 16]
//         ],
//       );
//     case 13:
//       return ImageProcessor.simpleThreshold(imageShape, 128);
//     case 14:
//       return ImageProcessor.percentBlackSelection(imageShape, 0.5);
//     case 15:
//       return ImageProcessor.meanIterativeSelection(imageShape);
//     case 16:
//       return ImageProcessor.entropySelection(imageShape);
//     case 17:
//       return ImageProcessor.minimumErrorThreshold(imageShape);
//     case 18:
//       return ImageProcessor.fuzzyMinimumErrorThreshold(imageShape);
//     case 19:
//       return ImageProcessor.dilate(imageShape, 3);
//     case 20:
//       return ImageProcessor.erode(imageShape, 3);
//     case 21:
//       return ImageProcessor.opening(imageShape, 3);
//     case 22:
//       return ImageProcessor.closing(imageShape, 3);
//     case 23:
//       return ImageProcessor.hitOrMiss(imageShape, [
//         [1, 1, 1],
//         [1, -1, -1],
//         [-1, -1, -1]
//       ]);
//     case 24:
//       return ImageProcessor.otsuThreshold(imageShape);
//     case 25:
//       return ImageProcessor.niblackThreshold(imageShape, -0.2);
//     case 26:
//       return ImageProcessor.sauvolaThreshold(imageShape, -0.2);
//     default:
//       return imageShape;
//   }
// }

// class ImageProcessor {
//   static List<Pixel> addRGB(List<Pixel> pixels, int r, int g, int b) {
//     return pixels.map((pixel) {
//       final newColor = _clampColor(
//         pixel.color.red + r,
//         pixel.color.green + g,
//         pixel.color.blue + b,
//       );
//       return Pixel(pixel.position, newColor);
//     }).toList();
//   }

//   static List<Pixel> subtractRGB(List<Pixel> pixels, int r, int g, int b) {
//     return pixels.map((pixel) {
//       final newColor = _clampColor(
//         pixel.color.red - r,
//         pixel.color.green - g,
//         pixel.color.blue - b,
//       );
//       return Pixel(pixel.position, newColor);
//     }).toList();
//   }

//   static List<Pixel> multiplyRGB(
//       List<Pixel> pixels, double r, double g, double b) {
//     return pixels.map((pixel) {
//       final newColor = _clampColor(
//         (pixel.color.red * r).toInt(),
//         (pixel.color.green * g).toInt(),
//         (pixel.color.blue * b).toInt(),
//       );
//       return Pixel(pixel.position, newColor);
//     }).toList();
//   }

//   static List<Pixel> divideRGB(
//       List<Pixel> pixels, double r, double g, double b) {
//     return pixels.map((pixel) {
//       final newColor = _clampColor(
//         (pixel.color.red / r).toInt(),
//         (pixel.color.green / g).toInt(),
//         (pixel.color.blue / b).toInt(),
//       );
//       return Pixel(pixel.position, newColor);
//     }).toList();
//   }

//   static List<Pixel> adjustBrightness(List<Pixel> pixels, int brightness) {
//     return pixels.map((pixel) {
//       final newColor = _clampColor(
//         pixel.color.red + brightness,
//         pixel.color.green + brightness,
//         pixel.color.blue + brightness,
//       );
//       return Pixel(pixel.position, newColor);
//     }).toList();
//   }

//   static List<Pixel> grayscale(List<Pixel> pixels, GrayscaleMode mode) {
//     return pixels.map((pixel) {
//       int grayValue;
//       switch (mode) {
//         case GrayscaleMode.average:
//           grayValue =
//               (pixel.color.red + pixel.color.green + pixel.color.blue) ~/ 3;
//           break;
//         case GrayscaleMode.red:
//           grayValue = pixel.color.red;
//           break;
//         case GrayscaleMode.green:
//           grayValue = pixel.color.green;
//           break;
//         case GrayscaleMode.blue:
//           grayValue = pixel.color.blue;
//           break;
//         case GrayscaleMode.max:
//           grayValue = [pixel.color.red, pixel.color.green, pixel.color.blue]
//               .reduce((a, b) => a > b ? a : b);
//           break;
//         case GrayscaleMode.min:
//           grayValue = [pixel.color.red, pixel.color.green, pixel.color.blue]
//               .reduce((a, b) => a < b ? a : b);
//           break;
//       }
//       final grayColor = Color.fromARGB(255, grayValue, grayValue, grayValue);
//       return Pixel(pixel.position, grayColor);
//     }).toList();
//   }

//   static Color _clampColor(int r, int g, int b) {
//     return Color.fromARGB(
//       255,
//       r.clamp(0, 255),
//       g.clamp(0, 255),
//       b.clamp(0, 255),
//     );
//   }

//   static ImageShape applyConvolution(
//       ImageShape shape, List<List<double>> mask) {
//     final int maskSize = mask.length;
//     final int offset = maskSize ~/ 2;

//     final pixels = List.of(shape.pixels);
//     final width = shape.endPosition.dx.toInt();
//     final height = shape.endPosition.dy.toInt();

//     final newPixels =
//         List<Pixel>.generate(pixels.length, (index) => pixels[index]);

//     for (int y = 0; y < height; y++) {
//       for (int x = 0; x < width; x++) {
//         double r = 0, g = 0, b = 0, weightSum = 0;

//         for (int i = -offset; i <= offset; i++) {
//           for (int j = -offset; j <= offset; j++) {
//             final nx = x + i;
//             final ny = y + j;

//             if (nx >= 0 && nx < width && ny >= 0 && ny < height) {
//               final pixelIndex = ny * width + nx;
//               final pixelColor = pixels[pixelIndex].color;

//               final weight = mask[i + offset][j + offset];
//               r += pixelColor.red * weight;
//               g += pixelColor.green * weight;
//               b += pixelColor.blue * weight;
//               weightSum += weight.abs();
//             }
//           }
//         }

//         weightSum = weightSum > 0 ? weightSum : 1;
//         r = r.clamp(0, 255) / weightSum;
//         g = g.clamp(0, 255) / weightSum;
//         b = b.clamp(0, 255) / weightSum;

//         final newColor = Color.fromARGB(255, r.round(), g.round(), b.round());
//         newPixels[y * width + x] =
//             Pixel(Offset(x.toDouble(), y.toDouble()), newColor);
//       }
//     }

//     return ImageShape(
//       type: ShapeType.freeDraw,
//       startPosition: Offset.zero,
//       endPosition: Offset(width.toDouble(), height.toDouble()),
//       pixels: newPixels,
//     );
//   }

//   static ImageShape applyMeanFilter(ImageShape shape) {
//     final mask = [
//       [1 / 9, 1 / 9, 1 / 9],
//       [1 / 9, 1 / 9, 1 / 9],
//       [1 / 9, 1 / 9, 1 / 9],
//     ];
//     return applyConvolution(shape, mask);
//   }

//   static ImageShape applyMedianFilter(ImageShape shape, int size) {
//     final offset = size ~/ 2;
//     final pixels = shape.pixels;
//     final width = shape.endPosition.dx.toInt();
//     final height = shape.endPosition.dy.toInt();

//     final newPixels =
//         List<Pixel>.generate(pixels.length, (index) => pixels[index]);

//     final reds = List<int>.filled(256, 0);
//     final greens = List<int>.filled(256, 0);
//     final blues = List<int>.filled(256, 0);

//     for (int y = 0; y < height; y++) {
//       reds.fillRange(0, 256, 0);
//       greens.fillRange(0, 256, 0);
//       blues.fillRange(0, 256, 0);

//       for (int dy = -offset; dy <= offset; dy++) {
//         for (int dx = -offset; dx <= offset; dx++) {
//           final nx = dx.clamp(0, width - 1);
//           final ny = (y + dy).clamp(0, height - 1);
//           final pixelIndex = ny * width + nx;
//           final color = pixels[pixelIndex].color;

//           reds[color.red]++;
//           greens[color.green]++;
//           blues[color.blue]++;
//         }
//       }

//       for (int x = 0; x < width; x++) {
//         int findMedian(List<int> histogram, int total) {
//           int count = 0;
//           for (int i = 0; i < 256; i++) {
//             count += histogram[i];
//             if (count > total ~/ 2) return i;
//           }
//           return 0;
//         }

//         final medianRed = findMedian(reds, size * size);
//         final medianGreen = findMedian(greens, size * size);
//         final medianBlue = findMedian(blues, size * size);

//         final newColor =
//             Color.fromARGB(255, medianRed, medianGreen, medianBlue);
//         newPixels[y * width + x] =
//             Pixel(Offset(x.toDouble(), y.toDouble()), newColor);

//         if (x + offset + 1 < width) {
//           for (int dy = -offset; dy <= offset; dy++) {
//             final ny = (y + dy).clamp(0, height - 1);
//             final addPixelIndex = ny * width + (x + offset + 1);
//             final addColor = pixels[addPixelIndex].color;

//             reds[addColor.red]++;
//             greens[addColor.green]++;
//             blues[addColor.blue]++;
//           }
//         }

//         if (x - offset >= 0) {
//           for (int dy = -offset; dy <= offset; dy++) {
//             final ny = (y + dy).clamp(0, height - 1);
//             final removePixelIndex = ny * width + (x - offset);
//             final removeColor = pixels[removePixelIndex].color;

//             reds[removeColor.red]--;
//             greens[removeColor.green]--;
//             blues[removeColor.blue]--;
//           }
//         }
//       }
//     }

//     return ImageShape(
//       type: ShapeType.freeDraw,
//       startPosition: Offset.zero,
//       endPosition: Offset(width.toDouble(), height.toDouble()),
//       pixels: newPixels,
//     );
//   }

//   static ImageShape applySobelFilter(ImageShape shape) {
//     final gx = [
//       [-1.0, 0.0, 1.0],
//       [-2.0, 0.0, 2.0],
//       [-1.0, 0.0, 1.0],
//     ];

//     final gy = [
//       [-1.0, -2.0, -1.0],
//       [0.0, 0.0, 0.0],
//       [1.0, 2.0, 1.0],
//     ];
//     final result = applyConvolution(shape, gx);
//     return applyConvolution(result, gy);
//   }

//   static ImageShape applySharpeningFilter(ImageShape shape) {
//     final mask = [
//       [0.0, -1.0, 0.0],
//       [-1.0, 5.0, -1.0],
//       [0.0, -1.0, 0.0],
//     ];
//     return applyConvolution(shape, mask);
//   }

//   static ImageShape applyGaussianBlur(ImageShape shape) {
//     final mask = [
//       [1 / 16, 2 / 16, 1 / 16],
//       [2 / 16, 4 / 16, 2 / 16],
//       [1 / 16, 2 / 16, 1 / 16],
//     ];
//     return applyConvolution(shape, mask);
//   }

//   static ImageShape applyCustomFilter(
//       ImageShape shape, List<List<double>> mask) {
//     return applyConvolution(shape, mask);
//   }

//   static ImageShape simpleThreshold(ImageShape imageShape, int threshold) {
//     final pixels = imageShape.pixels.map((pixel) {
//       final intensity = pixel.color.red;
//       final newColor = intensity >= threshold
//           ? const Color.fromARGB(255, 255, 255, 255)
//           : const Color.fromARGB(255, 0, 0, 0);
//       return Pixel(pixel.position, newColor);
//     }).toList();

//     return ImageShape(
//       type: imageShape.type,
//       startPosition: imageShape.startPosition,
//       endPosition: imageShape.endPosition,
//       pixels: pixels,
//       points: imageShape.points,
//       color: imageShape.color,
//       text: imageShape.text,
//     );
//   }

//   static ImageShape percentBlackSelection(
//       ImageShape imageShape, double percentage) {
//     final pixels = imageShape.pixels;
//     final sortedIntensities = pixels.map((pixel) => pixel.color.red).toList()
//       ..sort();

//     final thresholdIndex = (percentage * sortedIntensities.length).toInt();
//     final threshold = sortedIntensities[thresholdIndex];

//     return simpleThreshold(imageShape, threshold);
//   }

//   static ImageShape meanIterativeSelection(ImageShape imageShape) {
//     final pixels = imageShape.pixels;
//     double tPrev, tCurrent = 128.0;

//     do {
//       tPrev = tCurrent;

//       final lower = pixels
//           .where((p) => p.color.red <= tPrev)
//           .map((p) => p.color.red)
//           .toList();
//       final upper = pixels
//           .where((p) => p.color.red > tPrev)
//           .map((p) => p.color.red)
//           .toList();

//       final meanLower =
//           lower.isNotEmpty ? lower.reduce((a, b) => a + b) / lower.length : 0;
//       final meanUpper =
//           upper.isNotEmpty ? upper.reduce((a, b) => a + b) / upper.length : 0;

//       tCurrent = (meanLower + meanUpper) / 2;
//     } while ((tPrev - tCurrent).abs() > 1.0);

//     return simpleThreshold(imageShape, tCurrent.toInt());
//   }

//   static ImageShape entropySelection(ImageShape imageShape) {
//     final hist = List<int>.filled(256, 0);
//     log("Tworzenie histogramu...");

//     for (final pixel in imageShape.pixels) {
//       hist[pixel.color.red]++;
//     }

//     final totalPixels = imageShape.pixels.length;
//     final prob = hist.map((count) => count / totalPixels).toList();

//     double maxEntropy = double.negativeInfinity;
//     int bestThreshold = 0;

//     for (int t = 0; t < 256; t++) {
//       final prob0 = prob.sublist(0, t);
//       final prob1 = prob.sublist(t);

//       final p0 = prob0.fold(0.0, (a, b) => a + b);
//       final p1 = prob1.fold(0.0, (a, b) => a + b);

//       if (p0 > 0 && p1 > 0) {
//         final h0 = prob0
//             .map((p) => p > 0 ? p / p0 * math.log(p / p0) : 0)
//             .fold(0.0, (a, b) => a - b);
//         final h1 = prob1
//             .map((p) => p > 0 ? p / p1 * math.log(p / p1) : 0)
//             .fold(0.0, (a, b) => a - b);

//         final entropy = h0 + h1;

//         if (entropy > maxEntropy) {
//           maxEntropy = entropy;
//           bestThreshold = t;
//         }
//       }
//     }

//     log("Najlepszy próg: $bestThreshold z entropią: $maxEntropy");

//     return simpleThreshold(imageShape, bestThreshold);
//   }

//   static ImageShape minimumErrorThreshold(ImageShape imageShape) {
//     final pixels = imageShape.pixels.map((pixel) => pixel.color.red).toList();
//     final hist = List<int>.filled(256, 0);

//     for (final intensity in pixels) {
//       hist[intensity]++;
//     }

//     final totalPixels = pixels.length;

//     double minError = double.infinity;
//     int bestThreshold = 0;

//     for (int t = 1; t < 256; t++) {
//       final hist0 = hist.sublist(0, t);
//       final hist1 = hist.sublist(t);

//       final w0 = hist0.fold(0, (sum, count) => sum + count) / totalPixels;
//       final w1 = hist1.fold(0, (sum, count) => sum + count) / totalPixels;

//       if (w0 > 0 && w1 > 0) {
//         final mu0 = hist0
//                 .asMap()
//                 .entries
//                 .fold(0.0, (sum, entry) => sum + entry.key * entry.value) /
//             (w0 * totalPixels);

//         final mu1 = hist1.asMap().entries.fold(
//                 0.0, (sum, entry) => sum + (entry.key + t) * entry.value) /
//             (w1 * totalPixels);

//         final variance0 = hist0.asMap().entries.fold(
//                 0.0,
//                 (sum, entry) =>
//                     sum + (entry.key - mu0) * (entry.key - mu0) * entry.value) /
//             (w0 * totalPixels);

//         final variance1 = hist1.asMap().entries.fold(
//                 0.0,
//                 (sum, entry) =>
//                     sum +
//                     ((entry.key + t) - mu1) *
//                         ((entry.key + t) - mu1) *
//                         entry.value) /
//             (w1 * totalPixels);

//         final error = w0 * variance0 + w1 * variance1;

//         if (error < minError) {
//           minError = error;
//           bestThreshold = t;
//         }
//       }
//     }

//     return simpleThreshold(imageShape, bestThreshold);
//   }

//   static ImageShape fuzzyMinimumErrorThreshold(ImageShape imageShape) {
//     final pixels = imageShape.pixels.map((pixel) => pixel.color.red).toList();
//     final hist = List<int>.filled(256, 0);

//     for (final intensity in pixels) {
//       hist[intensity]++;
//     }

//     final totalPixels = pixels.length;
//     final probabilities = hist.map((h) => h / totalPixels).toList();

//     double minFuzzyError = double.infinity;
//     int bestThreshold = 0;

//     for (int t = 1; t < 256; t++) {
//       final prob0 = probabilities.sublist(0, t);
//       final prob1 = probabilities.sublist(t);

//       final p0 = prob0.fold(0.0, (a, b) => a + b);
//       final p1 = prob1.fold(0.0, (a, b) => a + b);

//       if (p0 > 0 && p1 > 0) {
//         final mu0 = prob0
//                 .asMap()
//                 .entries
//                 .fold(0.0, (sum, entry) => sum + entry.key * entry.value) /
//             p0;

//         final mu1 = prob1.asMap().entries.fold(
//                 0.0, (sum, entry) => sum + (entry.key + t) * entry.value) /
//             p1;

//         final fuzzyError = p0 * (1 - p0) + p1 * (1 - p1) + (mu0 - mu1).abs();

//         if (fuzzyError < minFuzzyError) {
//           minFuzzyError = fuzzyError;
//           bestThreshold = t;
//         }
//       }
//     }

//     return simpleThreshold(imageShape, bestThreshold);
//   }

//   static ImageShape dilate(ImageShape imageShape, int maskSize) {
//     final pixels = imageShape.pixels;
//     final offset = maskSize ~/ 2;
//     final width = imageShape.endPosition.dx.toInt();
//     final height = imageShape.endPosition.dy.toInt();

//     final newPixels =
//         List<Pixel>.generate(pixels.length, (index) => pixels[index]);

//     for (int y = offset; y < height - offset; y++) {
//       for (int x = offset; x < width - offset; x++) {
//         for (int dy = -offset; dy <= offset; dy++) {
//           for (int dx = -offset; dx <= offset; dx++) {
//             final nx = x + dx;
//             final ny = y + dy;

//             if (pixels[ny * width + nx].color.red == 255) {
//               newPixels[y * width + x] = Pixel(
//                   Offset(x.toDouble(), y.toDouble()),
//                   const Color.fromARGB(255, 255, 255, 255));
//               break;
//             }
//           }
//         }
//       }
//     }

//     return ImageShape(
//       type: imageShape.type,
//       startPosition: imageShape.startPosition,
//       endPosition: imageShape.endPosition,
//       pixels: newPixels,
//       points: imageShape.points,
//       color: imageShape.color,
//       text: imageShape.text,
//     );
//   }

//   static ImageShape erode(ImageShape imageShape, int maskSize) {
//     final pixels = imageShape.pixels;
//     final offset = maskSize ~/ 2;
//     final width = imageShape.endPosition.dx.toInt();
//     final height = imageShape.endPosition.dy.toInt();

//     final newPixels =
//         List<Pixel>.generate(pixels.length, (index) => pixels[index]);

//     for (int y = offset; y < height - offset; y++) {
//       for (int x = offset; x < width - offset; x++) {
//         bool allWhite = true;

//         for (int dy = -offset; dy <= offset; dy++) {
//           for (int dx = -offset; dx <= offset; dx++) {
//             final nx = x + dx;
//             final ny = y + dy;

//             if (pixels[ny * width + nx].color.red == 0) {
//               allWhite = false;
//               break;
//             }
//           }
//         }

//         if (!allWhite) {
//           newPixels[y * width + x] = Pixel(Offset(x.toDouble(), y.toDouble()),
//               const Color.fromARGB(255, 0, 0, 0));
//         }
//       }
//     }

//     return ImageShape(
//       type: imageShape.type,
//       startPosition: imageShape.startPosition,
//       endPosition: imageShape.endPosition,
//       pixels: newPixels,
//       points: imageShape.points,
//       color: imageShape.color,
//       text: imageShape.text,
//     );
//   }

//   static ImageShape opening(ImageShape imageShape, int maskSize) {
//     return dilate(erode(imageShape, maskSize), maskSize);
//   }

//   static ImageShape closing(ImageShape imageShape, int maskSize) {
//     return erode(dilate(imageShape, maskSize), maskSize);
//   }

//   static ImageShape hitOrMiss(ImageShape imageShape, List<List<int>> kernel) {
//     final offset = kernel.length ~/ 2;
//     final pixels = imageShape.pixels;
//     final width = imageShape.endPosition.dx.toInt();
//     final height = imageShape.endPosition.dy.toInt();

//     final newPixels =
//         List<Pixel>.generate(pixels.length, (index) => pixels[index]);

//     for (int y = offset; y < height - offset; y++) {
//       for (int x = offset; x < width - offset; x++) {
//         bool match = true;

//         for (int i = -offset; i <= offset; i++) {
//           for (int j = -offset; j <= offset; j++) {
//             final nx = x + i;
//             final ny = y + j;
//             final kernelValue = kernel[i + offset][j + offset];
//             final pixelIntensity = pixels[ny * width + nx].color.red;

//             if (kernelValue == 1 && pixelIntensity != 255) {
//               match = false;
//             } else if (kernelValue == -1 && pixelIntensity != 0) {
//               match = false;
//             }

//             if (!match) break;
//           }
//           if (!match) break;
//         }

//         final newColor = match
//             ? const Color.fromARGB(255, 255, 255, 255)
//             : const Color.fromARGB(255, 0, 0, 0);
//         newPixels[y * width + x] =
//             Pixel(Offset(x.toDouble(), y.toDouble()), newColor);
//       }
//     }

//     return ImageShape(
//       type: imageShape.type,
//       startPosition: imageShape.startPosition,
//       endPosition: imageShape.endPosition,
//       pixels: newPixels,
//       points: imageShape.points,
//       color: imageShape.color,
//       text: imageShape.text,
//     );
//   }

//   static ImageShape otsuThreshold(ImageShape imageShape) {
//     final hist = List<int>.filled(256, 0);

//     for (final pixel in imageShape.pixels) {
//       hist[pixel.color.red]++;
//     }

//     final totalPixels = imageShape.pixels.length;
//     int sum = 0, sumB = 0, weightB = 0, weightF = 0;
//     double maxVariance = 0.0;
//     int bestThreshold = 0;

//     for (int i = 0; i < 256; i++) {
//       sum += i * hist[i];
//     }

//     for (int t = 0; t < 256; t++) {
//       weightB += hist[t];
//       if (weightB == 0) continue;

//       weightF = totalPixels - weightB;
//       if (weightF == 0) break;

//       sumB += t * hist[t];
//       final meanB = sumB / weightB;
//       final meanF = (sum - sumB) / weightF;

//       final variance = weightB * weightF * math.pow(meanB - meanF, 2);
//       if (variance > maxVariance) {
//         maxVariance = variance.toDouble();
//         bestThreshold = t;
//       }
//     }

//     return simpleThreshold(imageShape, bestThreshold);
//   }

//   static ImageShape niblackThreshold(ImageShape imageShape, double k) {
//     final newPixels = List<Pixel>.from(imageShape.pixels);

//     for (int i = 0; i < imageShape.pixels.length; i++) {
//       final pixel = imageShape.pixels[i];
//       final window = _getWindow(imageShape, pixel.position);

//       final mean = _calculateMean(window);
//       final stdDev = _calculateStandardDeviation(window, mean);

//       final threshold = mean + k * stdDev;

//       newPixels[i] = pixel.color.red < threshold
//           ? Pixel(pixel.position, Colors.black)
//           : Pixel(pixel.position, Colors.white);
//     }

//     return ImageShape(
//       type: imageShape.type,
//       startPosition: imageShape.startPosition,
//       endPosition: imageShape.endPosition,
//       points: imageShape.points,
//       color: imageShape.color,
//       text: imageShape.text,
//       pixels: newPixels,
//     );
//   }

//   static ImageShape sauvolaThreshold(ImageShape imageShape, double k) {
//     final newPixels = List<Pixel>.from(imageShape.pixels);
//     const r = 128.0;

//     for (int i = 0; i < imageShape.pixels.length; i++) {
//       final pixel = imageShape.pixels[i];
//       final window = _getWindow(imageShape, pixel.position);

//       final mean = _calculateMean(window);
//       final stdDev = _calculateStandardDeviation(window, mean);

//       final threshold = mean * (1 + k * (stdDev / r - 1));

//       newPixels[i] = pixel.color.red < threshold
//           ? Pixel(pixel.position, Colors.black)
//           : Pixel(pixel.position, Colors.white);
//     }

//     return ImageShape(
//       type: imageShape.type,
//       startPosition: imageShape.startPosition,
//       endPosition: imageShape.endPosition,
//       points: imageShape.points,
//       color: imageShape.color,
//       text: imageShape.text,
//       pixels: newPixels,
//     );
//   }

//   static double _calculateMean(List<Pixel> window) {
//     return window.fold(0.0, (sum, p) => sum + p.color.red) / window.length;
//   }

//   static double _calculateStandardDeviation(List<Pixel> window, double mean) {
//     final variance =
//         window.fold(0.0, (sum, p) => sum + math.pow(p.color.red - mean, 2)) /
//             window.length;
//     return math.sqrt(variance);
//   }

//   static List<Pixel> _getWindow(ImageShape imageShape, Offset center) {
//     const windowSize = 7;
//     const halfSize = windowSize ~/ 2;

//     return imageShape.pixels.where((pixel) {
//       final dx = (pixel.position.dx - center.dx).abs();
//       final dy = (pixel.position.dy - center.dy).abs();
//       return dx <= halfSize && dy <= halfSize;
//     }).toList();
//   }
// }

// enum GrayscaleMode {
//   average,
//   red,
//   green,
//   blue,
//   max,
//   min,
// }
