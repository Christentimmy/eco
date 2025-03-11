import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalController extends GetxController {

  void initOneSignal() async {
    // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("2fa250e8-3569-45a5-9c27-db2be9b84c36");
    OneSignal.Notifications.requestPermission(true);
  }
}
