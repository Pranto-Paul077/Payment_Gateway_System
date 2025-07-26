import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PaymentMethodSkeleton extends StatefulWidget {
  const PaymentMethodSkeleton({Key? key}) : super(key: key);

  @override
  State<PaymentMethodSkeleton> createState() => _PaymentMethodSkeletonState();
}

class _PaymentMethodSkeletonState extends State<PaymentMethodSkeleton>
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
        return ListView.builder(
          itemCount: 3,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: _animation.value * 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 2.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: _animation.value * 0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Container(
                              height: 1.5.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: _animation.value * 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 6.w,
                        height: 3.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: _animation.value * 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
