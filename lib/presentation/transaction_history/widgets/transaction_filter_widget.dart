import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionFilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersApplied;
  final Map<String, dynamic> currentFilters;

  const TransactionFilterWidget({
    Key? key,
    required this.onFiltersApplied,
    required this.currentFilters,
  }) : super(key: key);

  @override
  State<TransactionFilterWidget> createState() =>
      _TransactionFilterWidgetState();
}

class _TransactionFilterWidgetState extends State<TransactionFilterWidget> {
  late Map<String, dynamic> _filters;
  DateTimeRange? _selectedDateRange;
  RangeValues _amountRange = const RangeValues(0, 10000);

  final List<String> _transactionTypes = ['All', 'Sent', 'Received', 'Pending'];
  final List<String> _paymentMethods = [
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'Digital Wallet',
    'Cash'
  ];
  final List<String> _categories = [
    'Food & Dining',
    'Shopping',
    'Transportation',
    'Bills & Utilities',
    'Entertainment',
    'Healthcare',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _selectedDateRange = _filters['dateRange'] as DateTimeRange?;
    _amountRange =
        _filters['amountRange'] as RangeValues? ?? const RangeValues(0, 10000);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateRangeSection(),
                  SizedBox(height: 3.h),
                  _buildAmountRangeSection(),
                  SizedBox(height: 3.h),
                  _buildTransactionTypeSection(),
                  SizedBox(height: 3.h),
                  _buildPaymentMethodSection(),
                  SizedBox(height: 3.h),
                  _buildCategorySection(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
            'Filter Transactions',
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

  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: _selectDateRange,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border:
                  Border.all(color: AppTheme.lightTheme.colorScheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDateRange != null
                      ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                      : 'Select date range',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: _selectedDateRange != null
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount Range',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_amountRange.start.toInt()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            Text(
              '\$${_amountRange.end.toInt()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
        RangeSlider(
          values: _amountRange,
          min: 0,
          max: 10000,
          divisions: 100,
          onChanged: (RangeValues values) {
            setState(() {
              _amountRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTransactionTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Type',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _transactionTypes.map((type) {
            final isSelected = _filters['transactionType'] == type;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _filters['transactionType'] = isSelected ? null : type;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  type,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Methods',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Column(
          children: _paymentMethods.map((method) {
            final selectedMethods =
                (_filters['paymentMethods'] as List<String>?) ?? [];
            final isSelected = selectedMethods.contains(method);

            return CheckboxListTile(
              title: Text(
                method,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  final methods = List<String>.from(selectedMethods);
                  if (value == true) {
                    methods.add(method);
                  } else {
                    methods.remove(method);
                  }
                  _filters['paymentMethods'] = methods;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _categories.map((category) {
            final selectedCategories =
                (_filters['categories'] as List<String>?) ?? [];
            final isSelected = selectedCategories.contains(category);

            return GestureDetector(
              onTap: () {
                setState(() {
                  final categories = List<String>.from(selectedCategories);
                  if (isSelected) {
                    categories.remove(category);
                  } else {
                    categories.add(category);
                  }
                  _filters['categories'] = categories;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  category,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
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
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _clearFilters,
              child: Text('Clear All'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _clearFilters() {
    setState(() {
      _filters.clear();
      _selectedDateRange = null;
      _amountRange = const RangeValues(0, 10000);
    });
  }

  void _applyFilters() {
    _filters['dateRange'] = _selectedDateRange;
    _filters['amountRange'] = _amountRange;
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
