import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/features/dashboard/presentation/finance/dashboard_finance_view_model.dart';

class CardFinanceBox extends StatelessWidget {
  CardFinanceBox(
      {super.key, required this.categoryItems, required this.settled, required this.accountPayables, required this.accountReceiables});

  final categoryItems, settled, accountPayables, accountReceiables;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 347.w,
      height: 180.08.h,
      padding: EdgeInsets.only(top: 20.38.h, bottom: 17.2.h, left: 19.w),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/overlays.png"),
              fit: BoxFit.cover
          ),
          color: AppColors.electricBlue,
          gradient: LinearGradient(
            colors: [
              AppColors.blueGradient2,
              AppColors.purpleGradient2_1,
              AppColors.purpleGradient2_2,
            ],
            stops: [0.0, 0.59, 1.0],
            transform: GradientRotation(80.r),
          ),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(90.w),
              topLeft: Radius.circular(10.w),
              bottomRight: Radius.circular(10.w),
              bottomLeft: Radius.circular(10.w)
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          SvgPicture.asset(
            "assets/icons/vector.svg", width: 18.w, height: 18.w,),
          Container(
            height: 112.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text(
                      "Summary Finance",
                      style: GoogleFonts.inter(
                          fontWeight: AppFontWeight.semiBold,
                          color: Colors.white,
                          fontSize: 16.sp
                      ),
                    ),
                  ],
                ),
                Column(
                  spacing: 12.w,
                  children: [
                    Row(
                      spacing: 19.w,
                      children: [
                        Container(
                          width: 118.w,
                          child: Row(
                            spacing: 12.w,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/rectangle_gradient.svg",
                                width: 4.w, height: 26.h,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Inventory Value",
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      fontWeight: AppFontWeight.light,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Obx(() {
                                    return Text(
                                      ConvertDollar().intToDollar(
                                          categoryItems.value),
                                      style: GoogleFonts.inter(
                                        fontSize: 11.sp,
                                        fontWeight: AppFontWeight.medium,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 118.w,
                          child: Row(
                            spacing: 12.w,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/rectangle_gradient.svg",
                                width: 4.w, height: 26.h,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Settled",
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      fontWeight: AppFontWeight.light,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Obx(() {
                                    return Text(
                                      ConvertDollar().intToDollar(settled.value),
                                      style: GoogleFonts.inter(
                                        fontSize: 11.sp,
                                        fontWeight: AppFontWeight.medium,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      spacing: 19.w,
                      children: [
                        Container(
                          width: 118.w,
                          child: Row(
                            spacing: 12.w,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/rectangle_gradient.svg",
                                width: 4.w, height: 26.h,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Account Payables",
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      fontWeight: AppFontWeight.light,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Obx(() {
                                    return Text(
                                      ConvertDollar().intToDollar(
                                          accountPayables.value),
                                      style: GoogleFonts.inter(
                                        fontSize: 11.sp,
                                        fontWeight: AppFontWeight.medium,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 130.w,
                          child: Row(
                            spacing: 12.w,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/rectangle_gradient.svg",
                                width: 4.w, height: 26.h,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Account Receivables",
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      fontWeight: AppFontWeight.light,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Obx(() {
                                    return Text(
                                      ConvertDollar().intToDollar(
                                          accountReceiables.value),
                                      style: GoogleFonts.inter(
                                        fontSize: 11.sp,
                                        fontWeight: AppFontWeight.medium,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
