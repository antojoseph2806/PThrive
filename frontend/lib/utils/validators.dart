class Validators {
  // Email validation with comprehensive checks
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final trimmed = value.trim();
    
    // Check minimum length
    if (trimmed.length < 5) {
      return 'Email is too short';
    }
    
    // Check maximum length (RFC 5321)
    if (trimmed.length > 254) {
      return 'Email is too long';
    }
    
    // Comprehensive email regex
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    
    // Check for consecutive dots
    if (trimmed.contains('..')) {
      return 'Email cannot contain consecutive dots';
    }
    
    // Check if starts or ends with dot
    if (trimmed.startsWith('.') || trimmed.endsWith('.')) {
      return 'Email cannot start or end with a dot';
    }
    
    // Check for maximum 2 subdomains (e.g., user@mail.example.com is max)
    final domainPart = trimmed.split('@').last;
    final domainParts = domainPart.split('.');
    if (domainParts.length > 3) {
      return 'Email can have maximum 2 subdomains';
    }
    
    return null;
  }

  // Strong password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (value.length > 128) {
      return 'Password is too long (max 128 characters)';
    }
    
    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Must contain at least 1 uppercase letter';
    }
    
    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Must contain at least 1 lowercase letter';
    }
    
    // Check for at least one digit
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Must contain at least 1 number';
    }
    
    // Check for at least one special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Must contain at least 1 special character';
    }
    
    return null;
  }

  // Phone number validation (10 digits exactly, must start with 6-9)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    if (digitsOnly.isEmpty) {
      return 'Phone number must contain digits';
    }
    
    if (digitsOnly.length < 10) {
      return 'Phone number must be 10 digits';
    }
    
    if (digitsOnly.length > 10) {
      return 'Phone number must be exactly 10 digits';
    }
    
    // Check if all digits are the same (invalid pattern)
    if (RegExp(r'^(\d)\1{9}$').hasMatch(digitsOnly)) {
      return 'Phone number cannot be all same digits';
    }
    
    // Check if starts with 6, 7, 8, or 9 (Indian mobile numbers)
    if (!digitsOnly.startsWith(RegExp(r'[6-9]'))) {
      return 'Phone number must start with 6, 7, 8, or 9';
    }
    
    return null;
  }

  // Name validation with character checks (allows spaces but not consecutive)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (trimmed.length > 50) {
      return 'Name is too long (max 50 characters)';
    }
    
    // Check for valid characters (only letters and single spaces)
    if (!RegExp(r'^[a-zA-Z]+( [a-zA-Z]+)*$').hasMatch(trimmed)) {
      return 'Name can only contain letters and single spaces';
    }
    
    // Check for consecutive spaces
    if (trimmed.contains('  ')) {
      return 'Name cannot contain consecutive spaces';
    }
    
    return null;
  }
  
  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  
  // Email or Phone validation for login
  static String? validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email or phone number is required';
    }
    
    final trimmed = value.trim();
    
    // Check if it's an email
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (emailRegex.hasMatch(trimmed)) {
      return null; // Valid email
    }
    
    // Check if it's a phone number (exactly 10 digits)
    final phoneDigits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (phoneDigits.length == 10) {
      return null; // Valid phone
    }
    
    return 'Enter a valid email or 10-digit phone number';
  }

  static bool isEmail(String value) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(value.trim());
  }

  static bool isPhone(String value) {
    final phoneDigits = value.trim().replaceAll(RegExp(r'\D'), '');
    return phoneDigits.length == 10;
  }
}
