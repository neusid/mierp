import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';

/// Shows an executive, fintech-grade bottom sheet confirmation modal with complete order details.
Future<void> showPayConfirmationModal({
  required BuildContext context,
  String? orderId,
  String? productName,
  String? productCode,
  String? imageProduct,
  int? quantity,
  int? unitPrice,
  int? totalCost,
  String? amount,
  int? discountPercent,
  int? discountMax,
  String? requestedBy,
  String? orderDate,
  required VoidCallback onConfirm,
}) {
  final convertDollar = ConvertDollar();
  final int discPercent = discountPercent ?? 0;
  final String displayTotal = totalCost != null
      ? convertDollar.intToDollar(totalCost)
      : (amount ?? "\$0");

  final String safeOrderId = orderId ?? "";
  final String safeProductName = (productName != null && productName.isNotEmpty)
      ? productName
      : (safeOrderId.isNotEmpty ? "Order #$safeOrderId" : "Invoice Order");

  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (bottomSheetContext) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.w),
          topRight: Radius.circular(24.w),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 28.w,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: SafeArea(
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
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // 2. HEADER: Title & Finance Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        gradient: AppColors.premiumDarkGradient,
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        color: Colors.white,
                        size: 20.w,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Konfirmasi Pembayaran",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          safeOrderId.isNotEmpty ? "Invoice #$safeOrderId" : "Invoice Order",
                          style: GoogleFonts.inter(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // GOJEK-STYLE SOLID PILL BADGE
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  child: Text(
                    "FINANCE",
                    style: GoogleFonts.inter(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF7C3AED),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // 3. PRODUCT ITEM PREVIEW CARD
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14.w),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
              ),
              child: Row(
                children: [
                  // Product Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.w),
                    child: Container(
                      width: 54.w,
                      height: 54.w,
                      color: const Color(0xFFF1F5F9),
                      child: (imageProduct != null && imageProduct.isNotEmpty)
                          ? Image.network(
                              imageProduct,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.inventory_2_outlined,
                                color: Color(0xFF94A3B8),
                              ),
                            )
                          : const Icon(
                              Icons.inventory_2_outlined,
                              color: Color(0xFF94A3B8),
                            ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          safeProductName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        if (productCode != null && productCode.isNotEmpty)
                          Text(
                            productCode,
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              size: 13.w,
                              color: const Color(0xFF94A3B8),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                "Oleh: ${requestedBy ?? 'Warehouse'}${orderDate != null ? ' • $orderDate' : ''}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 10.5.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            // 4. COST & CALCULATION BREAKDOWN
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.w),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
              ),
              child: Column(
                children: [
                  if (unitPrice != null) ...[
                    _buildCostRow("Harga Satuan", convertDollar.intToDollar(unitPrice)),
                    SizedBox(height: 8.h),
                  ],
                  if (quantity != null) ...[
                    _buildCostRow("Jumlah Barang", "$quantity Unit"),
                  ],
                  if (discPercent > 0 && unitPrice != null && quantity != null) ...[
                    SizedBox(height: 8.h),
                    _buildCostRow(
                      "Diskon ($discPercent%)",
                      "- ${convertDollar.intToDollar(((unitPrice * quantity) * discPercent / 100).round())}",
                      valueColor: const Color(0xFF16A34A),
                    ),
                  ],
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Divider(color: const Color(0xFFE2E8F0), height: 1.h, thickness: 1.w),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Pembayaran",
                        style: GoogleFonts.inter(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        displayTotal,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF7C3AED),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // 5. ACTION BUTTONS: Batal & Konfirmasi Bayar
            Row(
              children: [
                // Tombol Batal
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(bottomSheetContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                    ),
                    child: Text(
                      "Batal",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: const Color(0xFF475569),
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Tombol Konfirmasi Bayar
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      onConfirm();
                    },
                    child: Container(
                      height: 46.h,
                      decoration: BoxDecoration(
                        gradient: AppColors.premiumDarkGradient,
                        borderRadius: BorderRadius.circular(12.w),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                            blurRadius: 10.w,
                            offset: Offset(0, 3.h),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Konfirmasi Bayar",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
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

Widget _buildCostRow(String label, String value, {Color? valueColor}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF64748B),
        ),
      ),
      Text(
        value,
        style: GoogleFonts.inter(
          fontSize: 12.5.sp,
          fontWeight: FontWeight.w600,
          color: valueColor ?? const Color(0xFF1E293B),
        ),
      ),
    ],
  );
}
