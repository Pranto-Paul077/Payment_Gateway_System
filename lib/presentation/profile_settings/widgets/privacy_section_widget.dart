import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './settings_item_widget.dart';
import './settings_section_widget.dart';

class PrivacySectionWidget extends StatefulWidget {
  final Map<String, dynamic> privacySettings;
  final Function(Map<String, dynamic>) onSettingsChanged;

  const PrivacySectionWidget({
    Key? key,
    required this.privacySettings,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  State<PrivacySectionWidget> createState() => _PrivacySectionWidgetState();
}

class _PrivacySectionWidgetState extends State<PrivacySectionWidget> {
  void _showAccountDeletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.errorLight,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text('Delete Account'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. Deleting your account will:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            _buildDeletionPoint('Remove all your personal data'),
            _buildDeletionPoint('Cancel all pending transactions'),
            _buildDeletionPoint('Revoke access to all connected services'),
            _buildDeletionPoint('Delete your transaction history'),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: AppTheme.warningLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.warningLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'You can export your data before deletion',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.warningLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showDataExportDialog();
            },
            child: Text('Export Data First'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalConfirmationDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _showDataExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Your Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose what data you want to export:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            CheckboxListTile(
              title: Text('Transaction History'),
              value: true,
              onChanged: (value) {},
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: Text('Payment Methods'),
              value: true,
              onChanged: (value) {},
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: Text('Profile Information'),
              value: true,
              onChanged: (value) {},
              controlAffinity: ListTileControlAffinity.leading,
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Data export started. You will receive an email when ready.'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
            child: Text('Export Data'),
          ),
        ],
      ),
    );
  }

  void _showFinalConfirmationDialog() {
    final confirmationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Final Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Type "DELETE" to confirm account deletion:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: confirmationController,
              decoration: InputDecoration(
                hintText: 'Type DELETE here',
                border: OutlineInputBorder(),
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
              if (confirmationController.text == 'DELETE') {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Account deletion initiated. This may take up to 30 days.'),
                    backgroundColor: AppTheme.errorLight,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please type "DELETE" to confirm'),
                    backgroundColor: AppTheme.warningLight,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeletionPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'circle',
            color: AppTheme.errorLight,
            size: 2.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionWidget(
      title: 'Privacy',
      children: [
        SettingsItemWidget(
          iconName: 'share',
          title: 'Data Sharing',
          subtitle: widget.privacySettings["dataSharingEnabled"] as bool
              ? 'Enabled for service improvement'
              : 'Disabled',
          trailing: Switch(
            value: widget.privacySettings["dataSharingEnabled"] as bool,
            onChanged: (value) {
              final updatedSettings = {
                ...widget.privacySettings,
                "dataSharingEnabled": value,
              };
              widget.onSettingsChanged(updatedSettings);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      value ? 'Data sharing enabled' : 'Data sharing disabled'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
          ),
        ),
        SettingsItemWidget(
          iconName: 'email',
          title: 'Marketing Communications',
          subtitle: widget.privacySettings["marketingEnabled"] as bool
              ? 'Receiving promotional emails'
              : 'No promotional emails',
          trailing: Switch(
            value: widget.privacySettings["marketingEnabled"] as bool,
            onChanged: (value) {
              final updatedSettings = {
                ...widget.privacySettings,
                "marketingEnabled": value,
              };
              widget.onSettingsChanged(updatedSettings);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? 'Marketing communications enabled'
                      : 'Marketing communications disabled'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
          ),
        ),
        SettingsItemWidget(
          iconName: 'delete_forever',
          title: 'Delete Account',
          subtitle: 'Permanently delete your account and data',
          onTap: _showAccountDeletionDialog,
          showDivider: false,
        ),
      ],
    );
  }
}
