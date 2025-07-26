import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  final Function(String provider) onSocialLogin;
  final bool isLoading;

  const SocialLoginWidget({
    Key? key,
    required this.onSocialLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4.h),

        // Divider with text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or continue with',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Social Login Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Google Login
            _SocialLoginButton(
              onTap: () => onSocialLogin('google'),
              iconName: 'g_translate',
              label: 'Google',
              backgroundColor: Colors.white,
              borderColor: AppTheme.lightTheme.colorScheme.outline,
              textColor: AppTheme.lightTheme.colorScheme.onSurface,
              isEnabled: !isLoading,
            ),

            // Apple Login (iOS only)
            if (defaultTargetPlatform == TargetPlatform.iOS || kIsWeb)
              _SocialLoginButton(
                onTap: () => onSocialLogin('apple'),
                iconName: 'apple',
                label: 'Apple',
                backgroundColor: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.white,
                isEnabled: !isLoading,
              ),

            // Facebook Login
            _SocialLoginButton(
              onTap: () => onSocialLogin('facebook'),
              iconName: 'facebook',
              label: 'Facebook',
              backgroundColor: const Color(0xFF1877F2),
              borderColor: const Color(0xFF1877F2),
              textColor: Colors.white,
              isEnabled: !isLoading,
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatefulWidget {
  final VoidCallback onTap;
  final String iconName;
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final bool isEnabled;

  const _SocialLoginButton({
    Key? key,
    required this.onTap,
    required this.iconName,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.isEnabled,
  }) : super(key: key);

  @override
  State<_SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<_SocialLoginButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isEnabled) return;

    _animationController.forward().then((_) {
      _animationController.reverse();
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _handleTap,
            child: Container(
              width: 25.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.borderColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: widget.iconName,
                    color: widget.textColor,
                    size: 5.w,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    widget.label,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: widget.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
