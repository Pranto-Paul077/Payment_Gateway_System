import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SkeletonCardWidget extends StatefulWidget {
  const SkeletonCardWidget({Key? key}) : super(key: key);

  @override
  State<SkeletonCardWidget> createState() => _SkeletonCardWidgetState();
}

class _SkeletonCardWidgetState extends State<SkeletonCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildSkeletonBox(12.w, 12.w, isCircular: true),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSkeletonBox(40.w, 2.h),
                    SizedBox(height: 1.h),
                    _buildSkeletonBox(25.w, 1.5.h),
                    SizedBox(height: 0.5.h),
                    _buildSkeletonBox(20.w, 1.5.h),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildSkeletonBox(20.w, 2.h),
                  SizedBox(height: 1.h),
                  _buildSkeletonBox(15.w, 1.5.h),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkeletonBox(double width, double height,
      {bool isCircular = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant.withValues(
          alpha: _animation.value * 0.3,
        ),
        borderRadius: isCircular
            ? BorderRadius.circular(width / 2)
            : BorderRadius.circular(8),
      ),
    );
  }
}
