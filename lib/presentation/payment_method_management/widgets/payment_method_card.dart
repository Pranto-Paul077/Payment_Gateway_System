import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PaymentMethodCard extends StatelessWidget {
  final Map<String, dynamic> paymentMethod;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onSetDefault;
  final VoidCallback? onRemove;
  final VoidCallback? onViewDetails;
  final VoidCallback? onTransactionHistory;

  const PaymentMethodCard({
    Key? key,
    required this.paymentMethod,
    this.onTap,
    this.onEdit,
    this.onSetDefault,
    this.onRemove,
    this.onViewDetails,
    this.onTransactionHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDefault = paymentMethod['isDefault'] ?? false;
    final String type = paymentMethod['type'] ?? '';
    final String lastFour = paymentMethod['lastFour'] ?? '';
    final String expiryDate = paymentMethod['expiryDate'] ?? '';
    final String provider = paymentMethod['provider'] ?? '';
    final String holderName = paymentMethod['holderName'] ?? '';

    return Dismissible(
      key: Key(paymentMethod['id'].toString()),
      background: _buildLeftSwipeBackground(),
      secondaryBackground: _buildRightSwipeBackground(),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Left swipe - Edit action
          onEdit?.call();
        } else if (direction == DismissDirection.endToStart) {
          // Right swipe - Remove action
          onRemove?.call();
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showRemoveConfirmation(context);
        }
        return false; // Don't actually dismiss for edit
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isDefault
                ? BorderSide(color: AppTheme.lightTheme.primaryColor, width: 2)
                : BorderSide.none,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildProviderIcon(provider),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _getDisplayName(type, provider),
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (isDefault) ...[
                                  SizedBox(width: 2.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Default',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              _getSubtitle(
                                  type, lastFour, expiryDate, holderName),
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              onEdit?.call();
                              break;
                            case 'setDefault':
                              onSetDefault?.call();
                              break;
                            case 'viewDetails':
                              onViewDetails?.call();
                              break;
                            case 'transactionHistory':
                              onTransactionHistory?.call();
                              break;
                            case 'remove':
                              _showRemoveConfirmation(context)
                                  .then((confirmed) {
                                if (confirmed == true) {
                                  onRemove?.call();
                                }
                              });
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'edit',
                                  size: 20,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                                SizedBox(width: 3.w),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          if (!isDefault)
                            PopupMenuItem(
                              value: 'setDefault',
                              child: Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'star',
                                    size: 20,
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text('Set as Default'),
                                ],
                              ),
                            ),
                          PopupMenuItem(
                            value: 'viewDetails',
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'visibility',
                                  size: 20,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                                SizedBox(width: 3.w),
                                Text('View Details'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'transactionHistory',
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'history',
                                  size: 20,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                                SizedBox(width: 3.w),
                                Text('Transaction History'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'remove',
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'delete',
                                  size: 20,
                                  color: AppTheme.lightTheme.colorScheme.error,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  'Remove',
                                  style: TextStyle(
                                    color:
                                        AppTheme.lightTheme.colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        child: CustomIconWidget(
                          iconName: 'more_vert',
                          size: 24,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  if (type == 'bank_account') ...[
                    SizedBox(height: 2.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'security',
                            size: 16,
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Bank-grade security',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderIcon(String provider) {
    String iconName;
    Color iconColor;

    switch (provider.toLowerCase()) {
      case 'visa':
        iconName = 'credit_card';
        iconColor = Color(0xFF1A1F71);
        break;
      case 'mastercard':
        iconName = 'credit_card';
        iconColor = Color(0xFFEB001B);
        break;
      case 'american express':
      case 'amex':
        iconName = 'credit_card';
        iconColor = Color(0xFF006FCF);
        break;
      case 'paypal':
        iconName = 'account_balance_wallet';
        iconColor = Color(0xFF003087);
        break;
      case 'apple pay':
        iconName = 'phone_iphone';
        iconColor = Colors.black;
        break;
      case 'google pay':
        iconName = 'phone_android';
        iconColor = Color(0xFF4285F4);
        break;
      case 'bank':
        iconName = 'account_balance';
        iconColor = AppTheme.lightTheme.primaryColor;
        break;
      default:
        iconName = 'payment';
        iconColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      width: 12.w,
      height: 6.h,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: iconName,
          size: 24,
          color: iconColor,
        ),
      ),
    );
  }

  String _getDisplayName(String type, String provider) {
    switch (type) {
      case 'credit_card':
      case 'debit_card':
        return provider;
      case 'bank_account':
        return 'Bank Account';
      case 'digital_wallet':
        return provider;
      default:
        return provider;
    }
  }

  String _getSubtitle(
      String type, String lastFour, String expiryDate, String holderName) {
    switch (type) {
      case 'credit_card':
      case 'debit_card':
        return '•••• •••• •••• $lastFour • Expires $expiryDate';
      case 'bank_account':
        return '•••• •••• $lastFour • $holderName';
      case 'digital_wallet':
        return holderName.isNotEmpty ? holderName : 'Digital Wallet';
      default:
        return '•••• •••• •••• $lastFour';
    }
  }

  Widget _buildLeftSwipeBackground() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'edit',
                size: 24,
                color: Colors.white,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Edit',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightSwipeBackground() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'delete',
                size: 24,
                color: Colors.white,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Remove',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showRemoveConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Payment Method'),
        content: Text(
          'Are you sure you want to remove this payment method? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }
}
