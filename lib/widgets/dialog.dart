import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<String?> showTextInputDialog(BuildContext context) async {
  String inputText = "";
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter Text'),
        content: TextField(
          onChanged: (value) {
            inputText = value;
          },
          decoration: const InputDecoration(hintText: "Type your text here"),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(inputText);
            },
          ),
        ],
      );
    },
  );
}

Future<int?> showBezierPoints(BuildContext context) async {
  int inputText = 2;
  return await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter bezier points'),
        content: TextField(
          onChanged: (value) {
            inputText = int.parse(value);
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(inputText);
            },
          ),
        ],
      );
    },
  );
}

Future<Offset?> showMoveDialog(BuildContext context) async {
  double? x, y;
  return await showDialog<Offset>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter offset'),
        content: Column(
          children: [
            TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                x = double.parse(value);
              },
              decoration: const InputDecoration(labelText: 'X'),
            ),
            TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                y = double.parse(value);
              },
              decoration: const InputDecoration(labelText: 'Y'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context)
                  .pop((x == null || y == null ? null : Offset(x!, y!)));
            },
          ),
        ],
      );
    },
  );
}

Future<Offset?> showScaleDialog(BuildContext context) async {
  double? x, y;
  return await showDialog<Offset>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter offset'),
        content: Column(
          children: [
            TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                x = double.parse(value);
              },
              decoration: const InputDecoration(labelText: 'X'),
            ),
            TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                y = double.parse(value);
              },
              decoration: const InputDecoration(labelText: 'Y'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context)
                  .pop((x == null || y == null ? null : Offset(x!, y!)));
            },
          ),
        ],
      );
    },
  );
}

Future<double?> showRotateDialog(BuildContext context) async {
  double? angle;
  return await showDialog<double>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter angle'),
        content: Column(
          children: [
            TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                angle = double.parse(value);
              },
              decoration: const InputDecoration(labelText: 'Angle'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(angle);
            },
          ),
        ],
      );
    },
  );
}

Future<int?> showMenuDialog(BuildContext context) async {
  return await showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select action'),
        actions: <Widget>[
          TextButton(
            child: const Text('Move'),
            onPressed: () {
              Navigator.of(context).pop(0);
            },
          ),
          TextButton(
            child: const Text('Scale'),
            onPressed: () {
              Navigator.of(context).pop(1);
            },
          ),
          TextButton(
            child: const Text('Rotate'),
            onPressed: () {
              Navigator.of(context).pop(2);
            },
          ),
        ],
      );
    },
  );
}
