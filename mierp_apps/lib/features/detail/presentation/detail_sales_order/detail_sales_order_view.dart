import 'package:dotted_line/dotted_line.dart' as detail_sales_order_view;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/controller/move_page_controller.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/features/detail/presentation/detail_sales_order/detail_sales_order_view_model.dart';

class DetailSalesOrderView extends StatelessWidget {
  DetailSalesOrderView({super.key});

  final movePageC = Get.find<MovePageController>();
  final loadingC = Get.find<LoadingController>();
  final detailSalesOrderVM = Get.find<DetailSalesOrderViewModel>();
  final convertDollar = ConvertDollar();

  @override
  Widget build(BuildContext context) {
    ever(detailSalesOrderVM.success, (callback) {
      if (detailSalesOrderVM.success.value == true) {
        Get.snackbar("Success", "Success pay invoice");
        detailSalesOrderVM.success.value = false;
        // detailSalesOrderVM.requestSingleSalesOrder();
      }
    });

    ever(detailSalesOrderVM.errorMessage, (msg) {
      Get.snackbar("Failed", msg);
      detailSalesOrderVM.success.value = false;
      detailSalesOrderVM.errorMessage.value = "";
    });

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          Obx(() {
            if (detailSalesOrderVM.salesOrder.value == null) {
              return Container(
                color: Colors.black12,
                child: Center(
                  child: LoadingAnimationWidget.stretchedDots(
                    color: AppColors.softWhite,
                    size: 70.w,
                  ),
                ),
              );
            }
            return Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 346.w,
                    height: 400.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.w),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowBox2,
                          spreadRadius: 0,
                          blurRadius: 9.w,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(
                      top: 22.h,
                      left: 27.w,
                      right: 27.w,
                      bottom: 14.h,
                    ),
                    child: Obx(() {
                      return Column(
                        spacing: 10.h,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 28.w,
                            children: [
                              Container(
                                width: 183.w,
                                height: 77.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      detailSalesOrderVM
                                          .salesOrder
                                          .value!
                                          .productName,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.gray,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                    Text(
                                      detailSalesOrderVM
                                          .salesOrder
                                          .value!
                                          .productCode,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.coolGray,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    detailSalesOrderVM
                                                .salesOrder
                                                .value!
                                                .financeApproved! ==
                                            true
                                        ? Container(
                                            width: double.infinity,
                                            height: 24.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.mintGreen,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "PAID",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12.sp,
                                                  color: AppColors.neonGreen,
                                                  fontWeight:
                                                      AppFontWeight.regular,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: double.infinity,
                                            height: 24.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.softCream,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "UNPAID",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                  fontSize: 12.sp,
                                                  color: AppColors.cream,
                                                  fontWeight:
                                                      AppFontWeight.regular,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 75.w,
                                height: 75.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        detailSalesOrderVM
                                            .salesOrder
                                            .value!
                                            .imageProduct
                                            .isEmpty
                                        ? AssetImage(
                                            "assets/images/dummy_item.jpg",
                                          )
                                        : NetworkImage(
                                            detailSalesOrderVM
                                                .salesOrder
                                                .value!
                                                .imageProduct,
                                          ),
                                    fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.circular(10.w),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 45.w,
                            children: [
                              Column(
                                spacing: 5.h,
                                children: [
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      "Order Id",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.coolGray,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      detailSalesOrderVM.salesOrder.value!.id!,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 15.sp,
                                        color: AppColors.charcoal,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                spacing: 5.h,
                                children: [
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      "Created On",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.coolGray,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      detailSalesOrderVM
                                          .salesOrder
                                          .value!
                                          .purchasedDate!,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.charcoal,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            spacing: 45.w,
                            children: [
                              Column(
                                spacing: 5.h,
                                children: [
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      "To",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.coolGray,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      detailSalesOrderVM
                                          .salesOrder
                                          .value!
                                          .companyName,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.charcoal,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                spacing: 5.h,
                                children: [
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      "From",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.coolGray,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      "Warehouse",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.charcoal,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            spacing: 45.w,
                            children: [
                              Column(
                                spacing: 5.h,
                                children: [
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      "Quantity",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.coolGray,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      detailSalesOrderVM
                                          .salesOrder
                                          .value!
                                          .quantity
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.charcoal,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                spacing: 5.h,
                                children: [
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      "Unit Price",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.coolGray,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      convertDollar.intToDollar(
                                        detailSalesOrderVM
                                            .salesOrder
                                            .value!
                                            .unitPrice,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.charcoal,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Container(
                            width: double.infinity,
                            child: detail_sales_order_view.DottedLine(
                              lineThickness: 1.2.w,
                              dashLength: 10.w,
                              dashGapLength: 10.w,
                              dashColor: Color(0xFFD5D5D5),
                            ),
                          ),
                          Row(
                            spacing: 45.w,
                            children: [
                              Column(
                                spacing: 5.h,
                                children: [
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      "Line Total",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: AppColors.coolGray,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 119.w,
                                    child: Text(
                                      convertDollar.intToDollar(
                                        detailSalesOrderVM
                                            .salesOrder
                                            .value!
                                            .totalPrice,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 15.sp,
                                        color: AppColors.charcoal,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              detailSalesOrderVM.role.value == "warehouse"
                                  ? Container(
                                      width: 116.w,
                                      height: 30.h,
                                      child: ElevatedButton(
                                        onPressed:
                                            detailSalesOrderVM
                                                    .salesOrder
                                                    .value!
                                                    .financeApproved! !=
                                                true
                                            ? () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  isScrollControlled: true,
                                                  builder: (context) => Center(
                                                    child: Container(
                                                      width: 345.w,
                                                      height: 270.w,
                                                      padding:
                                                          EdgeInsetsGeometry.all(
                                                            30.w,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20.w,
                                                            ),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Image.asset(
                                                            "assets/icons/warning.png",
                                                            width: 50.w,
                                                          ),
                                                          SizedBox(
                                                            height: 10.w,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "ARE YOU SURE?",
                                                                style: GoogleFonts.inter(
                                                                  fontSize:
                                                                      14.sp,
                                                                  color:
                                                                      AppColors
                                                                          .gray,
                                                                  fontWeight:
                                                                      AppFontWeight
                                                                          .medium,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            "Please confirm if you want to delete this item. This action cannot be undone.",
                                                            style: GoogleFonts.inter(
                                                              fontSize: 12.sp,
                                                              color: AppColors
                                                                  .grayThin,
                                                              fontWeight:
                                                                  AppFontWeight
                                                                      .regular,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20.w,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: 116.w,
                                                                height: 35.h,
                                                                child: ElevatedButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                        context,
                                                                      ),
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadiusGeometry.circular(
                                                                            5.w,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    "Close",
                                                                    style: GoogleFonts.inter(
                                                                      fontSize:
                                                                          12.sp,
                                                                      color: AppColors
                                                                          .grayTitle,
                                                                      fontWeight:
                                                                          AppFontWeight
                                                                              .regular,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 116.w,
                                                                height: 35.h,
                                                                child: ElevatedButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                    detailSalesOrderVM.requestDeleteSalesOrder(
                                                                      detailSalesOrderVM
                                                                          .salesOrder
                                                                          .value!
                                                                          .id,
                                                                    );
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .vibrantOrange,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadiusGeometry.circular(
                                                                            5.w,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    "Confirm",
                                                                    style: GoogleFonts.inter(
                                                                      fontSize:
                                                                          12.sp,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          AppFontWeight
                                                                              .regular,
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
                                            : null,
                                        child: Text(
                                          "Delete",
                                          style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            color: Colors.white,
                                            fontWeight: AppFontWeight.regular,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              detailSalesOrderVM
                                                      .salesOrder!
                                                      .value!
                                                      .financeApproved! !=
                                                  true
                                              ? AppColors.vibrantOrange
                                              : AppColors.coolGray,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  5.w,
                                                ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 116.w,
                                      height: 30.h,
                                      child: ElevatedButton(
                                        onPressed:
                                            detailSalesOrderVM
                                                    .salesOrder
                                                    .value!
                                                    .financeApproved! ==
                                                false
                                            ? () {
                                                detailSalesOrderVM
                                                    .requestPaySalesOrder(
                                                      detailSalesOrderVM
                                                          .salesOrder
                                                          .value!
                                                          .id,
                                                      detailSalesOrderVM
                                                          .salesOrder
                                                          .value!
                                                          .productId,
                                                      detailSalesOrderVM
                                                          .salesOrder
                                                          .value!
                                                          .quantity,
                                                    );
                                              }
                                            : null,
                                        child: Text(
                                          "Pay Invoice",
                                          style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            color: Colors.white,
                                            fontWeight: AppFontWeight.regular,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              detailSalesOrderVM
                                                      .salesOrder!
                                                      .value!
                                                      .financeApproved! ==
                                                  false
                                              ? AppColors.electricBlue
                                              : AppColors.coolGray,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  5.w,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          SizedBox(height: 25.h),
                          Container(
                            width: 135.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: AppColors.grayThin,
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
          Column(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 112.h,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 14.2.w,
                            spreadRadius: 0,
                            color: AppColors.appBarShadow,
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 63.h),
                          Container(
                            padding: EdgeInsets.only(left: 30.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    detailSalesOrderVM.isLoading.value = true;
                                    detailSalesOrderVM.resetVariable();
                                    Get.back();
                                  },
                                  child: Icon(Icons.close, size: 24.w),
                                ),
                                SizedBox(width: 19.w),
                                Text(
                                  "Back To Summary",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: AppFontWeight.medium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Obx(
            () => detailSalesOrderVM.isLoading.value == true
                ? Container(
                    color: Colors.black26,
                    child: Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: AppColors.softWhite,
                        size: 70.w,
                      ),
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
