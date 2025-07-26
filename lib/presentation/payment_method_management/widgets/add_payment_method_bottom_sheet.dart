import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AddPaymentMethodBottomSheet extends StatelessWidget {
  final Function(String) onMethodSelected;

  const AddPaymentMethodBottomSheet({
    Key? key,
    required this.onMethodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Add Payment Method',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose how you\'d like to pay',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),
          _buildPaymentOption(
            context,
            icon: 'credit_card',
            title: 'Credit or Debit Card',
            subtitle: 'Visa, Mastercard, American Express',
            onTap: () => onMethodSelected('card'),
          ),
          SizedBox(height: 2.h),
          _buildPaymentOption(
            context,
            icon: 'account_balance',
            title: 'Bank Account',
            subtitle: 'Connect your bank account securely',
            onTap: () => onMethodSelected('bank'),
          ),
          SizedBox(height: 2.h),
          _buildPaymentOption(
            context,
            icon: 'phone_iphone',
            title: 'Apple Pay',
            subtitle: 'Pay with Touch ID or Face ID',
            onTap: () => onMethodSelected('apple_pay'),
            enabled: Theme.of(context).platform == TargetPlatform.iOS,
          ),
          SizedBox(height: 2.h),
          _buildPaymentOption(
            context,
            icon: 'phone_android',
            title: 'Google Pay',
            subtitle: 'Pay with your Google account',
            onTap: () => onMethodSelected('google_pay'),
            enabled: Theme.of(context).platform == TargetPlatform.android,
          ),
          SizedBox(height: 2.h),
          _buildPaymentOption(
            context,
            icon: 'account_balance_wallet',
            title: 'PayPal',
            subtitle: 'Pay with your PayPal account',
            onTap: () => onMethodSelected('paypal'),
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  size: 20,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your payment information is secure',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'We use bank-level encryption to protect your data',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: enabled
                    ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  size: 24,
                  color: enabled
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: enabled
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: enabled
                          ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          : AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            if (enabled)
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                size: 16,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
