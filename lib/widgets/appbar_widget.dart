import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/models/image_processing_model.dart';
import 'package:project1/viewmodels/board/board_cubit.dart';
import 'package:project1/views/home.dart';

AppBar appBar(Function(String val) func, BuildContext context) => AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.green],
          ),
        ),
      ),
      centerTitle: true,
      title: ValueListenableBuilder<String>(
        valueListenable: SelectedFilter.percentage,
        builder: (context, value, child) {
          return Text(
            value != "" ? "Color percentage: $value" : "",
            style: const TextStyle(fontSize: 24),
          );
        },
      ),
      actions: [
        Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: InkWell(
            onTap: () {
              context.read<BoardCubit>().clear();
              SelectedFilter.percentage.value = "";
            },
            child: const Row(
              children: [
                Icon(Icons.close),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Clear",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
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
          icon: const Row(
            children: [
              Icon(Icons.save),
              SizedBox(
                width: 5,
              ),
              Text(
                "Save",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
