import 'package:flutter/material.dart';

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
