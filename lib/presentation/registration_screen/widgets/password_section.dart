import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PasswordSection extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onConfirmPasswordVisibilityToggle;
  final Map<String, bool> passwordRequirements;
  final bool isPasswordMatch;
  final String? passwordError;
  final String? confirmPasswordError;

  const PasswordSection({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.onPasswordVisibilityToggle,
    required this.onConfirmPasswordVisibilityToggle,
    required this.passwordRequirements,
    required this.isPasswordMatch,
    this.passwordError,
    this.confirmPasswordError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),

        // Password Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Create a strong password',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'lock',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: onPasswordVisibilityToggle,
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName:
                          isPasswordVisible ? 'visibility_off' : 'visibility',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                errorText: passwordError,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),

        // Password Requirements Checklist
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password Requirements:',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              ...passwordRequirements.entries
                  .map((entry) => _buildRequirementItem(
                        entry.key,
                        entry.value,
                      )),
            ],
          ),
        ),
        SizedBox(height: 2.h),

        // Confirm Password Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm Password',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: !isConfirmPasswordVisible,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Confirm your password',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'lock',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (confirmPasswordController.text.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(right: 1.w),
                        child: CustomIconWidget(
                          iconName: isPasswordMatch ? 'check_circle' : 'cancel',
                          color: isPasswordMatch
                              ? AppTheme.successLight
                              : AppTheme.errorLight,
                          size: 20,
                        ),
                      ),
                    GestureDetector(
                      onTap: onConfirmPasswordVisibilityToggle,
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: isConfirmPasswordVisible
                              ? 'visibility_off'
                              : 'visibility',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                errorText: confirmPasswordError,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRequirementItem(String requirement, bool isMet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.3.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isMet ? 'check_circle' : 'radio_button_unchecked',
            color: isMet
                ? AppTheme.successLight
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              requirement,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontSize: 11.sp,
                color: isMet
                    ? AppTheme.successLight
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
