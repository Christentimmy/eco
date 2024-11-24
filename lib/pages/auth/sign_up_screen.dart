import 'package:eco/Resources/color_resources.dart';
import 'package:eco/pages/bottom_navigation_screen.dart';
import 'package:eco/pages/auth/password_recovery_screen.dart';
import 'package:eco/pages/auth/verify_phone_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final RxBool _isSignUpPage = true.obs;
  final RxBool _isSignInpPage = false.obs;

  final PageController _pageController = PageController();

  final RxBool _isLoginWithNumber = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 185, 185),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Get.height,
              width: Get.width,
              child: Stack(
                children: [
                  const VectorDiagram(),
                  Positioned(
                    bottom: 25,
                    left: 15,
                    child: Container(
                      height: 480,
                      width: 330,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
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
                                        _isSignInpPage.value = false;
                                        _isSignUpPage.value =
                                            !_isSignUpPage.value;

                                        if (_isSignUpPage.value) {
                                          _pageController.animateToPage(
                                            0,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.ease,
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          color: _isSignUpPage.value
                                              ? AppColors.primaryColor
                                              : Colors.white,
                                          fontWeight: _isSignUpPage.value
                                              ? FontWeight.bold
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Obx(
                                    () => GestureDetector(
                                      onTap: () {
                                        _isSignUpPage.value = false;
                                        _isSignInpPage.value =
                                            !_isSignInpPage.value;
                                        if (_isSignInpPage.value) {
                                          _pageController.animateToPage(
                                            1,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.ease,
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Sign In",
                                        style: TextStyle(
                                          color: _isSignInpPage.value
                                              ? AppColors.primaryColor
                                              : Colors.white,
                                          fontWeight: _isSignInpPage.value
                                              ? FontWeight.bold
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 400,
                              child: PageView(
                                controller: _pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  signUpPage(),
                                  loginPage(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding loginPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
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
              Get.to(()=> BottomNavigationScreen());
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
    );
  }

  Padding signUpPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
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
    return SizedBox(
      height: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 400,
            color: AppColors.primaryColor,
            width: Get.width,
            alignment: Alignment.bottomCenter,
            child: Image.asset("assets/images/Vector.png"),
          ),
          Positioned(
            bottom: 43,
            right: 60,
            child: Image.asset(
              "assets/images/ecoLogo.png",
              width: 250,
              height: 250,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CommonButton extends StatelessWidget {
  final String text;
  Color? bgColor;
  Color? textColor;
  final VoidCallback ontap;
  CommonButton({
    super.key,
    required this.text,
    this.bgColor,
    required this.ontap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: bgColor,
          gradient: bgColor == null ?  LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              const Color.fromARGB(255, 17, 99, 14),
            ],
          ) : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color:  textColor ?? Colors.white,
          ),
        ),
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
