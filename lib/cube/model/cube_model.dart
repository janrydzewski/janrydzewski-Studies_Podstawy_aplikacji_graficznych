import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2, Vector3;
import 'dart:math' as math;

class CustomCube extends StatefulWidget {
  final Vector2 delta;
  final double size;
  final Widget top;
  final Widget bottom;
  final Widget left;
  final Widget right;
  final Widget front;
  final Widget back;

  const CustomCube({
    super.key,
    required this.delta,
    required this.size,
    required this.top,
    required this.bottom,
    required this.front,
    required this.back,
    required this.right,
    required this.left,
  });

  @override
  State<CustomCube> createState() => _CubixDState();
}

class _CubixDState extends State<CustomCube>
    with SingleTickerProviderStateMixin {
  static const double _fiveDeg = CubixdUtils.fiveDeg;
  late final double _transitionMargin;
  late final double _height;
  late final double _width;
  late Widget top;
  late Widget rgt;
  late Widget bottom;
  late Widget lft;
  late Widget front;
  late Widget back;
  final CubixdTriggerSwitch _switch = CubixdTriggerSwitch(false);
  List<Widget> faces = [];

  @override
  void initState() {
    super.initState();
    _width = widget.size;
    _height = widget.size;
    top = _buildFace(side: 0, rotate: false, child: widget.top);
    bottom = _buildFace(side: 2, rotate: false, child: widget.bottom);
    _transitionMargin = _fiveDeg * 0.005 * (_height + _width) / 2;
    _buildFaces(false);
  }

  void _buildFaces(bool rotate) {
    rgt = _buildFace(side: 1, rotate: rotate, child: widget.right);
    lft = _buildFace(side: 3, rotate: rotate, child: widget.left);
    front = Transform(
      transform: Matrix4.identity()
        ..translate(Vector3(0, 0, -_width / 2))
        ..rotateZ(rotate ? math.pi : 0),
      alignment: Alignment.center,
      child: widget.front,
    );
    back = Transform(
      transform: Matrix4.identity()
        ..translate(Vector3(0, 0, _height / 2))
        ..rotateZ(rotate ? math.pi : 0)
        ..rotateY(math.pi),
      alignment: Alignment.center,
      child: widget.back,
    );
  }

  @override
  Widget build(BuildContext context) {
    final opt = (widget.delta.x > math.pi / 2 &&
            widget.delta.x < 3 * math.pi / 2) ||
        (widget.delta.x < -math.pi / 2 && widget.delta.x > -3 * math.pi / 2);
    _cubeEngine(widget.delta.y > 0);
    _switch.run(() => _buildFaces(opt), opt);

    return SizedBox(
      height: _height * 1.2,
      width: _width * 1.2,
      child: Stack(
        children: [
          SizedBox(
            height: _height,
            width: _width,
            child: Transform(
              transform: Matrix4.identity()
                ..translate(_width * 0.09, _height * 0.09, 0)
                ..setEntry(3, 2, 0.001)
                ..rotateX(widget.delta.x)
                ..rotateY(widget.delta.y),
              alignment: FractionalOffset.center,
              child: Stack(children: faces),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFace({
    required int side,
    required bool rotate,
    required Widget child,
  }) {
    final double translate;
    if (side > 3 || side < 0) throw Exception('Non side "$side" was found');
    final topOrBottom = side == 0 || side == 2;
    final Matrix4 transform;

    if (topOrBottom) {
      translate = side == 0 ? -_height / 2 : _height / 2;
      transform = Matrix4.identity()
        ..translate(0.0, translate, 0.0)
        ..rotateX(math.pi / 2)
        ..rotateX(side == 2 ? 0 : math.pi);
    } else {
      translate = side == 3 ? _width / -2 : _width / 2;
      transform = Matrix4.identity()
        ..translate(translate, 0.0, 0.0)
        ..rotateY(math.pi / 2)
        ..rotateY(side == 3 ? 0 : math.pi);
    }

    return Positioned.fill(
      child: Transform(
        transform: transform..rotateZ(rotate && !topOrBottom ? math.pi : 0),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  void _cubeEngine(bool opt) {
    if (widget.delta.x < -3 * math.pi / 2) {
      opt ? positiveYAux(true) : negativeYAux(true);
    } else if (widget.delta.x < -math.pi / 2) {
      opt ? positiveYAux(false) : negativeYAux(false);
    } else if (widget.delta.x < math.pi / 2) {
      opt ? positiveYAux(true) : negativeYAux(true);
    } else if (widget.delta.x < 3 * math.pi / 2) {
      opt ? positiveYAux(false) : negativeYAux(false);
    } else {
      opt ? positiveYAux(true) : negativeYAux(true);
    }
    universal();
  }

  void universal() {
    if (widget.delta.x < -2 * math.pi + 0.95 * _transitionMargin) {
      faces.insert(0, top);
    } else if (widget.delta.x < -math.pi - 1.35 * _transitionMargin) {
      faces.add(top);
    } else if (widget.delta.x < -math.pi + 0.95 * _transitionMargin) {
      faces.insert(0, top);
    } else if (widget.delta.x < -1.35 * _transitionMargin) {
      faces.add(bottom);
    } else if (widget.delta.x < 0.95 * _transitionMargin) {
      faces.insert(0, top);
    } else if (widget.delta.x < math.pi - 1.35 * _transitionMargin) {
      faces.add(top);
    } else if (widget.delta.x < math.pi + 0.95 * _transitionMargin) {
      faces.insert(0, bottom);
    } else if (widget.delta.x < 2 * math.pi - 1.35 * _transitionMargin) {
      faces.add(bottom);
    } else {
      faces.insert(0, bottom);
    }
  }

  void negativeYAux(bool opt) {
    if (opt) {
      if (widget.delta.y < -(3 * math.pi / 2 + _transitionMargin)) {
        faces = widget.delta.y < -_fiveDeg * 63 ? [rgt, front] : [front, rgt];
      } else if (widget.delta.y < -(math.pi + _transitionMargin)) {
        faces = widget.delta.y < -_fiveDeg * 45 ? [back, rgt] : [rgt, back];
      } else if (widget.delta.y < -(math.pi / 2 + _transitionMargin)) {
        faces = widget.delta.y < -_fiveDeg * 27 ? [lft, back] : [back, lft];
      } else {
        faces = widget.delta.y < -_fiveDeg * 9 ? [front, lft] : [lft, front];
      }
    } else {
      if (widget.delta.y < -(3 * math.pi / 2 + _transitionMargin)) {
        faces = widget.delta.y < -_fiveDeg * 63 ? [lft, back] : [back, lft];
      } else if (widget.delta.y < -(math.pi + _transitionMargin)) {
        faces = widget.delta.y < -_fiveDeg * 45 ? [front, lft] : [lft, front];
      } else if (widget.delta.y < -(math.pi / 2 + _transitionMargin)) {
        faces = widget.delta.y < -_fiveDeg * 27 ? [rgt, front] : [front, rgt];
      } else {
        faces = widget.delta.y < -_fiveDeg * 9 ? [back, rgt] : [rgt, back];
      }
    }
  }

  void positiveYAux(bool opt) {
    if (opt) {
      if (widget.delta.y < (math.pi / 2) - _transitionMargin) {
        faces = widget.delta.y > _fiveDeg * 9 ? [front, rgt] : [rgt, front];
      } else if (widget.delta.y < math.pi + _transitionMargin) {
        faces = widget.delta.y > _fiveDeg * 27 ? [rgt, back] : [back, rgt];
      } else if (widget.delta.y < 3 * math.pi / 2 + _transitionMargin) {
        faces = widget.delta.y > _fiveDeg * 45 ? [back, lft] : [lft, back];
      } else {
        faces = widget.delta.y < _fiveDeg * 63 ? [front, lft] : [lft, front];
      }
    } else {
      if (widget.delta.y < (math.pi / 2) - _transitionMargin) {
        faces = widget.delta.y > _fiveDeg * 9 ? [back, lft] : [lft, back];
      } else if (widget.delta.y < math.pi + _transitionMargin) {
        faces = widget.delta.y > _fiveDeg * 27 ? [lft, front] : [front, lft];
      } else if (widget.delta.y < 3 * math.pi / 2 + _transitionMargin) {
        faces = widget.delta.y > 45 * _fiveDeg ? [front, rgt] : [rgt, front];
      } else {
        faces = widget.delta.y < _fiveDeg * 63 ? [back, rgt] : [rgt, back];
      }
    }
  }
}

class CubixdTriggerSwitch {
  bool _opt;
  CubixdTriggerSwitch(this._opt);

  void run(VoidCallback call, bool opt) {
    if (_opt != opt) {
      call();
      _opt = !_opt;
    }
  }
}

abstract class CubixdUtils {
  static const int iSel = 4;
  static const double fiveDeg = math.pi / 36;

  static double getIvalue(double val) {
    final resP = val.abs() % (math.pi / 2);
    final resN = -val.abs() % (math.pi / 2);
    if (resP < CubixdUtils.iSel * CubixdUtils.fiveDeg) {
      return val < 0 ? val + resP : val - resP;
    }
    return val < 0 ? val - resN : val + resN;
  }
}
