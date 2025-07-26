import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PersonalInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String? selectedCountryCode;
  final VoidCallback onCountryCodeTap;
  final bool isEmailValid;
  final String? nameError;
  final String? emailError;
  final String? phoneError;

  const PersonalInfoSection({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.selectedCountryCode,
    required this.onCountryCodeTap,
    required this.isEmailValid,
    this.nameError,
    this.emailError,
    this.phoneError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),

        // Full Name Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Full Name',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Enter your full name',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                errorText: nameError,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Email Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email Address',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'Enter your email address',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'email',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: isEmailValid
                    ? Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.successLight,
                          size: 20,
                        ),
                      )
                    : null,
                errorText: emailError,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Phone Number Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phone Number',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                // Country Code Selector
                GestureDetector(
                  onTap: onCountryCodeTap,
                  child: Container(
                    height: 6.h,
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '🇺🇸',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          selectedCountryCode ?? '+1',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: 'keyboard_arrow_down',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                // Phone Number Input
                Expanded(
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: '(555) 123-4567',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'phone',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      errorText: phoneError,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
