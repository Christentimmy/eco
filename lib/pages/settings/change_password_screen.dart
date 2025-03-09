import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sim/controller/auth_controller.dart';
import 'package:sim/controller/driver_controller.dart';
import 'package:sim/widget/custom_button.dart';
import 'package:sim/widget/custom_textfield.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _driverController = Get.find<DriverController>();
  final _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.03),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    hintText: "Current Password",
                    textController: _currentPassword,
                    prefixIcon: Icons.lock,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    hintText: "New Password",
                    textController: _newPassword,
                    prefixIcon: Icons.lock,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    hintText: "Confirm Password",
                    textController: _confirmPassword,
                    prefixIcon: Icons.lock,
                    validator: (value) {
                      if (value != _newPassword.text) {
                        return "Passwords do not match.";
                      }
                      return null;
                    },
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Obx(
              () => CommonButton(
                child: _driverController.isloading.value
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ontap: () async {
                  if (_formKey.currentState!.validate()) {
                    _authController.changePassword(
                      oldPassword: _currentPassword.text,
                      newPassword: _newPassword.text,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      title: const Text(
        "Change Password",
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }
}
