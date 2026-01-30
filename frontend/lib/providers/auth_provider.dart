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
      
      if (_token != null) {
        // Load user data from storage
        final userId = prefs.getString('userId');
        final userName = prefs.getString('userName');
        final userEmail = prefs.getString('userEmail');
        final userProfilePicture = prefs.getString('userProfilePicture');
        
        if (userId != null && userName != null) {
          _user = {
            'id': userId,
            'fullName': userName,
            'email': userEmail,
            'profilePicture': userProfilePicture,
          };
        }
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
      // Start API call and storage access in parallel
      final responseFuture = _authService.login(email, password);
      final prefsFuture = SharedPreferences.getInstance();
      
      final results = await Future.wait([responseFuture, prefsFuture]);
      final response = results[0] as Map<String, dynamic>;
      final prefs = results[1] as SharedPreferences;
      
      _token = response['token'];
      _user = response['user'];
      
      // Save data without waiting
      prefs.setString('token', _token!);
      prefs.setString('userId', _user?['id'] ?? '');
      prefs.setString('userName', _user?['fullName'] ?? 'User');
      prefs.setString('userEmail', _user?['email'] ?? email);
      if (_user?['profilePicture'] != null) {
        prefs.setString('userProfilePicture', _user!['profilePicture']);
      }
      
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
      // Start API call and storage access in parallel
      final responseFuture = _authService.register(fullName, email, phoneNumber, password);
      final prefsFuture = SharedPreferences.getInstance();
      
      final results = await Future.wait([responseFuture, prefsFuture]);
      final response = results[0] as Map<String, dynamic>;
      final prefs = results[1] as SharedPreferences;
      
      _token = response['token'];
      _user = response['user'];
      
      // Save data without waiting
      prefs.setString('token', _token!);
      prefs.setString('userId', _user?['id'] ?? '');
      prefs.setString('userName', _user?['fullName'] ?? fullName);
      prefs.setString('userEmail', _user?['email'] ?? email);
      if (_user?['profilePicture'] != null) {
        prefs.setString('userProfilePicture', _user!['profilePicture']);
      }
      
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
      await _authService.signOutGoogle();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      // Silent fail on logout
    }
    
    notifyListeners();
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Start API call and storage access in parallel
      final responseFuture = _authService.signInWithGoogle();
      final prefsFuture = SharedPreferences.getInstance();
      
      final results = await Future.wait([responseFuture, prefsFuture]);
      final response = results[0] as Map<String, dynamic>;
      final prefs = results[1] as SharedPreferences;
      
      _token = response['token'];
      _user = response['user'];
      
      // Save data without waiting
      prefs.setString('token', _token!);
      prefs.setString('userId', _user?['id'] ?? '');
      prefs.setString('userName', _user?['fullName'] ?? 'User');
      prefs.setString('userEmail', _user?['email'] ?? '');
      if (_user?['profilePicture'] != null) {
        prefs.setString('userProfilePicture', _user!['profilePicture']);
      }
      
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

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.forgotPassword(email);
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

  Future<bool> resetPassword(String email, String otp, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email, otp, newPassword);
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
}
