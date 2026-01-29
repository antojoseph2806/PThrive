import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _error;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null;

  Future<void> loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      final userJson = prefs.getString('user');
      if (userJson != null) {
        // Cache user data for faster loading
        _user = {'fullName': prefs.getString('userName') ?? 'User'};
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load session';
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);
      _token = response['token'];
      _user = response['user'];
      
      // Cache data for faster subsequent loads
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString('token', _token!),
        prefs.setString('userName', _user?['fullName'] ?? 'User'),
      ]);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> register(String fullName, String email, String phoneNumber, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(fullName, email, phoneNumber, password);
      _token = response['token'];
      _user = response['user'];
      
      // Cache data for faster subsequent loads
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString('token', _token!),
        prefs.setString('userName', fullName),
      ]);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    _error = null;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      // Silent fail on logout
    }
    
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
