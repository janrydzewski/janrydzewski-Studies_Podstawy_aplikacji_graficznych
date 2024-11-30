import 'package:flutter/material.dart';
import 'package:project1/viewmodels/color_converter_viewmodel.dart';
import 'package:project1/views/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ColorConverterViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Project 1 - Jan Rydzewski',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
