import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:get/get.dart';

class CardDashboard extends StatelessWidget {
  CardDashboard(
      {super.key, required this.nameBox, required this.description, required this.totalItems, required this.urgent});

  final nameBox, description, urgent;
  RxInt totalItems;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowBox,
                        spreadRadius: -3.w,
                        offset: Offset(0, 4),
                        blurRadius: 21.w,
                      )
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 113.w,
                      child: Text(
                        nameBox,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: AppFontWeight.medium,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: AppFontWeight.medium,
                        color: AppColors.coolGray,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          return Text(
                            nameBox == "Total Qty" ? "${totalItems
                                .toString()} Items" : "${totalItems
                                .toString()} units",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: AppFontWeight.medium,
                              color: AppColors.charcoal,
                            ),
                          );
                        }),
                        Obx(() {
                          if(totalItems.value <= 10 && urgent){
                            return Container(
                              width: 37.44.w,
                              height: 14.62.h,
                              decoration: BoxDecoration(
                                  color: Color(0xFFD6F4FF),
                                  borderRadius: BorderRadius.circular(10.w)
                              ),
                              child: Center(
                                child: Text(
                                  "Now",
                                  style: GoogleFonts.inter(
                                    fontSize: 10.sp,
                                    fontWeight: AppFontWeight.medium,
                                    color: Color(0xFF01BAFF),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          };
                        }),
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
                color: Color(0xFFF2F2F2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowBox2,
                    spreadRadius: 2.w,
                    offset: Offset(0, 4),
                    blurRadius: 8.2.w,
                  )
                ],
                border: Border.all(color: Colors.white, width: 2.w),
              ),
              child: Center(
                child: Container(
                  width: 17.88.w,
                  height: 17.88.h,
                  child: Image.asset("assets/icons/order.png"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
