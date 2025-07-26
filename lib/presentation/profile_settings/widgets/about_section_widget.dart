import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './settings_item_widget.dart';
import './settings_section_widget.dart';

class AboutSectionWidget extends StatelessWidget {
  const AboutSectionWidget({Key? key}) : super(key: key);

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'account_balance_wallet',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Text('PayFlow Gateway'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Version', '2.1.4'),
            _buildInfoRow('Build', '2024.07.26'),
            _buildInfoRow('Platform', 'Flutter 3.16.0'),
            _buildInfoRow('Last Updated', 'July 26, 2024'),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security Features',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  _buildSecurityFeature('256-bit SSL Encryption'),
                  _buildSecurityFeature('PCI DSS Compliant'),
                  _buildSecurityFeature('Biometric Authentication'),
                  _buildSecurityFeature('Real-time Fraud Detection'),
                ],
              ),
            ),
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

  void _showLegalDocument(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 80.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
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
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Last updated: July 26, 2024',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityFeature(String feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.successLight,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Text(
            feature,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const termsContent = '''
TERMS OF SERVICE

Last updated: July 26, 2024

1. ACCEPTANCE OF TERMS
By accessing and using PayFlow Gateway, you accept and agree to be bound by the terms and provision of this agreement.

2. DESCRIPTION OF SERVICE
PayFlow Gateway is a mobile payment processing application that enables users to make secure financial transactions, manage payment methods, and process payments through various channels.

3. USER ACCOUNTS
You are responsible for maintaining the confidentiality of your account and password and for restricting access to your device.

4. PAYMENT PROCESSING
All payments are processed through secure, encrypted channels. We do not store your complete payment information on our servers.

5. FEES AND CHARGES
Standard transaction fees may apply. All fees will be clearly disclosed before you complete any transaction.

6. SECURITY
We implement industry-standard security measures to protect your financial information and transactions.

7. LIMITATION OF LIABILITY
PayFlow Gateway shall not be liable for any indirect, incidental, special, consequential, or punitive damages.

8. MODIFICATIONS
We reserve the right to modify these terms at any time. Continued use of the service constitutes acceptance of modified terms.

For complete terms, please visit our website or contact support.
''';

    const privacyContent = '''
PRIVACY POLICY

Last updated: July 26, 2024

1. INFORMATION WE COLLECT
We collect information you provide directly to us, such as when you create an account, make a payment, or contact us for support.

2. HOW WE USE YOUR INFORMATION
- Process payments and transactions
- Provide customer support
- Improve our services
- Comply with legal obligations

3. INFORMATION SHARING
We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy.

4. DATA SECURITY
We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.

5. DATA RETENTION
We retain your information for as long as necessary to provide our services and comply with legal obligations.

6. YOUR RIGHTS
You have the right to access, update, or delete your personal information. You may also opt out of certain communications.

7. COOKIES AND TRACKING
We use cookies and similar technologies to enhance your experience and analyze usage patterns.

8. INTERNATIONAL TRANSFERS
Your information may be transferred to and processed in countries other than your own.

9. CHILDREN'S PRIVACY
Our service is not intended for children under 13 years of age.

10. CONTACT US
If you have questions about this privacy policy, please contact our privacy team.

For complete privacy policy, please visit our website.
''';

    return SettingsSectionWidget(
      title: 'About',
      children: [
        SettingsItemWidget(
          iconName: 'info',
          title: 'App Version',
          subtitle: 'Version 2.1.4 (Build 2024.07.26)',
          onTap: () => _showAppInfo(context),
        ),
        SettingsItemWidget(
          iconName: 'description',
          title: 'Terms of Service',
          subtitle: 'Read our terms and conditions',
          onTap: () =>
              _showLegalDocument(context, 'Terms of Service', termsContent),
        ),
        SettingsItemWidget(
          iconName: 'privacy_tip',
          title: 'Privacy Policy',
          subtitle: 'How we protect your data',
          onTap: () =>
              _showLegalDocument(context, 'Privacy Policy', privacyContent),
        ),
        SettingsItemWidget(
          iconName: 'gavel',
          title: 'Legal Information',
          subtitle: 'Licenses and legal notices',
          onTap: () => _showLegalDocument(
            context,
            'Legal Information',
            'PayFlow Gateway is licensed under standard commercial terms. All rights reserved. This application uses various open-source libraries and components. For detailed license information, please contact our legal team.',
          ),
          showDivider: false,
        ),
      ],
    );
  }
}
