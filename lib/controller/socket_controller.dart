import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sim/controller/location_controller.dart';
import 'package:sim/controller/storage_controller.dart';
import 'package:sim/controller/driver_controller.dart';
import 'package:sim/models/chat_model.dart';
import 'package:sim/models/driver_model.dart';
import 'package:sim/models/review_model.dart';
import 'package:sim/models/ride_model.dart';
import 'package:sim/pages/booking/start_trip_screen.dart';
import 'package:sim/pages/booking/trip_details_screen.dart';
import 'package:sim/pages/booking/trip_payment_screen.dart';
import 'package:sim/pages/booking/trip_started_screen.dart';
import 'package:sim/pages/home/application_screen.dart';
import 'package:sim/pages/splash_screen.dart';
import 'package:sim/utils/base_url.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController extends GetxController with WidgetsBindingObserver {
  IO.Socket? socket;
  RxList<ChatModel> chatModelList = <ChatModel>[].obs;
  RxBool isloading = false.obs;
  final _driverController = Get.find<DriverController>();
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  void initializeSocket() async {
    String? token = await StorageController().getToken();
    if (token == null) {
      return;
    }

    socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'Authorization': 'Bearer $token'},
      'reconnection': true,
      "forceNew": true,
    });

    socket?.connect();

    socket?.onConnect((_) async {
      print("Socket connected successfully");
      final locationController = Get.find<LocationController>();
      await locationController.initializeLocation();
      listenToEvents();
    });

    socket?.onDisconnect((_) {
      print("Socket disconnected");
      scheduleReconnect();
      if (_reconnectAttempts >= _maxReconnectAttempts) {
        disConnectListeners();
      }
    });

    socket?.on('connect_error', (_) {
      print("Connection error");
      scheduleReconnect();
    });
  }

  void listenToEvents() {
    socket?.on("userDetails", (data) {
      debugPrint(data.toString());
    });

    socket?.on("applicationStatus", (data) {
      debugPrint(data.toString());
      if (data == "approved") {
        Get.offAll(() => const SplashScreen());
      } else {
        _driverController.getDriverDetails();
      }
    });

    socket?.on('driverLocationUpdated', (data) {
      double lat = double.tryParse(data['lat']) ?? 0.0;
      double lng = double.tryParse(data['lng']) ?? 0.0;
      print(data['lat'].runtimeType);
      LatLng driverLocation = LatLng(lat, lng);
      print('Driver location updated: $lat, $lng');
      _driverController.driverLocation.value = driverLocation;
      _driverController.driverLocation.refresh();
    });

    socket?.on("tripStatus", (data) {
      String? message = data?["message"];
      final rideData = data?["data"]?["ride"];
      final driverData = data?["data"]?["driver"];
      if (message == "Driver has accepted your ride") {
        if (rideData != null && driverData != null) {
          String roomId = rideData["_id"];
          print("Room ID: $roomId");
          DriverModel driver = DriverModel.fromJson(driverData);
          socket?.emit("joinRoom", {"roomId": roomId});
          Get.to(() => TripDetailsScreen(driver: driver, rideId: roomId));
        } else {
          print("Error: Missing ride or driver data");
        }
      }
      if (message == "Your trip has started") {
        if (rideData != null) {
          final ride = Ride.fromJson(rideData);
          final fromLocation = LatLng(
            ride.pickupLocation!.lat,
            ride.pickupLocation!.lng,
          );
          final toLocation = LatLng(
            ride.dropoffLocation!.lat,
            ride.dropoffLocation!.lng,
          );
          Get.to(
            () => TripStartedScreen(
              fromLocation: fromLocation,
              toLocation: toLocation,
              rideId: ride.id!,
            ),
          );
        } else {
          print("Error: Missing ride data");
        }
      }
      if (message == "Your trip has been completed") {
        if (rideData != null && driverData != null) {
          String rideId = rideData["_id"];
          DriverModel driver = DriverModel.fromJson(driverData);
          Get.to(
            () => TripPaymentScreen(
              rideId: rideId,
              driverUserId: driver.userId ?? "",
              reviews: driver.reviews ?? Reviews(),
            ),
          );
        }
      }
    });

    socket?.on("rideCancelled", (data) {
      _driverController.getAllRideRequests();
    });

    socket?.on('schedule-status', (data) {
      final message = data["message"];
      _driverController.getUserScheduledRides();
      if (data.containsKey("driver") &&
          data["driver"] != null &&
          message.contains("assigned")) {
        final driver = DriverModel.fromJson(data["driver"]);
        String rideId = data["rideId"] ?? "";
        Get.to(() => TripDetailsScreen(driver: driver, rideId: rideId));
      }
    });

    socket?.on("receiveMessage", (data) {
      debugPrint("📩 New message received: $data");
      ChatModel newMessage = ChatModel.fromJson(data);
      chatModelList.add(newMessage);
      chatModelList.refresh();
    });

    socket?.on("chat-history", (data) {
      chatModelList.clear();
      List chats = data["message"];
      List<ChatModel> needMap =
          chats.map((e) => ChatModel.fromJson(e)).toList();
      chatModelList.value = needMap;
    });

    socket?.on("newRideRequest", (data) async {
      await _driverController.getAllRideRequests();
    });

    socket?.on("rideCancelled", (data) {
      _driverController.getAllRideRequests();
    });

    socket?.on("schedule-status", (data) {
      var rideData = data["ride"];
      if (rideData == null || rideData!.containsKey("ride")) {
        return;
      }
      Ride ride = Ride.fromJson(rideData["ride"]);
      Get.to(() => StartTripScreen(ride: ride));
      _driverController.getAllRideRequests();
    });

    socket?.on("stripeOnboardingStatus", (data) {
      String message = data["message"];
      if (message.contains("completed")) {
        Get.offAll(() => const ApplicationProcessingScreen());
      }
    });
  }

  void disConnectListeners() async {
    if (socket != null) {
      socket?.off("userDetails");
      socket?.off("rideAccepted");
      socket?.off("driverLocationUpdated");
      socket?.off("tripStatus");
      socket?.off("rideCancelled");
    }
  }

  void disconnectSocket() {
    disConnectListeners();
    socket?.disconnect();
    socket = null;
    socket?.close();
    print('Socket disconnected and deleted');
  }

  void sendMessage({
    required String message,
    required String rideId,
  }) {
    final payload = {
      "rideId": rideId,
      "message": message,
    };
    socket?.emit('sendMessage', payload);
  }

  void joinRoom({required String roomId}) {
    socket?.emit("joinRoom", {"roomId": roomId});
  }

  void getChatHistory(String rideId) {
    socket?.emit("history", {"rideId": rideId});
  }

  void markRead({
    required String channedId,
    required String messageId,
  }) async {
    socket?.emit("MARK_MESSAGE_READ", {
      "channel_id": channedId,
      "message_ids": [messageId],
    });
  }

  void scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint("🚨 Max reconnection attempts reached. Stopping retry.");
      return;
    }

    int delay = 2 * _reconnectAttempts + 2;
    debugPrint("🔄 Reconnecting in $delay seconds...");

    Future.delayed(Duration(seconds: delay), () {
      _reconnectAttempts++;
      socket?.connect();
    });
  }

  void updateDriverLocation({
    required double lat,
    required double lng,
  }) {
    if (socket != null && socket!.connected) {
      socket!.emit("updateLocation", {"lat": lat, "lng": lng});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await _driverController.getAllRideRequests();
      if (socket == null || socket?.disconnected == true) {
        initializeSocket();
      }
    }
  }

  @override
  void onClose() {
    socket?.dispose();
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
    socket = null;
  }
}
