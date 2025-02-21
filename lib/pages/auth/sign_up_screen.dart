import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:sim/controller/auth_controller.dart';
import 'package:sim/models/user_model.dart';
import 'package:sim/pages/auth/password_recovery_screen.dart';
import 'package:sim/resources/color_resources.dart';
import 'package:sim/widget/custom_button.dart';
import 'package:sim/widget/custom_textfield.dart';
import 'package:sim/widget/loader.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final RxBool _isLoginWithNumber = true.obs;
  final RxInt _currentPage = 0.obs;
  final RxBool _isNumberValidated = false.obs;
  final _formSignUpKey = GlobalKey<FormState>();
  final _formLoginUpKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _loginEmailController = TextEditingController();
  final _loginPhoneNumberController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = Get.find<AuthController>();

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
          margin: EdgeInsets.only(top: Get.height * 0.28),
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
            () => InkWell(
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
            () => InkWell(
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
        height: Get.height * 0.55,
        child: Form(
          key: _formLoginUpKey,
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
                    return InkWell(
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
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: _isNumberValidated.value
                            ? Colors.red
                            : Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        CountryCodePicker(
                          onChanged: (value) {},
                          initialSelection: '+234',
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _loginPhoneNumberController,
                            keyboardType: TextInputType.number,
                            validator: _isLoginWithNumber.value
                                ? (value) {
                                    if (value!.isEmpty) {
                                      _isNumberValidated.value = true;
                                      return null;
                                    }
                                    _isNumberValidated.value = false;
                                    return null;
                                  }
                                : null,
                            decoration: const InputDecoration(
                              hintText: "mobile number",
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
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
                } else {
                  return CustomTextField(
                    hintText: "john@email.com",
                    textController: _loginEmailController,
                    validator: _isLoginWithNumber.value
                        ? null
                        : (value) {
                            if (value!.isEmpty) {
                              return "";
                            }
                            if (!value.contains("@")) {
                              return "";
                            }
                            return null;
                          },
                  );
                }
              }),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: "password",
                textController: _loginPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 25),
              Obx(
                () => CommonButton(
                  ontap: () async {
                    if (_authController.isLoading.value) {
                      return;
                    }
                    if (!_formLoginUpKey.currentState!.validate()) {
                      return;
                    }
                    await _authController.loginUser(
                      identifier: _isLoginWithNumber.value
                          ? _loginPhoneNumberController.text
                          : _loginEmailController.text,
                      password: _loginPasswordController.text,
                    );
                  },
                  child: _authController.isLoading.value
                      ? const CarLoader()
                      : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Get.to(() => PasswordRecoveryScreen()),
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
            ],
          ),
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
        height: Get.height * 0.55,
        child: Form(
          key: _formSignUpKey,
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
              // const EmailTextField(),
              CustomTextField(
                hintText: "John@email.com",
                textController: _emailController,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "";
                  }
                  if (!value!.contains('@')) {
                    return "";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: _isNumberValidated.value
                          ? Colors.red
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      CountryCodePicker(
                        onChanged: (value) {},
                        initialSelection: '+234',
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              _isNumberValidated.value = true;
                              return null;
                            }
                            _isNumberValidated.value = false;
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "mobile number",
                            hintStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
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
              ),
              const SizedBox(height: 10),
              // const PasswordTextField(),
              CustomTextField(
                hintText: "password",
                textController: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              // const ConfirmPassswordTextField(),
              CustomTextField(
                hintText: "confirm password",
                textController: _confirmPasswordController,
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return " ";
                  }
                  if (value != _passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              Obx(
                () => CommonButton(
                  ontap: () async {
                    if (!_formSignUpKey.currentState!.validate()) {
                      return;
                    }
                    UserModel userModel = UserModel(
                      email: _emailController.text,
                      phoneNumber: _phoneNumberController.text,
                      password: _passwordController.text,
                    );
                    await _authController.signUpUSer(userModel: userModel);
                  },
                  child: _authController.isLoading.value
                      ? const CarLoader()
                      : const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                ),
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
          width: 1,
          color: Colors.grey.withOpacity(0.5),
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
  const VectorDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Container(
            height: Get.height * 0.2,
            color: AppColors.primaryColor,
            width: Get.width,
          ),
          Image.asset(
            "assets/images/Vector.png",
          ),
          Container(
            margin: EdgeInsets.only(
              top: Get.height * 0.08,
              left: Get.height * 0.08,
            ),
            child: Image.asset(
              "assets/images/ecoLogo.png",
              width: Get.width * 0.6,
              height: Get.height * 0.25,
            ),
          ),
        ],
      ),
    );
  }
}
