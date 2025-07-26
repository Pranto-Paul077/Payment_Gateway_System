import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NewPaymentButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NewPaymentButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: ElevatedButton(
        onPressed: () {
          _showPaymentOptions(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'New Payment',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Choose Payment Method',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildPaymentOption(
                      context,
                      'Send to Contact',
                      'Send money to your contacts',
                      'contacts',
                      Colors.blue,
                      () {
                        Navigator.pop(context);
                        // Handle send to contact
                      },
                    ),
                    _buildPaymentOption(
                      context,
                      'Bank Transfer',
                      'Transfer to bank account',
                      'account_balance',
                      Colors.green,
                      () {
                        Navigator.pop(context);
                        // Handle bank transfer
                      },
                    ),
                    _buildPaymentOption(
                      context,
                      'QR Code Payment',
                      'Scan QR code to pay',
                      'qr_code_scanner',
                      Colors.purple,
                      () {
                        Navigator.pop(context);
                        // Handle QR payment
                      },
                    ),
                    _buildPaymentOption(
                      context,
                      'Bill Payment',
                      'Pay utility bills',
                      'receipt_long',
                      Colors.orange,
                      () {
                        Navigator.pop(context);
                        // Handle bill payment
                      },
                    ),
                    _buildPaymentOption(
                      context,
                      'Mobile Recharge',
                      'Recharge mobile phone',
                      'phone_android',
                      Colors.red,
                      () {
                        Navigator.pop(context);
                        // Handle mobile recharge
                      },
                    ),
                    _buildPaymentOption(
                      context,
                      'Online Shopping',
                      'Pay for online purchases',
                      'shopping_cart',
                      Colors.pink,
                      () {
                        Navigator.pop(context);
                        // Handle online shopping
                      },
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

  Widget _buildPaymentOption(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        leading: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'arrow_forward_ios',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
