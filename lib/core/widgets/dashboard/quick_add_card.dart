import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';

class QuickAddCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;
  final Gradient? gradient;
  final Color? iconColor;
  final Color? iconBgColor;
  final Color? iconBorderColor;

  const QuickAddCard({
    super.key,
    required this.title,
    required this.onTap,
    this.icon = Icons.add_rounded,
    this.gradient,
    this.iconColor,
    this.iconBgColor,
    this.iconBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2.w),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 14.w,
            offset: Offset(0, 4.h),
          ),
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
            blurRadius: 4.w,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.w),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 36.w,
                  height: 33.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    gradient: (iconBgColor == null && iconBorderColor == null)
                        ? (gradient ?? AppColors.premiumDarkGradient)
                        : null,
                    color: iconBgColor,
                    border: iconBorderColor != null
                        ? Border.all(color: iconBorderColor!, width: 1.w)
                        : null,
                    boxShadow: (iconBgColor == null && iconBorderColor == null)
                        ? [
                            BoxShadow(
                              color: const Color(0xFF2E1052).withValues(alpha: 0.28),
                              blurRadius: 8.w,
                              offset: Offset(0, 3.h),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: iconColor ?? Colors.white,
                      size: 18.w,
                    ),
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
