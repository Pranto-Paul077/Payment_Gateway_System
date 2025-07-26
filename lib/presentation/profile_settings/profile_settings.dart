import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/about_section_widget.dart';
import './widgets/payment_preferences_section_widget.dart';
import './widgets/personal_info_section_widget.dart';
import './widgets/privacy_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/security_section_widget.dart';
import './widgets/support_section_widget.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _hasUnsavedChanges = false;

  // Mock user data
  Map<String, dynamic> userData = {
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "phone": "+1 (555) 123-4567",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
    "isVerified": true,
  };

  // Mock security settings
  Map<String, dynamic> securitySettings = {
    "biometricEnabled": true,
    "twoFactorEnabled": false,
  };

  // Mock payment settings
  Map<String, dynamic> paymentSettings = {
    "defaultPaymentMethod": "Visa •••• 4532",
    "currency": "USD",
    "dailyLimit": 1000.0,
    "monthlyLimit": 10000.0,
    "notificationsEnabled": true,
  };

  // Mock privacy settings
  Map<String, dynamic> privacySettings = {
    "dataSharingEnabled": false,
    "marketingEnabled": true,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Unsaved Changes'),
          content:
              Text('You have unsaved changes. Are you sure you want to leave?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Stay'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Leave'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }

  void _onUserDataChanged(Map<String, dynamic> newData) {
    setState(() {
      userData = newData;
      _hasUnsavedChanges = true;
    });
  }

  void _onSecuritySettingsChanged(Map<String, dynamic> newSettings) {
    setState(() {
      securitySettings = newSettings;
      _hasUnsavedChanges = true;
    });
  }

  void _onPaymentSettingsChanged(Map<String, dynamic> newSettings) {
    setState(() {
      paymentSettings = newSettings;
      _hasUnsavedChanges = true;
    });
  }

  void _onPrivacySettingsChanged(Map<String, dynamic> newSettings) {
    setState(() {
      privacySettings = newSettings;
      _hasUnsavedChanges = true;
    });
  }

  void _onEditProfilePressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile photo editor opened'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Profile Settings'),
          leading: IconButton(
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          actions: [
            if (_hasUnsavedChanges)
              Container(
                margin: EdgeInsets.only(right: 4.w),
                child: Center(
                  child: Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: AppTheme.warningLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text('Profile'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'security',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text('Security'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'payment',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text('Payment'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'privacy_tip',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text('Privacy'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'support',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text('Support'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text('About'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Profile Tab
            SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  ProfileHeaderWidget(
                    userData: userData,
                    onEditPressed: _onEditProfilePressed,
                  ),
                  SizedBox(height: 3.h),
                  PersonalInfoSectionWidget(
                    userData: userData,
                    onSave: _onUserDataChanged,
                  ),
                ],
              ),
            ),
            // Security Tab
            SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  SecuritySectionWidget(
                    securitySettings: securitySettings,
                    onSettingsChanged: _onSecuritySettingsChanged,
                  ),
                ],
              ),
            ),
            // Payment Tab
            SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  PaymentPreferencesSectionWidget(
                    paymentSettings: paymentSettings,
                    onSettingsChanged: _onPaymentSettingsChanged,
                  ),
                ],
              ),
            ),
            // Privacy Tab
            SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  PrivacySectionWidget(
                    privacySettings: privacySettings,
                    onSettingsChanged: _onPrivacySettingsChanged,
                  ),
                ],
              ),
            ),
            // Support Tab
            SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  SupportSectionWidget(),
                ],
              ),
            ),
            // About Tab
            SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  AboutSectionWidget(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.shadowColor,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/dashboard-screen'),
                  icon: CustomIconWidget(
                    iconName: 'dashboard',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  label: Text('Dashboard'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(
                      context, '/payment-method-management'),
                  icon: CustomIconWidget(
                    iconName: 'credit_card',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 4.w,
                  ),
                  label: Text('Payment Methods'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
