
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';

class CardDashboard extends StatelessWidget {
  CardDashboard(
      {super.key, required this.nameBox, required this.description, required this.totalItems, required this.urgent});

  final nameBox, description, urgent;
  int totalItems;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 162.w,
      height: 124.h,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 14.w,
              ),
              Container(
                width: 162.w,
                height: 109.h,
                padding: EdgeInsets.only(top: 14.h, left: 17.w, right: 17.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.w),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 113.w,
                      child: Text(
                        nameBox,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: AppFontWeight.medium,
                          color: const Color(0xFF0F172A), // Slate 900
                        ),
                      ),
                    ),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: AppFontWeight.medium,
                        color: const Color(0xFF64748B), // Slate 500
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                              nameBox == "Total Qty" ? "${totalItems.toString()} Items" : "${totalItems.toString()} units",
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: AppFontWeight.semiBold,
                                color: const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ),
                        if(totalItems <= 10 && urgent == true)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                                color: const Color(0xFFED2736), // Mingda Solid Red
                                borderRadius: BorderRadius.circular(6.w)
                            ),
                            child: Center(
                              child: Text(
                                "Now",
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: AppFontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        else
                          SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 108.w,
            child: Container(
              width: 34.w,
              height: 34.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.w),
                color: const Color(0xFFF8FAFC), // Slate 50
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5.w),
              ),
              child: Center(
                child: SizedBox(
                  width: 17.88.w,
                  height: 17.88.h,
                  child: Image.asset("assets/icons/order.png", color: AppColors.electricBlue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
