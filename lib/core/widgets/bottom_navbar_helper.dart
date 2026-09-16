import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/controller/move_page_controller.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';

Widget MainBottomAppBarHelper({required String icon, required String label}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(20.w),
      onTap: () {
        Get.back();
      },
      child: Container(
        width: 90.w,
        height: 40.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
        decoration: BoxDecoration(
            color: AppColors.purpleShadow,
            borderRadius: BorderRadius.circular(100.w)
        ),
        child: Row(
          spacing: 6.w,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 20.02.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(AppColors.electricBlue, BlendMode.srcIn),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  height: 16/12,
                  fontWeight: AppFontWeight.medium,
                  color: AppColors.electricBlue
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget BottomAppBarHelper({required String icon, required String page}) {
  final movePageC = Get.find<MovePageController>();
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(20.w),
      onTap: (){
        movePageC.movePageWithBack(page);
      },
      child: Container(
        width: 55.w,
        height: 40.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
        child: Row(
          spacing: 6.w,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(AppColors.grayTitle, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    ),
  );
}

