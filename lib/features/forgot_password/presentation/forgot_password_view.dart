import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/input_widget.dart';
import 'package:mierp_apps/features/forgot_password/presentation/forgot_password_view_model.dart';

class ForgotPasswordView extends GetView<ForgotPasswordViewModel> {
  ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.electricBlue,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Center(
                    child: Container(
                      width: 350.w,
                      height: 658.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),),
                        color: Colors.white12,
                      ),
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    height: 671.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 1.sw,
                          height: 658.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),),
                            color: Colors.white,
                          ),
                          child: Form(
                            // key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 44.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/mierp.png", width: 120.w,
                                      height: 34.h,),
                                  ],
                                ),
                                SizedBox(height: 24.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Log in to your account",
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Welcome back! Please enter your details.",
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: AppFontWeight.regular,
                                        color: AppColors.grayThin,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h,),
                                Obx(() {
                                  return Container(
                                    width: 322.w,
                                    height: 93.w,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "*",
                                              style: GoogleFonts.inter(
                                                fontSize: 13.sp,
                                                fontWeight: AppFontWeight
                                                    .medium,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text(
                                              "Email",
                                              style: GoogleFonts.inter(
                                                fontSize: 13.sp,
                                                fontWeight: AppFontWeight
                                                    .medium,
                                                color: AppColors.grayTitle,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.w,),
                                        Container(
                                          width: 322.w,
                                          height: 45.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                6.w),
                                            boxShadow: controller.isFocus.value
                                                ? [BoxShadow(
                                                color: AppColors.blueLineShadow,
                                                spreadRadius: 4
                                            )
                                            ]
                                                : [BoxShadow(
                                                color: Colors.white,
                                                spreadRadius: 2
                                            )
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: controller.emailC,
                                            focusNode: controller.focusNode,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                controller.hasError.value =
                                                true;
                                                return null;
                                              }
                                              if (!value.contains('@')) {
                                                controller.hasError.value =
                                                true;
                                                return null;
                                              }
                                            },
                                            style: GoogleFonts.inter(
                                              fontSize: 13.sp,
                                              fontWeight: AppFontWeight.regular,
                                              height: 1.0,
                                            ),
                                            decoration: controller.hasError
                                                .value ? InputDecoration(
                                              errorMaxLines: 1,
                                              errorText: '',
                                              errorStyle: TextStyle(
                                                color: Colors.transparent,
                                                fontSize: 0,
                                              ),
                                              hintText: "Enter your email",
                                              hintStyle: GoogleFonts.inter(
                                                fontSize: 13.sp,
                                                fontWeight: AppFontWeight
                                                    .regular,
                                                height: 1.0,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(6.w),
                                                  borderSide: BorderSide(
                                                      color: AppColors.blueLine,
                                                      width: 1.w)
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(6.w),
                                                  borderSide: BorderSide(
                                                      color: AppColors.coolGray,
                                                      width: 1.w)
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius
                                                    .circular(6.w),
                                              ),
                                              contentPadding: EdgeInsets
                                                  .symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 12.5.w),
                                            ) : InputDecoration(
                                              hintText: "Enter your email",
                                              hintStyle: GoogleFonts.inter(
                                                fontSize: 13.sp,
                                                fontWeight: AppFontWeight
                                                    .regular,
                                                height: 1.0,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(6.w),
                                                  borderSide: BorderSide(
                                                      color: AppColors.blueLine,
                                                      width: 1.w)
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(6.w),
                                                  borderSide: BorderSide(
                                                      color: AppColors.coolGray,
                                                      width: 1.w)
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius
                                                    .circular(6.w),
                                              ),
                                              contentPadding: EdgeInsets
                                                  .symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 12.5.w),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
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
                                            borderRadius: BorderRadius.circular(
                                                6.w)
                                        ),
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                      ),
                                      onPressed: () {
                                        controller.requestResetPassword();
                                      },
                                      child: Text(
                                        "Forgot Password",
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
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
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
                                            Get.toNamed("/login",);
                                          },
                                          child: Text(
                                            "Login.",
                                            style: GoogleFonts.inter(
                                                color: AppColors.blueLine,
                                                fontWeight: AppFontWeight
                                                    .medium,
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
          // Obx(()=>loginViewModel.isLoading.value == true? Container(color: Colors.black26, child: Center(child: LoadingAnimationWidget.stretchedDots(color: AppColors.softWhite, size: 70.w,))):SizedBox(),)
        ],
      ),
    );
  }
}
