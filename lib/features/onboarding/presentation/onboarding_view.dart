import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/features/splash/presentation/splash_view_model.dart';

class OnboardingView extends StatelessWidget {
  OnboardingView({super.key});

  final splashC = Get.find<SplashViewModel>();

  @override
  Widget build(BuildContext context) {

    splashC.checkLogin();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Colors.black26,
          child: Center(
            child: LoadingAnimationWidget.stretchedDots(
              color: AppColors.softWhite, size: 70.w,
            ),
          ),
        ),
      ),
    );
  }
}
