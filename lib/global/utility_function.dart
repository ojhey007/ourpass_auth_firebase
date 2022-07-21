import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

Future<List> initBiometricAuthentication() async {
  LocalAuthentication localAuth = LocalAuthentication();
  try {
    bool authenticateWithBiometricsResponse = await localAuth.authenticate(
      localizedReason: 'Scan your fingerprint or face ID to authenticate',
      // useErrorDialogs: false,
      // stickyAuth: true
    );
    return [authenticateWithBiometricsResponse, null];
  } on PlatformException catch (e) {
    return [false, e.message];
  }
}
