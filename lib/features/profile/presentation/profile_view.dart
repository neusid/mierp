import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/core/widgets/modal_delete_confirmation.dart';
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
            CustomTopSnackbar.success(
              context,
              state.successMessage,
              onDismissed: () {
                if (context.mounted) {
                  context.go("/login");
                }
              },
            );
          }
        },
        builder: (context, state) {
          String initials = "U";
          if (state.name.isNotEmpty) {
            final parts = state.name.trim().split(RegExp(r'\s+'));
            if (parts.length > 1) {
              initials = (parts[0][0] + parts[1][0]).toUpperCase();
            } else {
              initials = parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
            }
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            body: Stack(
              children: [
                // 1. Signature Executive Header (Obsidian Black & Violet, Flat Bottom)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 240.h,
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumDarkGradient,
                    ),
                  ),
                ),

                // 2. Custom App Bar
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: onBack,
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 20.w,
                            ),
                          ),
                        ),
                        Text(
                          "Profil Pengguna",
                          style: GoogleFonts.inter(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(width: 38.w), // Visual balance
                      ],
                    ),
                  ),
                ),

                // 3. Scrollable Profile Content
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16.w, 70.h, 16.w, 32.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 3.1. Profile Identity Hero Card
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              children: [
                                // Executive Squircle Avatar (Clean, no glow)
                                Container(
                                  width: 80.w,
                                  height: 80.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    gradient: AppColors.premiumDarkGradient,
                                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    initials,
                                    style: GoogleFonts.inter(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 14.h),
                                Text(
                                  state.name.isEmpty ? "Pengguna MIErp" : state.name,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                if (state.email.isNotEmpty) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    state.email,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5.sp,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                                SizedBox(height: 10.h),
                                // Refined MIErp Signature Purple Pill
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.5.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.purpleTransparent,
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(color: AppColors.lavenderMist, width: 1.w),
                                  ),
                                  child: Text(
                                    (state.role.isEmpty ? "STAFF" : state.role).toUpperCase(),
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.vividPurple,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // 3.2. Actions & Settings Card
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1E293B).withValues(alpha: 0.04),
                                  blurRadius: 18.r,
                                  offset: Offset(0, 6.h),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildProfileMenuItem(
                                  icon: "user-profile",
                                  title: "Informasi Akun",
                                  subtitle: "Lihat dan ubah data profil",
                                  iconGradient: AppColors.premiumDarkGradient,
                                  iconColor: Colors.white,
                                  onTap: () => context.push('/account_info'),
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: const Color(0xFFF1F5F9),
                                  indent: 68.w,
                                  endIndent: 16.w,
                                ),
                                _buildProfileMenuItem(
                                  icon: "link",
                                  title: state.isVerif
                                      ? "Putuskan Akun Google"
                                      : "Tautkan Akun Google",
                                  subtitle: state.isVerif
                                      ? "Akun Google terhubung"
                                      : "Masuk lebih cepat dengan Google",
                                  iconBgColor: AppColors.purpleTransparent,
                                  iconColor: AppColors.vividPurple,
                                  onTap: () {
                                    if (state.isVerif) {
                                      context
                                          .read<ProfileBloc>()
                                          .add(ProfileUnlinkGoogleRequested());
                                    } else {
                                      context
                                          .read<ProfileBloc>()
                                          .add(ProfileLinkGoogleRequested());
                                    }
                                  },
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: const Color(0xFFF1F5F9),
                                  indent: 68.w,
                                  endIndent: 16.w,
                                ),
                                _buildProfileMenuItem(
                                  icon: "logout",
                                  title: "Keluar Akun",
                                  subtitle: "Akhiri sesi login di perangkat ini",
                                  iconBgColor: const Color(0xFFF1F5F9),
                                  iconColor: const Color(0xFF475569),
                                  onTap: () => context
                                      .read<ProfileBloc>()
                                      .add(ProfileLogoutRequested()),
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: const Color(0xFFF1F5F9),
                                  indent: 68.w,
                                  endIndent: 16.w,
                                ),
                                _buildProfileMenuItem(
                                  icon: "delete",
                                  title: "Hapus Akun",
                                  subtitle: "Tutup akun dan akses sistem secara permanen",
                                  iconGradient: AppColors.premiumDarkGradient,
                                  iconColor: Colors.white,
                                  onTap: () => _showConfirmDelete(context, state),
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
                        size: 60.w,
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
    required String title,
    required String subtitle,
    Color? iconBgColor,
    Gradient? iconGradient,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  gradient: iconGradient,
                  borderRadius: BorderRadius.circular(11.r),
                  border: iconGradient == null
                      ? Border.all(color: const Color(0xFFE2E8F0), width: 1.w)
                      : null,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/icons/$icon.svg",
                    width: 18.w,
                    height: 18.w,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xFF94A3B8),
                size: 20.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDelete(BuildContext context, ProfileState state) {
    ModalDeleteConfirmation.show(
      context: context,
      title: "Hapus Akun Anda?",
      message:
          "Apakah Anda yakin ingin menghapus akun ini? Seluruh data bisnis, riwayat transaksi, dan akses Anda akan dihapus secara permanen.",
      confirmText: "Hapus Akun",
      cancelText: "Batal",
      accountName: state.name.isNotEmpty ? state.name : null,
      accountEmail: state.email.isNotEmpty ? state.email : null,
      roleBadge: state.role.isNotEmpty ? state.role : null,
      onConfirm: () {
        context.read<ProfileBloc>().add(ProfileDeleteAccountRequested());
      },
    );
  }
}
