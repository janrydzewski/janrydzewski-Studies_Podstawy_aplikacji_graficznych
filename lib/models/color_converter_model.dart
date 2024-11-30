import 'dart:math';

class ColorConverter {
  static Map<String, double> rgbToCmyk(int r, int g, int b) {
    double rRatio = r / 255.0;
    double gRatio = g / 255.0;
    double bRatio = b / 255.0;

    double c = 1 - rRatio;
    double m = 1 - gRatio;
    double y = 1 - bRatio;

    double k = [c, m, y].reduce(min);

    if (k < 1.0) {
      c = (c - k) / (1 - k);
      m = (m - k) / (1 - k);
      y = (y - k) / (1 - k);
    } else {
      c = 0;
      m = 0;
      y = 0;
    }

    return {'C': c, 'M': m, 'Y': y, 'K': k};
  }

  static Map<String, double> rgbToHsv(int r, int g, int b) {
    double rRatio = r / 255.0;
    double gRatio = g / 255.0;
    double bRatio = b / 255.0;

    double maxVal = max(rRatio, max(gRatio, bRatio));
    double minVal = min(rRatio, min(gRatio, bRatio));
    double delta = maxVal - minVal;

    double h = 0;
    double s = (maxVal == 0) ? 0 : delta / maxVal;
    double v = maxVal;

    if (delta != 0) {
      if (maxVal == rRatio) {
        h = 60 * (((gRatio - bRatio) / delta) % 6);
      } else if (maxVal == gRatio) {
        h = 60 * (((bRatio - rRatio) / delta) + 2);
      } else {
        h = 60 * (((rRatio - gRatio) / delta) + 4);
      }
    }

    if (h < 0) h += 360;

    return {'H': h, 'S': s, 'V': v};
  }

  static Map<String, double> cmykToRgb(double c, double m, double y, double k) {
    int r = (255 * (1 - c) * (1 - k)).round().clamp(0, 255);
    int g = (255 * (1 - m) * (1 - k)).round().clamp(0, 255);
    int b = (255 * (1 - y) * (1 - k)).round().clamp(0, 255);

    return {'R': r.toDouble(), 'G': g.toDouble(), 'B': b.toDouble()};
  }

  static Map<String, double> hsvToRgb(double h, double s, double v) {
    double c = v * s;
    double x = c * (1 - ((h / 60) % 2 - 1).abs());
    double m = v - c;

    double r = 0, g = 0, b = 0;
    if (h < 60) {
      r = c;
      g = x;
    } else if (h < 120) {
      r = x;
      g = c;
    } else if (h < 180) {
      g = c;
      b = x;
    } else if (h < 240) {
      g = x;
      b = c;
    } else if (h < 300) {
      r = x;
      b = c;
    } else {
      r = c;
      b = x;
    }

    return {
      'R': ((r + m) * 255).clamp(0, 255),
      'G': ((g + m) * 255).clamp(0, 255),
      'B': ((b + m) * 255).clamp(0, 255),
    };
  }
}
