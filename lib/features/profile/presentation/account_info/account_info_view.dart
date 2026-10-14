import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _syncControllers(ProfileState state) {
    if (_firstNameController.text.isEmpty && _lastNameController.text.isEmpty) {
      if (state.firstName.isNotEmpty || state.lastName.isNotEmpty) {
        _firstNameController.text = state.firstName;
        _lastNameController.text = state.lastName;
      } else if (state.name.isNotEmpty) {
        final parts = state.name.trim().split(RegExp(r'\s+'));
        _firstNameController.text = parts.isNotEmpty ? parts[0] : '';
        _lastNameController.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(ProfileStarted()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.success && state.successMessage.isNotEmpty) {
            CustomTopSnackbar.success(context, state.successMessage);
            setState(() {
              _isEditing = false;
            });
          } else if (state.status == ProfileStatus.failure && state.errorMessage.isNotEmpty) {
            CustomTopSnackbar.error(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          _syncControllers(state);

          // Compute user initials for avatar
          String initials = "U";
          final displayName = state.name.isNotEmpty ? state.name : "User Name";
          if (displayName.isNotEmpty) {
            final parts = displayName.trim().split(RegExp(r'\s+'));
            if (parts.length > 1 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
              initials = (parts[0][0] + parts[1][0]).toUpperCase();
            } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
              initials = parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
            }
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            body: Stack(
              children: [
                // 1. Signature Clean Header (Obsidian Black & Violet, Flat Bottom)
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

                // 2. Scrollable Symmetrical Body Content
                SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: 64.h, bottom: 120.h, left: 16.w, right: 16.w),
                    child: Column(
                      children: [
                        // Main Profile Card (Clean solid surface, no heavy shadow)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(22.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Avatar Squircle (Kotak, No Glow)
                              Center(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
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
                                    if (_isEditing)
                                      Positioned(
                                        bottom: -4.w,
                                        right: -4.w,
                                        child: Container(
                                          width: 26.w,
                                          height: 26.w,
                                          decoration: BoxDecoration(
                                            color: AppColors.premiumDarkSolid,
                                            borderRadius: BorderRadius.circular(8.r),
                                            border: Border.all(color: Colors.white, width: 2.w),
                                          ),
                                          child: Center(
                                            child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 13.w),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 14.h),

                              // Name Heading
                              Text(
                                displayName,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  fontWeight: AppFontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                  letterSpacing: -0.4,
                                ),
                              ),
                              SizedBox(height: 6.h),

                              // Role Badge (MiERP Gojek-Style Pill Badge)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3E8FF),
                                  borderRadius: BorderRadius.circular(20.w),
                                  border: Border.all(color: const Color(0xFFE9D5FF), width: 1.w),
                                ),
                                child: Text(
                                  state.role.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5.sp,
                                    fontWeight: AppFontWeight.bold,
                                    color: const Color(0xFF7C3AED),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                              SizedBox(height: 28.h),

                              // Form Body (Symmetrical View vs Edit Modes)
                              if (_isEditing)
                                _buildEditForm(state)
                              else
                                _buildViewProfile(state, displayName),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. Custom Symmetrical App Bar
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        InkWell(
                          onTap: () {
                            if (_isEditing) {
                              setState(() => _isEditing = false);
                            } else {
                              context.pop();
                            }
                          },
                          borderRadius: BorderRadius.circular(12.w),
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12.w),
                            ),
                            child: Center(
                              child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20.w),
                            ),
                          ),
                        ),

                        // Title
                        Text(
                          _isEditing ? "Edit Profile" : "Account Info",
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: AppFontWeight.semiBold,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),

                        // Symmetrical Right Action / Placeholder
                        if (_isEditing)
                          InkWell(
                            onTap: () {
                              setState(() {
                                _syncControllers(state);
                                _isEditing = false;
                              });
                            },
                            borderRadius: BorderRadius.circular(12.w),
                            child: Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                              child: Center(
                                child: Icon(Icons.close_rounded, color: Colors.white, size: 22.w),
                              ),
                            ),
                          )
                        else
                          SizedBox(width: 40.w), // Mathematical dead-center balance
                      ],
                    ),
                  ),
                ),

                // 4. Sticky Bottom Action Bar
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
                    child: _isEditing
                        ? Row(
                            children: [
                              // Cancel Button (50% Width)
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _syncControllers(state);
                                      _isEditing = false;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12.w),
                                  child: Container(
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(12.w),
                                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.close_rounded, size: 18.w, color: const Color(0xFF475569)),
                                              SizedBox(width: 6.w),
                                              Text(
                                                "Cancel",
                                                style: GoogleFonts.inter(
                                                  fontWeight: AppFontWeight.bold,
                                                  fontSize: 14.5.w,
                                                  color: const Color(0xFF475569),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),

                              // Save Changes Button (50% Width)
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    final first = _firstNameController.text.trim();
                                    final last = _lastNameController.text.trim();
                                    if (first.isEmpty) {
                                      CustomTopSnackbar.error(context, "First name tidak boleh kosong");
                                      return;
                                    }
                                    context.read<ProfileBloc>().add(
                                          ProfileUpdateRequested(
                                            firstName: first,
                                            lastName: last,
                                          ),
                                        );
                                  },
                                  borderRadius: BorderRadius.circular(12.w),
                                  child: Container(
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.premiumDarkGradient,
                                      borderRadius: BorderRadius.circular(12.w),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF2E1052).withValues(alpha: 0.25),
                                          blurRadius: 8.w,
                                          offset: Offset(0, 4.w),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.check_rounded, size: 18.w, color: Colors.white),
                                              SizedBox(width: 6.w),
                                              Text(
                                                "Save Changes",
                                                style: GoogleFonts.inter(
                                                  fontWeight: AppFontWeight.bold,
                                                  fontSize: 14.5.w,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                _syncControllers(state);
                                _isEditing = true;
                              });
                            },
                            borderRadius: BorderRadius.circular(12.w),
                            child: Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                gradient: AppColors.premiumDarkGradient,
                                borderRadius: BorderRadius.circular(12.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2E1052).withValues(alpha: 0.25),
                                    blurRadius: 8.w,
                                    offset: Offset(0, 4.w),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.edit_rounded, size: 18.w, color: Colors.white),
                                    SizedBox(width: 8.w),
                                    Text(
                                      "Edit Profile",
                                      style: GoogleFonts.inter(
                                        fontWeight: AppFontWeight.bold,
                                        fontSize: 15.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ),

                // 5. Loading Overlay
                if (state.status == ProfileStatus.loading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.35),
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

  // --- Symmetrical View Profile Section ---
  Widget _buildViewProfile(ProfileState state, String displayName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1 Header
        Text(
          "PERSONAL INFORMATION",
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: AppFontWeight.bold,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 12.h),

        _buildInfoRow(
          icon: Icons.person_outline_rounded,
          label: "Full Name",
          value: displayName,
        ),
        Divider(height: 20.h, thickness: 1.w, color: const Color(0xFFF1F5F9)),

        SizedBox(height: 10.h),

        // Section 2 Header
        Text(
          "ACCOUNT CREDENTIALS",
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: AppFontWeight.bold,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 12.h),

        _buildInfoRow(
          icon: Icons.alternate_email_rounded,
          label: "Email Address",
          value: state.email.isEmpty ? "-" : state.email,
        ),
        Divider(height: 20.h, thickness: 1.w, color: const Color(0xFFF1F5F9)),

        _buildInfoRow(
          icon: Icons.shield_outlined,
          label: "Role",
          value: state.role.toUpperCase(),
        ),
        Divider(height: 20.h, thickness: 1.w, color: const Color(0xFFF1F5F9)),

        _buildInfoRow(
          icon: Icons.fingerprint_rounded,
          label: "Account ID",
          value: state.uid,
          isMonospace: true,
        ),
        Divider(height: 20.h, thickness: 1.w, color: const Color(0xFFF1F5F9)),

        _buildInfoRow(
          icon: Icons.verified_user_outlined,
          label: "Google Link",
          value: state.isVerif ? "Linked" : "Not Linked",
          valueColor: state.isVerif ? const Color(0xFF00AA13) : const Color(0xFFED2736),
          isBadge: true,
        ),
      ],
    );
  }

  // --- Symmetrical Edit Form Section ---
  Widget _buildEditForm(ProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Icon(Icons.edit_note_rounded, size: 16.w, color: const Color(0xFF7C3AED)),
            SizedBox(width: 6.w),
            Text(
              "EDIT PERSONAL INFORMATION",
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: AppFontWeight.bold,
                color: const Color(0xFF7C3AED),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        // 50/50 Symmetrical Row for First Name & Last Name
        Row(
          children: [
            Expanded(
              child: _buildFormField(
                label: "First Name",
                controller: _firstNameController,
                hint: "First name",
                icon: Icons.badge_outlined,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildFormField(
                label: "Last Name",
                controller: _lastNameController,
                hint: "Last name",
                icon: Icons.badge_outlined,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        Divider(color: const Color(0xFFF1F5F9), height: 1.h, thickness: 1.w),
        SizedBox(height: 20.h),

        // Read-only section header
        Row(
          children: [
            Icon(Icons.lock_outline_rounded, size: 14.w, color: const Color(0xFF94A3B8)),
            SizedBox(width: 6.w),
            Text(
              "READ-ONLY CREDENTIALS",
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: AppFontWeight.bold,
                color: const Color(0xFF94A3B8),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        // Clean Read-Only Info Rows
        _buildInfoRow(
          icon: Icons.alternate_email_rounded,
          label: "Email Address",
          value: state.email.isEmpty ? "-" : state.email,
        ),
        Divider(height: 20.h, thickness: 1.w, color: const Color(0xFFF1F5F9)),

        _buildInfoRow(
          icon: Icons.shield_outlined,
          label: "Role",
          value: state.role.toUpperCase(),
        ),
        Divider(height: 20.h, thickness: 1.w, color: const Color(0xFFF1F5F9)),

        _buildInfoRow(
          icon: Icons.fingerprint_rounded,
          label: "Account ID",
          value: state.uid,
          isMonospace: true,
        ),
        Divider(height: 20.h, thickness: 1.w, color: const Color(0xFFF1F5F9)),

        _buildInfoRow(
          icon: Icons.verified_user_outlined,
          label: "Google Link",
          value: state.isVerif ? "Linked" : "Not Linked",
          valueColor: state.isVerif ? const Color(0xFF00AA13) : const Color(0xFFED2736),
          isBadge: true,
        ),
      ],
    );
  }

  // --- Reusable Form Field with Consistent Height & Symmetric Bounds ---
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: AppFontWeight.medium,
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 16.w, color: const Color(0xFF94A3B8)),
              SizedBox(width: 8.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: AppFontWeight.semiBold,
                    color: const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13.5.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Reusable Info Row with Balanced 2-Column Alignment ---
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isMonospace = false,
    Color? valueColor,
    bool isBadge = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Column: Icon + Label
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8.w),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8.w),
                ),
                child: Center(
                  child: Icon(icon, size: 16.w, color: const Color(0xFF64748B)),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: AppFontWeight.medium,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),

          // Right Column: Value Text or Solid Pill Badge
          Flexible(
            child: isBadge
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: (valueColor ?? const Color(0xFF00AA13)).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.w),
                      border: Border.all(
                        color: (valueColor ?? const Color(0xFF00AA13)).withValues(alpha: 0.3),
                        width: 1.w,
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: valueColor ?? const Color(0xFF00AA13),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            value,
                            style: GoogleFonts.inter(
                              fontSize: 11.w,
                              fontWeight: AppFontWeight.bold,
                              color: valueColor ?? const Color(0xFF00AA13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Text(
                    value,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: isMonospace
                        ? GoogleFonts.jetBrainsMono(
                            fontSize: 12.5.sp,
                            fontWeight: AppFontWeight.medium,
                            color: valueColor ?? const Color(0xFF0F172A),
                          )
                        : GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: AppFontWeight.semiBold,
                            color: valueColor ?? const Color(0xFF0F172A),
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
