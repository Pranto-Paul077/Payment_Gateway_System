import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback onBiometricAuth;
  final bool isEnabled;

  const BiometricAuthWidget({
    Key? key,
    required this.onBiometricAuth,
    required this.isEnabled,
  }) : super(key: key);

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isBiometricAvailable = false;
  String _biometricType = 'fingerprint';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _checkBiometricAvailability();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    if (kIsWeb) {
      // Web doesn't support biometric authentication
      setState(() {
        _isBiometricAvailable = false;
      });
      return;
    }

    try {
      // Simulate biometric availability check
      // In real implementation, use local_auth package
      setState(() {
        _isBiometricAvailable = true;
        // Determine biometric type based on platform
        _biometricType = defaultTargetPlatform == TargetPlatform.iOS
            ? 'face_id'
            : 'fingerprint';
      });
    } catch (e) {
      setState(() {
        _isBiometricAvailable = false;
      });
    }
  }

  void _handleBiometricTap() async {
    if (!widget.isEnabled || !_isBiometricAvailable) return;

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Simulate biometric authentication
    // In real implementation, use local_auth package
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      widget.onBiometricAuth();
    } catch (e) {
      // Handle biometric authentication error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Biometric authentication failed. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    }
  }

  String _getBiometricIcon() {
    switch (_biometricType) {
      case 'face_id':
        return 'face';
      case 'fingerprint':
        return 'fingerprint';
      default:
        return 'security';
    }
  }

  String _getBiometricLabel() {
    switch (_biometricType) {
      case 'face_id':
        return 'Face ID';
      case 'fingerprint':
        return 'Fingerprint';
      default:
        return 'Biometric';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBiometricAvailable || !widget.isEnabled) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(height: 3.h),
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
                'OR',
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

        // Biometric Authentication Button
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTap: _handleBiometricTap,
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _getBiometricIcon(),
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 8.w,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 1.h),
        Text(
          'Use ${_getBiometricLabel()}',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
