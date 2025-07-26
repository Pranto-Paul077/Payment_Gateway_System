import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final Function(Map<String, dynamic>) onTransactionTap;

  const RecentTransactionsList({
    Key? key,
    required this.transactions,
    required this.onTransactionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/transaction-history'),
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        transactions.isEmpty
            ? _buildEmptyState()
            : SizedBox(
                height: 25.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return _buildTransactionCard(context, transaction);
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildTransactionCard(
      BuildContext context, Map<String, dynamic> transaction) {
    final isIncoming = (transaction['type'] as String) == 'incoming';
    final amount = transaction['amount'] as double;
    final merchant = transaction['merchant'] as String;
    final status = transaction['status'] as String;
    final date = transaction['date'] as DateTime;
    final category = transaction['category'] as String;

    return GestureDetector(
      onTap: () => onTransactionTap(transaction),
      onLongPress: () => _showQuickActions(context, transaction),
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 3.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow
                  .withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.5.w),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: _getCategoryIcon(category),
                    color: _getCategoryColor(category),
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        merchant,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        category,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(status),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${isIncoming ? '+' : '-'}\$${amount.toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: isIncoming
                        ? AppTheme.successLight
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _formatDate(date),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            LinearProgressIndicator(
              value: status == 'completed'
                  ? 1.0
                  : status == 'pending'
                      ? 0.5
                      : 0.0,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                status == 'completed'
                    ? AppTheme.successLight
                    : status == 'pending'
                        ? AppTheme.warningLight
                        : AppTheme.errorLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    String statusText;

    switch (status) {
      case 'completed':
        statusColor = AppTheme.successLight;
        statusText = 'Completed';
        break;
      case 'pending':
        statusColor = AppTheme.warningLight;
        statusText = 'Pending';
        break;
      case 'failed':
        statusColor = AppTheme.errorLight;
        statusText = 'Failed';
        break;
      default:
        statusColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
        statusText = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 25.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'receipt_long',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No Recent Transactions',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Your transaction history will appear here',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActions(
      BuildContext context, Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            ListTile(
              leading: CustomIconWidget(
                iconName: 'receipt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('View Receipt'),
              onTap: () {
                Navigator.pop(context);
                // Handle view receipt
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'repeat',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Repeat Payment'),
              onTap: () {
                Navigator.pop(context);
                // Handle repeat payment
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report_problem',
                color: AppTheme.errorLight,
                size: 24,
              ),
              title: const Text('Report Issue'),
              onTap: () {
                Navigator.pop(context);
                // Handle report issue
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return 'restaurant';
      case 'shopping':
        return 'shopping_bag';
      case 'transport':
        return 'directions_car';
      case 'entertainment':
        return 'movie';
      case 'bills':
        return 'receipt_long';
      case 'transfer':
        return 'swap_horiz';
      default:
        return 'payment';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'shopping':
        return Colors.purple;
      case 'transport':
        return Colors.blue;
      case 'entertainment':
        return Colors.pink;
      case 'bills':
        return Colors.red;
      case 'transfer':
        return Colors.green;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '${difference}d ago';

    return '${date.month}/${date.day}';
  }
}
