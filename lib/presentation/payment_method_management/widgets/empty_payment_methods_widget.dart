import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class EmptyPaymentMethodsWidget extends StatelessWidget {
  final VoidCallback onAddPaymentMethod;

  const EmptyPaymentMethodsWidget({
    Key? key,
    required this.onAddPaymentMethod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'payment',
                  size: 60,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'No Payment Methods',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Add your first payment method to start making secure transactions',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 6.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAddPaymentMethod,
                icon: CustomIconWidget(
                  iconName: 'add',
                  size: 20,
                  color: Colors.white,
                ),
                label: Text('Add Your First Payment Method'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'security',
                        size: 20,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Secure & Protected',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildSecurityFeature(
                    icon: 'verified_user',
                    title: 'PCI DSS Compliant',
                    subtitle: 'Bank-grade security standards',
                  ),
                  SizedBox(height: 1.h),
                  _buildSecurityFeature(
                    icon: 'lock',
                    title: 'End-to-End Encryption',
                    subtitle: 'Your data is always protected',
                  ),
                  SizedBox(height: 1.h),
                  _buildSecurityFeature(
                    icon: 'fingerprint',
                    title: 'Biometric Authentication',
                    subtitle: 'Secure access with your fingerprint',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityFeature({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          size: 16,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
