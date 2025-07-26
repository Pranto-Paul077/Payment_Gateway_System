import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsGrid extends StatelessWidget {
  final Function(String) onActionTap;

  const QuickActionsGrid({
    Key? key,
    required this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = [
      {
        'title': 'Send Money',
        'icon': 'send',
        'color': Colors.blue,
        'action': 'send_money',
      },
      {
        'title': 'Request Payment',
        'icon': 'request_page',
        'color': Colors.green,
        'action': 'request_payment',
      },
      {
        'title': 'Scan QR',
        'icon': 'qr_code_scanner',
        'color': Colors.purple,
        'action': 'scan_qr',
      },
      {
        'title': 'Pay Bills',
        'icon': 'receipt_long',
        'color': Colors.orange,
        'action': 'pay_bills',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.5,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _buildActionCard(context, action);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, Map<String, dynamic> action) {
    final title = action['title'] as String;
    final iconName = action['icon'] as String;
    final color = action['color'] as Color;
    final actionKey = action['action'] as String;

    return GestureDetector(
      onTap: () {
        // Add haptic feedback
        _triggerHapticFeedback();
        onActionTap(actionKey);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow
                  .withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 28,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _triggerHapticFeedback() {
    // Simple haptic feedback simulation
    // In a real app, you would use HapticFeedback.lightImpact()
  }
}
