import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionDetailModalWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailModalWidget({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTransactionSummary(),
                  SizedBox(height: 3.h),
                  _buildTransactionDetails(),
                  SizedBox(height: 3.h),
                  _buildMerchantDetails(),
                  SizedBox(height: 3.h),
                  _buildFeesBreakdown(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Transaction Details',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSummary() {
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
      default:
        amountColor = AppTheme.lightTheme.colorScheme.onSurface;
        amountPrefix = '';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            '$amountPrefix\$${amount.toStringAsFixed(2)}',
            style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.h),
          _buildStatusBadge(status),
          SizedBox(height: 2.h),
          Text(
            transaction['merchantName'] as String? ?? 'Unknown Merchant',
            style: AppTheme.lightTheme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetails() {
    final DateTime timestamp =
        transaction['timestamp'] as DateTime? ?? DateTime.now();
    final String confirmationNumber =
        transaction['confirmationNumber'] as String? ?? 'N/A';
    final String paymentMethod =
        transaction['paymentMethod'] as String? ?? 'Credit Card';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Information',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        _buildDetailRow('Date & Time', _formatDateTime(timestamp)),
        _buildDetailRow('Confirmation Number', confirmationNumber),
        _buildDetailRow('Payment Method', paymentMethod),
        _buildDetailRow('Transaction ID', transaction['id'].toString()),
        _buildDetailRow('Reference Number',
            transaction['referenceNumber'] as String? ?? 'N/A'),
      ],
    );
  }

  Widget _buildMerchantDetails() {
    final Map<String, dynamic> merchantInfo =
        transaction['merchantInfo'] as Map<String, dynamic>? ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Merchant Details',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        _buildDetailRow(
            'Business Name', merchantInfo['businessName'] as String? ?? 'N/A'),
        _buildDetailRow(
            'Category', merchantInfo['category'] as String? ?? 'N/A'),
        _buildDetailRow(
            'Location', merchantInfo['location'] as String? ?? 'N/A'),
        _buildDetailRow('Contact', merchantInfo['contact'] as String? ?? 'N/A'),
      ],
    );
  }

  Widget _buildFeesBreakdown() {
    final Map<String, dynamic> fees =
        transaction['fees'] as Map<String, dynamic>? ?? {};
    final double processingFee =
        (fees['processing'] as num?)?.toDouble() ?? 0.0;
    final double serviceFee = (fees['service'] as num?)?.toDouble() ?? 0.0;
    final double totalFees = processingFee + serviceFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fee Breakdown',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        _buildDetailRow(
            'Processing Fee', '\$${processingFee.toStringAsFixed(2)}'),
        _buildDetailRow('Service Fee', '\$${serviceFee.toStringAsFixed(2)}'),
        Divider(
          color: AppTheme.lightTheme.colorScheme.outline,
          thickness: 1,
        ),
        _buildDetailRow(
          'Total Fees',
          '\$${totalFees.toStringAsFixed(2)}',
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
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
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayText,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _downloadReceipt(context),
                  icon: CustomIconWidget(
                    iconName: 'download',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  label: Text('Download Receipt'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _shareTransaction(context),
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  label: Text('Share'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _repeatPayment(context),
              child: Text('Repeat Payment'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : hour;

    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} at ${displayHour}:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }

  void _downloadReceipt(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Receipt downloaded successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _shareTransaction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction details shared'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _repeatPayment(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Redirecting to payment screen...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }
}
