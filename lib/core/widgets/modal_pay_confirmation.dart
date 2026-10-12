import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';

/// Shows a standardized MiERP confirmation modal before executing an invoice payment.
Future<void> showPayConfirmationModal({
  required BuildContext context,
  String? orderId,
  String? amount,
  required VoidCallback onConfirm,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (bottomSheetContext) => Center(
      child: Container(
        width: 320.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24.w,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Badge
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.premiumDarkSolid.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.payments_rounded,
                color: AppColors.premiumDarkSolid,
                size: 34.w,
              ),
            ),
            SizedBox(height: 16.h),

            // Title
            Text(
              "Pay Invoice?",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: const Color(0xFF0F172A),
                fontWeight: AppFontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),

            // Subtitle Description
            Text(
              "Are you sure you want to approve and settle payment for this invoice? This transaction will be recorded in the ledger.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: const Color(0xFF64748B),
                fontWeight: AppFontWeight.regular,
                height: 1.4,
              ),
            ),

            // Order & Amount details pill if available
            if (orderId != null || amount != null) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10.w),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (orderId != null)
                      Expanded(
                        child: Text(
                          "Order #$orderId",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: const Color(0xFF64748B),
                            fontWeight: AppFontWeight.medium,
                          ),
                        ),
                      ),
                    if (amount != null)
                      Text(
                        amount,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: const Color(0xFF0F172A),
                          fontWeight: AppFontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 24.h),

            // Action Buttons
            Row(
              children: [
                // Cancel
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(bottomSheetContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: const Color(0xFF475569),
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Confirm Pay
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      onConfirm();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        gradient: AppColors.premiumDarkGradient,
                        borderRadius: BorderRadius.circular(12.w),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.premiumDarkSolid.withValues(alpha: 0.25),
                            blurRadius: 8.w,
                            offset: Offset(0, 3.w),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Confirm",
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            color: Colors.white,
                            fontWeight: AppFontWeight.bold,
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
