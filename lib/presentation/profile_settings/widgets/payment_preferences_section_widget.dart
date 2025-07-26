import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './settings_item_widget.dart';
import './settings_section_widget.dart';

class PaymentPreferencesSectionWidget extends StatefulWidget {
  final Map<String, dynamic> paymentSettings;
  final Function(Map<String, dynamic>) onSettingsChanged;

  const PaymentPreferencesSectionWidget({
    Key? key,
    required this.paymentSettings,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  State<PaymentPreferencesSectionWidget> createState() =>
      _PaymentPreferencesSectionWidgetState();
}

class _PaymentPreferencesSectionWidgetState
    extends State<PaymentPreferencesSectionWidget> {
  void _showPaymentMethodSelector() {
    final paymentMethods = [
      {"name": "Visa •••• 4532", "type": "Credit Card", "icon": "credit_card"},
      {
        "name": "PayPal",
        "type": "Digital Wallet",
        "icon": "account_balance_wallet"
      },
      {
        "name": "Bank Transfer",
        "type": "Bank Account",
        "icon": "account_balance"
      },
      {"name": "Apple Pay", "type": "Mobile Payment", "icon": "phone_iphone"},
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Default Payment Method',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ...paymentMethods
                .map((method) => ListTile(
                      leading: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: method["icon"] as String,
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 5.w,
                          ),
                        ),
                      ),
                      title: Text(method["name"] as String),
                      subtitle: Text(method["type"] as String),
                      trailing: Radio<String>(
                        value: method["name"] as String,
                        groupValue: widget
                            .paymentSettings["defaultPaymentMethod"] as String,
                        onChanged: (value) {
                          final updatedSettings = {
                            ...widget.paymentSettings,
                            "defaultPaymentMethod": value,
                          };
                          widget.onSettingsChanged(updatedSettings);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Default payment method updated'),
                              backgroundColor: AppTheme.successLight,
                            ),
                          );
                        },
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  void _showCurrencySelector() {
    final currencies = [
      {"code": "USD", "name": "US Dollar", "symbol": "\$"},
      {"code": "EUR", "name": "Euro", "symbol": "€"},
      {"code": "GBP", "name": "British Pound", "symbol": "£"},
      {"code": "JPY", "name": "Japanese Yen", "symbol": "¥"},
      {"code": "CAD", "name": "Canadian Dollar", "symbol": "C\$"},
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Currency',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ...currencies
                .map((currency) => ListTile(
                      leading: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Center(
                          child: Text(
                            currency["symbol"] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text('${currency["code"]} - ${currency["name"]}'),
                      trailing: Radio<String>(
                        value: currency["code"] as String,
                        groupValue:
                            widget.paymentSettings["currency"] as String,
                        onChanged: (value) {
                          final updatedSettings = {
                            ...widget.paymentSettings,
                            "currency": value,
                          };
                          widget.onSettingsChanged(updatedSettings);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Currency updated to ${currency["name"]}'),
                              backgroundColor: AppTheme.successLight,
                            ),
                          );
                        },
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  void _showTransactionLimitsDialog() {
    final dailyLimitController = TextEditingController(
      text: (widget.paymentSettings["dailyLimit"] as double).toString(),
    );
    final monthlyLimitController = TextEditingController(
      text: (widget.paymentSettings["monthlyLimit"] as double).toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction Limits'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dailyLimitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Daily Limit (\$)',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'today',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: monthlyLimitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Monthly Limit (\$)',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'calendar_month',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedSettings = {
                ...widget.paymentSettings,
                "dailyLimit":
                    double.tryParse(dailyLimitController.text) ?? 1000.0,
                "monthlyLimit":
                    double.tryParse(monthlyLimitController.text) ?? 10000.0,
              };
              widget.onSettingsChanged(updatedSettings);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Transaction limits updated'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionWidget(
      title: 'Payment Preferences',
      children: [
        SettingsItemWidget(
          iconName: 'payment',
          title: 'Default Payment Method',
          subtitle: widget.paymentSettings["defaultPaymentMethod"] as String,
          onTap: _showPaymentMethodSelector,
        ),
        SettingsItemWidget(
          iconName: 'attach_money',
          title: 'Currency',
          subtitle: widget.paymentSettings["currency"] as String,
          onTap: _showCurrencySelector,
        ),
        SettingsItemWidget(
          iconName: 'account_balance',
          title: 'Transaction Limits',
          subtitle:
              'Daily: \$${(widget.paymentSettings["dailyLimit"] as double).toStringAsFixed(0)} • Monthly: \$${(widget.paymentSettings["monthlyLimit"] as double).toStringAsFixed(0)}',
          onTap: _showTransactionLimitsDialog,
        ),
        SettingsItemWidget(
          iconName: 'notifications',
          title: 'Payment Notifications',
          subtitle: widget.paymentSettings["notificationsEnabled"] as bool
              ? 'Enabled for all transactions'
              : 'Disabled',
          trailing: Switch(
            value: widget.paymentSettings["notificationsEnabled"] as bool,
            onChanged: (value) {
              final updatedSettings = {
                ...widget.paymentSettings,
                "notificationsEnabled": value,
              };
              widget.onSettingsChanged(updatedSettings);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? 'Payment notifications enabled'
                      : 'Payment notifications disabled'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
          ),
          showDivider: false,
        ),
      ],
    );
  }
}
