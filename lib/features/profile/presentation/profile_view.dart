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
          String initials = "U";
          if (state.name.isNotEmpty) {
            final parts = state.name.trim().split(RegExp(r'\\s+'));
            if (parts.length > 1) {
              initials = parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
            } else {
              initials = parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
            }
          }

          return Stack(
            children: [
              // 1. Colored Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 220.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blueGradient,
                        AppColors.electricBlue,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),

              // 2. Custom App Bar / Back Button (over the header)
              Positioned(
                top: 60.h,
                left: 20.w,
                child: InkWell(
                  onTap: onBack,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
                  ),
                ),
              ),
              Positioned(
                top: 66.h,
                left: 0,
                right: 0,
                child: Text(
                  "Profile",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: AppFontWeight.semiBold,
                    color: Colors.white,
                  ),
                ),
              ),

              // 3. Content
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 80.h), // Offset for header

                    // Avatar & Info Card
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      padding: EdgeInsets.only(top: 24.h, bottom: 24.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.w),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.appBarShadow,
                            blurRadius: 20.w,
                            offset: Offset(0, 8.w),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Dynamic Avatar
                          Container(
                            width: 90.w,
                            height: 90.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF38BDF8), Color(0xFF2563EB)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(color: Colors.white, width: 4.w),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF2563EB).withOpacity(0.3),
                                  blurRadius: 12.w,
                                  offset: Offset(0, 4.w),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              initials,
                              style: GoogleFonts.lexendDeca(
                                fontSize: 32.sp,
                                fontWeight: AppFontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            state.name,
                            style: GoogleFonts.lexendDeca(
                              fontSize: 20.sp,
                              fontWeight: AppFontWeight.semiBold,
                              color: AppColors.grayTitle,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColors.electricBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.w),
                            ),
                            child: Text(
                              state.role.toUpperCase(),
                              style: GoogleFonts.lexendDeca(
                                fontSize: 12.sp,
                                fontWeight: AppFontWeight.semiBold,
                                color: AppColors.electricBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Actions Group Card
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.w),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.appBarShadow,
                            blurRadius: 20.w,
                            offset: Offset(0, 8.w),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildProfileMenuItem(
                            icon: "user-profile",
                            label: "Account Info",
                            onTap: () {},
                          ),
                          Divider(height: 1, thickness: 1, color: AppColors.shadowBox2, indent: 64.w),
                          _buildProfileMenuItem(
                            icon: "link",
                            label: "Link Account to Google",
                            onTap: !state.isVerif
                                ? () => context.read<ProfileBloc>().add(ProfileLinkGoogleRequested())
                                : null,
                          ),
                          Divider(height: 1, thickness: 1, color: AppColors.shadowBox2, indent: 64.w),
                          _buildProfileMenuItem(
                            icon: "link",
                            label: "Delete Account",
                            isDestructive: true,
                            onTap: () => _showConfirmDelete(context),
                          ),
                          Divider(height: 1, thickness: 1, color: AppColors.shadowBox2, indent: 64.w),
                          _buildProfileMenuItem(
                            icon: "logout",
                            label: "Logout",
                            onTap: () => context.read<ProfileBloc>().add(ProfileLogoutRequested()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

  Widget _buildProfileMenuItem({
    required String icon,
    required String label,
    required VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : AppColors.grayTitle;
    final iconColor = isDestructive ? Colors.red : Colors.black;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.w), // So ripple stays in bounds on corners
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: isDestructive ? Colors.red.withOpacity(0.1) : AppColors.bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/$icon.svg",
                        width: 20.w,
                        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: AppFontWeight.medium,
                      color: color,
                    ),
                  ),
                ],
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.grayThin,
                  size: 24.w,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDelete(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Center(
        child: Container(
          width: 345.w,
          height: 270.w,
          padding: EdgeInsets.all(30.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.w),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset("assets/icons/warning.png", width: 50.w),
              SizedBox(height: 10.w),
              Text(
                "ARE YOU SURE?",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: AppColors.gray,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
              Text(
                "Please confirm if you want to delete this account. This action cannot be undone.",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: AppColors.grayThin,
                  fontWeight: AppFontWeight.regular,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: BorderSide(color: AppColors.grayThin),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                      ),
                      child: Text(
                        "Close",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.grayTitle,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<ProfileBloc>().add(ProfileDeleteAccountRequested());
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        backgroundColor: AppColors.vibrantOrange, // the red/orange from original
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Confirm",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
