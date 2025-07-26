import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TermsAcceptanceSection extends StatelessWidget {
  final bool isTermsAccepted;
  final VoidCallback onTermsToggle;
  final VoidCallback onTermsOfServiceTap;
  final VoidCallback onPrivacyPolicyTap;

  const TermsAcceptanceSection({
    super.key,
    required this.isTermsAccepted,
    required this.onTermsToggle,
    required this.onTermsOfServiceTap,
    required this.onPrivacyPolicyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTermsToggle,
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: isTermsAccepted
                    ? AppTheme.lightTheme.colorScheme.primary
                    : Colors.transparent,
                border: Border.all(
                  color: isTermsAccepted
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: isTermsAccepted
                  ? Center(
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 16,
                      ),
                    )
                  : null,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: 'I agree to the ',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = onTermsOfServiceTap,
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = onPrivacyPolicyTap,
                  ),
                  TextSpan(
                    text:
                        '. I understand that my personal and financial information will be processed securely in accordance with applicable data protection laws.',
                    style: TextStyle(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
