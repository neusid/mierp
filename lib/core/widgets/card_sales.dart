import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
  });

  final idBarang,
      namaBarang,
      financeApproved,
      createdOn,
      nameUser,
      quantity,
      unitPrice,
      lineTotal,
      nameCustomer,
      imageProduct;

  final int? discountPercent;
  final int? discountMax;

  final convertDollar = ConvertDollar();

  @override
  Widget build(BuildContext context) {
    int finalDiscountPercent = discountPercent ?? 0;
    int finalDiscountMax = discountMax ?? 0;
    
    // Original price calculation
    int originalPrice = lineTotal;
    if (finalDiscountPercent > 0) {
      // If there's a discount, original price was higher
      originalPrice = (lineTotal / (1 - (finalDiscountPercent / 100.0))).round();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9.w),
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
            // LEFT IMAGE (Flush with the left corners)
            Container(
              width: 110.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(9.w),
                  bottomLeft: Radius.circular(9.w),
                ),
                color: const Color(0xFFF8FAFC),
                image: DecorationImage(
                  image: (imageProduct == null || imageProduct.toString().isEmpty)
                      ? const AssetImage("assets/images/dummy_item.jpg")
                      : NetworkImage(imageProduct) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
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
                      namaBarang,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: AppFontWeight.bold,
                        color: const Color(0xFF1C1C1C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    
                    // Subtitle: To company and Date
                    Row(
                      children: [
                        Icon(Icons.business_center_outlined, size: 14.w, color: const Color(0xFF6B7280)),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "To: $nameCustomer • $createdOn",
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
                    
                    // Paid/Unpaid Badge + Prices
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: financeApproved ? const Color(0xFF00AA13) : const Color(0xFFED2736),
                            borderRadius: BorderRadius.circular(9.w),
                          ),
                          child: Text(
                            financeApproved ? "PAID" : "UNPAID",
                            style: GoogleFonts.inter(
                              fontSize: 9.sp,
                              fontWeight: AppFontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        
                        if (finalDiscountPercent > 0) ...[
                          // Original Price (Strikethrough)
                          Text(
                            convertDollar.intToDollar(originalPrice),
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: AppFontWeight.medium,
                              color: const Color(0xFF9CA3AF),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 4.w),
                        ],
                        
                        // Final Price + Qty
                        Expanded(
                          child: Text(
                            "${convertDollar.intToDollar(lineTotal)} · Qty: $quantity",
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: AppFontWeight.semiBold,
                              color: const Color(0xFF1F2937),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    
                    // Bottom Section: Discount Pill
                    if (finalDiscountPercent > 0)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7), // Light Orange
                            borderRadius: BorderRadius.circular(9.w),
                          ),
                          child: Text(
                            "Diskon $finalDiscountPercent%, maks. ${(finalDiscountMax / 1000).toInt()}rb",
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: AppFontWeight.bold,
                              color: const Color(0xFFB45309), // Brown Orange
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    else
                      const Spacer(),
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
