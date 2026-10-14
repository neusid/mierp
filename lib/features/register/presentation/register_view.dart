import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/auth/input_auth_widget.dart';
import 'package:mierp_apps/core/widgets/auth/input_short_auth_widget.dart';
import 'package:mierp_apps/features/register/presentation/bloc/register_bloc.dart';
import '../../../core/theme/app_colors.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';

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
  final TextEditingController companyNameC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    firstNameC.dispose();
    lastNameC.dispose();
    companyNameC.dispose();
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
        child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterFailure) {
            CustomTopSnackbar.error(context, state.message);
          } else if (state is RegisterSuccess) {
            CustomTopSnackbar.success(
              context,
              state.message,
              onDismissed: () {
                if (context.mounted) {
                  context.go("/login");
                }
              },
            );
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
                      SizedBox(
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
                      SizedBox(
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
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 36.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset("assets/images/mierp.png", width: 120.w, height: 34.h),
                                        ],
                                      ),
                                      SizedBox(height: 20.h),
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
                                      SizedBox(height: 8.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Welcome! Please enter your details.",
                                            style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              fontWeight: AppFontWeight.regular,
                                              color: AppColors.grayThin,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 24.h),
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
                                        child: SizedBox(
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
                                      InputAuthWidget(
                                        head: "Company Name",
                                        controller: companyNameC,
                                        placeholder: "e.g. PT Maju Bersama",
                                        necessary: true,
                                        isPassword: false,
                                        formKey: formKey,
                                      ),
                                      SizedBox(height: 6.h),
                                      Center(
                                        child: Container(
                                          width: 322.w,
                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.premiumDarkSolid.withValues(alpha: 0.08),
                                            borderRadius: BorderRadius.circular(8.r),
                                            border: Border.all(color: AppColors.premiumDarkSolid.withValues(alpha: 0.2)),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.admin_panel_settings_outlined, size: 18.sp, color: AppColors.premiumDarkSolid),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Text(
                                                  "Pendaftaran publik dikhususkan untuk Admin Perusahaan.",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11.sp,
                                                    fontWeight: AppFontWeight.medium,
                                                    color: AppColors.premiumDarkSolid,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 18.h),
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
                                                context.read<RegisterBloc>().add(
                                                  RegisterSubmitted(
                                                    email: emailC.text,
                                                    password: passwordC.text,
                                                    firstName: firstNameC.text,
                                                    lastName: lastNameC.text,
                                                    companyName: companyNameC.text.trim(),
                                                    role: 'admin',
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Register as Admin",
                                              style: GoogleFonts.inter(
                                                fontSize: 14.sp,
                                                fontWeight: AppFontWeight.medium,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 24.h),
                                      Center(
                                        child: SizedBox(
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
                                      ),
                                      SizedBox(height: 24.h),
                                    ],
                                  ),
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
