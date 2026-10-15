import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uicons/uicons.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';

/// An executive confirmation bottom sheet adhering strictly to MIErp's
/// signature Obsidian Black and Ungu design tokens.
class ModalDeleteConfirmation extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final String? accountName;
  final String? accountEmail;
  final String? roleBadge;
  final VoidCallback onConfirm;

  const ModalDeleteConfirmation({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = "Hapus",
    this.cancelText = "Batal",
    this.accountName,
    this.accountEmail,
    this.roleBadge,
    required this.onConfirm,
  });

  /// Displays the confirmation modal bottom sheet.
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = "Hapus",
    String cancelText = "Batal",
    String? accountName,
    String? accountEmail,
    String? roleBadge,
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ModalDeleteConfirmation(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        accountName: accountName,
        accountEmail: accountEmail,
        roleBadge: roleBadge,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasAccountInfo = (accountName != null && accountName!.trim().isNotEmpty) ||
        (accountEmail != null && accountEmail!.trim().isNotEmpty);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 28.r,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. DRAG HANDLE
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.5.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),

              // 2. HEADER (Obsidian & Ungu signature badge)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumDarkGradient,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.premiumDarkSolid.withValues(alpha: 0.22),
                          blurRadius: 8.r,
                          offset: Offset(0, 3.h),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        UIcons.regularRounded.trash,
                        color: Colors.white,
                        size: 20.w,
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
                            fontSize: 16.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          message,
                          style: GoogleFonts.inter(
                            fontSize: 12.5.sp,
                            height: 1.4,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // 3. TARGET ACCOUNT DETAILS CARD (If provided)
              if (hasAccountInfo) ...[
                SizedBox(height: 16.h),
                _buildTargetAccountCard(),
              ],

              SizedBox(height: 22.h),

              // 4. ACTION BUTTONS (Batal & Konfirmasi)
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 46.h,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFF8FAFC),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: Text(
                          cancelText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: AppFontWeight.semiBold,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 46.h,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumDarkGradient,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.premiumDarkSolid.withValues(alpha: 0.28),
                              blurRadius: 10.w,
                              offset: Offset(0, 3.h),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              Navigator.of(context).maybePop();
                              onConfirm();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    size: 17.w,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6.w),
                                  Flexible(
                                    child: Text(
                                      confirmText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 13.5.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetAccountCard() {
    String initials = "U";
    if (accountName != null && accountName!.trim().isNotEmpty) {
      final parts = accountName!.trim().split(RegExp(r'\s+'));
      if (parts.length > 1) {
        initials = (parts[0][0] + parts[1][0]).toUpperCase();
      } else {
        initials = parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
      }
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              gradient: AppColors.premiumDarkGradient,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text(
                initials,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (accountName != null && accountName!.isNotEmpty)
                  Text(
                    accountName!,
                    style: GoogleFonts.inter(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (accountEmail != null && accountEmail!.isNotEmpty)
                  Text(
                    accountEmail!,
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      color: const Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (roleBadge != null && roleBadge!.isNotEmpty) ...[
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.purpleTransparent,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: AppColors.lavenderMist, width: 1.w),
              ),
              child: Text(
                roleBadge!.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.vividPurple,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
