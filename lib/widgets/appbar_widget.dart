// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/main.dart';
import 'package:project1/models/image_processing_model.dart';
import 'package:project1/viewmodels/board/board_cubit.dart';
import 'package:project1/views/home.dart';
import 'dart:ui' as ui;

AppBar appBar(Function(String val) func, BuildContext context) => AppBar(
      flexibleSpace: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: ValueListenableBuilder<String>(
          valueListenable: SelectedFilter.percentage,
          builder: (context, value, child) {
            return Text(
              value != "" ? "Color percentage: $value%" : "",
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
      ),
      actions: [
        const SizedBox(
          width: 20,
        ),
        Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: InkWell(
            onTap: () {
              if (MyApp.theme.value == ThemeData.light()) {
                MyApp.theme.value = ThemeData.dark();
              } else {
                MyApp.theme.value = ThemeData.light();
              }
            },
            child: const Icon(Icons.sunny),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () {
            MyApp.showGrid.value = !MyApp.showGrid.value;
          },
          child: const Icon(
            Icons.grid_3x3,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['png'],
            );

            if (result != null && result.files.single.path != null) {
              final filePath = result.files.single.path!;
              final bytes = await File(filePath).readAsBytes();

              final codec = await ui.instantiateImageCodec(bytes);
              final frame = await codec.getNextFrame();
              MyApp.backgroundImage.value = frame.image;
            }
          },
          child: const Icon(
            Icons.image,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () {
            MyApp.backgroundImage.value = null;
          },
          child: const Icon(
            Icons.clear,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            context.read<BoardCubit>().clear();
            SelectedFilter.percentage.value = "";
          },
          child: const Row(
            children: [
              Icon(
                Icons.clear,
                color: Colors.black,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Clear",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        PopupMenuButton<String>(
          initialValue: null,
          onSelected: (String item) {
            saveImage(context, item);
          },
          itemBuilder: (BuildContext context) => List.generate(
            6,
            (index) => PopupMenuItem<String>(
              value: "P${index + 1}",
              child: Text('P${index + 1}'),
            ),
          ),
          icon: Row(
            children: [
              Icon(
                Icons.save,
                color: MyApp.theme == ThemeMode.light
                    ? Colors.black
                    : Colors.black,
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                "Save",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
