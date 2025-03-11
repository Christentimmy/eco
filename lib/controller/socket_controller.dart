import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sim/controller/location_controller.dart';
import 'package:sim/controller/storage_controller.dart';
import 'package:sim/controller/driver_controller.dart';
import 'package:sim/models/chat_model.dart';
import 'package:sim/models/ride_model.dart';
import 'package:sim/pages/booking/start_trip_screen.dart';
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
    socket?.on("applicationStatus", (data) {
      debugPrint(data.toString());
      if (data == "approved") {
        Get.offAll(() => const SplashScreen());
      } else {
        _driverController.getDriverDetails();
      }
    });

    socket?.on("rideCancelled", (data) {
      _driverController.getAllRideRequests();
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

    socket?.on("schedule-status", (data) {
      var rideData = data["ride"];
      if (rideData == null || rideData!.containsKey("ride")) {
        return;
      }
      Ride ride = Ride.fromJson(rideData["ride"]);
      _driverController.getAllRideRequests();
      Get.to(() => StartTripScreen(ride: ride));
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
      socket?.off("rideAccepted");
      socket?.off("driverLocationUpdated");
      socket?.off("rideCancelled");
      socket?.off("applicationStatus");
      socket?.off("receiveMessage");
      socket?.off("chat-history");
      socket?.off("newRideRequest");
      socket?.off("schedule-status");
      socket?.off("stripeOnboardingStatus");
    }
  }

  void disconnectSocket() {
    disConnectListeners();
    socket?.disconnect();
    socket = null;
    socket?.close();
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
        final locationController = Get.find<LocationController>();
        await locationController.initializeLocation();
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
