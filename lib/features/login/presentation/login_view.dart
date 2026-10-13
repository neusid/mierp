import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/auth/input_auth_widget.dart';
import 'package:mierp_apps/features/login/presentation/bloc/login_bloc.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import '../../../core/theme/app_colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController(text: "admin@mierp.com");
  final TextEditingController passwordC = TextEditingController(text: "password123");
  bool saveCredential = false;

  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(LoginLoadCredential());
  }

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
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
        child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginInitial) {
            if (state.saveCredential) {
              setState(() {
                saveCredential = true;
                emailC.text = state.savedEmail;
              });
            }
          } else if (state is LoginFailure) {
            CustomTopSnackbar.show(context, state.message, isError: true);
          } else if (state is LoginSuccess) {
            if (state.role == "warehouse") {
              context.go("/warehouse_main_page");
            } else {
              context.go("/finance_main_page");
            }
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 1.sw,
                        height: 671.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 350.w,
                              height: 671.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.r),
                                  topRight: Radius.circular(20.r),
                                ),
                                color: AppColors.shadowElectricBlue.withValues(alpha: 0.29),
                              ),
                            ),
                          ],
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
                                          "Log in to your account",
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
                                          "Welcome back! Please enter your details.",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.sp,
                                            fontWeight: AppFontWeight.regular,
                                            color: AppColors.grayThin,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 32.h),
                                    InputAuthWidget(
                                      head: "Email",
                                      controller: emailC,
                                      placeholder: "",
                                      necessary: false,
                                      isPassword: false,
                                      formKey: formKey,
                                    ),
                                    InputAuthWidget(
                                      head: "Password",
                                      controller: passwordC,
                                      placeholder: "",
                                      necessary: false,
                                      isPassword: true,
                                      formKey: formKey,
                                    ),
                                    SizedBox(height: 20.h),
                                    Center(
                                      child: SizedBox(
                                        width: 322.w,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 15.w,
                                                  height: 15.h,
                                                  child: Checkbox(
                                                    activeColor: AppColors.blueGradient,
                                                    value: saveCredential,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        saveCredential = newValue ?? false;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  "Remember me",
                                                  style: GoogleFonts.inter(
                                                    color: AppColors.charcoal,
                                                    fontWeight: AppFontWeight.medium,
                                                    fontSize: 13.sp,
                                                  ),
                                                )
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () => context.push("/forgot"),
                                              child: Text(
                                                "Forgot Password",
                                                style: GoogleFonts.inter(
                                                  color: AppColors.blueLine,
                                                  fontWeight: AppFontWeight.medium,
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
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
                                              context.read<LoginBloc>().add(
                                                LoginSubmitted(
                                                  email: emailC.text,
                                                  password: passwordC.text,
                                                  saveCredential: saveCredential,
                                                ),
                                              );
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
                                    SizedBox(height: 20.h),
                                    Center(
                                      child: SizedBox(
                                        width: 322.w,
                                        height: 45.h,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6.w),
                                                side: BorderSide(
                                                    color: Colors.black12, width: 0.8.w)),
                                          ),
                                          onPressed: () {
                                            context.read<LoginBloc>().add(LoginWithGoogleSubmitted());
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset("assets/images/google.png", width: 15.w, height: 15.h),
                                              SizedBox(width: 6.w),
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
                                    SizedBox(height: 32.h),
                                    Center(
                                      child: SizedBox(
                                        width: 322.w,
                                        height: 20.h,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Don't have an account?",
                                              style: GoogleFonts.inter(
                                                fontSize: 13.sp,
                                                fontWeight: AppFontWeight.medium,
                                                color: AppColors.charcoal,
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            GestureDetector(
                                              onTap: () {
                                                context.go("/register");
                                              },
                                              child: Text(
                                                "Register.",
                                                style: GoogleFonts.inter(
                                                  color: AppColors.blueLine,
                                                  fontWeight: AppFontWeight.medium,
                                                  fontSize: 13.sp,
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
