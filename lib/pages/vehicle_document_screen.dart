import 'package:eco/pages/create_profile_screen.dart';
import 'package:eco/pages/sign_up_screen.dart';
import 'package:eco/pages/vehichle_document_screen_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleDocumentScreen extends StatelessWidget {
  const VehicleDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomSheet: Container(
        height: 120,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Color.fromARGB(255, 22, 22, 22),
        ),
        child: CommonButton(
          text: "Next",
          ontap: () {
            Get.to(() => VehichleDocumentScreen2());
          },
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Vehicle Document",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height / 12.5),
            CustomTextField(hintText: "Service Type"),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Brand (Auto Suggestion)"),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Model (Auto Suggestion)"),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Manufacture (Auto Suggestion)"),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Number Plate"),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Color"),
          ],
        ),
      ),
    );
  }
}
