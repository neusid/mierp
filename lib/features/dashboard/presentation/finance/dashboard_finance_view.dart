import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/dashboard/presentation/finance/bloc/dashboard_finance_bloc.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';
import 'package:mierp_apps/core/widgets/dashboard/blanket_mattress_widget.dart';

import 'package:mierp_apps/core/widgets/card_order.dart';
import 'package:mierp_apps/core/widgets/card_sales.dart';
import 'package:mierp_apps/core/widgets/card_stock.dart';


class DashboardFinanceView extends StatelessWidget {
  DashboardFinanceView({super.key});

  final tabs = [
    {"title": "All Summary", "collection": "all_summary"},
    {"title": "Order", "collection": "warehouse_order"},
    {"title": "Sales Order", "collection": "sales_order"},
    {"title": "Stock", "collection": "products"},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardFinanceBloc>()..add(DashboardFinanceStarted()),
      child: BlocConsumer<DashboardFinanceBloc, DashboardFinanceState>(
        listener: (context, state) {
          if (state.successMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage)));
          }
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
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
                                    Text(
                                        "${state.userName}!",
                                        style: GoogleFonts.lexendDeca(
                                          fontWeight: AppFontWeight.semiBold,
                                          fontSize: 19.sp,
                                          color: AppColors.grayTitle,
                                        ),
                                      ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.push('/notification');
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
                          Container(
                              child: Text(
                                ConvertDollar().intToDollar(
                                  state.productsItem,
                                ),
                                style: GoogleFonts.manrope(
                                  fontSize: 16.sp,
                                  color: Color(0xFFFEFEFE),
                                  fontWeight: AppFontWeight.medium,
                                ),
                              ),
                            ),
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
                    SizedBox(
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
                    Row(
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
                                    SizedBox(
                                      width: 40.w,
                                      child: Text(
                                        ConvertDollar().intToDollar(
                                          state.accountPayables,
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
                                    SizedBox(
                                      width: 40.w,
                                      child: Text(
                                        ConvertDollar().intToDollar(
                                          state.accountReceivables,
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
                                    SizedBox(
                                      width: 40.w,
                                      child: Text(
                                        ConvertDollar().intToDollar(
                                          state.settled,
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
                      ),
                    SizedBox(height: 12.3.h),
                    Column(
                      spacing: 0,
                      children: [
                        BlanketMattressWidget(
                          title: "Low Stock",
                          subtitle: "Items Low Stock",
                          count: state.lowStock,
                          rightTitle: "Action Required",
                          rightSubtitle: "2/5",
                          progress: 0.4,
                          themeColor: const Color(0xFFEF4444),
                          themeBgColor: const Color(0xFFFEF2F2),
                          headerIcon: Icons.warning_amber_rounded,
                          buttonText: "View All Low Stock Items ➔",
                          items: [
                            {"title": "MacBook Pro M2", "subtitle": "Electronics • SKU-MBP22", "badge": "2 Left"},
                            {"title": "Logitech MX Master 3S", "subtitle": "Peripherals • SKU-LOGI3S", "badge": "0 Left"},
                          ],
                        ),
                        BlanketMattressWidget(
                          title: "Incoming",
                          subtitle: "Incoming Deliveries",
                          count: state.upComingStock,
                          rightTitle: "Arriving Today",
                          rightSubtitle: "3/8",
                          progress: 0.375,
                          themeColor: const Color(0xFF4F46E5),
                          themeBgColor: const Color(0xFFEEF2FF),
                          headerIcon: Icons.local_shipping_outlined,
                          buttonText: "View All Incoming Stock ➔",
                          items: [
                            {"title": "Sony WH-1000XM5", "subtitle": "Audio • PO-1024", "badge": "15 Units"},
                            {"title": "Keychron K2 V2", "subtitle": "Peripherals • PO-1025", "badge": "40 Units"},
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
                        child: Builder(
                          builder: (context) {
                            int selectedIndex = tabs.indexWhere((t) => t["collection"] == state.selectedTab);
                            if (selectedIndex == -1) selectedIndex = 0;
                            
                            double alignmentX = -1.0;
                            if (selectedIndex == 1) alignmentX = -0.333;
                            if (selectedIndex == 2) alignmentX = 0.333;
                            if (selectedIndex == 3) alignmentX = 1.0;

                            return SizedBox(
                              width: 310.w,
                              height: 33.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AnimatedAlign(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutQuart,
                                    alignment: Alignment(alignmentX, 0),
                                    child: Container(
                                      width: 310.w / 4,
                                      height: 33.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(55.w),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF00B2FF),
                                            Color(0xFF7A00E6),
                                          ],
                                          transform: GradientRotation(-0.05.sw),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: tabs.map((e) {
                                      final isActive = state.selectedTab == e['collection'];
                                      return Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            context.read<DashboardFinanceBloc>().add(
                                              DashboardFinanceTabChanged(e['collection']!),
                                            );
                                          },
                                          child: Container(
                                            height: 33.h,
                                            color: Colors.transparent,
                                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                                            child: Center(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: AnimatedDefaultTextStyle(
                                                  duration: const Duration(milliseconds: 300),
                                                  curve: Curves.easeOutQuart,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11.sp,
                                                    fontWeight: isActive ? AppFontWeight.bold : AppFontWeight.medium,
                                                    color: isActive ? Colors.white : AppColors.charcoal,
                                                  ),
                                                  child: Text(e['title']!),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            );
                          }
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
                              context.push("/summary");
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
                    Builder(builder: (context) {
                      if (state.selectedTab == "all_summary") {
                        return Container(
                          child: Column(
                            spacing: 10.w,
                            children: [
                              ...state.listAllSummary.take(2).map((
                                e,
                              ) {
                                switch (e.summaryType) {
                                  case SummaryType.product:
                                    return GestureDetector(
                                      onTap: () {
                                        context.push(
                                          "/detail_product/${e.data.id}",
                                        );
                                      },
                                      child: CardStock(
                                        idBarang: e.data.productCode,
                                        namaBarang: e.data.productName,
                                        quantity: e.data.quantity,
                                        unitPrice: e.data.unitPrice,
                                        lineTotal:
                                            e.data.unitPrice *
                                            e.data.quantity,
                                        type: e.data.category,
                                        image: e.data.imageProduct,
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
                                        context.push(
                                          "/detail_sales_order/${e.data.id}",
                                        );
                                      },
                                      child: CardSales(
                                        idBarang: e.data.productCode,
                                        namaBarang: e.data.productName,
                                        financeApproved:
                                            e.data.financeApproved,
                                        createdOn: e.data.purchasedDate,
                                        nameUser: e.data.firstName,
                                        quantity: e.data.quantity,
                                        unitPrice: e.data.unitPrice,
                                        lineTotal: e.data.totalPrice,
                                        nameCustomer: e.data.companyName,
                                        imageProduct: e.data.imageProduct,
                                      ),
                                    );
                                }
                              }),
                              SizedBox(height: 5.w),
                            ],
                          ),
                        );
                      } else if (state.selectedTab == "products") {
                        if (state.selectedTab.isNotEmpty) {
                          return Container(
                            child: Column(
                              spacing: 10.w,
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
                                          idBarang: product.productCode,
                                          namaBarang: product.productName,
                                          quantity: product.quantity,
                                          unitPrice: product.unitPrice,
                                          lineTotal:
                                              product.unitPrice *
                                              product.quantity,
                                          type: product.category,
                                          image: product.imageProduct,
                                        ),
                                      ),
                                    )
                                    ,
                                SizedBox(height: 5.w),
                              ],
                            ),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      } else if (state.selectedTab ==
                          "warehouse_orders") {
                        if (state.listOrder.isNotEmpty) {
                          return Column(
                            spacing: 10.w,
                            children: [
                              ...state.listOrder.take(2).map((data) {
                                return GestureDetector(
                                  onTap: () {
                                    context.push(
                                      "/detail_product_order/${data.id}",
                                    );
                                  },
                                  child: CardOrder(
                                    idOrder: data.id,
                                    idBarang: data.productCode,
                                    namaBarang: data.productName,
                                    financeApproved: data.financeApproved,
                                    createdOn: data.orderDate,
                                    nameUser: data.firstName,
                                    quantity: data.quantity,
                                    unitPrice: data.unitPrice,
                                    lineTotal: data.totalCost,
                                    finance: true,
                                    imageProduct: data.imageProduct,
                                    onPayPressed: () =>
                                        context.read<DashboardFinanceBloc>().add(DashboardFinancePayProductRequested(
                                          data.id ?? "",
                                          data.productId ?? "",
                                          data.quantity ?? 0,
                                        )),
                                  ),
                                );
                              }),
                              SizedBox(height: 5.w),
                            ],
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      } else {
                        return Column(
                          children: [
                            ...state.listSalesOrder
                                .take(2)
                                .map(
                                  (data) => Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          context.push(
                                            "/detail_sales_order/${data.id}",
                                          );
                                        },
                                        child: CardSales(
                                          idBarang: data.productCode,
                                          namaBarang: data.productName,
                                          financeApproved:
                                              data.financeApproved,
                                          createdOn: data.purchasedDate,
                                          nameUser: data.firstName,
                                          quantity: data.quantity,
                                          unitPrice: data.unitPrice,
                                          lineTotal: data.totalPrice,
                                          nameCustomer: data.companyName,
                                          imageProduct: data.imageProduct,
                                        ),
                                      ),
                                      SizedBox(height: 10.w),
                                    ],
                                  ),
                                )
                                ,
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
        state.isLoading
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
        ],
      );
    },
    ),
    );
  }
}
