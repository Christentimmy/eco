import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sim/controller/socket_controller.dart';

class LocationController extends GetxController {
  Position? lastPosition;
  final int distanceThreshold = 150;

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
    // Fetch the initial location
    Position initialPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    updateDriverLocation(initialPosition);

    // Start listening to location updates
    startLocationUpdates();
  }

  void startLocationUpdates() {
    final socketController = Get.find<SocketController>();
    final socket = socketController.socket;
    if (socket != null && socket.connected) {
      Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: distanceThreshold,
        ),
      ).listen((Position position) {
        updateDriverLocation(position);
      });
    }
  }

  void updateDriverLocation(Position position) {
    final socketController = Get.find<SocketController>();
    final socket = socketController.socket;
    if (socket != null && socket.connected) {
      socketController.updateDriverLocation(
        lat: position.latitude,
        lng: position.longitude,
      );
      print("Location Updated: ${position.latitude}, ${position.longitude}");
    }
  }
}
