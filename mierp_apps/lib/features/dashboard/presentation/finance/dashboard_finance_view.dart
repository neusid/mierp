import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';
import 'package:mierp_apps/core/widgets/card_dashboard.dart';
import 'package:mierp_apps/core/widgets/card_order.dart';
import 'package:mierp_apps/core/widgets/card_sales.dart';
import 'package:mierp_apps/core/widgets/card_stock.dart';
import 'package:mierp_apps/features/dashboard/presentation/finance/dashboard_finance_view_model.dart';

class DashboardFinanceView extends StatelessWidget {
  const DashboardFinanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final financeVM = Get.find<DashboardFinanceViewModel>();

    ever(financeVM.success, (status) {
      if (status == true) {
        Get.snackbar("Success", "Success pay invoice");
        financeVM.success.value = false;
      }
    });

    ever(financeVM.errorMessage, (msg) {
      Get.snackbar("Failed", msg);
      financeVM.errorMessage.value = "";
    });

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 60.h,
              collapsedHeight: 70.h,
              pinned: true,
              floating: false,
              backgroundColor: AppColors.bgColor,
              surfaceTintColor: AppColors.bgColor,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: SizedBox(
                  height: 60.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 37.w,
                            height: 37.h,
                            decoration: BoxDecoration(
                              color: AppColors.electricBlue,
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  "assets/images/person.png",
                                  width: 33.w,
                                  height: 33.h,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hello!",
                                      style: GoogleFonts.lexendDeca(
                                        fontWeight: AppFontWeight.regular,
                                        fontSize: 14.sp,
                                        color: AppColors.grayTitle,
                                      ),
                                    ),
                                    Obx(() {
                                      return Text(
                                        "${financeVM.userName.value}!",
                                        style: GoogleFonts.lexendDeca(
                                          fontWeight: AppFontWeight.semiBold,
                                          fontSize: 19.sp,
                                          color: AppColors.grayTitle,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.toNamed('/notification');
                                  },
                                  icon: Icon(
                                    Icons.notifications_active,
                                    size: 24.w,
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
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 12.w),
                child: Column(
                  children: [
                    Container(
                      width: 343.w,
                      height: 76.h,
                      padding: EdgeInsets.only(
                        left: 17.w,
                        top: 10.w,
                        bottom: 10.w,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/cardbox.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total Balance",
                            style: GoogleFonts.manrope(
                              fontSize: 10.sp,
                              color: Color(0xFFE7E0FB),
                              fontWeight: AppFontWeight.medium,
                            ),
                          ),
                          Obx(() {
                            return Container(
                              child: Text(
                                ConvertDollar().intToDollar(
                                  financeVM.productsItem.value,
                                ),
                                style: GoogleFonts.manrope(
                                  fontSize: 16.sp,
                                  color: Color(0xFFFEFEFE),
                                  fontWeight: AppFontWeight.medium,
                                ),
                              ),
                            );
                          }),
                          Row(
                            spacing: 4.w,
                            children: [
                              SvgPicture.asset("assets/icons/check_mark.svg"),
                              Text(
                                "Updated Today",
                                style: GoogleFonts.manrope(
                                  fontSize: 8.sp,
                                  color: Color(0xFFFEFEFE),
                                  fontWeight: AppFontWeight.regular,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.3.h),
                    Container(
                      width: 343.w,
                      height: 20.w,
                      child: Row(
                        spacing: 16.w,
                        children: [
                          Text(
                            "Finance Details",
                            style: GoogleFonts.manrope(
                              fontSize: 14.sp,
                              color: AppColors.gray,
                              fontWeight: AppFontWeight.medium,
                            ),
                            maxLines: 1,
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.coolGray,
                              thickness: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.3.h),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 110.w,
                            height: 60.h,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.only(
                              left: 10.w,
                              top: 8.w,
                              right: 10.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.w),
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 5.w,
                                  children: [
                                    Image.asset(
                                      'assets/icons/top_right_red.png',
                                      width: 10.w,
                                      height: 10.h,
                                    ),
                                    Text(
                                      "Payables",
                                      style: GoogleFonts.manrope(
                                        fontSize: 10.sp,
                                        color: Color(0xFF707070),
                                        fontWeight: AppFontWeight.medium,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7.w),
                                Row(
                                  spacing: 6.w,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/line_red.svg',
                                      width: 2.w,
                                      height: 12.w,
                                    ),
                                    Container(
                                      width: 40.w,
                                      child: Text(
                                        ConvertDollar().intToDollar(
                                          financeVM.accountPayables.value,
                                        ),
                                        style: GoogleFonts.manrope(
                                          fontSize: 10.sp,
                                          color: Colors.black,
                                          fontWeight: AppFontWeight.medium,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: AppColors.grayDashline,
                                  height: 12.w,
                                  thickness: 1,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 110.w,
                            height: 60.h,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.only(
                              left: 10.w,
                              top: 8.w,
                              right: 10.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.w),
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 5.w,
                                  children: [
                                    Image.asset(
                                      'assets/icons/top-right-blue.png',
                                      width: 10.w,
                                      height: 10.h,
                                    ),
                                    Text(
                                      "Receivables",
                                      style: GoogleFonts.manrope(
                                        fontSize: 10.sp,
                                        color: Color(0xFF707070),
                                        fontWeight: AppFontWeight.medium,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7.w),
                                Row(
                                  spacing: 6.w,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/line_blue.svg',
                                      width: 2.w,
                                      height: 12.w,
                                    ),
                                    Container(
                                      width: 40.w,
                                      child: Text(
                                        ConvertDollar().intToDollar(
                                          financeVM.accountReceivables.value,
                                        ),
                                        style: GoogleFonts.manrope(
                                          fontSize: 10.sp,
                                          color: Colors.black,
                                          fontWeight: AppFontWeight.medium,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: AppColors.grayDashline,
                                  height: 12.w,
                                  thickness: 1,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 110.w,
                            height: 60.h,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.only(
                              left: 10.w,
                              top: 8.w,
                              right: 10.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.w),
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 5.w,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/check_mark.svg',
                                      width: 10.w,
                                      height: 10.h,
                                    ),
                                    Text(
                                      "Settled",
                                      style: GoogleFonts.manrope(
                                        fontSize: 10.sp,
                                        color: Color(0xFF707070),
                                        fontWeight: AppFontWeight.medium,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7.w),
                                Row(
                                  spacing: 6.w,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/line_green.svg',
                                      width: 2.w,
                                      height: 12.w,
                                    ),
                                    Container(
                                      width: 40.w,
                                      child: Text(
                                        ConvertDollar().intToDollar(
                                          financeVM.settled.value,
                                        ),
                                        style: GoogleFonts.manrope(
                                          fontSize: 10.sp,
                                          color: Colors.black,
                                          fontWeight: AppFontWeight.medium,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: AppColors.grayDashline,
                                  height: 12.w,
                                  thickness: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: 12.3.h),
                    Column(
                      spacing: 9.h,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardDashboard(
                              nameBox: "Product",
                              description:
                                  "All product types available in inventory",
                              totalItems: financeVM.productTotal,
                              urgent: false,
                            ),
                            CardDashboard(
                              nameBox: "Total Qty",
                              description: "Total quantity across all products",
                              totalItems: financeVM.totalQty,
                              urgent: false,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardDashboard(
                              nameBox: "Low Stock",
                              description:
                                  "Stock items with low remaining quantity",
                              totalItems: financeVM.lowStock,
                              urgent: true,
                            ),
                            CardDashboard(
                              nameBox: "Upcoming Stock",
                              description:
                                  "Stock items arriving soon to inventory",
                              totalItems: financeVM.upComingStock,
                              urgent: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 22.h),
                    Container(
                      width: 345.w,
                      height: 49.h,
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 22.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowBox,
                            spreadRadius: -3.w,
                            offset: Offset(0, 4),
                            blurRadius: 21.w,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Center(
                        child: Container(
                          width: 310.w,
                          height: 33.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: financeVM.tabs
                                .map(
                                  (e) => Obx(() {
                                    final isActive = e.isActive.value;
                                    return GestureDetector(
                                      onTap: () async {
                                        financeVM.changeTab(e);
                                        print(financeVM.collection.value);
                                      },
                                      child: Container(
                                        height: 33.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                        ),
                                        decoration: isActive
                                            ? BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(55.w),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFF00B2FF),
                                                    Color(0xFF7A00E6),
                                                  ],
                                                  transform: GradientRotation(
                                                    -0.05.sw,
                                                  ),
                                                ),
                                              )
                                            : BoxDecoration(),
                                        child: Center(
                                          child: Text(
                                            e.title,
                                            style: GoogleFonts.inter(
                                              fontSize: 11.sp,
                                              fontWeight: AppFontWeight.medium,
                                              color: isActive
                                                  ? Colors.white
                                                  : AppColors.charcoal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Summary",
                            style: GoogleFonts.manrope(
                              fontSize: 14.sp,
                              color: AppColors.gray,
                              fontWeight: AppFontWeight.semiBold,
                            ),
                            maxLines: 1,
                          ),
                          GestureDetector(
                            onTap: () {
                              financeVM.moveToSummaryView();
                            },
                            child: Row(
                              children: [
                                Text(
                                  "View all",
                                  style: GoogleFonts.manrope(
                                    fontSize: 14.sp,
                                    color: AppColors.gray,
                                    fontWeight: AppFontWeight.semiBold,
                                  ),
                                  maxLines: 1,
                                ),
                                SizedBox(width: 5.w),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.charcoal,
                                  size: 10.w,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),
                    Obx(() {
                      if (financeVM.collection.value == "all_summary") {
                        return Container(
                          child: Column(
                            spacing: 10.w,
                            children: [
                              ...financeVM.itemStore.listAllSummary.take(2).map((
                                e,
                              ) {
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
                                        Get.toNamed(
                                          "/detail_product_order/${e.data.id}",
                                        );
                                      },
                                      child: CardOrder(
                                        idOrder: e.data!.id,
                                        idBarang: e.data!.productCode,
                                        namaBarang: e.data!.productName,
                                        financeApproved:
                                            e.data!.financeApproved,
                                        createdOn: e.data!.orderDate,
                                        nameUser: e.data!.firstName,
                                        quantity: e.data!.quantity,
                                        unitPrice: e.data!.unitPrice,
                                        lineTotal: e.data!.totalCost,
                                        imageProduct: e.data!.imageProduct,
                                        onPayPressed: () {},
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
                              SizedBox(height: 5.w),
                            ],
                          ),
                        );
                      } else if (financeVM.collection.value == "products") {
                        if (financeVM.collection.value.isNotEmpty) {
                          return Container(
                            child: Column(
                              spacing: 10.w,
                              children: [
                                ...financeVM.listProduct
                                    .take(2)
                                    .map(
                                      (product) => GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            "/detail_product/${product.id}",
                                          );
                                        },
                                        child: CardStock(
                                          idBarang: product!.productCode,
                                          namaBarang: product!.productName,
                                          quantity: product!.quantity,
                                          unitPrice: product!.unitPrice,
                                          lineTotal:
                                              product!.unitPrice *
                                              product!.quantity,
                                          type: product!.category,
                                          image: product!.imageProduct,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                SizedBox(height: 5.w),
                              ],
                            ),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      } else if (financeVM.collection.value ==
                          "warehouse_orders") {
                        if (financeVM.listOrder.isNotEmpty) {
                          return Column(
                            spacing: 10.w,
                            children: [
                              ...financeVM.listOrder.take(2).map((data) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                      "/detail_product_order/${data.id}",
                                    );
                                  },
                                  child: CardOrder(
                                    idOrder: data!.id,
                                    idBarang: data!.productCode,
                                    namaBarang: data!.productName,
                                    financeApproved: data!.financeApproved,
                                    createdOn: data!.orderDate,
                                    nameUser: data!.firstName,
                                    quantity: data!.quantity,
                                    unitPrice: data!.unitPrice,
                                    lineTotal: data!.totalCost,
                                    finance: true,
                                    imageProduct: data!.imageProduct,
                                    onPayPressed: () =>
                                        financeVM.requestPayProductOrder(
                                          data!.id,
                                          data!.productId,
                                          data!.quantity,
                                        ),
                                  ),
                                );
                              }).toList(),
                              SizedBox(height: 5.w),
                            ],
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      } else {
                        return Column(
                          children: [
                            ...financeVM.listSalesOrder
                                .take(2)
                                .map(
                                  (data) => Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          Get.toNamed(
                                            "/detail_sales_order/${data!.id}",
                                          );
                                        },
                                        child: CardSales(
                                          idBarang: data!.productCode,
                                          namaBarang: data!.productName,
                                          financeApproved:
                                              data!.financeApproved,
                                          createdOn: data!.purchasedDate,
                                          nameUser: data!.firstName,
                                          quantity: data!.quantity,
                                          unitPrice: data!.unitPrice,
                                          lineTotal: data!.totalPrice,
                                          nameCustomer: data!.companyName,
                                          imageProduct: data!.imageProduct,
                                        ),
                                      ),
                                      SizedBox(height: 10.w),
                                    ],
                                  ),
                                )
                                .toList(),
                            SizedBox(height: 5.w),
                          ],
                        );
                      }
                    }),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
        Obx(
          () => financeVM.isLoading.value
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
    );
  }
}
