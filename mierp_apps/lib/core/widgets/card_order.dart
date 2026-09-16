import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';

class CardOrder extends StatelessWidget {
  CardOrder({
    super.key,
    required this.idOrder,
    required this.idBarang,
    required this.namaBarang,
    required this.financeApproved,
    required this.createdOn,
    required this.nameUser,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.imageProduct,
    this.finance,
    required this.onPayPressed,
  });

  final idOrder,
      idBarang,
      namaBarang,
      financeApproved,
      createdOn,
      nameUser,
      quantity,
      unitPrice,
      lineTotal,
      imageProduct,
      finance;
  final converDollar = ConvertDollar();
  final VoidCallback onPayPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 342.w,
      height: 140.h,
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
      child: Center(
        child: Container(
          width: 317.w,
          height: 113.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50.18.w,
                    height: 50.18.h,
                    decoration: BoxDecoration(
                      // color: Color(0xFFF1F4FF),
                      image: DecorationImage(
                        image: imageProduct == null
                            ? AssetImage("assets/images/dummy_item.jpg")
                            : NetworkImage(imageProduct),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Container(
                    width: 250.w,
                    height: 50.18.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                idBarang,
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: AppFontWeight.light,
                                  color: AppColors.gray,
                                ),
                              ),
                            ),
                            Container(
                              width: 86.w,
                              height: 15.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.w),
                                ),
                                color: AppColors.purpleShadow,
                              ),
                              child: Center(
                                child: Text(
                                  "Account Payables",
                                  style: GoogleFonts.inter(
                                    fontSize: 7.sp,
                                    fontWeight: AppFontWeight.regular,
                                    color: AppColors.electricBlue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                namaBarang,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: AppFontWeight.regular,
                                  color: AppColors.gray,
                                ),
                              ),
                            ),
                            Container(
                              width: 47.w,
                              height: 14.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.w),
                                ),
                                color: financeApproved
                                    ? AppColors.mintGreen
                                    : AppColors.softCream,
                              ),
                              child: Center(
                                child: Text(
                                  financeApproved ? "Paid" : "Unpaid",
                                  style: GoogleFonts.inter(
                                    fontSize: 7.sp,
                                    fontWeight: AppFontWeight.regular,
                                    color: financeApproved
                                        ? AppColors.neonGreen
                                        : AppColors.vibrantOrange,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "Created on",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 8.sp,
                                  fontWeight: AppFontWeight.regular,
                                  color: AppColors.gray,
                                ),
                              ),
                            ),
                            Text(
                              createdOn.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 8.sp,
                                fontWeight: AppFontWeight.light,
                                color: AppColors.charcoal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 13.w),
              DottedLine(
                direction: Axis.horizontal,
                dashColor: AppColors.grayDashline,
                lineLength: 317.w,
                lineThickness: 2.w,
                dashLength: 5.w,
                dashGapLength: 5.w,
              ),
              SizedBox(height: 13.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "From",
                            style: GoogleFonts.inter(
                              fontSize: 8.sp,
                              fontWeight: AppFontWeight.light,
                              color: AppColors.gray,
                            ),
                          ),
                          Text(
                            //"Warehouse",
                            nameUser,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: AppFontWeight.medium,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 23.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            converDollar.intToDollar(unitPrice),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            converDollar.intToDollar(lineTotal),
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
                    width: 80.w,
                    height: 24.81.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        backgroundColor: !financeApproved && finance != null
                            ? AppColors.electricBlue
                            : AppColors.coolGray,
                        padding: EdgeInsets.all(0),
                      ),
                      onPressed: !financeApproved && finance != null
                          ? onPayPressed
                          : null,
                      child: Center(
                        child: Text(
                          "Pay Invoice",
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            color: Colors.white,
                            fontWeight: AppFontWeight.medium,
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
}
