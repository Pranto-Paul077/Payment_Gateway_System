import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './settings_item_widget.dart';
import './settings_section_widget.dart';

class SupportSectionWidget extends StatelessWidget {
  const SupportSectionWidget({Key? key}) : super(key: key);

  void _showHelpCenter(BuildContext context) {
    final helpTopics = [
      {
        "title": "Getting Started",
        "description": "Learn the basics of using PayFlow Gateway",
        "icon": "play_circle_outline",
      },
      {
        "title": "Payment Methods",
        "description": "How to add and manage payment methods",
        "icon": "payment",
      },
      {
        "title": "Transaction Issues",
        "description": "Troubleshoot failed or pending transactions",
        "icon": "error_outline",
      },
      {
        "title": "Security & Privacy",
        "description": "Keep your account safe and secure",
        "icon": "security",
      },
      {
        "title": "Account Management",
        "description": "Manage your profile and settings",
        "icon": "account_circle",
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 70.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Help Center',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search help articles...',
                        border: InputBorder.none,
                        hintStyle:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Expanded(
              child: ListView.builder(
                itemCount: helpTopics.length,
                itemBuilder: (context, index) {
                  final topic = helpTopics[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: ListTile(
                      leading: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: topic["icon"] as String,
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 6.w,
                          ),
                        ),
                      ),
                      title: Text(
                        topic["title"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        topic["description"] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      trailing: CustomIconWidget(
                        iconName: 'chevron_right',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Opening ${topic["title"]} help articles'),
                            backgroundColor: AppTheme.successLight,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 60.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contact Support',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildContactOption(
              context,
              'Live Chat',
              'Get instant help from our support team',
              'chat',
              'Available 24/7',
              AppTheme.successLight,
            ),
            SizedBox(height: 2.h),
            _buildContactOption(
              context,
              'Email Support',
              'Send us a detailed message',
              'email',
              'Response within 24 hours',
              AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 2.h),
            _buildContactOption(
              context,
              'Phone Support',
              'Speak directly with our team',
              'phone',
              'Mon-Fri 9AM-6PM EST',
              AppTheme.warningLight,
            ),
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emergency Support',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.errorLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'For urgent security issues or unauthorized transactions, call our emergency hotline immediately.',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Calling emergency support...'),
                          backgroundColor: AppTheme.errorLight,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorLight,
                    ),
                    icon: CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 4.w,
                    ),
                    label: Text('Call Emergency Support'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackForm(BuildContext context) {
    final feedbackController = TextEditingController();
    String selectedCategory = 'General';
    int rating = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: 70.h,
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Send Feedback',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Text(
                'Category',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                ),
                items: [
                  'General',
                  'Bug Report',
                  'Feature Request',
                  'Complaint',
                  'Compliment'
                ]
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedCategory = value!);
                },
              ),
              SizedBox(height: 2.h),
              Text(
                'Rating',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => rating = index + 1),
                    child: Padding(
                      padding: EdgeInsets.only(right: 1.w),
                      child: CustomIconWidget(
                        iconName: index < rating ? 'star' : 'star_border',
                        color: AppTheme.warningLight,
                        size: 8.w,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 2.h),
              Text(
                'Your Feedback',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 1.h),
              Expanded(
                child: TextField(
                  controller: feedbackController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Tell us about your experience...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Thank you for your feedback!'),
                        backgroundColor: AppTheme.successLight,
                      ),
                    );
                  },
                  child: Text('Send Feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context,
    String title,
    String description,
    String iconName,
    String availability,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening $title...'),
            backgroundColor: AppTheme.successLight,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    description,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  Text(
                    availability,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: color,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionWidget(
      title: 'Support',
      children: [
        SettingsItemWidget(
          iconName: 'help_center',
          title: 'Help Center',
          subtitle: 'Browse articles and tutorials',
          onTap: () => _showHelpCenter(context),
        ),
        SettingsItemWidget(
          iconName: 'support_agent',
          title: 'Contact Support',
          subtitle: 'Get help from our team',
          onTap: () => _showContactSupport(context),
        ),
        SettingsItemWidget(
          iconName: 'feedback',
          title: 'Send Feedback',
          subtitle: 'Help us improve the app',
          onTap: () => _showFeedbackForm(context),
          showDivider: false,
        ),
      ],
    );
  }
}
