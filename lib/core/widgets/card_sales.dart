import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';

class CardSales extends StatelessWidget {
  CardSales({
    super.key,
    required this.idBarang,
    required this.namaBarang,
    required this.financeApproved,
    required this.createdOn,
    required this.nameUser,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.nameCustomer,
    required this.imageProduct,
    this.discountPercent,
    this.discountMax,
    this.finance,
    this.isRejected,
    this.rejectionReason,
    this.onPayPressed,
  });

  final dynamic idBarang;
  final dynamic namaBarang;
  final dynamic financeApproved;
  final dynamic createdOn;
  final dynamic nameUser;
  final dynamic quantity;
  final dynamic unitPrice;
  final dynamic lineTotal;
  final dynamic nameCustomer;
  final dynamic imageProduct;
  final dynamic finance;
  final int? discountPercent;
  final int? discountMax;
  final bool? isRejected;
  final String? rejectionReason;
  final VoidCallback? onPayPressed;

  final convertDollar = ConvertDollar();

  String _formatDate(dynamic dateStr) {
    if (dateStr == null) return "-";
    final s = dateStr.toString().trim();
    if (s.isEmpty) return "-";
    try {
      final dt = DateTime.tryParse(s);
      if (dt != null) {
        const months = [
          "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
          "Jul", "Agu", "Sep", "Okt", "Nov", "Des"
        ];
        return "${dt.day} ${months[dt.month - 1]} ${dt.year}";
      }
    } catch (_) {}
    if (s.contains(" ")) return s.split(" ")[0];
    if (s.contains("T")) return s.split("T")[0];
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final bool rejected = isRejected == true;
    final bool isApproved = financeApproved == true;
    final bool isFinance = finance == true;
    final bool isPayable = !rejected && !isApproved && isFinance && onPayPressed != null;

    int finalDiscountPercent = discountPercent ?? 0;
    int finalDiscountMax = discountMax ?? 0;

    int originalPrice = lineTotal is int ? lineTotal : (int.tryParse(lineTotal.toString()) ?? 0);
    int finalLineTotal = originalPrice;
    if (finalDiscountPercent > 0) {
      originalPrice = (finalLineTotal / (1 - (finalDiscountPercent / 100.0))).round();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.w,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // LEFT IMAGE (Flush with the left corners) with Qty Pill Badge
            Stack(
              children: [
                Container(
                  width: 105.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.w),
                      bottomLeft: Radius.circular(10.w),
                    ),
                    color: const Color(0xFFF8FAFC),
                    image: DecorationImage(
                      image: (imageProduct == null || imageProduct.toString().isEmpty)
                          ? const AssetImage("assets/images/dummy_item.jpg")
                          : NetworkImage(imageProduct.toString()) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8.w,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(6.w),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 0.8.w,
                      ),
                    ),
                    child: Text(
                      "$quantity pcs",
                      style: GoogleFonts.inter(
                        fontSize: 9.5.w,
                        fontWeight: AppFontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // RIGHT CONTENT
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      namaBarang?.toString() ?? "-",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: AppFontWeight.bold,
                        color: const Color(0xFF1C1C1C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),

                    // Subtitle: To company and Date
                    Row(
                      children: [
                        Icon(Icons.business_center_outlined, size: 14.w, color: const Color(0xFF6B7280)),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "To: ${nameCustomer ?? '-'} • ${_formatDate(createdOn)}",
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: AppFontWeight.medium,
                              color: const Color(0xFF6B7280),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),

                    // Discount Pill (if exists)
                    if (finalDiscountPercent > 0)
                      Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(6.w),
                          ),
                          child: Text(
                            "Diskon $finalDiscountPercent%, maks. ${(finalDiscountMax / 1000).toInt()}rb",
                            style: GoogleFonts.inter(
                              fontSize: 9.5.sp,
                              fontWeight: AppFontWeight.bold,
                              color: const Color(0xFFB45309),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                    // Price & Action Row (Pay Now / Paid / Unpaid)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Left: Prices (Stacked Vertically if Discounted)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (finalDiscountPercent > 0) ...[
                                Text(
                                  convertDollar.intToDollar(originalPrice),
                                  style: GoogleFonts.inter(
                                    fontSize: 10.w,
                                    fontWeight: AppFontWeight.medium,
                                    color: const Color(0xFF9CA3AF),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  maxLines: 1,
                                ),
                                SizedBox(height: 1.h),
                              ],
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  convertDollar.intToDollar(finalLineTotal),
                                  style: GoogleFonts.inter(
                                    fontSize: 13.5.w,
                                    fontWeight: AppFontWeight.bold,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),

                        // Right: Pay Now Button (Finance) or Status Badge (Warehouse / Status)
                        if (isFinance && rejected)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(8.w),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.block_rounded, size: 12.w, color: const Color(0xFF64748B)),
                                SizedBox(width: 4.w),
                                Text(
                                  "REJECTED",
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5.w,
                                    fontWeight: AppFontWeight.bold,
                                    color: const Color(0xFF64748B),
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (isPayable)
                          GestureDetector(
                            onTap: onPayPressed,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                gradient: AppColors.premiumDarkGradient,
                                borderRadius: BorderRadius.circular(8.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2E1052).withValues(alpha: 0.25),
                                    offset: Offset(0, 2.w),
                                    blurRadius: 4.w,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.payment_rounded, size: 12.w, color: Colors.white),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Pay Now",
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5.w,
                                      fontWeight: AppFontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: rejected
                                  ? const Color(0xFFDC2626)
                                  : isApproved
                                      ? const Color(0xFF00AA13)
                                      : const Color(0xFFED2736),
                              borderRadius: BorderRadius.circular(8.w),
                            ),
                            child: Text(
                              rejected
                                  ? "REJECTED"
                                  : isApproved
                                      ? "PAID"
                                      : "UNPAID",
                              style: GoogleFonts.inter(
                                fontSize: 9.5.w,
                                fontWeight: AppFontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
