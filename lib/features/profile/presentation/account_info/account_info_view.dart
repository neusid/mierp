import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mierp_apps/core/di/injection_container.dart';

class AccountInfoView extends StatefulWidget {
  const AccountInfoView({super.key});

  @override
  State<AccountInfoView> createState() => _AccountInfoViewState();
}

class _AccountInfoViewState extends State<AccountInfoView> {
  bool _isEditing = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(ProfileStarted()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          // If we added update logic, we'd listen for success here
        },
        builder: (context, state) {
          // Initialize controller with current name if empty
          if (_nameController.text.isEmpty && !_isEditing) {
            _nameController.text = state.name;
          }

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

                // 2. Content
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 80.h, bottom: 120.h),
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
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
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
                                    if (_isEditing)
                                      Container(
                                        padding: EdgeInsets.all(6.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.vividPurple,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2.w),
                                        ),
                                        child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14.w),
                                      ),
                                  ],
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
                                SizedBox(height: 32.h),

                                // Editable Name Field
                                _buildEditableRow("Full Name", _nameController, isEditing: _isEditing),
                                Divider(height: 24.h, thickness: 1, color: AppColors.softWhite),
                                _buildInfoRow("Email Address", state.email.isEmpty ? "-" : state.email),
                                Divider(height: 24.h, thickness: 1, color: AppColors.softWhite),
                                _buildInfoRow("Role", state.role.toUpperCase()),
                                Divider(height: 24.h, thickness: 1, color: AppColors.softWhite),
                                _buildInfoRow("Account ID", state.uid, isMonospace: true),
                                Divider(height: 24.h, thickness: 1, color: AppColors.softWhite),
                                _buildInfoRow("Verification", state.isVerif ? "Verified" : "Unverified", 
                                  valueColor: state.isVerif ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Custom App Bar (Placed last in Stack to catch tap events!)
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => context.pop(),
                          borderRadius: BorderRadius.circular(12.w),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12.w),
                            ),
                            child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24.w),
                          ),
                        ),
                        Text(
                          "Account Info",
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

                // BOTTOM ACTION BAR
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: const Color(0xFFE2E8F0), width: 1.w)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10.w,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_isEditing) {
                            // TODO: Dispatch update event to Bloc
                            // context.read<ProfileBloc>().add(ProfileUpdateRequested(_nameController.text));
                            _isEditing = false;
                            CustomTopSnackbar.show(context, "Profil berhasil diperbarui", isError: false);
                          } else {
                            _isEditing = true;
                          }
                        });
                      },
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          gradient: _isEditing ? AppColors.premiumDarkGradient : null,
                          color: _isEditing ? null : AppColors.softWhite,
                          borderRadius: BorderRadius.circular(10.w),
                          boxShadow: _isEditing ? [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.2),
                              blurRadius: 8.w,
                              offset: Offset(0, 4.w),
                            ),
                          ] : [],
                        ),
                        child: Center(
                          child: Text(
                            _isEditing ? "Save Changes" : "Edit Profile",
                            style: GoogleFonts.inter(
                              fontWeight: AppFontWeight.bold,
                              fontSize: 16.sp,
                              color: _isEditing ? Colors.white : AppColors.vividPurple,
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildEditableRow(String label, TextEditingController controller, {required bool isEditing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: AppFontWeight.medium,
            color: AppColors.grayThin,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: isEditing 
            ? Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: AppColors.softWhite,
                  borderRadius: BorderRadius.circular(8.w),
                  border: Border.all(color: AppColors.vividPurple.withValues(alpha: 0.5), width: 1.w),
                ),
                child: TextField(
                  controller: controller,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: AppFontWeight.semiBold,
                    color: AppColors.grayTitle,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              )
            : Text(
                controller.text,
                textAlign: TextAlign.right,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: AppFontWeight.semiBold,
                  color: AppColors.grayTitle,
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMonospace = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: AppFontWeight.medium,
            color: AppColors.grayThin,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: isMonospace 
                ? GoogleFonts.jetBrainsMono(
                    fontSize: 14.sp,
                    fontWeight: AppFontWeight.medium,
                    color: valueColor ?? AppColors.grayTitle,
                  )
                : GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: AppFontWeight.semiBold,
                    color: valueColor ?? AppColors.grayTitle,
                  ),
          ),
        ),
      ],
    );
  }
}
