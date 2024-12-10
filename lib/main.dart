import 'package:flutter/material.dart';
import 'package:project1/viewmodels/color_converter_viewmodel.dart';
import 'package:project1/views/home.dart';
import 'package:project1/views/loading.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static ValueNotifier<bool> isLoaded = ValueNotifier<bool>(false);
  static ValueNotifier<ThemeData> theme =
      ValueNotifier<ThemeData>(ThemeData.light());

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    startApp();
    super.initState();
  }

  startApp() async {
    await Future.delayed(const Duration(seconds: 3));
    MyApp.isLoaded.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: MyApp.theme,
      builder: (context, themeValue, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: MyApp.isLoaded,
          builder: (context, isLoadedValue, child) {
            return MaterialApp(
              title: 'Project 1 - Jan Rydzewski',
              debugShowCheckedModeBanner: false,
              theme: themeValue,
              home: isLoadedValue ? const HomePage() : const LandingPage(),
            );
          },
        );
      },
    );
  }
}
