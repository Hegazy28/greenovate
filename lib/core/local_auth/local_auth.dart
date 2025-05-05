import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LocalAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if device supports biometric authentication
  Future<bool> get isBiometricSupported async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (e) {
      print('Biometric support check error: $e');
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> get availableBiometrics async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      print('Available biometrics check error: $e');
      return [];
    }
  }

  /// Authenticate user with biometrics
   Future<bool> authenticate({
    String localizedReason = 'Authenticate to access sensitive information',
    bool biometricOnly = true,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) async {
    try {
      if (!await isBiometricSupported) return false;

      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable ||
          e.code == auth_error.passcodeNotSet ||
          e.code == auth_error.notEnrolled) {
        // Handle specific authentication errors
        print('Authentication error: ${e.message}');
      } else {
        print('Unexpected authentication error: $e');
      }
      return false;
    } catch (e) {
      print('General authentication error: $e');
      return false;
    }
  }

  /// Simple authentication check (your original method improved)
  Future<bool> isAuthenticated() async {
    return await authenticate(
      localizedReason: 'Please authenticate to show account balance',
      biometricOnly: true,
    );
  }
}