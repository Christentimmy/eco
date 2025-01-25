import 'package:sim/pages/auth/password_recovery_screen.dart';
import 'package:sim/resources/color_resources.dart';
import 'package:sim/pages/bottom_navigation_screen.dart';
import 'package:sim/pages/auth/verify_phone_screen.dart';
import 'package:sim/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final RxBool _isLoginWithNumber = true.obs;
  final RxInt _currentPage = 0.obs;
  // final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 185, 185),
      body: Stack(
        children: [
          const VectorDiagram(),
          _buildInputFields(),
        ],
      ),
    );
  }

  SingleChildScrollView _buildInputFields() {
    return SingleChildScrollView(
      // physics: NeverScrollableScrollPhysics(),
      child: Center(
        child: Container(
          height: Get.height * 0.7,
          width: Get.width * 0.92,
          margin: EdgeInsets.only(top: Get.height * 0.27),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildAuthDecision(),
              _buildCrossFade(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCrossFade() {
    return Obx(
      () => AnimatedCrossFade(
        firstChild: signUpPage(),
        secondChild: loginPage(),
        crossFadeState: _currentPage.value == 0
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }

  Widget _buildAuthDecision() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Obx(
            () => GestureDetector(
              onTap: () {
                CrossFadeState.showFirst;
                _currentPage.value = 0;
              },
              child: Text(
                "Sign Up",
                style: TextStyle(
                  color: _currentPage.value == 0
                      ? AppColors.primaryColor
                      : Colors.white,
                  fontWeight: _currentPage.value == 0 ? FontWeight.bold : null,
                ),
              ),
            ),
          ),
          const Spacer(),
          Obx(
            () => GestureDetector(
              onTap: () {
                CrossFadeState.showSecond;
                _currentPage.value = 1;
              },
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: _currentPage.value == 1
                      ? AppColors.primaryColor
                      : Colors.white,
                  fontWeight: _currentPage.value == 1 ? FontWeight.bold : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: SizedBox(
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Login Into Your Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() {
                  return GestureDetector(
                    onTap: () {
                      _isLoginWithNumber.value = !_isLoginWithNumber.value;
                    },
                    child: Text(
                      _isLoginWithNumber.value
                          ? "Use Email Instead"
                          : "Change to number",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ],
            ),
            Obx(() {
              if (_isLoginWithNumber.value) {
                return const PhoneNumberTextField();
              } else {
                return const EmailTextField();
              }
            }),
            const SizedBox(height: 10),
            const PasswordTextField(),
            const SizedBox(height: 25),
            CommonButton(
              ontap: () {
                Get.to(() => BottomNavigationScreen());
              },
              text: "Login",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => const PasswordRecoveryScreen()),
                  child: const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Text(
              "By clicking start, you agree to our Terms and Conditions",
              style: TextStyle(
                fontSize: 9,
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }

  Widget signUpPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: SizedBox(
        height: Get.height * 0.56,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Create Account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            const EmailTextField(),
            // CustomTextField(
            //   hintText: "name@gmail.com",
            //   textController: _textController,
            // ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: Colors.grey,
                ),
              ),
              child: Row(
                children: [
                  CountryCodePicker(
                    onChanged: (value) {},
                    initialSelection: '+234',
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    // optional. aligns the flag and the Text left
                    alignLeft: false,
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "mobile number",
                        hintStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const PasswordTextField(),
            const SizedBox(height: 10),
            const ConfirmPassswordTextField(),
            const SizedBox(height: 25),
            CommonButton(
              ontap: () {
                Get.to(() => VerifyPhoneNumberScreen());
              },
              text: "Sign Up",
            ),
            const Spacer(),
            const Text(
              "By clicking start, you agree to our Terms and Conditions",
              style: TextStyle(
                fontSize: 9,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PhoneNumberTextField extends StatelessWidget {
  const PhoneNumberTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: Colors.grey,
        ),
      ),
      child: Row(
        children: [
          CountryCodePicker(
            onChanged: (value) {
              print(value);
            },
            initialSelection: '+234',
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            // optional. aligns the flag and the Text left
            alignLeft: false,
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "mobile number",
                hintStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VectorDiagram extends StatelessWidget {
  const VectorDiagram({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      height: Get.height * 0.3,
      width: Get.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/images/Vector.png",
              width: Get.width,
              height: Get.height * 0.25,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: Get.height * 0.05,
                right: 15,
              ),
              child: Image.asset(
                "assets/images/ecoLogo.png",
                width: Get.width / 2.0,
                fit: BoxFit.cover,
                height: Get.height * 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmPassswordTextField extends StatelessWidget {
  const ConfirmPassswordTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: "confirm password",
        hintStyle: const TextStyle(
          fontSize: 12,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: "password",
        hintStyle: const TextStyle(
          fontSize: 12,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: "name@example.com",
        hintStyle: const TextStyle(
          fontSize: 12,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
