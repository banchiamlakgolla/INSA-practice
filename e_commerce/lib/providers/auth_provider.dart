import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _token;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String? get token => _token;
  bool get isLoggedIn => _token != null;
  String get errorMessage => _errorMessage;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = '';

    notifyListeners();

    try {
      final token = await _authService.login(username, password);

      _token = token;

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', token);

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');

    notifyListeners();
  }
}
