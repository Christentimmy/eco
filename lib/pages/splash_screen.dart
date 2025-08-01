import 'package:sim/controller/socket_controller.dart';
import 'package:sim/controller/storage_controller.dart';
import 'package:sim/controller/driver_controller.dart';
import 'package:sim/resources/color_resources.dart';
import 'package:sim/pages/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      final driverController = Get.find<DriverController>();
      final socketController = Get.find<SocketController>();
      final storageController = Get.find<StorageController>();

      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        Get.off(() => SignUpScreen());
        return;
      }
      socketController.initializeSocket();
      bool hasNavigated = await driverController.getDriverStatus();
      if (hasNavigated) return;
      await driverController.getCurrentRide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/ecoLogo.png",
              width: 220,
              fit: BoxFit.cover,
            ),
          ),
          _buildSplashText(),
        ],
      ),
    );
  }

  Widget _buildSplashText() {
    return Column(
      children: AnimationConfiguration.toStaggeredList(
        childAnimationBuilder: (widget) => SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: widget,
          ),
        ),
        children: [
          const SizedBox(height: 100),
          const Text(
            "Drive with ECO",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Support your living with extra Cash",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
