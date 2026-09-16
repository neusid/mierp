import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/controller/move_page_controller.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';

class ButtonProfileWidget extends StatelessWidget {
  final icon, label;
  VoidCallback? onPress;

  ButtonProfileWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onPress,
  });

  final movePageC = Get.find<MovePageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335.w,
      height: 59.1.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE8E8E8),
            blurRadius: 12.w,
            offset: Offset(0, 1.w),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPress != null ? onPress : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 24.w,
              children: [
                SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: SvgPicture.asset(
                    "assets/icons/$icon.svg",
                    colorFilter: ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: AppFontWeight.medium,
                    color: AppColors.grayTitle,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 27.26.w,
              height: 25.5.w,
              child: SvgPicture.asset(
                "assets/icons/chevron-down.svg",
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 23.1.w, vertical: 18.95.h),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.w),
          ),
          elevation: 0,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}

class ButtonProfileConfirmWidget extends StatelessWidget {
  final icon, label;
  VoidCallback? onPress;

  ButtonProfileConfirmWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onPress,
  });

  final movePageC = Get.find<MovePageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335.w,
      height: 59.1.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE8E8E8),
            blurRadius: 12.w,
            offset: Offset(0, 1.w),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Center(
            child: Container(
              width: 345.w,
              height: 270.w,
              padding: EdgeInsetsGeometry.all(30.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset("assets/icons/warning.png", width: 50.w),
                  SizedBox(height: 10.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ARE YOU SURE?",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.gray,
                          fontWeight: AppFontWeight.medium,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Please confirm if you want to delete this item. This action cannot be undone.",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.grayThin,
                      fontWeight: AppFontWeight.regular,
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 116.w,
                        height: 35.h,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(5.w),
                            ),
                          ),
                          child: Text(
                            "Close",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: AppColors.grayTitle,
                              fontWeight: AppFontWeight.regular,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 116.w,
                        height: 35.h,
                        child: ElevatedButton(
                          onPressed: onPress != null
                              ? () {
                                  Get.back();
                                  onPress!();
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.vibrantOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(5.w),
                            ),
                          ),
                          child: Text(
                            "Confirm",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: AppFontWeight.regular,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 24.w,
              children: [
                SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: SvgPicture.asset(
                    "assets/icons/$icon.svg",
                    colorFilter: ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: AppFontWeight.medium,
                    color: AppColors.grayTitle,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 27.26.w,
              height: 25.5.w,
              child: SvgPicture.asset(
                "assets/icons/chevron-down.svg",
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 23.1.w, vertical: 18.95.h),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.w),
          ),
          elevation: 0,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}
