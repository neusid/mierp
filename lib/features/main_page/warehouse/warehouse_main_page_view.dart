import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/features/dashboard/presentation/warehouse/dashboard_warehouse_view.dart';
import 'package:mierp_apps/features/main_page/warehouse/warehouse_main_page_view_model.dart';
import 'package:mierp_apps/features/profile/presentation/profile_view.dart';

class WarehouseMainPageView extends GetView<WarehouseMainPageViewModel> {
  const WarehouseMainPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Obx(() {
        return IndexedStack(
          index: controller.currentIndex.value,
          children: [
            DashboardWarehouseView(),
            ProfileView(onBack: controller.goToDashboard),
          ],
        );
      }),
      bottomNavigationBar: BottomAppBar(
        height: 70.w,
        padding: EdgeInsetsGeometry.only(
            left: 16.w, right: 16.w, top: 12.w, bottom: 6.w),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.w),
                onTap: () {
                  controller.currentIndex.value = 0;
                },
                child: Container(
                  width: 90.w,
                  height: 40.w,
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 8.w),
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
                        "assets/icons/home-2.svg",
                        width: 20.02.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                            AppColors.electricBlue, BlendMode.srcIn),
                      ),
                      Text(
                        "Home",
                        style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            height: 16 / 12,
                            fontWeight: AppFontWeight.medium,
                            color: AppColors.electricBlue
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.w),
                onTap: () {
                  controller.currentIndex.value = 0;
                },
                child: Container(
                  width: 55.w,
                  height: 40.w,
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 8.w),
                  child: Row(
                    spacing: 6.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/search-normal.svg",
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(
                            AppColors.grayTitle, BlendMode.srcIn),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.w),
                onTap: () {
                  controller.currentIndex.value = 0;
                },
                child: Container(
                  width: 55.w,
                  height: 40.w,
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 8.w),
                  child: Row(
                    spacing: 6.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/graph.svg",
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(
                            AppColors.grayTitle, BlendMode.srcIn),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.w),
                onTap: () {
                  controller.currentIndex.value = 0;
                },
                child: Container(
                  width: 55.w,
                  height: 40.w,
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 8.w),
                  child: Row(
                    spacing: 6.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/clock.svg",
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(
                            AppColors.grayTitle, BlendMode.srcIn),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.w),
                onTap: () {
                  controller.currentIndex.value = 1;
                },
                child: Container(
                  width: 55.w,
                  height: 40.w,
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 8.w),
                  child: Row(
                    spacing: 6.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/user.svg",
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(
                            AppColors.grayTitle, BlendMode.srcIn),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



