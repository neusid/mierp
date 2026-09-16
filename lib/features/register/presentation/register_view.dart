import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/auth/input_select_auth_widget.dart';
import 'package:mierp_apps/core/widgets/auth/input_auth_widget.dart';
import 'package:mierp_apps/core/widgets/auth/input_short_auth_widget.dart';
import 'package:mierp_apps/data/login/login_repository.dart';
import 'package:mierp_apps/features/login/presentation/login_view_model.dart';
import 'package:mierp_apps/features/register/presentation/register_view_model.dart';
import '../../../core/theme/app_colors.dart';


class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final loginR = Get.find<LoginRepository>();
  final loadingC = Get.find<LoadingController>();

  final registerViewModel = Get.find<RegisterViewModel>();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.electricBlue,
          body: Column(
            mainAxisAlignment: .end,
            children: [
              Stack(
                children: [
                  Container(
                    width: 1.sw,
                    height: 768.h,
                    child: Column(
                      mainAxisAlignment: .end,
                      children: [
                        Container(
                          width: 350.w,
                          height: 768.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),),
                            color: AppColors.shadowElectricBlue.withValues(
                                alpha: 0.29),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    height: 768.h,
                    child: Column(
                      mainAxisAlignment: .end,
                      children: [
                        Container(
                          width: 1.sw,
                          height: 751.95.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),),
                            color: Colors.white,
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: .center,
                              children: [
                                SizedBox(height: 44.h,),
                                Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Image.asset(
                                      "assets/images/mierp.png", width: 120.w,
                                      height: 34.h,),
                                  ],
                                ),
                                SizedBox(height: 24.h,),
                                Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Text(
                                      "Create your account",
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: AppFontWeight.medium,
                                        color: AppColors.gray,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h,),
                                Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Text(
                                      "Welcome! Please enter your details.",
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: AppFontWeight.regular,
                                        color: AppColors.grayThin,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 32.h,),
                                InputAuthWidget(head: "Email",
                                  controller: registerViewModel.emailC,
                                  placeholder: "",
                                  necessary: true,
                                  isPassword: false,
                                  formKey: formKey,
                                ),
                                InputAuthWidget(
                                  head: "Password",
                                  controller: registerViewModel.passwordC,
                                  placeholder: "",
                                  necessary: true,
                                  isPassword: true,
                                  formKey: formKey,
                                ),
                                Center(
                                  child: Container(
                                    width: 322.w,
                                    child: Row(
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
                                        InputShortAuthWidget(
                                          head: "First Name",
                                          controller: registerViewModel.firstNameC,
                                          placeholder: "",
                                          necessary: true,
                                          isPassword: false,
                                          formKey: formKey,
                                        ),
                                        InputShortAuthWidget(
                                          head: "Last Name",
                                          controller: registerViewModel.lastNameC,
                                          placeholder: "",
                                          necessary: true,
                                          isPassword: false,
                                          formKey: formKey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InputSelectAuthWidget(
                                  head: "Role",
                                  placeholder: "",
                                  necessary: true,
                                  isPassword: false,
                                  formKey: formKey,
                                ),
                                SizedBox(height: 20.h,),
                                Center(
                                  child: Container(
                                    width: 322.w,
                                    height: 45.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        AppColors.electricBlue,
                                        AppColors.blueGradient
                                      ]),
                                      borderRadius: BorderRadius.circular(6.w),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6.w)
                                        ),
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                      ),
                                      onPressed: () {
                                        if(formKey.currentState!.validate()){
                                          registerViewModel.RegisterWithEmailPassword();
                                        }
                                      },
                                      child: Text(
                                        "Register",
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: AppFontWeight.medium,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 32.h,),
                                Center(
                                  child: Container(
                                    width: 322.w,
                                    height: 20.h,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Have an account?",
                                          style: GoogleFonts.inter(
                                            fontSize: 13.sp,
                                            fontWeight: AppFontWeight.medium,
                                            color: AppColors.charcoal,
                                          ),
                                        ),
                                        SizedBox(width: 4.w,),
                                        GestureDetector(
                                          onTap: () {
                                            Get.offAllNamed("/login");
                                          },
                                          child: Text(
                                            "Login.",
                                            style: GoogleFonts.inter(
                                                color: AppColors.blueLine,
                                                fontWeight: AppFontWeight.medium,
                                                fontSize: 13.sp
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Obx(() => loadingC.isLoading.value ? Container(color: Colors.black26,
            child: Center(child: LoadingAnimationWidget.stretchedDots(
              color: AppColors.softWhite, size: 70.w,))) : SizedBox(),)
      ],
    );
  }
}

