import 'package:get/get.dart';
import 'package:sim/controller/auth_controller.dart';
import 'package:sim/controller/call_controller.dart';
import 'package:sim/controller/onesignal_controller.dart';
import 'package:sim/controller/socket_controller.dart';
import 'package:sim/controller/storage_controller.dart';
import 'package:sim/controller/driver_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageController());
    Get.put(DriverController());
    Get.put(AuthController());
    Get.put(CallController());
    Get.put(OneSignalController());
    Get.put(SocketController());
  }
}
