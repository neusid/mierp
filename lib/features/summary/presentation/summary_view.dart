import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/summary/presentation/bloc/summary_bloc.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';
import 'package:mierp_apps/core/widgets/card_order.dart';
import 'package:mierp_apps/core/widgets/card_sales.dart';
import 'package:mierp_apps/core/widgets/card_stock.dart';

class SummaryView extends StatelessWidget {
  SummaryView({super.key});

  final convertDollar = ConvertDollar();

  final tabs = [
    {"title": "All Summary", "collection": "all_summary"},
    {"title": "Product", "collection": "products"},
    {"title": "Order", "collection": "orders"},
    {"title": "Sales Order", "collection": "sales_orders"},
  ];
  final options = ['All', 'Paid', 'Unpaid'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SummaryBloc>()..add(SummaryStarted()),
      child: BlocConsumer<SummaryBloc, SummaryState>(
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
          if (state.successMessage.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.successMessage)));
          }
        },
        builder: (context, state) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          context.pop();
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
                          SizedBox(
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
                                    onTapOutside: (event) {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                    controller: TextEditingController(
                                      text: state.keyword,
                                    ),
                                    onChanged: (value) {
                                      context.read<SummaryBloc>().add(
                                        SummarySearchChanged(value),
                                      );
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
                                      prefixIcon: Icon(
                                        Icons.search,
                                        size: 17.47.w,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Builder(
                                  builder: (context) {
                                    return Material(
                                      animateColor: true,
                                      child: PopupMenuButton<int>(
                                        enabled: state.selectedTab != "products" && state.selectedTab != "all_summary",
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.w),
                                        ),
                                        color: Colors.white,
                                        elevation: 8,
                                        offset: Offset(0, 40.h),
                                        constraints: BoxConstraints(
                                          minWidth: 150.w,
                                          maxWidth: 150.w,
                                        ),
                                        onSelected: (value) {
                                          context.read<SummaryBloc>().add(SummaryFilterChanged(value));
                                        },
                                        itemBuilder: (context) {
                                          return List.generate(options.length, (index) {
                                            bool isSelected = state.tag == index;
                                            return PopupMenuItem<int>(
                                              value: index,
                                              padding: EdgeInsets.zero,
                                              height: 45.h,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
                                                decoration: BoxDecoration(
                                                  gradient: isSelected ? AppColors.premiumDarkGradient : null,
                                                  color: isSelected ? null : const Color(0xFFF9FAFB),
                                                  borderRadius: BorderRadius.circular(10.w),
                                                  border: isSelected ? null : Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      options[index],
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14.sp,
                                                        fontWeight: isSelected ? AppFontWeight.bold : AppFontWeight.medium,
                                                        color: isSelected ? Colors.white : const Color(0xFF6B7280),
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      Icon(Icons.check, color: Colors.white, size: 18.w),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                        },
                                        child: Container(
                                          width: 30.03.w,
                                          height: 30.03.h,
                                          padding: EdgeInsets.all(6.w),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.w),
                                          ),
                                          child: SvgPicture.asset(
                                            "assets/icons/filter.svg",
                                            colorFilter: ColorFilter.mode(
                                              state.selectedTab != "products" && state.selectedTab != "all_summary"
                                                  ? AppColors.grayTitle
                                                  : Colors.grey,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 22.71.h),
                          Builder(
                            builder: (context) {
                              int selectedIndex = tabs.indexWhere(
                                (t) => t["collection"] == state.selectedTab,
                              );
                              if (selectedIndex == -1) selectedIndex = 0;

                              double alignmentX = -1.0;
                              if (selectedIndex == 1) alignmentX = -0.333;
                              if (selectedIndex == 2) alignmentX = 0.333;
                              if (selectedIndex == 3) alignmentX = 1.0;

                              return SizedBox(
                                width: 344.w,
                                height: 32.h,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    AnimatedAlign(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeOutQuart,
                                      alignment: Alignment(alignmentX, 1.0),
                                      child: Container(
                                        width: 78.w,
                                        height: 3.h,
                                        decoration: BoxDecoration(
                                          gradient: AppColors.premiumDarkGradient,
                                          borderRadius: BorderRadius.circular(
                                            1.5.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: tabs.map((data) {
                                        bool isSelected =
                                            state.selectedTab ==
                                            data["collection"];
                                        return GestureDetector(
                                          onTap: () {
                                            context.read<SummaryBloc>().add(
                                              SummaryTabChanged(
                                                data["collection"]!,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 78.w,
                                            height: 30.h,
                                            color: Colors.transparent,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: AnimatedDefaultTextStyle(
                                                    duration: const Duration(
                                                      milliseconds: 300,
                                                    ),
                                                    curve: Curves.easeInOut,
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 13.sp,
                                                      fontWeight: isSelected
                                                          ? AppFontWeight.bold
                                                          : AppFontWeight
                                                                .medium,
                                                      color: isSelected
                                                          ? AppColors
                                                                .premiumDarkSolid
                                                          : Colors.black,
                                                    ),
                                                    child: Text(
                                                      data["title"] ?? "",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        if (state.selectedTab == "all_summary") {
                          return Expanded(
                            child: SingleChildScrollView(
                              child: state.filteredSummaries.isNotEmpty
                                  ? Column(
                                      spacing: 10,
                                      children: [
                                        SizedBox(height: 3.w),
                                        ...state.filteredSummaries.map((e) {
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
                                                  namaBarang:
                                                      e.data.productName,
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
                                                  idOrder: e.data.id,
                                                  idBarang: e.data.productId,
                                                  namaBarang:
                                                      e.data.productName,
                                                  financeApproved:
                                                      e.data.financeApproved,
                                                  createdOn: e.data.orderDate,
                                                  nameUser: e.data.firstName,
                                                  quantity: e.data.quantity,
                                                  unitPrice: e.data.unitPrice,
                                                  lineTotal: e.data.totalCost,
                                                  imageProduct:
                                                      e.data.imageProduct,
                                                  finance:
                                                      state.role == "finance"
                                                      ? true
                                                      : null,
                                                  onPayPressed: () => context
                                                      .read<SummaryBloc>()
                                                      .add(
                                                        SummaryPayRequested(
                                                          e.data.id,
                                                          e.data.productId,
                                                          e.data.quantity,
                                                        ),
                                                      ),
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
                                                  namaBarang:
                                                      e.data.productName,
                                                  financeApproved:
                                                      e.data.financeApproved,
                                                  createdOn:
                                                      e.data.purchasedDate,
                                                  nameUser: e.data.firstName,
                                                  quantity: e.data.quantity,
                                                  unitPrice: e.data.unitPrice,
                                                  lineTotal: e.data.totalPrice,
                                                  nameCustomer:
                                                      e.data.companyName,
                                                  imageProduct:
                                                      e.data.imageProduct,
                                                ),
                                              );
                                          }
                                        }),
                                        SizedBox(height: 10.w),
                                      ],
                                    ).paddingOnly(top: 12.w, bottom: 24.w, left: 24.w, right: 24.w)
                                  : _buildEmptyState(),
                            ),
                          );
                        } else if (state.selectedTab == "products") {
                          return Expanded(
                            child: SingleChildScrollView(
                              child: state.filteredProducts.isNotEmpty
                                  ? Column(
                                      spacing: 10.w,
                                      children: state.filteredProducts.map((
                                        data,
                                      ) {
                                        return GestureDetector(
                                          onTap: () {
                                            context.push(
                                              "/detail_product/${data.id}",
                                            );
                                          },
                                          child: CardStock(
                                            idBarang: data.productCode,
                                            namaBarang: data.productName,
                                            quantity: data.quantity,
                                            unitPrice: data.unitPrice,
                                            lineTotal:
                                                data.unitPrice *
                                                data.quantity,
                                            type: data.category,
                                            image: data.imageProduct,
                                          ),
                                        );
                                      }).toList(),
                                    ).paddingOnly(top: 12.w, bottom: 24.w, left: 24.w, right: 24.w)
                                  : _buildEmptyState(),
                            ),
                          );
                        } else if (state.selectedTab == "orders") {
                          return Expanded(
                            child: SingleChildScrollView(
                              child: state.filteredOrders.isNotEmpty
                                  ? Column(
                                      spacing: 10.w,
                                      children: state.filteredOrders.map((
                                        data,
                                      ) {
                                        return GestureDetector(
                                          onTap: () {
                                            context.push(
                                              "/detail_product_order/data.id",
                                            );
                                          },
                                          child: CardOrder(
                                            idOrder: data.id ?? '',
                                            idBarang: data.productId,
                                            namaBarang: data.productName,
                                            financeApproved:
                                                data.financeApproved,
                                            createdOn: data.orderDate,
                                            nameUser: data.firstName,
                                            quantity: data.quantity,
                                            unitPrice: data.unitPrice,
                                            lineTotal: data.totalCost,
                                            imageProduct: data.imageProduct,
                                            finance: state.role == "finance"
                                                ? true
                                                : null,
                                            onPayPressed: () =>
                                                context.read<SummaryBloc>().add(
                                                  SummaryPayRequested(
                                                    data.id ?? '',
                                                    data.productId,
                                                    data.quantity,
                                                  ),
                                                ),
                                          ),
                                        );
                                      }).toList(),
                                    ).paddingOnly(top: 12.w, bottom: 24.w, left: 24.w, right: 24.w)
                                  : _buildEmptyState(),
                            ),
                          );
                        } else {
                          return Expanded(
                            child: SingleChildScrollView(
                              child: state.filteredSalesOrders.isNotEmpty
                                  ? Column(
                                      spacing: 10.w,
                                      children: state.filteredSalesOrders
                                          .map(
                                            (data) => GestureDetector(
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
                                                imageProduct:
                                                    data.imageProduct,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ).paddingOnly(top: 12.w, bottom: 24.w, left: 24.w, right: 24.w)
                                  : _buildEmptyState(),
                            ),
                          );
                        }
                      },
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
            ),
          );
        },
      ),
    );
  }
}

extension WidgetPaddingX on Widget {
  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // If you want to use the JPG version, comment the SvgPicture below and uncomment this Image widget:
          // Image.asset(
          //   'assets/images/folder_empty.jpg',
          //   width: 220.w,
          //   fit: BoxFit.contain,
          // ),
          SvgPicture.asset('assets/images/folder_empty.svg', width: 220.w),
          SizedBox(height: 24.h),
          Text(
            "Oops! No Data Available",
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: AppFontWeight.bold,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              "The data you're looking for isn't available yet.",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: AppFontWeight.medium,
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 60.h),
        ],
      ),
    );
  }
}
