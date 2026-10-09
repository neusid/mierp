import 'package:mierp_apps/core/widgets/dashboard/quick_add_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/widgets/dashboard/blanket_mattress_widget.dart';
import 'package:mierp_apps/features/dashboard/presentation/warehouse/bloc/dashboard_warehouse_bloc.dart';
import 'package:mierp_apps/core/di/injection_container.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/card_dashboard.dart';
import 'package:mierp_apps/core/widgets/card_order.dart';
import 'package:mierp_apps/core/widgets/card_sales.dart';
import 'package:mierp_apps/core/widgets/card_stock.dart';

class DashboardWarehouseView extends StatelessWidget {
  DashboardWarehouseView({super.key});

  final tabs = [
    {"title": "All Summary", "collection": "all_summary"},
    {"title": "Order", "collection": "warehouse_order"},
    {"title": "Sales Order", "collection": "sales_order"},
    {"title": "Stock", "collection": "products"},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<DashboardWarehouseBloc>()..add(DashboardWarehouseStarted()),
      child: BlocBuilder<DashboardWarehouseBloc, DashboardWarehouseState>(
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 1.sw,
                      height: 160.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF3B82F6), Color(0xFF6D28D9)],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60.w),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -90.h,
                            right: -40.w,
                            child: Container(
                              width: 200.w,
                              height: 200.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.06),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 90.h,
                            left: -20.w,
                            child: Container(
                              width: 120.w,
                              height: 120.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.06),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 56.h,
                            left: 32.w,
                            right: 28.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 48.w,
                                  height: 48.w,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE9D5FF),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: const Color(0xFF7C3AED),
                                      size: 28.w,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Good Morning,",
                                        style: GoogleFonts.inter(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFFE0E7FF),
                                        ),
                                      ),
                                      Text(
                                        state.userName.isNotEmpty
                                            ? state.userName
                                            : "Admin",
                                        style: GoogleFonts.inter(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: -0.5,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.push('/notification');
                                  },
                                  child: Container(
                                    width: 40.w,
                                    height: 40.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(12.w),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.notifications_none_rounded,
                                          color: Colors.white,
                                          size: 24.w,
                                        ),
                                        Positioned(
                                          top: 10.w,
                                          right: 10.w,
                                          child: Container(
                                            width: 8.w,
                                            height: 8.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFFEF4444),
                                              border: Border.all(
                                                color: const Color(0xFF4F46E5),
                                                width: 1.5.w,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.w),
                                border: Border.all(
                                  color: const Color(0xFFF1F5F9),
                                  width: 1.5.w,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8.w,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 28.w,
                                        height: 28.w,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3E8FF),
                                          borderRadius: BorderRadius.circular(
                                            8.w,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFE9D5FF),
                                            width: 1.w,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.inventory_2_outlined,
                                            color: const Color(0xFF7C3AED),
                                            size: 16.w,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          state.totalProducts.toString(),
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF334155),
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -0.5,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    "Total Products",
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF64748B),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.w),
                                border: Border.all(
                                  color: const Color(0xFFF1F5F9),
                                  width: 1.5.w,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8.w,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 28.w,
                                        height: 28.w,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3E8FF),
                                          borderRadius: BorderRadius.circular(
                                            8.w,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFE9D5FF),
                                            width: 1.w,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.layers_rounded,
                                            color: const Color(0xFF7C3AED),
                                            size: 16.w,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          state.totalQty.toString(),
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF334155),
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -0.5,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    "Total Quantity",
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF64748B),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        spacing: 16.h,
                        children: [
                          BlanketMattressWidget(
                            title: "Low Stock Products",
                            subtitle: "Needs immediate attention",
                            count: state.totalLowStock,
                            rightTitle: "Action Req.",
                            rightSubtitle:
                                "${state.totalLowStock} of ${state.totalProducts} Items",
                            progress: state.totalProducts > 0
                                ? (state.totalLowStock / state.totalProducts)
                                : 0.0,
                            themeColor: const Color(0xFFEF4444),
                            themeBgColor: const Color(0xFFFFF1F2),
                            headerIcon: Icons.warning_amber_rounded,
                            buttonText: "View All Low Stock ➔",
                            items:
                                (state.listProduct.toList()..sort(
                                      (a, b) =>
                                          a.quantity.compareTo(b.quantity),
                                    ))
                                    .take(2)
                                    .map(
                                      (e) => {
                                        "title": e.productName,
                                        "subtitle":
                                            "${e.category} • ${e.productCode}",
                                        "badge": "${e.quantity} Left",
                                      "image": e.imageProduct ?? "",
                                      },
                                    )
                                    .toList(),
                          ),
                          BlanketMattressWidget(
                            title: "Incoming Stock",
                            subtitle: "Expected today",
                            count: state.totalUpcomingStock,
                            rightTitle: "On Track",
                            rightSubtitle:
                                "${state.totalUpcomingStock} incoming",
                            progress: state.totalProducts > 0
                                ? (state.totalUpcomingStock /
                                      state.totalProducts)
                                : 0.0,
                            themeColor: const Color(0xFF3B82F6),
                            themeBgColor: const Color(0xFFEEF2FF),
                            headerIcon: Icons.local_shipping_outlined,
                            buttonText: "View All Incoming Stock ➔",
                            items: state.listOrder
                                .where((e) => e.financeApproved == true)
                                .take(2)
                                .map(
                                  (e) => {
                                    "title": e.productName,
                                    "subtitle": "Order • ${e.productCode}",
                                    "badge": "${e.quantity} Units",
                                  "image": e.imageProduct ?? "",
                                      },
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),
                    QuickAddCard(
                      title: "Add New Unit",
                      onTap: () {
                        context.push("/add_unit");
                      },
                    ),
                    SizedBox(height: 22.h),
                    QuickAddCard(
                      title: "Add Sales Order",
                      onTap: () {
                        context.push("/add_sales_order");
                      },
                    ),
                    SizedBox(height: 22.h),
                    QuickAddCard(
                      title: "Add Product Order",
                      onTap: () {
                        context.push("/add_product_order");
                      },
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
                              children: tabs.map((e) {
                                final isActive =
                                    state.selectedTab == e['collection'];
                                return GestureDetector(
                                  onTap: () async {
                                    context.read<DashboardWarehouseBloc>().add(
                                      DashboardWarehouseTabChanged(
                                        e['collection']!,
                                      ),
                                    );
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
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF3B82F6),
                                                Color(0xFF6D28D9),
                                              ],
                                            ),
                                          )
                                        : BoxDecoration(),
                                    child: Center(
                                      child: Text(
                                        e['title']!,
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
                              }).toList(),
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
                                    context.push("/summary");
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
                          Builder(
                            builder: (context) {
                              if (state.selectedTab == "all_summary") {
                                if (state.selectedTab.isNotEmpty) {
                                  return Container(
                                    child: Column(
                                      spacing: 4.h,
                                      children: [
                                        ...state.listAllSummary.take(2).map((
                                          e,
                                        ) {
                                          switch (e!.summaryType) {
                                            case SummaryType.product:
                                              return GestureDetector(
                                                onTap: () {
                                                  context.push(
                                                    "/detail_product/${e.data.id}",
                                                  );
                                                },
                                                child: CardStock(
                                                  idBarang: e!.data.productCode,
                                                  namaBarang:
                                                      e!.data.productName,
                                                  quantity: e!.data.quantity,
                                                  unitPrice: e!.data.unitPrice,
                                                  lineTotal:
                                                      e!.data.unitPrice *
                                                      e!.data.quantity,
                                                  type: e!.data.category,
                                                  image: e!.data.imageProduct,
                                                    createdOn: e!.data.createdOn,
                                                ),
                                              );
                                            case SummaryType.order:
                                              return GestureDetector(
                                                onTap: () {
                                                  context.push(
                                                    "/detail_product_order/${e.data.id}",
                                                  );
                                                },
                                                child: CardOrder(
                                                  idOrder: e.data!.id,
                                                  discountPercent: e.data!.discountPercent,
                                                  discountMax: e.data!.discountMax,
                                                  idBarang: e.data!.productCode,
                                                  namaBarang:
                                                      e.data!.productName,
                                                  financeApproved:
                                                      e.data!.financeApproved,
                                                  createdOn: e.data!.orderDate,
                                                  nameUser: e.data!.firstName,
                                                  quantity: e.data!.quantity,
                                                  unitPrice: e.data!.unitPrice,
                                                  lineTotal: e.data!.totalCost,
                                                  imageProduct:
                                                      e.data!.imageProduct,
                                                  onPayPressed: () {},
                                                ),
                                              );
                                            case SummaryType.salesOrder:
                                              return GestureDetector(
                                                onTap: () async {
                                                  context.push(
                                                    "/detail_sales_order/${e.data.id}",
                                                  );
                                                },
                                                child: CardSales(
                                                  idBarang: e!.data.productCode,
                                                  namaBarang:
                                                      e!.data.productName,
                                                  financeApproved:
                                                      e!.data.financeApproved,
                                                  createdOn:
                                                      e!.data.purchasedDate,
                                                  nameUser: e!.data.firstName,
                                                  quantity: e!.data.quantity,
                                                  unitPrice: e!.data.unitPrice,
                                                  lineTotal: e!.data.totalPrice,
                                                  nameCustomer:
                                                      e!.data.companyName,
                                                  imageProduct:
                                                      e!.data.imageProduct,
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
                              } else if (state.selectedTab == "products") {
                                if (state.selectedTab.isNotEmpty) {
                                  return Container(
                                    child: Column(
                                      spacing: 4.h,
                                      children: [
                                        ...state.listProduct
                                            .take(2)
                                            .map(
                                              (product) => GestureDetector(
                                                onTap: () {
                                                  context.push(
                                                    "/detail_product/${product.id}",
                                                  );
                                                },
                                                child: CardStock(
                                                  idBarang:
                                                      product!.productCode,
                                                  namaBarang:
                                                      product!.productName,
                                                  quantity: product!.quantity,
                                                  unitPrice: product!.unitPrice,
                                                  lineTotal:
                                                      product!.unitPrice *
                                                      product!.quantity,
                                                  type: product!.category,
                                                  image: product!.imageProduct,
                                                    createdOn: product!.createdOn,
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
                              } else if (state.selectedTab ==
                                  "warehouse_order") {
                                if (state.listOrder.isNotEmpty) {
                                  return Column(
                                    spacing: 4.h,
                                    children: [
                                      ...state.listOrder.take(2).map((data) {
                                        return GestureDetector(
                                          onTap: () {
                                            context.push(
                                              "/detail_product_order/${data.id}",
                                            );
                                          },
                                          child: CardOrder(
                                            idOrder: data!.id,
                                            idBarang: data!.productCode,
                                            namaBarang: data!.productName,
                                            financeApproved:
                                                data!.financeApproved,
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
                                  spacing: 4.h,
                                  children: [
                                    ...state.listSalesOrder
                                        .take(2)
                                        .map(
                                          (e) => GestureDetector(
                                            onTap: () async {
                                              context.push(
                                                "/detail_sales_order/${e.id}",
                                              );
                                            },
                                            child: CardSales(
                                              idBarang: e!.productCode,
                                              namaBarang: e!.productName,
                                              financeApproved:
                                                  e!.financeApproved,
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
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
              if (state.isLoading)
                Container(
                  color: Colors.black26,
                  child: Center(
                    child: LoadingAnimationWidget.stretchedDots(
                      color: AppColors.softWhite,
                      size: 70.w,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
