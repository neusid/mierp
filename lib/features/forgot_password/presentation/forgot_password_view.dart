import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/auth/input_auth_widget.dart';
import 'package:mierp_apps/features/forgot_password/presentation/bloc/forgot_password_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.premiumDarkGradient),
        child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ForgotPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            Future.delayed(const Duration(seconds: 3), () {
              context.go("/login");
            });
          }
        },
        builder: (context, state) {
          final isLoading = state is ForgotPasswordLoading;

          return Stack(
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
                              topRight: Radius.circular(20.r),
                            ),
                            color: Colors.white12,
                          ),
                        ),
                      ),
                      SizedBox(
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
                                  topRight: Radius.circular(20.r),
                                ),
                                color: Colors.white,
                              ),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 44.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/images/mierp.png", width: 120.w, height: 34.h),
                                      ],
                                    ),
                                    SizedBox(height: 24.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Reset your password",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.sp,
                                            fontWeight: AppFontWeight.medium,
                                            color: AppColors.gray,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Enter your email to receive a reset link.",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.sp,
                                            fontWeight: AppFontWeight.regular,
                                            color: AppColors.grayThin,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20.h),
                                    InputAuthWidget(
                                      head: "Email",
                                      controller: emailC,
                                      placeholder: "Enter your email",
                                      necessary: true,
                                      isPassword: false,
                                      formKey: formKey,
                                    ),
                                    SizedBox(height: 20.h),
                                    Center(
                                      child: Container(
                                        width: 322.w,
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                          gradient: AppColors.premiumDarkGradient,
                                          borderRadius: BorderRadius.circular(10.w),
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6.w)),
                                            shadowColor: Colors.transparent,
                                            surfaceTintColor: Colors.transparent,
                                          ),
                                          onPressed: () {
                                            if (formKey.currentState!.validate()) {
                                              context.read<ForgotPasswordBloc>().add(
                                                ResetPasswordRequested(emailC.text)
                                              );
                                            }
                                          },
                                          child: Text(
                                            "Send Reset Link",
                                            style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              fontWeight: AppFontWeight.medium,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 32.h),
                                    Center(
                                      child: SizedBox(
                                        width: 322.w,
                                        height: 20.h,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Remembered your password?",
                                              style: GoogleFonts.inter(
                                                fontSize: 13.sp,
                                                fontWeight: AppFontWeight.medium,
                                                color: AppColors.charcoal,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            GestureDetector(
                                              onTap: () {
                                                context.push("/login");
                                              },
                                              child: Text(
                                                "Login.",
                                                style: GoogleFonts.inter(
                                                    color: AppColors.blueLine,
                                                    fontWeight: AppFontWeight.medium,
                                                    fontSize: 13.sp),
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
              if (isLoading)
                Container(
                  color: Colors.black26,
                  child: Center(
                    child: LoadingAnimationWidget.stretchedDots(color: AppColors.softWhite, size: 70.w),
                  ),
                )
            ],
          );
        },
      ),
      ),
    );
  }
}
