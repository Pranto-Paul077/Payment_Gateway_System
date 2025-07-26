import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_balance_card.dart';
import './widgets/new_payment_button.dart';
import './widgets/quick_actions_grid.dart';
import './widgets/recent_transactions_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isBalanceVisible = true;
  bool _isRefreshing = false;
  DateTime _lastUpdated = DateTime.now();
  late TabController _tabController;

  // Mock user data
  final String _userName = "Sarah Johnson";
  final double _accountBalance = 12847.50;

  // Mock transaction data
  final List<Map<String, dynamic>> _recentTransactions = [
    {
      "id": "txn_001",
      "merchant": "Starbucks Coffee",
      "amount": 15.75,
      "type": "outgoing",
      "status": "completed",
      "category": "Food",
      "date": DateTime.now().subtract(const Duration(hours: 2)),
      "description": "Coffee and pastry",
      "paymentMethod": "Credit Card ****1234",
    },
    {
      "id": "txn_002",
      "merchant": "Amazon Purchase",
      "amount": 89.99,
      "type": "outgoing",
      "status": "pending",
      "category": "Shopping",
      "date": DateTime.now().subtract(const Duration(hours: 5)),
      "description": "Electronics accessories",
      "paymentMethod": "PayFlow Wallet",
    },
    {
      "id": "txn_003",
      "merchant": "Salary Deposit",
      "amount": 3500.00,
      "type": "incoming",
      "status": "completed",
      "category": "Transfer",
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "description": "Monthly salary",
      "paymentMethod": "Bank Transfer",
    },
    {
      "id": "txn_004",
      "merchant": "Uber Ride",
      "amount": 24.50,
      "type": "outgoing",
      "status": "completed",
      "category": "Transport",
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "description": "Trip to downtown",
      "paymentMethod": "PayFlow Wallet",
    },
    {
      "id": "txn_005",
      "merchant": "Netflix Subscription",
      "amount": 15.99,
      "type": "outgoing",
      "status": "failed",
      "category": "Entertainment",
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "description": "Monthly subscription",
      "paymentMethod": "Credit Card ****5678",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    _simulateAutoRefresh();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _simulateAutoRefresh() {
    // Simulate automatic balance refresh every 30 seconds
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        setState(() {
          _lastUpdated = DateTime.now();
        });
        _simulateAutoRefresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _currentIndex == 0
            ? _buildDashboardContent()
            : _buildPlaceholderContent(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton:
          _currentIndex == 0 ? _buildFloatingActionButton() : null,
    );
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 2.h),
            AccountBalanceCard(
              userName: _userName,
              balance: _accountBalance,
              isBalanceVisible: _isBalanceVisible,
              onToggleVisibility: () {
                setState(() {
                  _isBalanceVisible = !_isBalanceVisible;
                });
              },
            ),
            SizedBox(height: 3.h),
            QuickActionsGrid(
              onActionTap: _handleQuickAction,
            ),
            SizedBox(height: 3.h),
            RecentTransactionsList(
              transactions: _recentTransactions,
              onTransactionTap: _handleTransactionTap,
            ),
            SizedBox(height: 3.h),
            NewPaymentButton(
              onPressed: () {
                // Handle new payment
              },
            ),
            SizedBox(height: 2.h),
            _buildLastUpdatedInfo(),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PayFlow Gateway',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              Text(
                'Secure payments made simple',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: _showNotifications,
                child: Container(
                  padding: EdgeInsets.all(2.5.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Stack(
                    children: [
                      CustomIconWidget(
                        iconName: 'notifications',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.errorLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile-settings'),
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomImageWidget(
                      imageUrl:
                          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent() {
    String title;
    String subtitle;
    String iconName;

    switch (_currentIndex) {
      case 1:
        title = 'Payments';
        subtitle = 'Manage your payment methods';
        iconName = 'payment';
        break;
      case 2:
        title = 'Transaction History';
        subtitle = 'View all your transactions';
        iconName = 'history';
        break;
      case 3:
        title = 'Profile Settings';
        subtitle = 'Manage your account settings';
        iconName = 'person';
        break;
      default:
        title = 'Dashboard';
        subtitle = 'Welcome to PayFlow';
        iconName = 'dashboard';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 3.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _tabController.animateTo(index);
          });
          _handleBottomNavigation(index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        selectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'payment',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Handle quick payment
        _showQuickPaymentDialog();
      },
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      icon: CustomIconWidget(
        iconName: 'flash_on',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 24,
      ),
      label: Text(
        'Quick Pay',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLastUpdatedInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'sync',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            'Last updated: ${_formatLastUpdated(_lastUpdated)}',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _lastUpdated = DateTime.now();
    });
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'send_money':
        _showSendMoneyDialog();
        break;
      case 'request_payment':
        _showRequestPaymentDialog();
        break;
      case 'scan_qr':
        _showQRScanner();
        break;
      case 'pay_bills':
        _showBillPayment();
        break;
    }
  }

  void _handleTransactionTap(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Merchant: ${transaction['merchant']}'),
            Text(
                'Amount: \$${(transaction['amount'] as double).toStringAsFixed(2)}'),
            Text('Status: ${transaction['status']}'),
            Text('Category: ${transaction['category']}'),
            Text(
                'Date: ${_formatTransactionDate(transaction['date'] as DateTime)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavigation(int index) {
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/payment-method-management');
        break;
      case 2:
        Navigator.pushNamed(context, '/transaction-history');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile-settings');
        break;
    }
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('You have 3 new notifications'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showQuickPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Payment'),
        content: const Text('Quick payment feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSendMoneyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Money'),
        content: const Text('Send money feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showRequestPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Payment'),
        content: const Text('Request payment feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showQRScanner() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Scanner'),
        content: const Text('QR scanner feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBillPayment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bill Payment'),
        content: const Text('Bill payment feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatLastUpdated(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatTransactionDate(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
