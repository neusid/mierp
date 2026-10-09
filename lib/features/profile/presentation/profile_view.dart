import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/button_profile_widget.dart';
import 'package:mierp_apps/features/profile/presentation/bloc/profile_bloc.dart';

class ProfileView extends StatelessWidget {
  final VoidCallback onBack;

  const ProfileView({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(ProfileStarted()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.failure && state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state.status == ProfileStatus.success && state.successMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage)));
          } else if (state.status == ProfileStatus.logoutSuccess) {
            context.go("/login");
          } else if (state.status == ProfileStatus.deleteSuccess) {
            context.go("/login");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage)));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 144.h),
                    SizedBox(
                      width: 110.w,
                      height: 110.h,
                      child: Image.asset("assets/images/profile-box.png"),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 21.9.h),
                              Text(
                                state.name,
                                style: GoogleFonts.lexendDeca(
                                  fontSize: 16.sp,
                                  fontWeight: AppFontWeight.semiBold,
                                  color: AppColors.grayTitle,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                state.role.toUpperCase(),
                                style: GoogleFonts.lexendDeca(
                                  fontSize: 12.sp,
                                  fontWeight: AppFontWeight.light,
                                  color: AppColors.grayTitle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 43.h),
                            SizedBox(
                              width: double.infinity,
                              child: SvgPicture.asset("assets/images/shape.svg"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 27.h),
                    Column(
                      spacing: 11.1.w,
                      children: [
                        ButtonProfileWidget(
                          icon: "user-profile",
                          label: "Account Info",
                          onPress: () {},
                        ),
                        ButtonProfileWidget(
                          icon: "link",
                          label: "Link Account to Google",
                          onPress: !state.isVerif
                              ? () => context.read<ProfileBloc>().add(ProfileLinkGoogleRequested())
                              : null,
                        ),
                        ButtonProfileConfirmWidget(
                          icon: "link",
                          label: "Delete Account",
                          onPress: () => context.read<ProfileBloc>().add(ProfileDeleteAccountRequested()),
                        ),
                        ButtonProfileWidget(
                          icon: "logout",
                          label: "Logout",
                          onPress: () => context.read<ProfileBloc>().add(ProfileLogoutRequested()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 112.h,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 14.2.w,
                                spreadRadius: 0,
                                color: AppColors.appBarShadow,
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 63.h),
                              Container(
                                padding: EdgeInsets.only(left: 30.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: onBack,
                                      child: Icon(Icons.close, size: 24.w),
                                    ),
                                    SizedBox(width: 19.w),
                                    Text(
                                      "Back To Summary",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        fontWeight: AppFontWeight.medium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (state.status == ProfileStatus.loading)
                Container(
                  color: Colors.black26,
                  child: Center(
                    child: LoadingAnimationWidget.stretchedDots(
                      color: AppColors.softWhite,
                      size: 70.w,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
