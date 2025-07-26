import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './settings_section_widget.dart';

class PersonalInfoSectionWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) onSave;

  const PersonalInfoSectionWidget({
    Key? key,
    required this.userData,
    required this.onSave,
  }) : super(key: key);

  @override
  State<PersonalInfoSectionWidget> createState() =>
      _PersonalInfoSectionWidgetState();
}

class _PersonalInfoSectionWidgetState extends State<PersonalInfoSectionWidget> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.userData["name"] as String);
    _emailController =
        TextEditingController(text: widget.userData["email"] as String);
    _phoneController =
        TextEditingController(text: widget.userData["phone"] as String);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    await Future.delayed(Duration(seconds: 1)); // Simulate API call

    final updatedData = {
      ...widget.userData,
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
    };

    widget.onSave(updatedData);

    setState(() {
      _isLoading = false;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _cancelEditing() {
    setState(() {
      _nameController.text = widget.userData["name"] as String;
      _emailController.text = widget.userData["email"] as String;
      _phoneController.text = widget.userData["phone"] as String;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionWidget(
      title: 'Personal Information',
      children: [
        Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                iconName: 'person',
                enabled: _isEditing,
              ),
              SizedBox(height: 2.h),
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                iconName: 'email',
                enabled: _isEditing,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 2.h),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                iconName: 'phone',
                enabled: _isEditing,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  if (_isEditing) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _cancelEditing,
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveChanges,
                        child: _isLoading
                            ? SizedBox(
                                width: 4.w,
                                height: 4.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : Text('Save'),
                      ),
                    ),
                  ] else
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() => _isEditing = true),
                        icon: CustomIconWidget(
                          iconName: 'edit',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 4.w,
                        ),
                        label: Text('Edit Information'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String iconName,
    required bool enabled,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: iconName,
            color: enabled
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
        ),
        filled: true,
        fillColor: enabled
            ? AppTheme.lightTheme.colorScheme.surface
            : AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (label == 'Email Address' && !value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }
}
