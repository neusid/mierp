
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/features/notification/presentation/notification_view_model.dart';

class NotificationView extends GetView<NotificationViewModel> {
  NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 112.h,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 14.2.w,
                  spreadRadius: 0,
                  color: AppColors.appBarShadow,
                )
              ],
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 63.h,
                ),
                Container(
                  padding: EdgeInsets.only(left: 30.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.close,
                          size: 24.w,
                        ),
                      ),
                      SizedBox(
                        width: 19.w,
                      ),
                      Text(
                        "Back to Dashboard",
                        style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: AppFontWeight.medium
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60.w,),
                Lottie.asset(
                  "assets/lottie/empty_ghost.json",
                  width: 292.w,),
                Container(
                  width: 250.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 10.w,
                    children: [
                      Text(
                        "Oops! Notifications Not Ready",
                        style: GoogleFonts.inter(
                          fontSize: 16.w,
                          fontWeight: AppFontWeight.medium,
                          color: AppColors.grayTitle,
                        ),
                      ),
                      Text(
                        "This feature isn’t available in the current version.",
                        style: GoogleFonts.inter(
                          fontSize: 14.w,
                          fontWeight: AppFontWeight.regular,
                          color: AppColors.grayThin,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
