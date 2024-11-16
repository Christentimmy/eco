import 'package:flutter/material.dart';

class ArrivingPickUpScreen extends StatelessWidget {
  const ArrivingPickUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Expanded(child: Image.asset("mapImage.png")),
        ],
      ),
    );
  }
}
