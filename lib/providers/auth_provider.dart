import 'package:flutter/material.dart';
import 'package:task_manager_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String username, String password) async {
    _isAuthenticated = await _authService.login(username, password);
    notifyListeners();
  }
}
