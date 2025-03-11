import 'package:sim/controller/driver_controller.dart';
import 'package:sim/resources/color_resources.dart';
import 'package:sim/widget/custom_button.dart';
import 'package:sim/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sim/widget/loader.dart';

class AddCardScreen extends StatelessWidget {
  AddCardScreen({super.key});

  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _driverController = Get.find<DriverController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          "Add Card",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.05),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account Name",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: "Enter Name",
                    textController: _accountNameController,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "IBAN",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: "Enter IBAN Number",
                    textController: _accountNumberController,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            CommonButton(
              child: Obx(
                () => _driverController.isloading.value
                    ? const CarLoader()
                    : const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              ontap: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                if (_driverController.isloading.value) {
                  return;
                }
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                await _driverController.addBankAccount(
                  accountHolderName: _accountNameController.text,
                  iban: _accountNumberController.text,
                  context: context,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
