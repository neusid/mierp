import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/auth/input_auth_widget.dart';
import 'package:mierp_apps/data/login/login_repository.dart';
import 'package:mierp_apps/features/login/presentation/login_view_model.dart';
import '../../../core/theme/app_colors.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final loginViewModel = Get.find<LoginViewModel>();
  final loginR = Get.find<LoginRepository>();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.electricBlue,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: .end,
            children: [
              Stack(
                children: [
                  Container(
                    width: 1.sw,
                    height: 671.h,
                    child: Column(
                      mainAxisAlignment: .end,
                      children: [
                        Container(
                          width: 350.w,
                          height: 671.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                            ),
                            color: AppColors.shadowElectricBlue.withValues(
                                alpha: 0.29),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    height: 671.h,
                    child: Column(
                      mainAxisAlignment: .end,
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
                                  mainAxisAlignment: .center,
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
                                SizedBox(height: 32.h,),
                                InputAuthWidget(head: "Email",
                                  controller: loginViewModel.emailC,
                                  placeholder: "",
                                  necessary: false,
                                  isPassword: false,
                                  formKey: formKey,
                                ),
                                InputAuthWidget(
                                  head: "Password",
                                  controller: loginViewModel.passwordC,
                                  placeholder: "",
                                  necessary: false,
                                  isPassword: true,
                                  formKey: formKey,
                                ),
                                SizedBox(height: 20.h,),
                                Center(
                                  child: Container(
                                    width: 322.w,
                                    child: Row(
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Obx(() {
                                              return Container(
                                                width: 15.w,
                                                height: 15.h,
                                                child: Checkbox(
                                                  activeColor: AppColors.blueGradient,
                                                  value: loginViewModel.saveCredential.value,
                                                  onChanged: (newValue) {
                                                    loginViewModel.saveCredential.value = newValue!;
                                                  },
                                                ),
                                              );
                                            }),
                                            SizedBox(width: 8.w,),
                                            Text(
                                              "Remember me",
                                              style: GoogleFonts.inter(
                                                  color: AppColors.charcoal,
                                                  fontWeight: AppFontWeight.medium,
                                                  fontSize: 13.sp
                                              ),
                                            )
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () => Get.toNamed("/forgot"),
                                          child: Text(
                                            "Forgot Password",
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
                                          // if(loginViewModel.saveCredential.value == true) {
                                          //
                                          // }
                                          loginViewModel.login(loginViewModel.emailC.text, loginViewModel.passwordC.text);
                                          print("${loginViewModel.emailC.text} ${loginViewModel.passwordC.text}");
                                        }
                                      },
                                      child: Text(
                                        "Log In",
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: AppFontWeight.medium,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h,),
                                Center(
                                  child: Container(
                                    width: 322.w,
                                    height: 45.h,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6.w),
                                            side: BorderSide(
                                                color: Colors.black12, width: 0.8.w)
                                        ),
                                      ),
                                      onPressed: ()=>loginViewModel.loginWithGoogle(),
                                      child: Row(
                                        mainAxisAlignment: .center,
                                        children: [
                                          Image.asset(
                                            "assets/images/google.png", width: 15.w,
                                            height: 15.h,),
                                          SizedBox(width: 6.w,),
                                          Text(
                                            "Log In With Google",
                                            style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              fontWeight: AppFontWeight.medium,
                                              color: AppColors.charcoal,
                                            ),
                                          )
                                        ],
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
                                      mainAxisAlignment: .center,
                                      children: [
                                        Text(
                                          "Don't have an account?",
                                          style: GoogleFonts.inter(
                                            fontSize: 13.sp,
                                            fontWeight: AppFontWeight.medium,
                                            color: AppColors.charcoal,
                                          ),
                                        ),
                                        SizedBox(width: 4.w,),
                                        GestureDetector(
                                          onTap: () {
                                            Get.offAllNamed("/register");
                                          },
                                          child: Text(
                                            "Register.",
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
          Obx(()=>loginViewModel.isLoading.value == true? Container(color: Colors.black26, child: Center(child: LoadingAnimationWidget.stretchedDots(color: AppColors.softWhite, size: 70.w,))):SizedBox(),)
        ],
      ),
    );
  }
}

