import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/features/loading/loading_view_model.dart';

class LoadingView extends GetView<LoadingViewModel> {
  LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return AnimatedOpacity(
          opacity: controller.isVisible.value?1:0,
          duration: Duration(milliseconds: 500),
          child: AnimatedSlide(
            offset: controller.isVisible.value?
            Offset.zero: Offset(0, 0.5),
            curve: Curves.easeOut,
            duration: Duration(milliseconds: 500),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20.w,
                children: [
                  LottieBuilder.asset(
                    "assets/lottie/businessman_flies_up_with_rocket.json",
                    width: 292.w,),
                  Container(
                    width: 200.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10.w,
                      children: [
                        Text(
                          "Processing…",
                          style: GoogleFonts.inter(
                            fontSize: 16.w,
                            fontWeight: AppFontWeight.medium,
                            color: AppColors.grayTitle,
                          ),
                        ),
                        Text(
                          "We are processing your data. Please wait a moment.",
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
          ),
        );
      }),
    );
  }
}
