//providers.dart
// State management (Session and User providers)

import 'package:flutter/material.dart';

class SessionProvider extends ChangeNotifier {
  String? sessionId;
  String? code;

  void updateSession(String sessionId, String code) {
    this.sessionId = sessionId;
    this.code = code;
    notifyListeners();
  }
}

class UserProvider extends ChangeNotifier {
  String? deviceId;

  void updateDeviceId(String deviceId) {
    this.deviceId = deviceId;
    notifyListeners();
  }
}
