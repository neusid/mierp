import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';

class QuickAddCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const QuickAddCard({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 14.h),
      child: Container(
        width: 345.w,
        height: 49.h,
        padding: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 22.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowBox,
              spreadRadius: -3.w,
              offset: const Offset(0, 4),
              blurRadius: 21.w,
            ),
          ],
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: Center(
          child: SizedBox(
            width: 310.w,
            height: 33.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 36.w,
                    height: 33.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                      gradient: AppColors.premiumDarkGradient,
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
