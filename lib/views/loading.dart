import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              "assets/landing.json",
              width: 500,
              height: 500,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Świetna aplikacja na grafikę komputerową",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 50),
            ),
          ],
        ),
      ),
    );
  }
}
