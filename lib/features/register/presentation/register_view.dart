import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/auth/input_select_auth_widget.dart';
import 'package:mierp_apps/core/widgets/auth/input_auth_widget.dart';
import 'package:mierp_apps/core/widgets/auth/input_short_auth_widget.dart';
import 'package:mierp_apps/features/register/presentation/bloc/register_bloc.dart';
import '../../../core/theme/app_colors.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController firstNameC = TextEditingController();
  final TextEditingController lastNameC = TextEditingController();
  
  String role = "warehouse";

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    firstNameC.dispose();
    lastNameC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.electricBlue,
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            Future.delayed(const Duration(seconds: 3), () {
              context.go("/login");
            });
          }
        },
        builder: (context, state) {
          final isLoading = state is RegisterLoading;

          return Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 1.sw,
                        height: 768.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 350.w,
                              height: 768.h,
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
                      Container(
                        width: 1.sw,
                        height: 768.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 1.sw,
                              height: 751.95.h,
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
                                          "Create your account",
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
                                          "Welcome! Please enter your details.",
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
                                      necessary: true,
                                      isPassword: false,
                                      formKey: formKey,
                                    ),
                                    InputAuthWidget(
                                      head: "Password",
                                      controller: passwordC,
                                      placeholder: "",
                                      necessary: true,
                                      isPassword: true,
                                      formKey: formKey,
                                    ),
                                    Center(
                                      child: Container(
                                        width: 322.w,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InputShortAuthWidget(
                                              head: "First Name",
                                              controller: firstNameC,
                                              placeholder: "",
                                              necessary: true,
                                              isPassword: false,
                                              formKey: formKey,
                                            ),
                                            InputShortAuthWidget(
                                              head: "Last Name",
                                              controller: lastNameC,
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
                                      value: role,
                                      onChanged: (val) {
                                        setState(() {
                                          role = val ?? "warehouse";
                                        });
                                      }
                                    ),
                                    SizedBox(height: 20.h),
                                    Center(
                                      child: Container(
                                        width: 322.w,
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.electricBlue,
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
                                              context.read<RegisterBloc>().add(
                                                RegisterSubmitted(
                                                  email: emailC.text,
                                                  password: passwordC.text,
                                                  firstName: firstNameC.text,
                                                  lastName: lastNameC.text,
                                                  role: role,
                                                )
                                              );
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
                                    SizedBox(height: 32.h),
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
                                            SizedBox(width: 4.w),
                                            GestureDetector(
                                              onTap: () {
                                                context.go("/login");
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
    );
  }
}
