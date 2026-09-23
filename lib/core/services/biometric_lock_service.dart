import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class BiometricLockService {
  static const _storageKey = 'biometric_lock_enabled';
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> isEnabled() async {
    final val = await _storage.read(key: _storageKey);
    return val == 'true';
  }

  Future<void> setEnabled(bool value) async {
    await _storage.write(key: _storageKey, value: value.toString());
  }

  Future<bool> isAvailable() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    return canCheck && isSupported;
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Verify your identity to unlock the app',
        options: const AuthenticationOptions(biometricOnly: false),
      );
    } catch (_) {
      return false;
    }
  }
}
