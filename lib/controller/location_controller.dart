import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sim/controller/socket_controller.dart';

class LocationController extends GetxController {
  Position? lastPosition;
  final int distanceThreshold = 150;
  final socketController = Get.find<SocketController>();

  @override
  void onInit() {
    super.onInit();
    initializeLocation();
  }

  Future<void> initializeLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return;
    }

    try {
      Position initialPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      updateDriverLocation(initialPosition);
      startLocationUpdates();
    } catch (e) {
      print("Error fetching initial location: $e");
    }
  }

  void startLocationUpdates() {
    if (socketController.socket == null ||
        !socketController.socket!.connected) {
      print("Socket is not connected. Not starting location updates.");
      return;
    }

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceThreshold,
      ),
    ).listen((Position position) {
      updateDriverLocation(position);
    });
  }

  void updateDriverLocation(Position position) {
    if (socketController.socket != null && socketController.socket!.connected) {
      socketController.updateDriverLocation(
        lat: position.latitude,
        lng: position.longitude,
      );
    } else {
      print("Socket disconnected, cannot send location updates.");
    }
  }
}
