import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionCardWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback? onTap;
  final Function(String)? onSwipeAction;

  const TransactionCardWidget({
    Key? key,
    required this.transaction,
    this.onTap,
    this.onSwipeAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(transaction['id'].toString()),
      background: _buildLeftSwipeBackground(),
      secondaryBackground: _buildRightSwipeBackground(),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onSwipeAction?.call('view_receipt');
        } else if (direction == DismissDirection.endToStart) {
          onSwipeAction?.call('report_issue');
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildTransactionIcon(),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildTransactionDetails(),
              ),
              _buildAmountAndStatus(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftSwipeBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'receipt',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 24,
          ),
          SizedBox(width: 2.w),
          Text(
            'View Receipt',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSwipeBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Report Issue',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onError,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 2.w),
          CustomIconWidget(
            iconName: 'report_problem',
            color: AppTheme.lightTheme.colorScheme.onError,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionIcon() {
    final String paymentMethod =
        transaction['paymentMethod'] as String? ?? 'credit_card';
    final String type = transaction['type'] as String? ?? 'sent';

    String iconName;
    Color iconColor;

    switch (paymentMethod.toLowerCase()) {
      case 'credit card':
      case 'debit card':
        iconName = 'credit_card';
        break;
      case 'bank transfer':
        iconName = 'account_balance';
        break;
      case 'digital wallet':
        iconName = 'account_balance_wallet';
        break;
      case 'cash':
        iconName = 'payments';
        break;
      default:
        iconName = 'payment';
    }

    switch (type.toLowerCase()) {
      case 'received':
        iconColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      case 'sent':
        iconColor = AppTheme.lightTheme.colorScheme.error;
        break;
      case 'pending':
        iconColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      default:
        iconColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: iconName,
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildTransactionDetails() {
    final String merchantName =
        transaction['merchantName'] as String? ?? 'Unknown Merchant';
    final String paymentMethod =
        transaction['paymentMethod'] as String? ?? 'Credit Card';
    final DateTime timestamp =
        transaction['timestamp'] as DateTime? ?? DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          merchantName,
          style: AppTheme.lightTheme.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),
        Text(
          paymentMethod,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          _formatTime(timestamp),
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountAndStatus() {
    final double amount = (transaction['amount'] as num?)?.toDouble() ?? 0.0;
    final String type = transaction['type'] as String? ?? 'sent';
    final String status = transaction['status'] as String? ?? 'completed';

    Color amountColor;
    String amountPrefix;

    switch (type.toLowerCase()) {
      case 'received':
        amountColor = AppTheme.lightTheme.colorScheme.primary;
        amountPrefix = '+';
        break;
      case 'sent':
        amountColor = AppTheme.lightTheme.colorScheme.error;
        amountPrefix = '-';
        break;
      case 'pending':
        amountColor = AppTheme.lightTheme.colorScheme.tertiary;
        amountPrefix = '';
        break;
      default:
        amountColor = AppTheme.lightTheme.colorScheme.onSurface;
        amountPrefix = '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$amountPrefix\$${amount.toStringAsFixed(2)}',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: amountColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        _buildStatusBadge(status),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'completed':
        backgroundColor =
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.primary;
        displayText = 'Completed';
        break;
      case 'pending':
        backgroundColor =
            AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.tertiary;
        displayText = 'Pending';
        break;
      case 'failed':
        backgroundColor =
            AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.error;
        displayText = 'Failed';
        break;
      default:
        backgroundColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant
            .withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
        displayText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : hour;
      return '${displayHour}:${dateTime.minute.toString().padLeft(2, '0')} $period';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }
}
