import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    'admin@payflow.com': 'admin123',
    'user@payflow.com': 'user123',
    'demo@payflow.com': 'demo123',
  };

  @override
  void initState() {
    super.initState();
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Check mock credentials
      if (_mockCredentials.containsKey(email) &&
          _mockCredentials[email] == password) {
        // Success haptic feedback
        HapticFeedback.lightImpact();

        // Navigate to dashboard
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard-screen');
        }
      } else {
        // Invalid credentials
        setState(() {
          _errorMessage = 'Invalid email or password. Please try again.';
        });
        HapticFeedback.vibrate();
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Network error. Please check your connection and try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleBiometricAuth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(milliseconds: 800));

      // Success haptic feedback
      HapticFeedback.lightImpact();

      // Navigate to dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard-screen');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Biometric authentication failed. Please try again.';
      });
      HapticFeedback.vibrate();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate social login
      await Future.delayed(const Duration(seconds: 1));

      // Success haptic feedback
      HapticFeedback.lightImpact();

      // Navigate to dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard-screen');
      }
    } catch (e) {
      setState(() {
        _errorMessage = '$provider login failed. Please try again.';
      });
      HapticFeedback.vibrate();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, '/registration-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8.h),

                  // App Logo
                  const AppLogoWidget(),
                  SizedBox(height: 6.h),

                  // Welcome Text
                  Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Sign in to your account to continue',
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Error Message
                  if (_errorMessage != null) ...[
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.error
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.error
                              .withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'error_outline',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],

                  // Login Form
                  LoginFormWidget(
                    onLogin: _handleLogin,
                    isLoading: _isLoading,
                  ),

                  // Biometric Authentication
                  BiometricAuthWidget(
                    onBiometricAuth: _handleBiometricAuth,
                    isEnabled: !_isLoading,
                  ),

                  // Social Login
                  SocialLoginWidget(
                    onSocialLogin: _handleSocialLogin,
                    isLoading: _isLoading,
                  ),

                  SizedBox(height: 4.h),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New user? ',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: _isLoading ? null : _navigateToSignUp,
                        child: Text(
                          'Sign Up',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Trust Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TrustBadge(
                        iconName: 'verified_user',
                        label: 'SSL Secured',
                      ),
                      SizedBox(width: 6.w),
                      _TrustBadge(
                        iconName: 'account_balance',
                        label: 'PCI DSS',
                      ),
                      SizedBox(width: 6.w),
                      _TrustBadge(
                        iconName: 'shield',
                        label: 'Bank Grade',
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final String iconName;
  final String label;

  const _TrustBadge({
    Key? key,
    required this.iconName,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.7),
          size: 4.w,
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
