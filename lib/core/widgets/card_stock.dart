import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';

class CardStock extends StatelessWidget {
  const CardStock({
    super.key,
    required this.idBarang,
    required this.namaBarang,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.type,
    required this.image,
    this.createdOn,
  });

  final dynamic idBarang;
  final dynamic namaBarang;
  final dynamic quantity;
  final dynamic unitPrice;
  final dynamic lineTotal;
  final dynamic type;
  final dynamic image;
  final String? createdOn;

  @override
  Widget build(BuildContext context) {
    final convertDollar = ConvertDollar();
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
            // LEFT IMAGE (Flush with the left corners) with Category Frosted Pill Badge
            Stack(
              children: [
                Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9.w),
                      bottomLeft: Radius.circular(9.w),
                    ),
                    color: const Color(0xFFF8FAFC),
                    image: DecorationImage(
                      image: (image == null || image.toString().isEmpty)
                          ? const AssetImage("assets/images/dummy_item.jpg")
                          : NetworkImage(image.toString()) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (type != null && type.toString().trim().isNotEmpty)
                  Positioned(
                    top: 8.w,
                    left: 8.w,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 84.w),
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(6.w),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 0.8.w,
                        ),
                      ),
                      child: Text(
                        type.toString().trim().toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 8.sp,
                          fontWeight: AppFontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
            
            // RIGHT CONTENT
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Middle: Clean Typography Body
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            namaBarang,
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: AppFontWeight.bold,
                              color: const Color(0xFF1C1C1C),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            idBarang,
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: AppFontWeight.medium,
                              color: const Color(0xFF94A3B8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          if (createdOn != null && createdOn!.isNotEmpty) ...[
                            Row(
                              children: [
                                Icon(Icons.calendar_today_outlined, size: 10.w, color: const Color(0xFF64748B)),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    "Added: $createdOn",
                                    style: GoogleFonts.inter(
                                      fontSize: 9.sp,
                                      fontWeight: AppFontWeight.medium,
                                      color: const Color(0xFF64748B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                          ],
                          Text(
                            "${convertDollar.intToDollar(unitPrice)}  •  Total: ${convertDollar.intToDollar(lineTotal)}",
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: AppFontWeight.medium,
                              color: const Color(0xFF64748B),
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(width: 8.w),
                    
                    // Right: Pill Badge for Quantity
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF), // MiERP Purple Light
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            quantity.toString(),
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: AppFontWeight.bold,
                              color: const Color(0xFF7C3AED), // MiERP Purple Deep
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            "Qty",
                            style: GoogleFonts.inter(
                              fontSize: 8.5.sp,
                              fontWeight: AppFontWeight.semiBold,
                              color: const Color(0xFF7C3AED),
                            ),
                          ),
                        ],
                      ),
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
