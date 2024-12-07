import 'package:flutter/material.dart';

Future<int?> showFilterDialog(BuildContext context) async {
  return await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 5.0,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("To reduce time, all values are hardcoded"),
                  Wrap(
                    runSpacing: 5,
                    spacing: 5,
                    children: List.generate(
                        28,
                        (index) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: filterElement(index, context))),
                  ),
                ],
              ),
            ),
          ));
}

Widget filterElement(int id, BuildContext context) {
  String getText() {
    return switch (id) {
      0 => "Classic",
      1 => "Add RGB",
      2 => "Substract RGB",
      3 => "Multiply RGB",
      4 => "Divide RGB",
      5 => "Adjust Brightness",
      6 => "Grayscale",
      7 => "Filtr wygładzający",
      8 => "Filtr medianowy",
      9 => "Filtr Sobela",
      10 => "Filtr górnoprzepustowy wyostrzający",
      11 => "Filtr rozmycie gaussowskie",
      12 => "Splot maski",
      13 => "Histogram",
      14 => "Binaryzacja ręczna",
      15 => "Binaryzacja Procent Black",
      16 => "Binaryzacja Entropia",
      17 => "Binaryzacja Minimum Error",
      18 => "Binaryzacja Rozmyty Min. Błąd",
      19 => "Dylatacja",
      20 => "Erozja",
      21 => "Otwarcie",
      22 => "Domknięcie",
      23 => "Hit or Miss",
      24 => "Otsu",
      25 => "Niblack",
      26 => "Sauvola",
      27 => "Wykrywanie koloru",
      _ => "Unknown"
    };
  }

  return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(id), child: Text(getText()));
}
