import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import '../config/api_config.dart';

class AuthService {
  // Reuse HTTP client for better performance
  static final http.Client _client = http.Client();
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '388026117671-c9ahgfr3cdl8gs2h060ce49tp7bs5fd5.apps.googleusercontent.com',
  );

  Future<Map<String, dynamic>> login(String emailOrPhone, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.authEndpoint}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'emailOrPhone': emailOrPhone, 'password': password}),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid credentials');
      } else if (response.statusCode >= 500) {
        throw Exception('Service unavailable');
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Login failed');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) rethrow;
      throw Exception('Connection failed');
    }
  }

  Future<Map<String, dynamic>> register(
    String fullName,
    String email,
    String phoneNumber,
    String password,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.authEndpoint}/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 409) {
        throw Exception('Email already registered');
      } else if (response.statusCode >= 500) {
        throw Exception('Service unavailable');
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Registration failed');
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) rethrow;
      throw Exception('Connection failed');
    }
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In...');
      
      // Sign out first to ensure fresh account picker
      await _googleSignIn.signOut();
      
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('Google Sign-In cancelled by user');
        throw Exception('Sign-in cancelled');
      }

      print('Google user obtained: ${googleUser.email}');

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        print('ID token is null');
        throw Exception('Unable to sign in with Google. Please try again.');
      }

      print('ID token obtained, sending to backend...');

      // Send ID token to backend for verification
      final response = await _client.post(
        Uri.parse('${ApiConfig.authEndpoint}/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': googleAuth.idToken}),
      ).timeout(const Duration(seconds: 15));

      print('Backend response status: ${response.statusCode}');
      print('Backend response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode >= 500) {
        throw Exception('Service temporarily unavailable');
      } else {
        throw Exception('Unable to sign in with Google. Please try again.');
      }
    } catch (e) {
      print('Google Sign-In error: $e');
      
      // Clean up on error
      await _googleSignIn.signOut();
      
      // Return user-friendly message
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('Unable to sign in with Google. Please try again.');
    }
  }

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      // Silent fail
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String emailOrPhone) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.authEndpoint}/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'emailOrPhone': emailOrPhone}),
      ).timeout(const Duration(seconds: 8)); // Reduced timeout for faster response

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Account not found');
      } else if (response.statusCode == 429) {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Too many attempts. Please try again later.');
      } else if (response.statusCode >= 500) {
        throw Exception('Our servers are busy. Please try again in a moment.');
      } else {
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['error'] ?? 'Unable to send verification code. Please try again.');
        } catch (_) {
          throw Exception('Unable to send verification code. Please try again.');
        }
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timed out. Please check your connection and try again.');
      }
      throw Exception('Unable to connect. Please check your internet connection.');
    }
  }

  Future<Map<String, dynamic>> resetPassword(String emailOrPhone, String otp, String newPassword) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.authEndpoint}/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emailOrPhone': emailOrPhone,
          'otp': otp,
          'newPassword': newPassword,
        }),
      ).timeout(const Duration(seconds: 8)); // Reduced timeout for faster response

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode >= 500) {
        throw Exception('Our servers are busy. Please try again in a moment.');
      } else {
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['error'] ?? 'Password reset failed. Please try again.');
        } catch (_) {
          throw Exception('Password reset failed. Please try again.');
        }
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timed out. Please check your connection and try again.');
      }
      throw Exception('Unable to connect. Please check your internet connection.');
    }
  }
}
