import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/country_code_bottom_sheet.dart';
import './widgets/create_account_button.dart';
import './widgets/password_section.dart';
import './widgets/personal_info_section.dart';
import './widgets/social_registration_section.dart';
import './widgets/terms_acceptance_section.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State variables
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isTermsAccepted = false;
  bool _isLoading = false;
  String _selectedCountryCode = '+1';
  String _selectedCountryFlag = '🇺🇸';

  // Validation states
  bool _isEmailValid = false;
  bool _isPasswordMatch = false;
  Map<String, bool> _passwordRequirements = {
    'At least 8 characters': false,
    'Contains uppercase letter': false,
    'Contains lowercase letter': false,
    'Contains number': false,
    'Contains special character': false,
  };

  // Error messages
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _setupListeners();
    _loadSavedData();
  }

  void _setupListeners() {
    _nameController.addListener(_validateName);
    _emailController.addListener(_validateEmail);
    _phoneController.addListener(_validatePhone);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  void _loadSavedData() {
    // Load saved form data from secure storage
    // Implementation would use flutter_secure_storage
  }

  void _saveFormData() {
    // Save form progress to secure storage
    // Implementation would use flutter_secure_storage
  }

  void _validateName() {
    setState(() {
      if (_nameController.text.isEmpty) {
        _nameError = null;
      } else if (_nameController.text.trim().length < 2) {
        _nameError = 'Name must be at least 2 characters';
      } else if (!RegExp(r'^[a-zA-Z\s]+$')
          .hasMatch(_nameController.text.trim())) {
        _nameError = 'Name can only contain letters and spaces';
      } else {
        _nameError = null;
      }
    });
    _saveFormData();
  }

  void _validateEmail() {
    setState(() {
      final email = _emailController.text.trim();
      if (email.isEmpty) {
        _emailError = null;
        _isEmailValid = false;
      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(email)) {
        _emailError = 'Please enter a valid email address';
        _isEmailValid = false;
      } else {
        _emailError = null;
        _isEmailValid = true;
      }
    });
    _saveFormData();
  }

  void _validatePhone() {
    setState(() {
      final phone = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
      if (phone.isEmpty) {
        _phoneError = null;
      } else if (phone.length < 10) {
        _phoneError = 'Phone number must be at least 10 digits';
      } else {
        _phoneError = null;
        // Format phone number
        if (phone.length == 10) {
          _phoneController.text =
              '(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6)}';
          _phoneController.selection = TextSelection.fromPosition(
            TextPosition(offset: _phoneController.text.length),
          );
        }
      }
    });
    _saveFormData();
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _passwordRequirements = {
        'At least 8 characters': password.length >= 8,
        'Contains uppercase letter': password.contains(RegExp(r'[A-Z]')),
        'Contains lowercase letter': password.contains(RegExp(r'[a-z]')),
        'Contains number': password.contains(RegExp(r'[0-9]')),
        'Contains special character':
            password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      };

      final allRequirementsMet =
          _passwordRequirements.values.every((met) => met);
      if (password.isEmpty) {
        _passwordError = null;
      } else if (!allRequirementsMet) {
        _passwordError = null; // Show requirements instead
      } else {
        _passwordError = null;
      }
    });
    _validateConfirmPassword();
    _saveFormData();
  }

  void _validateConfirmPassword() {
    setState(() {
      final confirmPassword = _confirmPasswordController.text;
      if (confirmPassword.isEmpty) {
        _confirmPasswordError = null;
        _isPasswordMatch = false;
      } else if (confirmPassword != _passwordController.text) {
        _confirmPasswordError = 'Passwords do not match';
        _isPasswordMatch = false;
      } else {
        _confirmPasswordError = null;
        _isPasswordMatch = true;
      }
    });
    _saveFormData();
  }

  bool get _isFormValid {
    return _nameController.text.trim().isNotEmpty &&
        _nameError == null &&
        _isEmailValid &&
        _phoneController.text.isNotEmpty &&
        _phoneError == null &&
        _passwordRequirements.values.every((met) => met) &&
        _isPasswordMatch &&
        _isTermsAccepted;
  }

  void _showCountryCodePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CountryCodeBottomSheet(
        onCountrySelected: (code, flag) {
          setState(() {
            _selectedCountryCode = code;
            _selectedCountryFlag = flag;
          });
        },
      ),
    );
  }

  void _showTermsOfService() {
    // Implementation would open in-app browser
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening Terms of Service...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _showPrivacyPolicy() {
    // Implementation would open in-app browser
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening Privacy Policy...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() => _isLoading = true);

    try {
      // Implementation would use Google Sign-In SDK
      await Future.delayed(Duration(seconds: 2)); // Simulate API call

      // Show success and navigate
      _showWelcomeAnimation();
    } catch (e) {
      _showErrorMessage('Google sign-up failed. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleSignUp() async {
    setState(() => _isLoading = true);

    try {
      // Implementation would use Sign in with Apple
      await Future.delayed(Duration(seconds: 2)); // Simulate API call

      // Show success and navigate
      _showWelcomeAnimation();
    } catch (e) {
      _showErrorMessage('Apple sign-up failed. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCreateAccount() async {
    if (!_isFormValid) return;

    setState(() => _isLoading = true);

    try {
      // Simulate account creation API call
      await Future.delayed(Duration(seconds: 3));

      // Show success animation and navigate
      _showWelcomeAnimation();
    } catch (e) {
      _showErrorMessage('Account creation failed. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showWelcomeAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successLight,
              size: 60,
            ),
            SizedBox(height: 2.h),
            Text(
              'Welcome to PayFlow!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Your account has been created successfully.',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                  context, '/payment-method-management');
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_nameController.text.isNotEmpty ||
        _emailController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty ||
        _passwordController.text.isNotEmpty) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Discard Changes?'),
              content: Text(
                  'You have unsaved changes. Are you sure you want to go back?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Discard'),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          title: Text(
            'Create Account',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Header
                  Text(
                    'Join PayFlow Gateway',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Create your secure payment account in just a few steps',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontSize: 14.sp,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Social Registration Section
                  SocialRegistrationSection(
                    onGoogleSignUp: _handleGoogleSignUp,
                    onAppleSignUp: _handleAppleSignUp,
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: 4.h),

                  // Personal Information Section
                  PersonalInfoSection(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    selectedCountryCode: _selectedCountryCode,
                    onCountryCodeTap: _showCountryCodePicker,
                    isEmailValid: _isEmailValid,
                    nameError: _nameError,
                    emailError: _emailError,
                    phoneError: _phoneError,
                  ),
                  SizedBox(height: 3.h),

                  // Password Section
                  PasswordSection(
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    isPasswordVisible: _isPasswordVisible,
                    isConfirmPasswordVisible: _isConfirmPasswordVisible,
                    onPasswordVisibilityToggle: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                    onConfirmPasswordVisibilityToggle: () {
                      setState(() => _isConfirmPasswordVisible =
                          !_isConfirmPasswordVisible);
                    },
                    passwordRequirements: _passwordRequirements,
                    isPasswordMatch: _isPasswordMatch,
                    passwordError: _passwordError,
                    confirmPasswordError: _confirmPasswordError,
                  ),
                  SizedBox(height: 3.h),

                  // Terms Acceptance Section
                  TermsAcceptanceSection(
                    isTermsAccepted: _isTermsAccepted,
                    onTermsToggle: () {
                      setState(() => _isTermsAccepted = !_isTermsAccepted);
                    },
                    onTermsOfServiceTap: _showTermsOfService,
                    onPrivacyPolicyTap: _showPrivacyPolicy,
                  ),
                  SizedBox(height: 4.h),

                  // Create Account Button
                  CreateAccountButton(
                    onPressed: _handleCreateAccount,
                    isEnabled: _isFormValid,
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: 2.h),

                  // Login Link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                        ),
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, '/login-screen'),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
