import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/dashboard/presentation/finance/bloc/dashboard_finance_bloc.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';

import 'package:mierp_apps/core/widgets/card_order.dart';
import 'package:mierp_apps/core/widgets/card_sales.dart';
import 'package:mierp_apps/core/widgets/card_stock.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/core/widgets/modal_pay_confirmation.dart';


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
        listenWhen: (previous, current) =>
            (previous.successMessage != current.successMessage && current.successMessage.isNotEmpty) ||
            (previous.errorMessage != current.errorMessage && current.errorMessage.isNotEmpty),
        listener: (context, state) {
          if (state.successMessage.isNotEmpty) {
            CustomTopSnackbar.success(context, state.successMessage);
            context.read<DashboardFinanceBloc>().add(DashboardFinanceMessageCleared());
          }
          if (state.errorMessage.isNotEmpty) {
            CustomTopSnackbar.error(context, state.errorMessage);
            context.read<DashboardFinanceBloc>().add(DashboardFinanceMessageCleared());
          }
        },
        builder: (context, state) {
          return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 110.h,
              collapsedHeight: 110.h,
              pinned: true,
              floating: false,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2E1052),
                      Color(0xFF1E0B36),
                      AppColors.gray,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28.w),
                    bottomRight: Radius.circular(28.w),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E1052).withValues(alpha: 0.35),
                      offset: Offset(0, 8.w),
                      blurRadius: 16.w,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Top-Left Purple Ambient Light Orb
                    Positioned(
                      top: -30.h,
                      left: -20.w,
                      child: Container(
                        width: 140.w,
                        height: 140.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF9333EA).withValues(alpha: 0.16),
                        ),
                      ),
                    ),
                    // Bottom-Right Deep Indigo Ambient Orb
                    Positioned(
                      bottom: -20.h,
                      right: -20.w,
                      child: Container(
                        width: 130.w,
                        height: 130.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                        ),
                      ),
                    ),
                    // Hairline Frosted Glass Bottom Border
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1.5.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(28.w),
                            bottomRight: Radius.circular(28.w),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF9333EA).withValues(alpha: 0.4),
                              const Color(0xFFC084FC).withValues(alpha: 0.5),
                              const Color(0xFF818CF8).withValues(alpha: 0.2),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. AVATAR WITH GLOW RING
                    Stack(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          padding: EdgeInsets.all(2.5.w),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFFC084FC), Color(0xFF7C3AED)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF2E1052),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.person_rounded,
                                color: const Color(0xFFE9D5FF),
                                size: 26.w,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 1.w,
                          right: 1.w,
                          child: Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF10B981),
                              border: Border.all(
                                color: const Color(0xFF2E1052),
                                width: 2.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.6),
                                  blurRadius: 4.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    // 2. USER INFO: ROLE PILL, GREETING, NAME
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Role Badge Pill "FINANCE DEPT"
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.5.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C3AED).withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(10.w),
                              border: Border.all(
                                color: const Color(0xFFA855F7).withValues(alpha: 0.35),
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5.w,
                                  height: 5.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFA855F7),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFA855F7).withValues(alpha: 0.6),
                                        blurRadius: 3.w,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  "FINANCE DEPT",
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFD8B4FE),
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            "Good Morning,",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 11.5.sp,
                              color: const Color(0xFFCBD5E1),
                            ),
                          ),
                          Text(
                            state.userName.isNotEmpty ? state.userName : "Finance Officer",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 17.5.sp,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // 3. FROSTED SQUIRCLE NOTIFICATION BUTTON WITH UNREAD DOT
                    InkWell(
                      onTap: () {
                        context.push('/notification');
                      },
                      borderRadius: BorderRadius.circular(13.w),
                      child: Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(13.w),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.14),
                            width: 1.2.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              offset: Offset(0, 2.w),
                              blurRadius: 4.w,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none_rounded,
                              color: const Color(0xFFF1F5F9),
                              size: 22.w,
                            ),
                            Positioned(
                              top: 9.w,
                              right: 9.w,
                              child: Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFEF4444),
                                  border: Border.all(
                                    color: AppColors.gray,
                                    width: 1.2.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFEF4444).withValues(alpha: 0.6),
                                      blurRadius: 4.w,
                                    ),
                                  ],
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
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 12.w),
                child: Column(
                  children: [
                    // 1. HERO TOTAL BALANCE CARD (REPLACES CARDBOX.PNG)
                    Container(
                      width: 345.w,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF241042),
                            Color(0xFF1E1238),
                            Color(0xFF0F172A),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.w),
                        border: Border.all(
                          color: const Color(0xFFA855F7).withValues(alpha: 0.35),
                          width: 1.2.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2E1052).withValues(alpha: 0.32),
                            offset: Offset(0, 10.w),
                            blurRadius: 16.w,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Net Balance",
                                style: GoogleFonts.inter(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFC4B5FD),
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(10.w),
                                  border: Border.all(
                                    color: const Color(0xFF34D399).withValues(alpha: 0.35),
                                    width: 1.w,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 5.w,
                                      height: 5.w,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF34D399),
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      "Updated Today",
                                      style: GoogleFonts.inter(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF6EE7B7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            ConvertDollar().intToDollar(state.productsItem),
                            style: GoogleFonts.inter(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.8,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6.w),
                                ),
                                child: Text(
                                  "USD (\$)",
                                  style: GoogleFonts.inter(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.trending_up_rounded,
                                    color: const Color(0xFF34D399),
                                    size: 14.w,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    "+12.4% this month",
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF34D399),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  context.push("/summary");
                                },
                                borderRadius: BorderRadius.circular(11.w),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(11.w),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Text(
                                    "Report ➔",
                                    style: GoogleFonts.inter(
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    // 2. FINANCE DETAILS SECTION HEADER
                    Row(
                      children: [
                        Text(
                          "Finance Details",
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFE2E8F0),
                            thickness: 1.2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    // 3. CONSOLIDATED METRIC STRIP CARD
                    _ConsolidatedMetricsCard(
                      payables: state.accountPayables,
                      receivables: state.accountReceivables,
                      settled: state.settled,
                    ),
                    SizedBox(height: 18.h),
                    // 4. SEGMENTED TAB BAR
                    Container(
                      width: 345.w,
                      height: 48.h,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2.w),
                        borderRadius: BorderRadius.circular(14.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            offset: Offset(0, 4.w),
                            blurRadius: 14.w,
                          ),
                        ],
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
                              width: 337.w,
                              height: 40.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AnimatedAlign(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutQuart,
                                    alignment: Alignment(alignmentX, 0),
                                    child: Container(
                                      width: 337.w / 4,
                                      height: 38.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.w),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF7C3AED),
                                            Color(0xFF4F46E5),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                                            blurRadius: 8.w,
                                            offset: Offset(0, 2.w),
                                          ),
                                        ],
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
                                            height: 38.h,
                                            color: Colors.transparent,
                                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                                            child: Center(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: AnimatedDefaultTextStyle(
                                                  duration: const Duration(milliseconds: 300),
                                                  curve: Curves.easeOutQuart,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 11.sp,
                                                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                                    color: isActive ? Colors.white : const Color(0xFF64748B),
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
                    SizedBox(height: 18.h),
                    // 6. RECENT SUMMARY HEADER
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent Summary",
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              color: const Color(0xFF0F172A),
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
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
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5.sp,
                                    color: const Color(0xFF7C3AED),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                ),
                                SizedBox(width: 4.w),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: const Color(0xFF7C3AED),
                                  size: 11.w,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Builder(builder: (context) {
                      if (state.selectedTab == "all_summary") {
                        return Column(
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
                          );
                      } else if (state.selectedTab == "products") {
                        if (state.selectedTab.isNotEmpty) {
                          return Column(
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
                                    onPayPressed: () {
                                      showPayConfirmationModal(
                                        context: context,
                                        orderId: data.id,
                                        amount: ConvertDollar().intToDollar(data.totalCost),
                                        onConfirm: () => context
                                            .read<DashboardFinanceBloc>()
                                            .add(
                                              DashboardFinancePayProductRequested(
                                                data.id ?? "",
                                                data.productId,
                                                data.quantity,
                                              ),
                                            ),
                                      );
                                    },
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

class _ConsolidatedMetricsCard extends StatelessWidget {
  final int payables;
  final int receivables;
  final int settled;

  const _ConsolidatedMetricsCard({
    required this.payables,
    required this.receivables,
    required this.settled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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
            offset: Offset(0, 4.h),
            blurRadius: 10.w,
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Payables
          Expanded(
            child: _buildMetricItem(
              title: "Payables",
              value: ConvertDollar().intToDollar(payables),
              accentColor: const Color(0xFFEF4444),
              bgAccentColor: const Color(0xFFFEF2F2),
              icon: Icons.arrow_outward_rounded,
            ),
          ),
          // Vertical Divider 1
          Container(
            width: 1.w,
            height: 46.h,
            color: const Color(0xFFF1F5F9),
          ),
          // 2. Receivables
          Expanded(
            child: _buildMetricItem(
              title: "Receivable",
              value: ConvertDollar().intToDollar(receivables),
              accentColor: const Color(0xFF4F46E5),
              bgAccentColor: const Color(0xFFEEF2FF),
              icon: Icons.south_west_rounded,
            ),
          ),
          // Vertical Divider 2
          Container(
            width: 1.w,
            height: 46.h,
            color: const Color(0xFFF1F5F9),
          ),
          // 3. Settled
          Expanded(
            child: _buildMetricItem(
              title: "Settled",
              value: ConvertDollar().intToDollar(settled),
              accentColor: const Color(0xFF10B981),
              bgAccentColor: const Color(0xFFECFDF5),
              icon: Icons.check_circle_outline_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String title,
    required String value,
    required Color accentColor,
    required Color bgAccentColor,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: bgAccentColor,
                  borderRadius: BorderRadius.circular(6.w),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 11.5.w,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

