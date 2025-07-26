import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/skeleton_card_widget.dart';
import './widgets/transaction_detail_modal_widget.dart';
import './widgets/transaction_filter_widget.dart';
import './widgets/transaction_search_widget.dart';
import './widgets/transaction_section_widget.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};
  bool _isLoading = false;
  bool _isLoadingMore = false;

  // Mock transaction data
  final List<Map<String, dynamic>> _allTransactions = [
    {
      "id": 1,
      "merchantName": "Starbucks Coffee",
      "amount": 12.50,
      "type": "sent",
      "status": "completed",
      "paymentMethod": "Credit Card",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "confirmationNumber": "SB123456789",
      "referenceNumber": "REF001234",
      "merchantInfo": {
        "businessName": "Starbucks Corporation",
        "category": "Food & Dining",
        "location": "123 Main St, New York, NY",
        "contact": "+1 (555) 123-4567"
      },
      "fees": {"processing": 0.30, "service": 0.00}
    },
    {
      "id": 2,
      "merchantName": "John Smith",
      "amount": 250.00,
      "type": "received",
      "status": "completed",
      "paymentMethod": "Bank Transfer",
      "timestamp": DateTime.now().subtract(Duration(hours: 5)),
      "confirmationNumber": "BT987654321",
      "referenceNumber": "REF005678",
      "merchantInfo": {
        "businessName": "Personal Transfer",
        "category": "Personal",
        "location": "N/A",
        "contact": "john.smith@email.com"
      },
      "fees": {"processing": 0.00, "service": 2.50}
    },
    {
      "id": 3,
      "merchantName": "Amazon",
      "amount": 89.99,
      "type": "sent",
      "status": "pending",
      "paymentMethod": "Digital Wallet",
      "timestamp": DateTime.now().subtract(Duration(hours: 8)),
      "confirmationNumber": "AMZ456789123",
      "referenceNumber": "REF009876",
      "merchantInfo": {
        "businessName": "Amazon.com Inc.",
        "category": "Shopping",
        "location": "Online",
        "contact": "support@amazon.com"
      },
      "fees": {"processing": 1.80, "service": 0.00}
    },
    {
      "id": 4,
      "merchantName": "Uber",
      "amount": 24.75,
      "type": "sent",
      "status": "completed",
      "paymentMethod": "Credit Card",
      "timestamp": DateTime.now().subtract(Duration(days: 1, hours: 3)),
      "confirmationNumber": "UB789123456",
      "referenceNumber": "REF012345",
      "merchantInfo": {
        "businessName": "Uber Technologies Inc.",
        "category": "Transportation",
        "location": "San Francisco, CA",
        "contact": "support@uber.com"
      },
      "fees": {"processing": 0.50, "service": 1.25}
    },
    {
      "id": 5,
      "merchantName": "Netflix",
      "amount": 15.99,
      "type": "sent",
      "status": "completed",
      "paymentMethod": "Debit Card",
      "timestamp": DateTime.now().subtract(Duration(days: 2)),
      "confirmationNumber": "NF321654987",
      "referenceNumber": "REF067890",
      "merchantInfo": {
        "businessName": "Netflix Inc.",
        "category": "Entertainment",
        "location": "Los Gatos, CA",
        "contact": "help@netflix.com"
      },
      "fees": {"processing": 0.32, "service": 0.00}
    },
    {
      "id": 6,
      "merchantName": "Electric Company",
      "amount": 125.50,
      "type": "sent",
      "status": "completed",
      "paymentMethod": "Bank Transfer",
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "confirmationNumber": "EC654987321",
      "referenceNumber": "REF098765",
      "merchantInfo": {
        "businessName": "City Electric Utility",
        "category": "Bills & Utilities",
        "location": "Downtown Office",
        "contact": "+1 (555) 987-6543"
      },
      "fees": {"processing": 0.00, "service": 3.00}
    },
    {
      "id": 7,
      "merchantName": "Sarah Johnson",
      "amount": 75.00,
      "type": "received",
      "status": "completed",
      "paymentMethod": "Digital Wallet",
      "timestamp": DateTime.now().subtract(Duration(days: 5)),
      "confirmationNumber": "SJ147258369",
      "referenceNumber": "REF054321",
      "merchantInfo": {
        "businessName": "Personal Transfer",
        "category": "Personal",
        "location": "N/A",
        "contact": "sarah.j@email.com"
      },
      "fees": {"processing": 1.50, "service": 0.00}
    },
    {
      "id": 8,
      "merchantName": "Target",
      "amount": 156.78,
      "type": "sent",
      "status": "failed",
      "paymentMethod": "Credit Card",
      "timestamp": DateTime.now().subtract(Duration(days: 7)),
      "confirmationNumber": "TG963852741",
      "referenceNumber": "REF076543",
      "merchantInfo": {
        "businessName": "Target Corporation",
        "category": "Shopping",
        "location": "Local Store #1234",
        "contact": "+1 (555) 234-5678"
      },
      "fees": {"processing": 3.14, "service": 0.00}
    },
    {
      "id": 9,
      "merchantName": "Dr. Wilson's Clinic",
      "amount": 200.00,
      "type": "sent",
      "status": "completed",
      "paymentMethod": "Credit Card",
      "timestamp": DateTime.now().subtract(Duration(days: 10)),
      "confirmationNumber": "DW852741963",
      "referenceNumber": "REF087654",
      "merchantInfo": {
        "businessName": "Wilson Medical Practice",
        "category": "Healthcare",
        "location": "Medical Center Plaza",
        "contact": "+1 (555) 345-6789"
      },
      "fees": {"processing": 4.00, "service": 0.00}
    },
    {
      "id": 10,
      "merchantName": "Mike Davis",
      "amount": 50.00,
      "type": "received",
      "status": "completed",
      "paymentMethod": "Cash",
      "timestamp": DateTime.now().subtract(Duration(days: 14)),
      "confirmationNumber": "MD741852963",
      "referenceNumber": "REF098765",
      "merchantInfo": {
        "businessName": "Personal Transfer",
        "category": "Personal",
        "location": "N/A",
        "contact": "mike.davis@email.com"
      },
      "fees": {"processing": 0.00, "service": 0.00}
    }
  ];

  List<Map<String, dynamic>> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filteredTransactions = List.from(_allTransactions);
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreTransactions();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadMoreTransactions() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more data
    await Future.delayed(Duration(milliseconds: 1000));

    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _refreshTransactions() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh
    await Future.delayed(Duration(milliseconds: 1000));

    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onFiltersApplied(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allTransactions);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((transaction) {
        final merchantName =
            (transaction['merchantName'] as String).toLowerCase();
        final amount = transaction['amount'].toString();
        final paymentMethod =
            (transaction['paymentMethod'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return merchantName.contains(query) ||
            amount.contains(query) ||
            paymentMethod.contains(query);
      }).toList();
    }

    // Apply date range filter
    if (_activeFilters['dateRange'] != null) {
      final DateTimeRange dateRange =
          _activeFilters['dateRange'] as DateTimeRange;
      filtered = filtered.where((transaction) {
        final DateTime transactionDate = transaction['timestamp'] as DateTime;
        return transactionDate
                .isAfter(dateRange.start.subtract(Duration(days: 1))) &&
            transactionDate.isBefore(dateRange.end.add(Duration(days: 1)));
      }).toList();
    }

    // Apply amount range filter
    if (_activeFilters['amountRange'] != null) {
      final RangeValues amountRange =
          _activeFilters['amountRange'] as RangeValues;
      filtered = filtered.where((transaction) {
        final double amount = (transaction['amount'] as num).toDouble();
        return amount >= amountRange.start && amount <= amountRange.end;
      }).toList();
    }

    // Apply transaction type filter
    if (_activeFilters['transactionType'] != null &&
        _activeFilters['transactionType'] != 'All') {
      final String type =
          (_activeFilters['transactionType'] as String).toLowerCase();
      filtered = filtered.where((transaction) {
        return (transaction['type'] as String).toLowerCase() == type;
      }).toList();
    }

    // Apply payment method filter
    if (_activeFilters['paymentMethods'] != null) {
      final List<String> methods =
          _activeFilters['paymentMethods'] as List<String>;
      if (methods.isNotEmpty) {
        filtered = filtered.where((transaction) {
          return methods.contains(transaction['paymentMethod'] as String);
        }).toList();
      }
    }

    setState(() {
      _filteredTransactions = filtered;
    });
  }

  void _clearFilters() {
    setState(() {
      _activeFilters.clear();
      _searchQuery = '';
      _applyFilters();
    });
  }

  Map<String, List<Map<String, dynamic>>> _groupTransactionsByDate() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    final now = DateTime.now();

    for (final transaction in _filteredTransactions) {
      final DateTime transactionDate = transaction['timestamp'] as DateTime;
      final difference = now.difference(transactionDate).inDays;

      String sectionKey;
      if (difference == 0) {
        sectionKey = 'Today';
      } else if (difference == 1) {
        sectionKey = 'Yesterday';
      } else if (difference < 7) {
        sectionKey = 'This Week';
      } else {
        sectionKey = 'Earlier';
      }

      grouped.putIfAbsent(sectionKey, () => []);
      grouped[sectionKey]!.add(transaction);
    }

    // Sort transactions within each group by timestamp (newest first)
    grouped.forEach((key, transactions) {
      transactions.sort((a, b) {
        final DateTime dateA = a['timestamp'] as DateTime;
        final DateTime dateB = b['timestamp'] as DateTime;
        return dateB.compareTo(dateA);
      });
    });

    return grouped;
  }

  void _showTransactionDetail(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionDetailModalWidget(
        transaction: transaction,
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionFilterWidget(
        onFiltersApplied: _onFiltersApplied,
        currentFilters: _activeFilters,
      ),
    );
  }

  void _handleSwipeAction(Map<String, dynamic> transaction, String action) {
    String message;
    switch (action) {
      case 'view_receipt':
        message = 'Viewing receipt for ${transaction['merchantName']}';
        break;
      case 'repeat_payment':
        message = 'Repeating payment to ${transaction['merchantName']}';
        break;
      case 'share_details':
        message = 'Sharing transaction details';
        break;
      case 'report_issue':
        message = 'Reporting issue with transaction';
        break;
      case 'add_to_favorites':
        message = 'Added ${transaction['merchantName']} to favorites';
        break;
      default:
        message = 'Action completed';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Transaction History'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Export functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Exporting transactions...'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'file_download',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(15.h),
          child: Column(
            children: [
              TransactionSearchWidget(
                onSearchChanged: _onSearchChanged,
                onFilterTap: _showFilterBottomSheet,
                hasActiveFilters: _activeFilters.isNotEmpty,
              ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'History'),
                  Tab(text: 'Pending'),
                  Tab(text: 'Failed'),
                  Tab(text: 'Scheduled'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryTab(),
          _buildPendingTab(),
          _buildFailedTab(),
          _buildScheduledTab(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_isLoading) {
      return _buildSkeletonList();
    }

    if (_filteredTransactions.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshTransactions,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: 70.h,
            child: EmptyStateWidget(
              title: _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                  ? 'No transactions found'
                  : 'No transactions yet',
              subtitle: _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                  ? 'Try adjusting your search or filters to find what you\'re looking for.'
                  : 'Your transaction history will appear here once you start making payments.',
              showClearFilters:
                  _searchQuery.isNotEmpty || _activeFilters.isNotEmpty,
              onClearFilters: _clearFilters,
              actionText: _searchQuery.isEmpty && _activeFilters.isEmpty
                  ? 'Make a Payment'
                  : null,
              onActionPressed: _searchQuery.isEmpty && _activeFilters.isEmpty
                  ? () => Navigator.pushNamed(context, '/dashboard-screen')
                  : null,
            ),
          ),
        ),
      );
    }

    final groupedTransactions = _groupTransactionsByDate();
    final sectionOrder = ['Today', 'Yesterday', 'This Week', 'Earlier'];

    return RefreshIndicator(
      onRefresh: _refreshTransactions,
      child: ListView.builder(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: sectionOrder.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < sectionOrder.length) {
            final sectionTitle = sectionOrder[index];
            final transactions = groupedTransactions[sectionTitle] ?? [];

            return TransactionSectionWidget(
              sectionTitle: sectionTitle,
              transactions: transactions,
              onTransactionTap: _showTransactionDetail,
              onSwipeAction: _handleSwipeAction,
            );
          } else {
            return Padding(
              padding: EdgeInsets.all(4.w),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPendingTab() {
    final pendingTransactions = _filteredTransactions
        .where((t) => (t['status'] as String).toLowerCase() == 'pending')
        .toList();

    if (pendingTransactions.isEmpty) {
      return EmptyStateWidget(
        title: 'No pending transactions',
        subtitle: 'All your transactions have been processed successfully.',
      );
    }

    return ListView.builder(
      itemCount: pendingTransactions.length,
      itemBuilder: (context, index) {
        return TransactionSectionWidget(
          sectionTitle: index == 0 ? 'Pending Transactions' : '',
          transactions: [pendingTransactions[index]],
          onTransactionTap: _showTransactionDetail,
          onSwipeAction: _handleSwipeAction,
        );
      },
    );
  }

  Widget _buildFailedTab() {
    final failedTransactions = _filteredTransactions
        .where((t) => (t['status'] as String).toLowerCase() == 'failed')
        .toList();

    if (failedTransactions.isEmpty) {
      return EmptyStateWidget(
        title: 'No failed transactions',
        subtitle: 'Great! All your transactions have been successful.',
      );
    }

    return ListView.builder(
      itemCount: failedTransactions.length,
      itemBuilder: (context, index) {
        return TransactionSectionWidget(
          sectionTitle: index == 0 ? 'Failed Transactions' : '',
          transactions: [failedTransactions[index]],
          onTransactionTap: _showTransactionDetail,
          onSwipeAction: _handleSwipeAction,
        );
      },
    );
  }

  Widget _buildScheduledTab() {
    return EmptyStateWidget(
      title: 'No scheduled payments',
      subtitle:
          'Set up recurring payments or schedule future transactions to see them here.',
      actionText: 'Schedule Payment',
      onActionPressed: () {
        Navigator.pushNamed(context, '/dashboard-screen');
      },
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return SkeletonCardWidget();
      },
    );
  }
}
