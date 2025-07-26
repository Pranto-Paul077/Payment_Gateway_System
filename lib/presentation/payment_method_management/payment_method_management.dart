import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_payment_method_bottom_sheet.dart';
import './widgets/empty_payment_methods_widget.dart';
import './widgets/payment_method_card.dart';
import './widgets/payment_method_skeleton.dart';
import './widgets/security_badges_widget.dart';

class PaymentMethodManagement extends StatefulWidget {
  const PaymentMethodManagement({Key? key}) : super(key: key);

  @override
  State<PaymentMethodManagement> createState() =>
      _PaymentMethodManagementState();
}

class _PaymentMethodManagementState extends State<PaymentMethodManagement> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _paymentMethods = [];

  // Mock payment methods data
  final List<Map<String, dynamic>> _mockPaymentMethods = [
    {
      "id": 1,
      "type": "credit_card",
      "provider": "Visa",
      "lastFour": "4532",
      "expiryDate": "12/26",
      "holderName": "John Doe",
      "isDefault": true,
      "addedDate": "2025-01-15",
    },
    {
      "id": 2,
      "type": "debit_card",
      "provider": "Mastercard",
      "lastFour": "8901",
      "expiryDate": "08/27",
      "holderName": "John Doe",
      "isDefault": false,
      "addedDate": "2025-01-10",
    },
    {
      "id": 3,
      "type": "bank_account",
      "provider": "Bank",
      "lastFour": "7890",
      "expiryDate": "",
      "holderName": "Chase Bank",
      "isDefault": false,
      "addedDate": "2025-01-05",
    },
    {
      "id": 4,
      "type": "digital_wallet",
      "provider": "PayPal",
      "lastFour": "",
      "expiryDate": "",
      "holderName": "john.doe@email.com",
      "isDefault": false,
      "addedDate": "2024-12-20",
    },
    {
      "id": 5,
      "type": "digital_wallet",
      "provider": "Apple Pay",
      "lastFour": "1234",
      "expiryDate": "",
      "holderName": "John's iPhone",
      "isDefault": false,
      "addedDate": "2024-12-15",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _paymentMethods = List.from(_mockPaymentMethods);
      _isLoading = false;
    });
  }

  void _showAddPaymentMethodBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddPaymentMethodBottomSheet(
        onMethodSelected: (method) {
          Navigator.pop(context);
          _handleAddPaymentMethod(method);
        },
      ),
    );
  }

  void _handleAddPaymentMethod(String method) {
    String message = '';
    switch (method) {
      case 'card':
        message = 'Opening card scanner...';
        break;
      case 'bank':
        message = 'Connecting to bank...';
        break;
      case 'apple_pay':
        message = 'Setting up Apple Pay...';
        break;
      case 'google_pay':
        message = 'Setting up Google Pay...';
        break;
      case 'paypal':
        message = 'Connecting to PayPal...';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Simulate adding a new payment method
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        _addNewPaymentMethod(method);
      }
    });
  }

  void _addNewPaymentMethod(String method) {
    final newMethod = {
      "id": _paymentMethods.length + 1,
      "type": method == 'card' ? 'credit_card' : method,
      "provider": _getProviderName(method),
      "lastFour": "0000",
      "expiryDate": method == 'card' ? "12/28" : "",
      "holderName": "John Doe",
      "isDefault": false,
      "addedDate": DateTime.now().toString().substring(0, 10),
    };

    setState(() {
      _paymentMethods.insert(0, newMethod);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment method added successfully'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getProviderName(String method) {
    switch (method) {
      case 'card':
        return 'Visa';
      case 'bank':
        return 'Bank';
      case 'apple_pay':
        return 'Apple Pay';
      case 'google_pay':
        return 'Google Pay';
      case 'paypal':
        return 'PayPal';
      default:
        return 'Unknown';
    }
  }

  void _editPaymentMethod(Map<String, dynamic> method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${method['provider']} payment method'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _setAsDefault(Map<String, dynamic> method) {
    setState(() {
      // Remove default from all methods
      for (var pm in _paymentMethods) {
        pm['isDefault'] = false;
      }
      // Set selected method as default
      method['isDefault'] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${method['provider']} set as default payment method'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removePaymentMethod(Map<String, dynamic> method) {
    setState(() {
      _paymentMethods.removeWhere((pm) => pm['id'] == method['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${method['provider']} payment method removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _paymentMethods.add(method);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewPaymentMethodDetails(Map<String, dynamic> method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${method['provider']} Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Type',
                method['type'].toString().replaceAll('_', ' ').toUpperCase()),
            _buildDetailRow('Last Four', method['lastFour']),
            if (method['expiryDate'].isNotEmpty)
              _buildDetailRow('Expires', method['expiryDate']),
            _buildDetailRow('Holder', method['holderName']),
            _buildDetailRow('Added', method['addedDate']),
            _buildDetailRow(
                'Status', method['isDefault'] ? 'Default' : 'Active'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              '$label:',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _viewTransactionHistory(Map<String, dynamic> method) {
    Navigator.pushNamed(context, '/transaction-history');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Methods'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            size: 24,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadPaymentMethods,
            icon: CustomIconWidget(
              iconName: 'refresh',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? PaymentMethodSkeleton()
          : _paymentMethods.isEmpty
              ? EmptyPaymentMethodsWidget(
                  onAddPaymentMethod: _showAddPaymentMethodBottomSheet,
                )
              : RefreshIndicator(
                  onRefresh: _loadPaymentMethods,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Manage your payment methods',
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 2.h),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final method = _paymentMethods[index];
                            return PaymentMethodCard(
                              paymentMethod: method,
                              onTap: () => _viewPaymentMethodDetails(method),
                              onEdit: () => _editPaymentMethod(method),
                              onSetDefault: () => _setAsDefault(method),
                              onRemove: () => _removePaymentMethod(method),
                              onViewDetails: () =>
                                  _viewPaymentMethodDetails(method),
                              onTransactionHistory: () =>
                                  _viewTransactionHistory(method),
                            );
                          },
                          childCount: _paymentMethods.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SecurityBadgesWidget(),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 10.h),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: _paymentMethods.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _showAddPaymentMethodBottomSheet,
              icon: CustomIconWidget(
                iconName: 'add',
                size: 20,
                color: Colors.white,
              ),
              label: Text('Add Payment Method'),
            )
          : null,
    );
  }
}
