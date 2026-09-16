import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:mierp_apps/core/controller/move_page_controller.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/core/widgets/card_order.dart';
import 'package:mierp_apps/core/widgets/card_sales.dart';
import 'package:mierp_apps/core/widgets/card_stock.dart';
import 'package:mierp_apps/features/summary/presentation/summary_view_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SummaryView extends StatelessWidget {
  SummaryView({super.key});

  final summaryVM = Get.find<SummaryViewModel>();
  final movePageC = Get.find<MovePageController>();
  final loadingC = Get.find<LoadingController>();
  final convertDollar = ConvertDollar();

  @override
  Widget build(BuildContext context) {
    ever(summaryVM.success, (status) {
      if (status == true) {
        Get.snackbar("Success", ("Success pay invoice"));
        summaryVM.success.value = false;
      }
    });

    ever(summaryVM.errorMessage, (msg) {
      Get.snackbar("Failed", msg);
      summaryVM.errorMessage.value = "";
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 255.h,
                decoration: BoxDecoration(color: Colors.white),
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
                                    summaryVM.moveBack();
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
                    SizedBox(height: 29.h),
                    Container(
                      width: 344.w,
                      height: 45.29.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 303.47.w,
                            height: 45.29.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.w),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4.w),
                                  color: Color(0xFFE8E8E8),
                                  blurRadius: 20.w,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: summaryVM.searchKeyC,
                              onChanged: (value) {
                                summaryVM.keyword.value = value;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                hint: Text(
                                  "Search anything...",
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.grayThin,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 18.03.w,
                                ),
                                prefixIcon: Icon(Icons.search, size: 17.47.w),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Obx(() {
                            return Material(
                              animateColor: true,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5.w),
                                child: Container(
                                  width: 30.03.w,
                                  height: 30.03.h,
                                  padding: EdgeInsets.all(6.w),
                                  child: SvgPicture.asset(
                                    "assets/icons/filter.svg",
                                    colorFilter: ColorFilter.mode(
                                      summaryVM.collection.value !=
                                                  "products" &&
                                              summaryVM.collection.value !=
                                                  "all_summary"
                                          ? AppColors.grayTitle
                                          : Colors.grey,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                onTap:
                                    summaryVM.collection.value != "products" &&
                                        summaryVM.collection.value !=
                                            "all_summary"
                                    ? () => showBarModalBottomSheet(
                                        context: context,
                                        enableDrag: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(
                                                10.w,
                                              ),
                                        ),
                                        builder: (context) {
                                          return Container(
                                            width: double.infinity,
                                            height: 150.h,
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title: Center(
                                                    child: Text(
                                                      "Filter Card",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color:
                                                            AppColors.grayThin,
                                                      ),
                                                    ),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                        left: 0,
                                                        right: 0,
                                                      ),
                                                ),
                                                Obx(() {
                                                  return ChipsChoice<
                                                    int
                                                  >.single(
                                                    value: summaryVM.tag.value,
                                                    choiceCheckmark: true,
                                                    onChanged: (value) =>
                                                        summaryVM.filterData(
                                                          value,
                                                        ),
                                                    choiceItems:
                                                        C2Choice.listFrom<
                                                          int,
                                                          String
                                                        >(
                                                          source: summaryVM
                                                              .options
                                                              .value,
                                                          value: (i, v) => i,
                                                          label: (i, v) => v,
                                                        ),
                                                  );
                                                }),
                                                SizedBox(height: 10.h),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : null,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 22.71.h),
                    Obx(() {
                      return Container(
                        width: 344.w,
                        height: 32.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: summaryVM.tabs.map((data) {
                            return GestureDetector(
                              onTap: () {
                                summaryVM.changeTab(data);
                              },
                              child: Container(
                                width: 78.w,
                                height: 30.h,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data!.title,
                                      style: GoogleFonts.manrope(
                                        fontSize: 13.sp,
                                        fontWeight: AppFontWeight.medium,
                                        color: Colors.black,
                                      ),
                                    ),
                                    !data.isActive.value
                                        ? SizedBox()
                                        : Column(
                                            children: [
                                              SizedBox(height: 7.h),
                                              Container(
                                                height: 3.h,
                                                color: AppColors.electricBlue,
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Obx(() {
                if (summaryVM.collection.value == "all_summary") {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: summaryVM.listAllSummary.isNotEmpty
                          ? Column(
                              spacing: 10,
                              children: [
                                SizedBox(height: 3.w),
                                ...summaryVM.listAllSummary.map((e) {
                                  switch (e!.summaryType) {
                                    case SummaryType.product:
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            "/detail_product/${e.data.id}",
                                          );
                                        },
                                        child: CardStock(
                                          idBarang: e!.data.productCode,
                                          namaBarang: e!.data.productName,
                                          quantity: e!.data.quantity,
                                          unitPrice: e!.data.unitPrice,
                                          lineTotal:
                                              e!.data.unitPrice *
                                              e!.data.quantity,
                                          type: e!.data.category,
                                          image: e!.data.imageProduct,
                                        ),
                                      );
                                    case SummaryType.order:
                                      return GestureDetector(
                                        onTap: () {
                                          summaryVM.detailProductOrder(
                                            e.data.id,
                                          );
                                        },
                                        child: CardOrder(
                                          idOrder: e!.data.id,
                                          idBarang: e!.data.productId,
                                          namaBarang: e!.data.productName,
                                          financeApproved:
                                              e!.data.financeApproved,
                                          createdOn: e!.data.orderDate,
                                          nameUser: e!.data.firstName,
                                          quantity: e!.data.quantity,
                                          unitPrice: e!.data.unitPrice,
                                          lineTotal: e!.data.totalCost,
                                          imageProduct: e!.data.imageProduct,
                                          finance: summaryVM.role == "finance"
                                              ? true
                                              : null,
                                          onPayPressed: () => summaryVM
                                              .requestPayInvoiceOrderProduct(
                                                e!.data.id,
                                                e!.data.productId,
                                                e!.data.quantity,
                                              ),
                                        ),
                                      );
                                    case SummaryType.salesOrder:
                                      return GestureDetector(
                                        onTap: () async {
                                          Get.toNamed(
                                            "/detail_sales_order/${e.data.id}",
                                          );
                                        },
                                        child: CardSales(
                                          idBarang: e!.data.productCode,
                                          namaBarang: e!.data.productName,
                                          financeApproved:
                                              e!.data.financeApproved,
                                          createdOn: e!.data.purchasedDate,
                                          nameUser: e!.data.firstName,
                                          quantity: e!.data.quantity,
                                          unitPrice: e!.data.unitPrice,
                                          lineTotal: e!.data.totalPrice,
                                          nameCustomer: e!.data.companyName,
                                          imageProduct: e!.data.imageProduct,
                                        ),
                                      );
                                  }
                                }).toList(),
                                SizedBox(height: 10.w),
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    "assets/lottie/empty_ghost.json",
                                    width: 292.w,
                                  ),
                                  Container(
                                    width: 250.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 10.w,
                                      children: [
                                        Text(
                                          "Oops! No Data Available…",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.w,
                                            fontWeight: AppFontWeight.medium,
                                            color: AppColors.grayTitle,
                                          ),
                                        ),
                                        Text(
                                          "The data you’re looking for isn’t available yet.",
                                          style: GoogleFonts.inter(
                                            fontSize: 14.w,
                                            fontWeight: AppFontWeight.regular,
                                            color: AppColors.grayThin,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  );
                } else if (summaryVM.collection.value == "products") {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: summaryVM.listProduct.isNotEmpty
                          ? Column(
                              spacing: 10.w,
                              children: summaryVM.listProduct.map((data) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed("/detail_product/${data.id}");
                                  },
                                  child: CardStock(
                                    idBarang: data!.productCode,
                                    namaBarang: data!.productName,
                                    quantity: data!.quantity,
                                    unitPrice: data!.unitPrice,
                                    lineTotal: data!.unitPrice * data!.quantity,
                                    type: data!.category,
                                    image: data!.imageProduct,
                                  ),
                                );
                              }).toList(),
                            ).paddingOnly(top: 12.w, bottom: 24.w)
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    "assets/lottie/empty_ghost.json",
                                    width: 292.w,
                                  ),
                                  Container(
                                    width: 250.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 10.w,
                                      children: [
                                        Text(
                                          "Oops! No Data Available…",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.w,
                                            fontWeight: AppFontWeight.medium,
                                            color: AppColors.grayTitle,
                                          ),
                                        ),
                                        Text(
                                          "The data you’re looking for isn’t available yet.",
                                          style: GoogleFonts.inter(
                                            fontSize: 14.w,
                                            fontWeight: AppFontWeight.regular,
                                            color: AppColors.grayThin,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  );
                } else if (summaryVM.collection.value == "warehouse_orders") {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: summaryVM.listOrder.isNotEmpty
                          ? Column(
                              spacing: 10.w,
                              children: summaryVM.listOrder.map((data) {
                                return GestureDetector(
                                  onTap: () {
                                    summaryVM.detailProductOrder(data.id);
                                  },
                                  child: CardOrder(
                                    idOrder: data!.id,
                                    idBarang: data!.productId,
                                    namaBarang: data!.productName,
                                    financeApproved: data!.financeApproved,
                                    createdOn: data!.orderDate,
                                    nameUser: data!.firstName,
                                    quantity: data!.quantity,
                                    unitPrice: data!.unitPrice,
                                    lineTotal: data!.totalCost,
                                    imageProduct: data!.imageProduct,
                                    finance: summaryVM.role == "finance"
                                        ? true
                                        : null,
                                    onPayPressed: () =>
                                        summaryVM.requestPayInvoiceOrderProduct(
                                          data!.id,
                                          data!.productId,
                                          data!.quantity,
                                        ),
                                  ),
                                );
                              }).toList(),
                            ).paddingOnly(top: 12.w, bottom: 24.w)
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    "assets/lottie/empty_ghost.json",
                                    width: 292.w,
                                  ),
                                  Container(
                                    width: 250.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 10.w,
                                      children: [
                                        Text(
                                          "Oops! No Data Available…",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.w,
                                            fontWeight: AppFontWeight.medium,
                                            color: AppColors.grayTitle,
                                          ),
                                        ),
                                        Text(
                                          "The data you’re looking for isn’t available yet.",
                                          style: GoogleFonts.inter(
                                            fontSize: 14.w,
                                            fontWeight: AppFontWeight.regular,
                                            color: AppColors.grayThin,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: summaryVM.listSalesOrder.isNotEmpty
                          ? Column(
                              spacing: 10.w,
                              children: summaryVM.listSalesOrder
                                  .map(
                                    (data) => GestureDetector(
                                      onTap: () async {
                                        Get.toNamed(
                                          "/detail_sales_order/${data.id}",
                                        );
                                      },
                                      child: CardSales(
                                        idBarang: data!.productCode,
                                        namaBarang: data!.productName,
                                        financeApproved: data!.financeApproved,
                                        createdOn: data!.purchasedDate,
                                        nameUser: data!.firstName,
                                        quantity: data!.quantity,
                                        unitPrice: data!.unitPrice,
                                        lineTotal: data!.totalPrice,
                                        nameCustomer: data!.companyName,
                                        imageProduct: data!.imageProduct,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ).paddingOnly(top: 12.w, bottom: 24.w)
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    "assets/lottie/empty_ghost.json",
                                    width: 292.w,
                                  ),
                                  Container(
                                    width: 250.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 10.w,
                                      children: [
                                        Text(
                                          "Oops! No Data Available…",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.w,
                                            fontWeight: AppFontWeight.medium,
                                            color: AppColors.grayTitle,
                                          ),
                                        ),
                                        Text(
                                          "The data you’re looking for isn’t available yet.",
                                          style: GoogleFonts.inter(
                                            fontSize: 14.w,
                                            fontWeight: AppFontWeight.regular,
                                            color: AppColors.grayThin,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  );
                }
              }),
            ],
          ),
          Obx(
            () => summaryVM.isLoading.value
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
