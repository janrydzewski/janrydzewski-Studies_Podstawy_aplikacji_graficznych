import 'package:flutter/material.dart';

class HeaderModel extends StatelessWidget {
  final String label;
  const HeaderModel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(label,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}
