import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageController extends GetxController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Store token
  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: 'userToken', value: token);
  }

  // Get token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'userToken');
  }

  // Delete token
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'userToken');
  }

   /// Save Secret Key
  Future<void> saveSecretKey(String key) async {
    await _secureStorage.write(key: "secretKey", value: key);
  }

  /// Retrieve Secret Key
  Future<String?> getSecretKey() async {
    return await _secureStorage.read(key: "secretKey");
  }

  /// Delete Secret Key (Optional)
  Future<void> deleteSecretKey() async {
    await _secureStorage.delete(key: "secretKey");
  }
}
