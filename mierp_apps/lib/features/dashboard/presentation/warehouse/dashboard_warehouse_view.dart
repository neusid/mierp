import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/card_dashboard.dart';
import 'package:mierp_apps/core/widgets/card_order.dart';
import 'package:mierp_apps/core/widgets/card_sales.dart';
import 'package:mierp_apps/core/widgets/card_stock.dart';
import 'package:mierp_apps/features/dashboard/presentation/warehouse/warehouse_view_model.dart';

class DashboardWarehouseView extends StatelessWidget {
  DashboardWarehouseView({super.key});

  final warehouseVM = Get.find<WarehouseViewModel>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 394.w,
                    height: 158.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/warehouse_card.png"),
                        fit: BoxFit.cover,
                        alignment: AlignmentGeometry.directional(0, 0.5),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF7A00E6),
                          Color(0xFF4B3FEB),
                          Color(0xFF29B1FF),
                        ],
                        transform: GradientRotation(0.35.sw),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60.w),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 77.h),
                        Container(
                          padding: EdgeInsets.only(left: 24.w),
                          child: Row(
                            children: [
                              Container(
                                width: 18.w,
                                height: 18.h,
                                child: Image.asset(
                                  "assets/images/warehouse_group.png",
                                ),
                              ),
                              SizedBox(width: 63.w),
                              Text(
                                "Summary Warehouse",
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: AppFontWeight.semiBold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 123.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 289.w,
                            height: 70.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.w),
                                topLeft: Radius.circular(20.w),
                              ),
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
                            child: Row(
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
                                Container(
                                  width: 192.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hello!",
                                            style: GoogleFonts.lexendDeca(
                                              fontWeight: AppFontWeight.regular,
                                              fontSize: 14.sp,
                                              color: AppColors.grayTitle,
                                            ),
                                          ),
                                          Container(
                                            width: 130.w,
                                            child: Obx(() {
                                              return Text(
                                                "${warehouseVM.userName.value}!",
                                                style: GoogleFonts.lexendDeca(
                                                  fontWeight:
                                                      AppFontWeight.semiBold,
                                                  fontSize: 16.sp,
                                                  color: AppColors.grayTitle,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              );
                                            }),
                                          ),
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  spacing: 9.h,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardDashboard(
                          nameBox: "Product",
                          description:
                              "All product types available in inventory",
                          totalItems: warehouseVM.lenghtProduct,
                          urgent: false,
                        ),
                        CardDashboard(
                          nameBox: "Total Qty",
                          description: "Total quantity across all products",
                          totalItems: warehouseVM.totalQtyProduct,
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
                          totalItems: warehouseVM.totalLowProduct,
                          urgent: true,
                        ),
                        CardDashboard(
                          nameBox: "Upcoming Stock",
                          description: "Stock items arriving soon to inventory",
                          totalItems: warehouseVM.totalUpcomingProduct,
                          urgent: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22.h),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 14.h),
                child: Container(
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
                        children: [
                          Text("Add New Unit"),
                          GestureDetector(
                            onTap: () {
                              warehouseVM.movePage("/add_unit");
                            },
                            child: Container(
                              width: 36.w,
                              height: 33.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF00B2FF),
                                    Color(0xFF7A00E6),
                                  ],
                                  transform: GradientRotation(-0.05.sw),
                                ),
                              ),
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 22.h),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 14.h),
                child: Container(
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
                        children: [
                          Text("Add Sales Order"),
                          GestureDetector(
                            onTap: () {
                              warehouseVM.movePage("/add_sales_order");
                            },
                            child: Container(
                              width: 36.w,
                              height: 33.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF00B2FF),
                                    Color(0xFF7A00E6),
                                  ],
                                  transform: GradientRotation(-0.05.sw),
                                ),
                              ),
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 22.h),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 14.h),
                child: Container(
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
                        children: [
                          Text("Add Product Order"),
                          GestureDetector(
                            onTap: () {
                              warehouseVM.movePage("/add_product_order");
                            },
                            child: Container(
                              width: 36.w,
                              height: 33.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF00B2FF),
                                    Color(0xFF7A00E6),
                                  ],
                                  transform: GradientRotation(-0.05.sw),
                                ),
                              ),
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 22.h),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 14.h),
                child: Container(
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
                        children: warehouseVM.tabs
                            .map(
                              (e) => Obx(() {
                                final isActive = e.isActive.value;
                                return GestureDetector(
                                  onTap: () async {
                                    warehouseVM.changeTab(e);
                                  },
                                  child: Container(
                                    height: 33.h,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                    ),
                                    decoration: isActive
                                        ? BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              55.w,
                                            ),
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
              ),
              SizedBox(height: 22.h),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 24.h),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Summary"),
                          GestureDetector(
                            onTap: () {
                              warehouseVM.isLoading.value = true;
                              Future.delayed(Duration(seconds: 1), () {
                                warehouseVM.isLoading.value = false;
                                Get.toNamed("/summary");
                              });
                            },
                            child: Row(
                              children: [
                                Text("View all"),
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
                      if (warehouseVM.collection.value == "all_summary") {
                        if (warehouseVM.collection.value.isNotEmpty) {
                          return Container(
                            child: Column(
                              spacing: 10.w,
                              children: [
                                ...warehouseVM.itemStore.listAllSummary.take(2).map((
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
                        } else {
                          return CircularProgressIndicator();
                        }
                      } else if (warehouseVM.collection.value == "products") {
                        if (warehouseVM.collection.value.isNotEmpty) {
                          return Container(
                            child: Column(
                              spacing: 10.w,
                              children: [
                                ...warehouseVM.listProduct
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
                      } else if (warehouseVM.collection.value ==
                          "warehouse_order") {
                        if (warehouseVM.listOrder.isNotEmpty) {
                          return Column(
                            spacing: 10.w,
                            children: [
                              ...warehouseVM.listOrder.take(2).map((data) {
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
                                    imageProduct: data!.imageProduct,
                                    onPayPressed: () {},
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
                          spacing: 10.w,
                          children: [
                            ...warehouseVM.listSalesOrder
                                .take(2)
                                .map(
                                  (e) => GestureDetector(
                                    onTap: () async {
                                      Get.toNamed(
                                        "/detail_sales_order/${e.id}",
                                      );
                                    },
                                    child: CardSales(
                                      idBarang: e!.productCode,
                                      namaBarang: e!.productName,
                                      financeApproved: e!.financeApproved,
                                      createdOn: e!.purchasedDate,
                                      nameUser: e!.firstName,
                                      quantity: e!.quantity,
                                      unitPrice: e!.unitPrice,
                                      lineTotal: e!.totalPrice,
                                      nameCustomer: e!.companyName,
                                      imageProduct: e!.imageProduct,
                                    ),
                                  ),
                                )
                                .toList(),
                            SizedBox(height: 5.w),
                          ],
                        );
                      }
                    }),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
        Obx(
          () => warehouseVM.isLoading.value
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
