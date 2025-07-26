import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import './transaction_card_widget.dart';

class TransactionSectionWidget extends StatelessWidget {
  final String sectionTitle;
  final List<Map<String, dynamic>> transactions;
  final Function(Map<String, dynamic>) onTransactionTap;
  final Function(Map<String, dynamic>, String) onSwipeAction;

  const TransactionSectionWidget({
    Key? key,
    required this.sectionTitle,
    required this.transactions,
    required this.onTransactionTap,
    required this.onSwipeAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            sectionTitle,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return TransactionCardWidget(
              transaction: transaction,
              onTap: () => onTransactionTap(transaction),
              onSwipeAction: (action) => onSwipeAction(transaction, action),
            );
          },
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
