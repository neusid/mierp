import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';

class CardStock extends StatelessWidget {
  CardStock({
    super.key,
    required this.idBarang,
    required this.namaBarang,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.type,
    required this.image,
  });

  final idBarang, namaBarang, quantity, unitPrice, lineTotal, type, image;

  final convertDollar = ConvertDollar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 342.w,
          height: 107.h,
          padding: EdgeInsets.all(13.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowBox,
                spreadRadius: -3.w,
                offset: Offset(0, 4),
                blurRadius: 21.w,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 318.w,
                height: 79.h,
                child: Center(
                  child: Row(
                    children: [
                      Container(
                        width: 69.w,
                        height: 69.h,
                        decoration: BoxDecoration(
                          // color: Color(0xFFF1F4FF),
                          image: DecorationImage(
                            image: image == null
                                ? AssetImage("assets/images/google.png")
                                : NetworkImage(image),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                      ),
                      SizedBox(width: 19.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            idBarang,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: AppFontWeight.light,
                              color: AppColors.gray,
                            ),
                          ),
                          Container(
                            width: 180.w,
                            child: Text(
                              namaBarang,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: AppFontWeight.regular,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.w),
                          DottedLine(
                            direction: Axis.horizontal,
                            dashColor: AppColors.grayDashline,
                            lineLength: 225.w,
                            lineThickness: 2.w,
                            dashLength: 5.w,
                            dashGapLength: 5.w,
                          ),
                          SizedBox(height: 6.w),
                          Container(
                            width: 225.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Quantity",
                                          style: GoogleFonts.inter(
                                            fontSize: 8.sp,
                                            fontWeight: AppFontWeight.light,
                                            color: AppColors.gray,
                                          ),
                                        ),
                                        Text(
                                          quantity.toString(),
                                          style: GoogleFonts.inter(
                                            fontSize: 10.sp,
                                            fontWeight: AppFontWeight.regular,
                                            color: AppColors.gray,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 9.w),
                                    Column(
                                      children: [
                                        Text(
                                          "Unit Price",
                                          style: GoogleFonts.inter(
                                            fontSize: 8.sp,
                                            fontWeight: AppFontWeight.light,
                                            color: AppColors.gray,
                                          ),
                                        ),
                                        Text(
                                          convertDollar.intToDollar(unitPrice),
                                          style: GoogleFonts.inter(
                                            fontSize: 10.sp,
                                            fontWeight: AppFontWeight.regular,
                                            color: AppColors.gray,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 9.w),
                                    Column(
                                      children: [
                                        Text(
                                          "Line Total",
                                          style: GoogleFonts.inter(
                                            fontSize: 8.sp,
                                            fontWeight: AppFontWeight.light,
                                            color: AppColors.gray,
                                          ),
                                        ),
                                        Text(
                                          convertDollar.intToDollar(lineTotal),
                                          style: GoogleFonts.inter(
                                            fontSize: 10.sp,
                                            fontWeight: AppFontWeight.regular,
                                            color: AppColors.gray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 54.w,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.w),
                                    color: AppColors.coolGray,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "View More",
                                        style: GoogleFonts.inter(
                                          fontSize: 6.sp,
                                          color: AppColors.grayThin,
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 6.w,
                                        color: AppColors.grayThin,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: 60.w,
            height: 20.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(10.w)),
              color: AppColors.purpleTransparent,
            ),
            child: Center(
              child: Text(
                type,
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  fontWeight: AppFontWeight.regular,
                  color: AppColors.blueBold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
