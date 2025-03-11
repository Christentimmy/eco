import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sim/controller/socket_controller.dart';
import 'package:sim/controller/storage_controller.dart';
import 'package:sim/controller/driver_controller.dart';
import 'package:sim/models/user_model.dart';
import 'package:sim/pages/auth/create_profile_screen.dart';
import 'package:sim/pages/auth/personal_document_screen.dart';
import 'package:sim/pages/auth/reset_password_screen.dart';
import 'package:sim/pages/auth/sign_up_screen.dart';
import 'package:sim/pages/auth/verify_phone_screen.dart';
import 'package:sim/pages/bottom_navigation_screen.dart';
import 'package:sim/pages/home/application_screen.dart';
import 'package:sim/service/auth_service.dart';
import 'package:sim/widget/snack_bar.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final AuthService _authService = AuthService();
  final _storageController = Get.find<StorageController>();
  final _driverController = Get.find<DriverController>();
  final _socketController = Get.find<SocketController>();

  Future<void> signUpUSer({
    required UserModel userModel,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.signUpUser(userModel: userModel);
      if (response == null) return;
      final decoded = json.decode(response.body);
      var message = decoded["message"] ?? "";
      if (response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      String token = decoded["token"];
      await _storageController.storeToken(token);
      _socketController.initializeSocket();
      await _driverController.getUserDetails();
      OneSignal.Notifications.requestPermission(true);
      String? subId = OneSignal.User.pushSubscription.id;
      if (subId != null) {
        await _driverController.saveUserOneSignalId(oneSignalId: subId);
      }
      Get.offAll(
        () => VerifyPhoneNumberScreen(
          email: userModel.email,
          nextScreenMethod: () => Get.offAll(() => CreateProfileScreen()),
        ),
      );
    } catch (e) {
      debugPrint("Error From Auth Controller: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendOtp() async {
    isLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null) return;
      final response = await _authService.sendOtp(token: token);
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(
          "Failed to get OTP, ${decoded["message"]}",
        );
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp({
    required String otpCode,
    required String email,
    VoidCallback? whatNext,
  }) async {
    isLoading.value = true;
    try {
      final response =
          await _authService.verifyOtp(otpCode: otpCode, email: email);
      print(response?.body);
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      if (whatNext != null) {
        whatNext();
        return;
      }
      Get.offAll(() => CreateProfileScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeProfileScreen({
    required UserModel userModel,
    required File imageFile,
    VoidCallback? nextScreen,
  }) async {
    isLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      final String? token = await storageController.getToken();
      if (token == null) return;
      final response = await _authService.completeProfile(
        userModel: userModel,
        token: token,
        imageFile: imageFile,
      );
      if (response == null) return;
      final responseBody = await response.stream.bytesToString();
      final decoded = json.decode(responseBody);

      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      await _driverController.getUserDetails();
      if (nextScreen != null) {
        nextScreen();
        return;
      }
      Get.offAll(() => const PersonalDocumentScreen(isReSubmitting: false));
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser({
    required String identifier,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.loginUser(
        identifier: identifier,
        password: password,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"] ?? "";
      String token = decoded["token"] ?? "";
      final storageController = Get.find<StorageController>();
      if (response.statusCode == 404 || response.statusCode == 405) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      await storageController.storeToken(token);
      if (response.statusCode == 401) {
        CustomSnackbar.showErrorSnackBar(message);
        Get.offAll(
          () => VerifyPhoneNumberScreen(
            email: identifier,
            nextScreenMethod: () => Get.offAll(() => BottomNavigationScreen()),
          ),
        );
        return;
      }
      if (response.statusCode == 400) {
        CustomSnackbar.showErrorSnackBar(message);
        Get.offAll(() => CreateProfileScreen());
        return;
      }
      if (response.statusCode == 406) {
        CustomSnackbar.showErrorSnackBar(message);
        Get.to(() => const ApplicationProcessingScreen());
        return;
      }
      await _driverController.getUserDetails();
      await _driverController.getDriverIncome();
      await _driverController.getAllRideRequests();
      await _driverController.getCurrentRide();
      await _driverController.fetchRideHistory();
      Get.offAll(() => BottomNavigationScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;
      final response = await _authService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        token: token,
      );
      if (response == null) return;
      final data = json.decode(response.body);
      String message = data["message"];
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      CustomSnackbar.showSuccessSnackBar(message);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      String? token = await StorageController().getToken();
      if (token == null) {
        CustomSnackbar.showErrorSnackBar("No user session found.");
        return;
      }

      final response = await _authService.logout(token: token);
      if (response == null) return;
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode != 200) {
        debugPrint(data["message"].toString());
        return;
      }
      final driverController = Get.find<DriverController>();
      final storage = Get.find<StorageController>();
      await storage.deleteToken();
      driverController.clearUserData();
      Get.offAll(() => SignUpScreen());
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> deleteAccount() async {
    isLoading.value = true;
    try {
      String? token = await StorageController().getToken();
      if (token == null) {
        CustomSnackbar.showErrorSnackBar("No user session found.");
        return;
      }

      final response = await _authService.deleteAccount(token: token);
      if (response == null) return;
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode != 200) {
        debugPrint(data["message"].toString());
        return;
      }
      final driverController = Get.find<DriverController>();
      final storage = Get.find<StorageController>();
      await storage.deleteToken();
      driverController.clearUserData();
      Get.offAll(() => SignUpScreen());
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendOtpForgotPassword({
    required String email,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.sendOtpForgotPassword(
        email: email,
      );
      if (response == null) return;
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode != 200) {
        debugPrint(data["message"].toString());
        return;
      }
      CustomSnackbar.showSuccessSnackBar("OTP sent to your email.");
      Get.offAll(
        () => VerifyPhoneNumberScreen(
          nextScreenMethod: () {
            Get.to(() => ResetPasswordScreen(email: email));
          },
          email: email,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.forgotPassword(
        email: email,
        password: password,
      );
      if (response == null) return;
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode != 200) {
        debugPrint(data["message"].toString());
        return;
      }
      CustomSnackbar.showSuccessSnackBar("Password changed successfully.");
      Get.offAll(() => SignUpScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
