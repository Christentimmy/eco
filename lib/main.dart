import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sim/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}