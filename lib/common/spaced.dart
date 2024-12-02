import 'package:flutter/material.dart';

extension SpacedWidgets on Iterable<Widget> {
  /// Interleaves a widget between a list of widgets
  List<Widget> spacedWith(
    Widget spacer, {
    bool spaceEvenly = false,
  }) {
    final spacedItems = expand(
      (item) sync* {
        yield spacer;
        yield item;
      },
    ).skip(1).toList();

    if (spaceEvenly) {
      return [
        spacer,
        ...spacedItems,
        spacer,
      ];
    } else {
      return spacedItems;
    }
  }

  List<Widget> spaced(
    double gap, {
    bool spaceEvenly = false,
  }) =>
      spacedWith(SizedBox(width: gap, height: gap), spaceEvenly: spaceEvenly);
}

const kColumnPadding = EdgeInsets.symmetric(horizontal: 16);

extension ColumnPadding on Widget {
  Widget get columnPadding {
    return Padding(
      padding: kColumnPadding,
      child: this,
    );
  }
}
