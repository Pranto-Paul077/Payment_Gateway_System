import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './settings_item_widget.dart';
import './settings_section_widget.dart';

class SecuritySectionWidget extends StatefulWidget {
  final Map<String, dynamic> securitySettings;
  final Function(Map<String, dynamic>) onSettingsChanged;

  const SecuritySectionWidget({
    Key? key,
    required this.securitySettings,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  State<SecuritySectionWidget> createState() => _SecuritySectionWidgetState();
}

class _SecuritySectionWidgetState extends State<SecuritySectionWidget> {
  void _showPasswordChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'lock',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'lock_outline',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'lock_outline',
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password changed successfully'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
            child: Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showActiveSessions() {
    final sessions = [
      {
        "device": "iPhone 14 Pro",
        "location": "New York, NY",
        "lastActive": "Active now",
        "isCurrent": true,
      },
      {
        "device": "MacBook Pro",
        "location": "New York, NY",
        "lastActive": "2 hours ago",
        "isCurrent": false,
      },
      {
        "device": "Chrome Browser",
        "location": "San Francisco, CA",
        "lastActive": "1 day ago",
        "isCurrent": false,
      },
    ];

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
                  'Active Sessions',
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
            Expanded(
              child: ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(3.w),
                      border: Border.all(
                        color: AppTheme.lightTheme.dividerColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: (session["isCurrent"] as bool)
                                ? AppTheme.successLight.withValues(alpha: 0.1)
                                : AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: (session["device"] as String)
                                      .contains('iPhone')
                                  ? 'phone_iphone'
                                  : (session["device"] as String)
                                          .contains('MacBook')
                                      ? 'laptop_mac'
                                      : 'computer',
                              color: (session["isCurrent"] as bool)
                                  ? AppTheme.successLight
                                  : AppTheme.lightTheme.colorScheme.primary,
                              size: 6.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    session["device"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (session["isCurrent"] as bool) ...[
                                    SizedBox(width: 2.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                        color: AppTheme.successLight,
                                        borderRadius:
                                            BorderRadius.circular(1.w),
                                      ),
                                      child: Text(
                                        'Current',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                session["location"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                              Text(
                                session["lastActive"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        if (!(session["isCurrent"] as bool))
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Session terminated'),
                                  backgroundColor: AppTheme.warningLight,
                                ),
                              );
                            },
                            child: Text('End Session'),
                          ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    return SettingsSectionWidget(
      title: 'Security',
      children: [
        SettingsItemWidget(
          iconName: 'lock',
          title: 'Change Password',
          subtitle: 'Update your account password',
          onTap: _showPasswordChangeDialog,
        ),
        SettingsItemWidget(
          iconName: 'fingerprint',
          title: 'Biometric Authentication',
          subtitle: widget.securitySettings["biometricEnabled"] as bool
              ? 'Enabled for secure access'
              : 'Enable fingerprint/face unlock',
          trailing: Switch(
            value: widget.securitySettings["biometricEnabled"] as bool,
            onChanged: (value) {
              final updatedSettings = {
                ...widget.securitySettings,
                "biometricEnabled": value,
              };
              widget.onSettingsChanged(updatedSettings);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? 'Biometric authentication enabled'
                      : 'Biometric authentication disabled'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
          ),
        ),
        SettingsItemWidget(
          iconName: 'security',
          title: 'Two-Factor Authentication',
          subtitle: widget.securitySettings["twoFactorEnabled"] as bool
              ? 'Enabled for extra security'
              : 'Add an extra layer of security',
          trailing: Switch(
            value: widget.securitySettings["twoFactorEnabled"] as bool,
            onChanged: (value) {
              final updatedSettings = {
                ...widget.securitySettings,
                "twoFactorEnabled": value,
              };
              widget.onSettingsChanged(updatedSettings);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? 'Two-factor authentication enabled'
                      : 'Two-factor authentication disabled'),
                  backgroundColor: AppTheme.successLight,
                ),
              );
            },
          ),
        ),
        SettingsItemWidget(
          iconName: 'devices',
          title: 'Active Sessions',
          subtitle: 'Manage your logged-in devices',
          onTap: _showActiveSessions,
          showDivider: false,
        ),
      ],
    );
  }
}
