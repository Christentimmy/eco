import 'package:eco/resources/color_resources.dart';
import 'package:eco/pages/auth/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Password Recovery",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: Get.height / 8.5),
              Center(
                child: SvgPicture.asset("assets/images/rec1.svg"),
              ),
              const SizedBox(height: 20),
              const Text(
                "Please enter your email to recover your\npassword",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  hintText: "example@gmail.com",
                  prefixIcon: const Icon(
                    Icons.alternate_email,
                    size: 15,
                  ),
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(162, 126, 126, 126),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      width: 2,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height / 5.5),
              GestureDetector(
                onTap: () => Get.to(() => ResetPasswordScreen()),
                child: Container(
                  height: 45,
                  width: Get.width / 1.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        const Color.fromARGB(212, 37, 37, 37)
                      ],
                    ),
                  ),
                  child: const Text(
                    "Send Link",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
