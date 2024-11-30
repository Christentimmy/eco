import 'package:eco/resources/color_resources.dart';
import 'package:eco/pages/auth/personal_document_screen.dart';
import 'package:eco/widget/custom_button.dart';
import 'package:eco/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankDetailsScreen extends StatelessWidget {
  BankDetailsScreen({super.key});

  final _bankNameController = TextEditingController();
  final _accountHolderController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _swiftController = TextEditingController();

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
            Get.to(() => PersonalDocumentScreen());
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
            CustomTextField(
              hintText: "Bank Name",
              textController: _bankNameController,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hintText: "Account Holder Name",
              textController: _accountHolderController,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hintText: "Account Number",
              textController: _accountNumberController,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hintText: "Swift/FSC code",
              textController: _swiftController,
            ),
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
                        )),
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
