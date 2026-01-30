class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  static String? validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email or phone number is required';
    }
    
    final trimmed = value.trim();
    
    // Check if it's an email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailRegex.hasMatch(trimmed)) {
      return null; // Valid email
    }
    
    // Check if it's a phone number (digits only, 10-15 characters)
    final phoneDigits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (phoneDigits.length >= 10 && phoneDigits.length <= 15) {
      return null; // Valid phone
    }
    
    return 'Enter a valid email or phone number';
  }

  static bool isEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value.trim());
  }

  static bool isPhone(String value) {
    final phoneDigits = value.trim().replaceAll(RegExp(r'\D'), '');
    return phoneDigits.length >= 10 && phoneDigits.length <= 15;
  }
}
