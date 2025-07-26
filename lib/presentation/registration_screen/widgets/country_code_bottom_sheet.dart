import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CountryCodeBottomSheet extends StatelessWidget {
  final Function(String, String) onCountrySelected;

  const CountryCodeBottomSheet({
    super.key,
    required this.onCountrySelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> countries = [
      {'name': 'United States', 'code': '+1', 'flag': '🇺🇸'},
      {'name': 'Canada', 'code': '+1', 'flag': '🇨🇦'},
      {'name': 'United Kingdom', 'code': '+44', 'flag': '🇬🇧'},
      {'name': 'Germany', 'code': '+49', 'flag': '🇩🇪'},
      {'name': 'France', 'code': '+33', 'flag': '🇫🇷'},
      {'name': 'Australia', 'code': '+61', 'flag': '🇦🇺'},
      {'name': 'Japan', 'code': '+81', 'flag': '🇯🇵'},
      {'name': 'India', 'code': '+91', 'flag': '🇮🇳'},
      {'name': 'China', 'code': '+86', 'flag': '🇨🇳'},
      {'name': 'Brazil', 'code': '+55', 'flag': '🇧🇷'},
    ];

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              children: [
                Text(
                  'Select Country',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
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
          ),

          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),

          // Country List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              itemCount: countries.length,
              itemBuilder: (context, index) {
                final country = countries[index];
                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
                  leading: Text(
                    country['flag']!,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  title: Text(
                    country['name']!,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    country['code']!,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onTap: () {
                    onCountrySelected(country['code']!, country['flag']!);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
