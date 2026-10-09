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
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
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
            CustomTopSnackbar.show(context, state.errorMessage, isError: true);
          } else if (state.status == ProfileStatus.success && state.successMessage.isNotEmpty) {
            CustomTopSnackbar.show(context, state.successMessage, isError: false);
          } else if (state.status == ProfileStatus.logoutSuccess) {
            context.go("/login");
          } else if (state.status == ProfileStatus.deleteSuccess) {
            context.go("/login");
            CustomTopSnackbar.show(context, state.successMessage, isError: false);
          }
        },
        builder: (context, state) {
          String initials = "U";
          if (state.name.isNotEmpty) {
            final parts = state.name.trim().split(RegExp(r'\s+'));
            if (parts.length > 1) {
              initials = parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
            } else {
              initials = parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
            }
          }

          return Scaffold(
            backgroundColor: AppColors.softWhite,
            body: Stack(
              children: [
                // 1. Premium Dark Header
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 250.h,
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumDarkGradient,
                    ),
                  ),
                ),

                // 2. Custom App Bar
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: onBack,
                          borderRadius: BorderRadius.circular(12.w),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12.w),
                            ),
                            child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24.w),
                          ),
                        ),
                        Text(
                          "Profile",
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: AppFontWeight.semiBold,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(width: 40.w), // Symmetrical balance
                      ],
                    ),
                  ),
                ),

                // 3. Content
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 80.h, bottom: 40.h),
                      child: Column(
                        children: [
                          // Avatar & Info Card
                          Container(
                            width: 335.w,
                            padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24.w),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 24.w,
                                  offset: Offset(0, 8.w),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Dynamic Avatar
                                Container(
                                  width: 88.w,
                                  height: 88.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.purpleTransparent,
                                    border: Border.all(color: AppColors.lavenderMist, width: 2.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    initials,
                                    style: GoogleFonts.inter(
                                      fontSize: 32.sp,
                                      fontWeight: AppFontWeight.bold,
                                      color: AppColors.vividPurple,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  state.name.isEmpty ? "User Name" : state.name,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 20.sp,
                                    fontWeight: AppFontWeight.semiBold,
                                    color: AppColors.grayTitle,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.softWhite,
                                    borderRadius: BorderRadius.circular(20.w),
                                  ),
                                  child: Text(
                                    state.role.isEmpty ? "ROLE" : state.role.toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      fontWeight: AppFontWeight.bold,
                                      color: AppColors.grayThin,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Actions Group Card
                          Container(
                            width: 335.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24.w),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 24.w,
                                  offset: Offset(0, 8.w),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildProfileMenuItem(
                                  icon: "user-profile",
                                  label: "Account Info",
                                  onTap: () => context.push('/account_info'),
                                ),
                                Divider(height: 1, thickness: 1, color: AppColors.softWhite, indent: 64.w),
                                _buildProfileMenuItem(
                                  icon: "link",
                                  label: state.isVerif ? "Unlink Google Account" : "Link Google Account",
                                  onTap: () {
                                    if (state.isVerif) {
                                      context.read<ProfileBloc>().add(ProfileUnlinkGoogleRequested());
                                    } else {
                                      context.read<ProfileBloc>().add(ProfileLinkGoogleRequested());
                                    }
                                  },
                                ),
                                Divider(height: 1, thickness: 1, color: AppColors.softWhite, indent: 64.w),
                                _buildProfileMenuItem(
                                  icon: "logout",
                                  label: "Logout",
                                  onTap: () => context.read<ProfileBloc>().add(ProfileLogoutRequested()),
                                ),
                                Divider(height: 1, thickness: 1, color: AppColors.softWhite, indent: 64.w),
                                _buildProfileMenuItem(
                                  icon: "delete",
                                  label: "Delete Account",
                                  isDestructive: true,
                                  onTap: () => _showConfirmDelete(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (state.status == ProfileStatus.loading)
                  Container(
                    color: Colors.black26,
                    child: Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: Colors.white,
                        size: 70.w,
                      ),
                    ),
                  ),
              ],
            ),
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
    final textColor = isDestructive ? Colors.red : AppColors.grayTitle;
    final iconColor = isDestructive ? Colors.red : AppColors.vividPurple;
    final iconBgColor = isDestructive ? Colors.red.withValues(alpha: 0.1) : AppColors.purpleTransparent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.w), // Match card radius
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: iconBgColor,
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
                      fontSize: 15.sp,
                      fontWeight: AppFontWeight.semiBold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.coolGray,
                  size: 24.w,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
        title: Text(
          "Delete Account",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: AppFontWeight.bold,
            color: AppColors.grayTitle,
          ),
        ),
        content: Text(
          "Are you sure you want to delete your account? This action cannot be undone.",
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppColors.grayThin,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: GoogleFonts.inter(
                color: AppColors.grayThin,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileBloc>().add(ProfileDeleteAccountRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.w),
              ),
            ),
            child: Text(
              "Delete",
              style: GoogleFonts.inter(
                color: Colors.red,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
