import 'package:eco/Resources/color_resources.dart';
import 'package:eco/pages/create_profile_screen.dart';
import 'package:eco/pages/personal_document_screen.dart';
import 'package:eco/pages/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankDetailsScreen extends StatelessWidget {
  const BankDetailsScreen({super.key});

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
            Get.to(()=> PersonalDocumentScreen());
          },
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Bank Details",
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
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height / 8.5),
            CustomTextField(hintText: "Bank Name"),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Account Holder Name"),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Account Number"),
            const SizedBox(height: 15),
            CustomTextField(hintText: "Swift/FSC code"),
            const SizedBox(height: 25),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text:
                          "By continuing, I confirm that I have read & agree to the\n",
                    ),
                    TextSpan(
                      text: "Terms & conditions",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const TextSpan(
                      text: " and ",
                    ),
                    TextSpan(
                      text: "Privacy policy",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      )
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
