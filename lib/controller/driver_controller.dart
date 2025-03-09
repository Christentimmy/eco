import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sim/controller/storage_controller.dart';
import 'package:sim/models/car_model.dart';
import 'package:sim/models/driver_model.dart';
import 'package:sim/models/fare_breakdown_model.dart';
import 'package:sim/models/payment_model.dart';
import 'package:sim/models/review_model.dart';
import 'package:sim/models/ride_model.dart';
import 'package:sim/models/user_model.dart';
import 'package:sim/pages/auth/create_profile_screen.dart';
import 'package:sim/pages/auth/sign_up_screen.dart';
import 'package:sim/pages/auth/vehicle_document_screen.dart';
import 'package:sim/pages/auth/vehicle_document_screen_2.dart';
import 'package:sim/pages/auth/verify_phone_screen.dart';
import 'package:sim/pages/booking/review_screen.dart';
import 'package:sim/pages/booking/start_trip_screen.dart';
import 'package:sim/pages/booking/trip_status_screen.dart';
import 'package:sim/pages/booking/waiting_ride_screen.dart';
import 'package:sim/pages/bottom_navigation_screen.dart';
import 'package:sim/pages/home/application_screen.dart';
import 'package:sim/service/driver_service.dart';
import 'package:sim/utils/url_launcher.dart';
import 'package:sim/widget/snack_bar.dart';

class DriverController extends GetxController {
  RxBool isloading = false.obs;
  RxBool isStartTripLoading = false.obs;
  RxBool isAcceptRideLoading = false.obs;
  RxBool isScheduleLoading = false.obs;
  RxBool isRideHistoryFetched = false.obs;
  RxBool isRideBreakDownLoading = false.obs;
  RxBool isRequestRideLoading = false.obs;
  RxBool isPaymentProcessing = false.obs;
  RxBool isEditLoading = false.obs;
  RxBool isScheduleFetched = false.obs;
  RxBool isPaymentHistoryFetched = false.obs;
  var driverLocation = const LatLng(59.9139, 10.7522).obs;
  Rxn<UserModel> userModel = Rxn<UserModel>();
  Rxn<DriverModel> driverModel = Rxn<DriverModel>();
  Rxn<Ride> currentRideModel = Rxn<Ride>();
  RxList<Ride> userScheduleList = <Ride>[].obs;
  RxList<Ride> allRideRequests = <Ride>[].obs;
  RxList<Ride> rideHistoryList = <Ride>[].obs;
  RxList<PaymentModel> driverIncomeList = <PaymentModel>[].obs;
  Rxn<FareBreakdownModel> rideFareBreakdownModel = Rxn<FareBreakdownModel>();
  RxBool isGetUserIdLoading = false.obs;
  final DriverService _driverService = DriverService();
  RxList<DriverModel> availableDriverList = <DriverModel>[].obs;
  RxInt totalPages = 1.obs;
  RxInt currentPage = 1.obs;
  RxBool isFetchingMore = false.obs;
  ScrollController scrollController = ScrollController();

  @override
  onInit() {
    getUserDetails();
    getDriverDetails();
    getAllRideRequests();
    fetchRideHistory();
    // getUserScheduledRides();
    super.onInit();
  }

  Future<void> registerVehicle({
    required Car carModel,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      final String? token = await storageController.getToken();
      if (token == null) return;
      final response = await _driverService.registerVehicle(
        carModel: carModel,
        token: token,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      Get.to(() => VehichleDocumentScreen2());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> uploadPersonalDoc({
    required File imageFile,
    required String title,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      final String? token = await storageController.getToken();
      if (token == null) return;
      final response = await _driverService.uploadPersonalDoc(
        token: token,
        imageFile: imageFile,
        title: title,
      );
      if (response == null) return;
      final responseBody = await response.stream.bytesToString();
      final decoded = json.decode(responseBody);

      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      Get.offAll(() => VehicleDocumentScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> uploadVehicleDocs({
    required File imageFile,
    required String title,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      final String? token = await storageController.getToken();
      if (token == null) return;
      final response = await _driverService.uploadVehicleDocs(
        token: token,
        imageFile: imageFile,
        title: title,
      );
      if (response == null) return;
      final responseBody = await response.stream.bytesToString();
      final decoded = json.decode(responseBody);

      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> updateDriverStatus({
    required String status,
  }) async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;
      final response = await _driverService.updateDriverStatus(
        status: status,
        token: token,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"] ?? "";
      print(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> getDriverStatus() async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return false;

      final response = await _driverService.getDriverStatus(token: token);
      print(response?.body);
      if (response == null) {
        Get.offAll(() => SignUpScreen());
        return true;
      }
      final decoded = json.decode(response.body);
      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        Get.offAll(() => SignUpScreen());
        debugPrint(message);
        return true;
      }

      String status = decoded["data"]["status"];
      bool isVerified = decoded["data"]["is_verified"] ?? false;
      bool isVehicleVerified = decoded["data"]["is_vehicle_approved"] ?? false;
      bool isEmailVerified = decoded["data"]["is_email_verified"] ?? false;
      bool isProfileCompleted = decoded["data"]["profile_completed"] ?? false;
      bool isPhoneNumberVerified =
          decoded["data"]["is_phone_number_verified"] ?? false;

      if (status == "banned" || status == "blocked") {
        CustomSnackbar.showErrorSnackBar("Your account has been banned.");
        Get.offAll(() => SignUpScreen());
        return true;
      }
      if (!isEmailVerified && !isPhoneNumberVerified) {
        CustomSnackbar.showErrorSnackBar("Your account email is not verified.");
        Get.offAll(() => VerifyPhoneNumberScreen(
            email: decoded["data"]["email"],
            nextScreenMethod: () {
              Get.offAll(() => BottomNavigationScreen());
            }));
        return true;
      }
      if (!isProfileCompleted) {
        CustomSnackbar.showErrorSnackBar("Your profile is not completed.");
        Get.offAll(() => CreateProfileScreen());
        return true;
      }
      if (!isVerified && !isVehicleVerified) {
        Get.offAll(() => const ApplicationProcessingScreen());
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> getNearByDrivers({
    required LatLng fromLocation,
    int? radius,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;
      final response = await _driverService.getNearByDrivers(
        token: token,
        fromLocation: fromLocation,
        radius: radius,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      List driversFromResponse = decoded["data"];
      if (driversFromResponse.isEmpty) return;
      List<DriverModel> driverModelList =
          driversFromResponse.map((e) => DriverModel.fromJson(e)).toList();
      availableDriverList.value = driverModelList;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<UserModel?> getUserById({
    required String userId,
  }) async {
    isGetUserIdLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return null;

      final response = await _driverService.getUserById(
        token: token,
        userId: userId,
      );

      if (response == null) return null;
      print(response.body);
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return null;
      }
      var userData = decoded["data"];
      return UserModel.fromJson(userData);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isGetUserIdLoading.value = false;
    }
    return null;
  }

  Future<void> requestRide({
    required String driverId,
    required LatLng fromLocation,
    required String fromLocationName,
    required LatLng toLocation,
    required String toLocationName,
    required String paymentMethod,
  }) async {
    isRequestRideLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;
      final response = await _driverService.requestRide(
        token: token,
        driverId: driverId,
        fromLocation: fromLocation,
        fromLocationName: fromLocationName,
        toLocation: toLocation,
        toLocationName: toLocationName,
        paymentMethod: paymentMethod,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      final rideFromResponse = decoded["data"]["ride"];
      print(rideFromResponse);
      currentRideModel.value = null;
      currentRideModel.value = Ride.fromJson(rideFromResponse);
      print(currentRideModel.value?.id);
      CustomSnackbar.showSuccessSnackBar("Request sent successfully.");
      Get.off(
        () => WaitingRideScreen(
          fromLoactionName: fromLocationName,
          toLoactionName: toLocationName,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isRequestRideLoading.value = false;
    }
  }

  Future<void> getUserDetails() async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.getUserDetails(token: token);
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];

      if (message == "Token has expired.") {
        Get.offAll(() => SignUpScreen());
        return;
      }

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }

      var userData = decoded["data"];
      userModel.value = UserModel.fromJson(userData);
      userModel.refresh();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> getDriverDetails() async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.getDriverDetails(token: token);
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];

      if (message == "Token has expired.") {
        Get.offAll(() => SignUpScreen());
        return;
      }

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }

      var userData = decoded["data"];
      driverModel.value = DriverModel.fromJson(userData);
      userModel.refresh();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> saveUserOneSignalId({
    required String oneSignalId,
  }) async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;
      const prefs = FlutterSecureStorage();
      String? savedId = await prefs.read(key: "one_signal_id");
      if (savedId != null || savedId == oneSignalId) {
        return;
      }
      await prefs.write(key: "one_signal_id", value: oneSignalId);
      final response = await _driverService.saveUserOneSignalId(
        token: token,
        id: oneSignalId,
      );
      if (response == null) return;
      print(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> cancelRideRequest({
    required String rideId,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.cancelRideRequest(
        token: token,
        rideId: rideId,
      );

      if (response == null) return;
      print(response.body);
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      await fetchRideHistory();
      await getUserScheduledRides();
      Get.offAll(() => BottomNavigationScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> cancelTrip({required String rideId}) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.cancelTrip(
        token: token,
        rideId: rideId,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];

      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }

      await fetchRideHistory();
      await getUserScheduledRides();
      Get.to(() => BottomNavigationScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> makePayment({
    required String rideId,
    required Reviews reviews,
    required String driverUserId,
  }) async {
    isPaymentProcessing.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _driverService.initiateStripePayment(
        token: token,
        rideId: rideId,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }

      String clientSecret = decoded["paymentResult"]["clientSecret"];
      await _presentStripePaymentSheet(
        clientSecret: clientSecret,
        reviews: reviews,
        driverUserId: driverUserId,
      );
      await fetchRideHistory();
      await getUserScheduledRides();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isPaymentProcessing.value = false;
    }
  }

  Future<void> _presentStripePaymentSheet({
    required String clientSecret,
    required Reviews reviews,
    required String driverUserId,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.dark,
          merchantDisplayName: 'SIM',
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      CustomSnackbar.showSuccessSnackBar("Payment processing!");
      Get.offAll(
        () => ReviewScreen(
          reviews: reviews,
          driverUserId: driverUserId,
        ),
      );
    } catch (e) {
      print(e);
      debugPrint("Stripe Payment Error: $e");
      CustomSnackbar.showErrorSnackBar("Payment failed");
    }
  }

  Future<void> getRideFareBreakDown({
    required String rideId,
  }) async {
    isRideBreakDownLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.getRideFareBreakDown(
        token: token,
        rideId: rideId,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      final rideFareBreakdown = decoded["breakdown"];
      if (rideFareBreakdown == null) return;
      rideFareBreakdownModel.value = FareBreakdownModel.fromMap(
        rideFareBreakdown,
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isRideBreakDownLoading.value = false;
    }
  }

  Future<void> updateUserDetails({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    File? profilePicture,
  }) async {
    isEditLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.updateUserDetails(
        token: token,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        profilePicture: profilePicture,
      );

      if (response == null) return;

      final decoded = json.decode(response.body);
      String message = decoded["message"];

      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }

      CustomSnackbar.showSuccessSnackBar("Profile updated successfully");
      getUserDetails();
      Get.offAll(() => BottomNavigationScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isEditLoading.value = false;
    }
  }

  Future<void> getUserScheduledRides({String? status}) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.getUserScheduledRides(
        token: token,
        status: status,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (message == "Token has expired.") {
        Get.offAll(() => SignUpScreen());
        return;
      }
      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }

      final rides = decoded["data"]["rides"] as List;

      userScheduleList.clear();
      userScheduleList.value = rides.map((e) => Ride.fromJson(e)).toList();
      if (response.statusCode == 200) isScheduleFetched.value = true;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> scheduleRide({
    required Map<String, dynamic> rideData,
  }) async {
    isScheduleLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.scheduleRide(
        token: token,
        rideData: rideData,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      CustomSnackbar.showSuccessSnackBar(message);
      getUserScheduledRides();
      await fetchRideHistory();

      Get.offAll(() => BottomNavigationScreen());
    } catch (e, stackrace) {
      debugPrint("${e.toString()} $stackrace");
    } finally {
      isScheduleLoading.value = false;
    }
  }

  Future<void> cancelScheduleRide({
    required String rideId,
  }) async {
    isScheduleLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.cancelScheduleRide(
        token: token,
        rideId: rideId,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }

      getUserScheduledRides();
      await fetchRideHistory();

      Get.offAll(() => BottomNavigationScreen());
    } catch (e, stackrace) {
      debugPrint("${e.toString()} $stackrace");
    } finally {
      isScheduleLoading.value = false;
    }
  }

  Future<void> fetchRideHistory({
    String? status,
  }) async {
    isloading.value = false;
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.getRideHistories(
        token: token,
        status: status,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (decoded["message"].toString() == "Token has expired.") {
        Get.offAll(() => SignUpScreen());
        return;
      }
      if (response.statusCode != 200) {
        debugPrint(decoded["message"].toString());
        return;
      }

      List rides = decoded["rides"];
      List<Ride> mappedList = rides.map((e) => Ride.fromJson(e)).toList();
      rideHistoryList.clear();
      rideHistoryList.value = mappedList;
      if (response.statusCode == 200) isRideHistoryFetched.value = true;
    } catch (e) {
      debugPrint("Error fetching ride history: $e");
    } finally {
      isloading.value = false;
    }
  }

  Future<void> getCurrentRide() async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.getCurrentRide(token: token);
      print(response?.body);
      if (response == null) {
        Get.offAll(() => BottomNavigationScreen());
        return;
      }
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (message == "Token has expired.") {
        Get.offAll(() => SignUpScreen());
        return;
      }

      if (response.statusCode != 200) {
        Get.offAll(() => BottomNavigationScreen());
        debugPrint(message);
        return;
      }
      currentRideModel.value = Ride.fromJson(decoded["data"]);
      String status = currentRideModel.value?.status ?? "";
      String scheduleStatus = currentRideModel.value?.scheduleStatus ?? "";
      bool isSchedule = currentRideModel.value?.isScheduled ?? false;
      if (scheduleStatus == "assigned" && isSchedule) {
        Get.offAll(() => TripStatusScreen(ride: currentRideModel.value!));
        return;
      }

      if (status == "accepted") {
        Get.offAll(() => StartTripScreen(ride: currentRideModel.value!));
        return;
      } else if (status == "progress" || status == "paused") {
        Get.offAll(() => TripStatusScreen(ride: currentRideModel.value!));
        return;
      }
      Get.offAll(() => BottomNavigationScreen());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> rateDriver({
    required String rating,
    required String rideId,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.rateDriver(
        rating: rating,
        rideId: rideId,
        token: token,
      );

      if (response == null) return;
      final data = json.decode(response.body);
      String message = data["message"];
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      Get.offAll(() => BottomNavigationScreen());
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<DriverModel?> getDriverWithId({
    required String driverId,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return null;

      final response = await _driverService.getDriverWithId(
        driverId: driverId,
        token: token,
      );

      if (response == null) return null;
      final data = json.decode(response.body);
      String message = data["message"];
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return null;
      }

      return DriverModel.fromJson(data["data"]["driver"]);
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      isloading.value = false;
    }
    return null;
  }

  Future<void> getAllRideRequests() async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.getAllRideRequests(
        token: token,
      );
      if (response == null) return;
      final data = json.decode(response.body);
      String message = data["message"];
      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }
      List rides = data["data"];
      if (rides.isEmpty) return;
      allRideRequests.clear();
      List<Ride> mapped = rides.map((e) => Ride.fromJson(e)).toList();
      allRideRequests.value = mapped;
      allRideRequests.refresh();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> acceptRideRequest({
    required String rideId,
    required Ride ride,
  }) async {
    isAcceptRideLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.acceptRideRequest(
        token: token,
        rideId: rideId,
      );
      if (response == null) return;
      final data = json.decode(response.body);
      String message = data["message"];
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      Get.to(() => StartTripScreen(ride: ride));
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isAcceptRideLoading.value = false;
    }
  }

  Future<void> startTrip(String rideId) async {
    isStartTripLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.startTrip(
        token: token,
        rideId: rideId,
      );

      if (response == null) {
        Get.offAll(() => BottomNavigationScreen());
        return;
      }

      final decoded = json.decode(response.body);
      String message = decoded["message"];

      if (message == "Token has expired.") {
        Get.offAll(() => SignUpScreen());
        return;
      }

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }

      currentRideModel.value = Ride.fromJson(decoded["ride"]);
      Get.offAll(() => TripStatusScreen(ride: currentRideModel.value!));
    } catch (e) {
      debugPrint("❌ Error starting trip: $e");
    } finally {
      isStartTripLoading.value = false;
    }
  }

  Future<void> completeTrip(String rideId) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.completeTrip(
        token: token,
        rideId: rideId,
      );

      if (response == null) {
        Get.offAll(() => BottomNavigationScreen());
        return;
      }

      final decoded = json.decode(response.body);
      String message = decoded["message"];

      if (message == "Token has expired.") {
        Get.offAll(() => SignUpScreen());
        return;
      }

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }

      currentRideModel.value = Ride.fromJson(decoded["ride"]);
      await getAllRideRequests();
      Get.offAll(() => BottomNavigationScreen());
    } catch (e) {
      debugPrint("❌ Error completing trip: $e");
    } finally {
      isloading.value = false;
    }
  }

  Future<void> pauseTrip(String rideId) async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.pauseTrip(
        token: token,
        rideId: rideId,
      );
      if (response == null) {
        Get.snackbar("Error", "Failed to pause trip.");
        return;
      }
      print(response.body);

      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        Get.snackbar("Error", message);
        return;
      }

      currentRideModel.value = Ride.fromJson(decoded["ride"]);
    } catch (e) {
      debugPrint("❌ Error pausing trip: $e");
    }
  }

  Future<void> resumeTrip(String rideId) async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.resumeTrip(
        token: token,
        rideId: rideId,
      );
      if (response == null) {
        Get.snackbar("Error", "Failed to resume trip.");
        return;
      }
      print(response.body);

      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        Get.snackbar("Error", message);
        return;
      }

      currentRideModel.value = Ride.fromJson(decoded["ride"]);
    } catch (e) {
      debugPrint("❌ Error resuming trip: $e");
    }
  }

  Future<void> getOnboardinglink() async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;
      final response = await _driverService.getOnboardingLink(token: token);
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }
      String onboardingLink = decoded["data"]["link"] ?? "";
      if (onboardingLink.isNotEmpty) {
        await launchStripeOnboarding(onboardingLink);
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getDriverIncome() async {
    if (isloading.value) return;
    isloading.value = true;

    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _driverService.getDriverIncome(token: token);

      if (response == null) return;
      final decoded = json.decode(response.body);

      if (response.statusCode != 200) {
        String message = decoded["message"];
        debugPrint(message);
        return;
      }

      List payments = decoded["data"];
      if (payments.isEmpty) return;
      driverIncomeList.clear();
      List<PaymentModel> mapped =
          payments.map((payment) => PaymentModel.fromJson(payment)).toList();
      driverIncomeList.value = mapped;
      if (response.statusCode == 200) isPaymentHistoryFetched.value = true;
    } catch (e) {
      debugPrint("❌ Error fetching payments: $e");
    } finally {
      isloading.value = false;
    }
  }

  void clearUserData() {
    userModel.value = null;
    currentRideModel.value = null;
    userScheduleList.clear();
    rideHistoryList.clear();
    driverIncomeList.clear();
    rideFareBreakdownModel.value = null;
    availableDriverList.clear();
    allRideRequests.clear();
    driverModel.value = null;
    driverLocation.value = const LatLng(59.9139, 10.7522);
  }
}
