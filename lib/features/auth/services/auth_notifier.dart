import 'package:flutter/material.dart';
import 'package:smartmush_farmer/core/storage/auth_storage.dart';

class AuthNotifier extends ChangeNotifier {
  static final AuthNotifier _instance = AuthNotifier._internal();
  factory AuthNotifier() => _instance;
  AuthNotifier._internal();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    final token = await AuthStorage.getToken();
    _isLoggedIn = token != null && token.isNotEmpty;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthStorage.clear();
    _isLoggedIn = false;
    notifyListeners();
  }

  void notifyAuthChanged() {
    checkLoginStatus();
  }
}
