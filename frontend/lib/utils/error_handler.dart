import 'package:flutter/material.dart';
import 'network_helper.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Network errors
    if (error is NetworkException) {
      return error.message;
    } else if (errorString.contains('socket') || errorString.contains('network')) {
      return 'No internet connection. Please check your network.';
    } else if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    
    // Authentication errors
    else if (errorString.contains('invalid email or password')) {
      return 'Invalid email or password';
    } else if (errorString.contains('email already')) {
      return 'Email already registered. Please login instead.';
    } else if (errorString.contains('session expired') || errorString.contains('token')) {
      return 'Session expired. Please login again.';
    }
    
    // Google Sign-In errors
    else if (errorString.contains('google sign-in cancelled') || errorString.contains('sign_in_canceled')) {
      return 'Sign-in cancelled';
    } else if (errorString.contains('google')) {
      return 'Unable to sign in with Google. Please try again.';
    }
    
    // Server errors
    else if (errorString.contains('server error') || errorString.contains('500')) {
      return 'Service temporarily unavailable. Please try again later.';
    }
    
    // Generic user-friendly message (hide all technical details)
    else {
      return 'Something went wrong. Please try again.';
    }
  }

  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final message = getErrorMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Future<T?> handleAsyncOperation<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? successMessage,
    bool showLoading = false,
  }) async {
    try {
      if (showLoading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final result = await operation();

      if (showLoading && context.mounted) {
        Navigator.of(context).pop();
      }

      if (successMessage != null && context.mounted) {
        showSuccessSnackBar(context, successMessage);
      }

      return result;
    } catch (e) {
      if (showLoading && context.mounted) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        showErrorSnackBar(context, e);
      }

      return null;
    }
  }
}
