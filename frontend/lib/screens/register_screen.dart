import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/validators.dart';
import 'dashboard_screen.dart';

// Custom formatter to prevent consecutive spaces
class _NoConsecutiveSpacesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the new text contains consecutive spaces, reject the change
    if (newValue.text.contains('  ')) {
      return oldValue;
    }
    return newValue;
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  
  // Track if fields have been touched for validation
  bool _nameValidated = false;
  bool _emailValidated = false;
  bool _phoneValidated = false;
  bool _passwordValidated = false;
  bool _confirmPasswordValidated = false;

  
  @override
  void initState() {
    super.initState();
    
    // Add listeners to validate when focus changes
    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus && _nameController.text.isNotEmpty) {
        setState(() => _nameValidated = true);
      }
    });
    
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus && _emailController.text.isNotEmpty) {
        setState(() => _emailValidated = true);
      }
    });
    
    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus && _phoneController.text.isNotEmpty) {
        setState(() => _phoneValidated = true);
      }
    });
    
    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus && _passwordController.text.isNotEmpty) {
        setState(() => _passwordValidated = true);
      }
    });
    
    _confirmPasswordFocus.addListener(() {
      if (!_confirmPasswordFocus.hasFocus && _confirmPasswordController.text.isNotEmpty) {
        setState(() => _confirmPasswordValidated = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: SingleChildScrollView(
          child: Column(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF22D3EE)],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // PThrive Logo
                    Image.asset(
                      'assets/images/pthrive_logo.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if logo not found
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.favorite, size: 30, color: Color(0xFF3B82F6)),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Create Your Account',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const Text('Join PThrive and start your recovery', style: TextStyle(fontSize: 13, color: Colors.white70)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildValidatedTextField(
                    'FULL NAME',
                    _nameController,
                    _nameFocus,
                    Icons.person_outline,
                    'Enter your full name (e.g., Sony Jose)',
                    TextInputType.text,
                    Validators.validateName,
                    _nameValidated,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      _NoConsecutiveSpacesFormatter(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildValidatedTextField(
                    'EMAIL ADDRESS',
                    _emailController,
                    _emailFocus,
                    Icons.email_outlined,
                    'Enter your email address',
                    TextInputType.emailAddress,
                    Validators.validateEmail,
                    _emailValidated,
                  ),
                  const SizedBox(height: 16),
                  _buildValidatedTextField(
                    'PHONE NUMBER',
                    _phoneController,
                    _phoneFocus,
                    Icons.phone_outlined,
                    'Enter 10-digit phone number',
                    TextInputType.phone,
                    Validators.validatePhone,
                    _phoneValidated,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 16),
                  _buildValidatedPasswordField(
                    'PASSWORD',
                    _passwordController,
                    _passwordFocus,
                    _obscurePassword,
                    () => setState(() => _obscurePassword = !_obscurePassword),
                    Validators.validatePassword,
                    _passwordValidated,
                  ),
                  const SizedBox(height: 16),
                  _buildValidatedPasswordField(
                    'CONFIRM PASSWORD',
                    _confirmPasswordController,
                    _confirmPasswordFocus,
                    _obscureConfirmPassword,
                    () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    (value) => Validators.validateConfirmPassword(value, _passwordController.text),
                    _confirmPasswordValidated,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) => setState(() => _agreedToTerms = value!),
                      ),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            text: 'I agree to the ',
                            style: TextStyle(color: Colors.black87),
                            children: [
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(color: Color(0xFF3B82F6)),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(color: Color(0xFF3B82F6)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: (_agreedToTerms && !authProvider.isLoading)
                              ? () => _handleRegister(context)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Create Account', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Or sign up with', style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return OutlinedButton(
                        onPressed: authProvider.isLoading ? null : () => _handleGoogleSignIn(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/google.png',
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.g_mobiledata, size: 24, color: Colors.red);
                              },
                            ),
                            const SizedBox(width: 12),
                            const Text('Continue with Google'),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildValidatedTextField(
    String label,
    TextEditingController controller,
    FocusNode focusNode,
    IconData icon,
    String hint,
    TextInputType keyboardType,
    String? Function(String?) validator,
    bool shouldValidate, {
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          validator: shouldValidate ? validator : null,
          autovalidateMode: shouldValidate 
              ? AutovalidateMode.always 
              : AutovalidateMode.disabled,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.grey[100],
            counterText: maxLength != null ? '' : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            errorStyle: const TextStyle(fontSize: 12),
          ),
          onChanged: (value) {
            if (shouldValidate) {
              setState(() {}); // Trigger rebuild to show validation
            }
          },
        ),
      ],
    );
  }

  Widget _buildValidatedPasswordField(
    String label,
    TextEditingController controller,
    FocusNode focusNode,
    bool obscure,
    VoidCallback toggle,
    String? Function(String?) validator,
    bool shouldValidate,
  ) {
    String placeholderText = label.contains('CONFIRM') 
        ? 'Confirm your password' 
        : 'Enter your password';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscure,
          validator: shouldValidate ? validator : null,
          autovalidateMode: shouldValidate 
              ? AutovalidateMode.always 
              : AutovalidateMode.disabled,
          decoration: InputDecoration(
            hintText: placeholderText,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: toggle,
            ),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            errorStyle: const TextStyle(fontSize: 12),
            errorMaxLines: 2,
          ),
          onChanged: (value) {
            if (shouldValidate) {
              setState(() {}); // Trigger rebuild to show validation
            }
          },
        ),
      ],
    );
  }

  Future<void> _handleRegister(BuildContext context) async {
    // Mark all fields as validated to show errors
    setState(() {
      _nameValidated = true;
      _emailValidated = true;
      _phoneValidated = true;
      _passwordValidated = true;
      _confirmPasswordValidated = true;
    });

    // Validate all fields
    if (!_formKey.currentState!.validate()) {
      _showError(context, 'Please fix all errors before submitting');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _phoneController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        _showError(context, e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.signInWithGoogle();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = e.toString().replaceAll('Exception: ', '');
        if (errorMessage != 'Google sign-in cancelled') {
          _showError(context, errorMessage);
        }
      }
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red, duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }
}
