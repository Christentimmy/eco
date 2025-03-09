import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sim/bindings/app_bindings.dart';
import 'package:sim/controller/onesignal_controller.dart';
import 'package:sim/pages/splash_screen.dart';

final appLinks = AppLinks();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51QrKaD2fYqVtcus28JnXdX7eNT7Q5dYei3Gz16MfbC3n9uHoEegMzGjNISovjZca9Bta9dFEK7lLcgR6mam7yBLR00Uo4yzLkI";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  final oneSignalController = Get.put(OneSignalController());
  oneSignalController.initOneSignal();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SIM',
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
      initialBinding: AppBindings(),
    );
  }
}
