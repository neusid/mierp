import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';

class ComingSoonView extends StatelessWidget {
  final String title;
  final VoidCallback onHomePressed;

  const ComingSoonView({
    super.key,
    required this.title,
    required this.onHomePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgColor,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Vector Line-art Illustration
          Container(
            width: 280.w,
            height: 280.w,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              "assets/images/coming_soon_lineart.svg",
              width: 240.w,
              height: 240.w,
            ),
          ),
          SizedBox(height: 32.h),
          
          // Title
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: AppFontWeight.bold,
              color: AppColors.grayTitle,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          
          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              "Fitur ini masih dalam tahap pengembangan. Kami sedang menyiapkan sesuatu yang hebat untuk Anda!",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: AppFontWeight.medium,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40.h),
          
          // Home Button
          GestureDetector(
            onTap: onHomePressed,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
              decoration: BoxDecoration(
                gradient: AppColors.premiumDarkGradient,
                borderRadius: BorderRadius.circular(100.w),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E1052).withValues(alpha: 0.3),
                    blurRadius: 12.w,
                    offset: Offset(0, 6.h),
                  ),
                ],
              ),
              child: Text(
                "Kembali ke Beranda",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: AppFontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
