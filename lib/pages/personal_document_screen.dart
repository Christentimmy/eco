import 'package:eco/Resources/color_resources.dart';
import 'package:eco/pages/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalDocumentScreen extends StatelessWidget {
  const PersonalDocumentScreen({super.key});

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
            // Get.to(()=>);
          },
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Personal Document",
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
            const PersonDocumentCard(
              firstText: "Birth Certificate",
              secondText: "Vehicle Registration",
            ),
            const SizedBox(height: 15),
             const PersonDocumentCard(
              firstText: "Driving License",
              secondText: "A driving license is an official Id",
            ),
            const SizedBox(height: 15),
             const PersonDocumentCard(
              firstText: "Passport",
              secondText: "A passport is a travel document  ",
            ),
            const SizedBox(height: 15),
            // CustomTextField(hintText: "Swift/FSC code"),
            const PersonDocumentCard(
              firstText: "Election Card",
              secondText: "Vote regitration card",
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

class PersonDocumentCard extends StatelessWidget {
  final String firstText;
  final String secondText;
  const PersonDocumentCard({
    super.key,
    required this.firstText,
    required this.secondText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 2,
          color: AppColors.primaryColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                firstText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                secondText,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            "Upload",
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
