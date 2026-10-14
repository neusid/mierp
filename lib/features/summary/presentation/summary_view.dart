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
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/core/widgets/modal_pay_confirmation.dart';
import 'package:mierp_apps/features/payment/presentation/payment_success_view.dart';
import 'package:mierp_apps/features/main_page/presentation/cubit/main_page_cubit.dart';

class SummaryView extends StatefulWidget {
  final VoidCallback? onBack;
  const SummaryView({super.key, this.onBack});

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  final convertDollar = ConvertDollar();
  Map<String, dynamic>? _lastPaidOrder;

  final tabs = [
    {"title": "All Summary", "collection": "all_summary"},
    {"title": "Product", "collection": "products"},
    {"title": "Order", "collection": "orders"},
    {"title": "Sales Order", "collection": "sales_orders"},
  ];
  final options = ['All', 'Paid', 'Unpaid', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SummaryBloc>()..add(SummaryStarted()),
      child: BlocConsumer<SummaryBloc, SummaryState>(
        listenWhen: (previous, current) =>
            (previous.successMessage != current.successMessage && current.successMessage.isNotEmpty) ||
            (previous.errorMessage != current.errorMessage && current.errorMessage.isNotEmpty),
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            final errorText = state.errorMessage.startsWith('Exception')
                ? 'Gagal memuat data ringkasan. Silakan periksa koneksi Anda.'
                : state.errorMessage;
            CustomTopSnackbar.error(
              context,
              errorText,
              title: 'Gagal Memuat Data',
            );
            context.read<SummaryBloc>().add(SummaryMessageCleared());
          }
          if (state.successMessage.isNotEmpty) {
            final orderInfo = _lastPaidOrder;
            _lastPaidOrder = null;
            final bloc = context.read<SummaryBloc>();
            bloc.add(SummaryMessageCleared());

            if (orderInfo != null) {
              PaymentSuccessView.open(
                context,
                invoiceId: orderInfo['invoiceId'] ?? '-',
                productName: orderInfo['productName'] ?? 'Order',
                quantity: orderInfo['quantity'] ?? 1,
                amount: orderInfo['amount'] ?? '\$0',
                requestedBy: orderInfo['requestedBy'],
                paymentType: orderInfo['paymentType'] ?? 'Warehouse Order',
              ).then((_) {
          if (mounted) {
                  bloc.add(SummaryStarted());
                }
              });
            } else {
              CustomTopSnackbar.success(
                context,
                state.successMessage,
                title: 'Berhasil',
              );
            }
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
                                          if (widget.onBack != null) {
                                            widget.onBack!();
                                          } else if (context.canPop()) {
                                            context.pop();
                                          } else {
                                            try {
                                              context.read<MainPageCubit>().goToDashboard();
                                            } catch (_) {}
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(12.w),
                                        child: Container(
                                          padding: EdgeInsets.all(8.w),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(12.w),
                                          ),
                                          child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.charcoal, size: 24.w),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        state.role.toLowerCase() == "finance"
                                            ? "Approvals Summary"
                                            : "Back To Summary",
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
                                          minWidth: 160.w,
                                          maxWidth: 160.w,
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
                              final bool isFinance = state.role.toLowerCase() == "finance";
                              final activeTabs = isFinance
                                  ? tabs.where((t) => t["collection"] != "products").toList()
                                  : tabs;

                              int selectedIndex = activeTabs.indexWhere(
                                (t) => t["collection"] == state.selectedTab,
                              );
                              if (selectedIndex == -1) selectedIndex = 0;

                              double alignmentX = -1.0;
                              if (activeTabs.length == 3) {
                                if (selectedIndex == 0) alignmentX = -1.0;
                                if (selectedIndex == 1) alignmentX = 0.0;
                                if (selectedIndex == 2) alignmentX = 1.0;
                              } else {
                                if (selectedIndex == 0) alignmentX = -1.0;
                                if (selectedIndex == 1) alignmentX = -0.333;
                                if (selectedIndex == 2) alignmentX = 0.333;
                                if (selectedIndex == 3) alignmentX = 1.0;
                              }

                              final double tabItemWidth = activeTabs.length == 3 ? 96.w : 78.w;
                              final double indicatorWidth = activeTabs.length == 3 ? 84.w : 78.w;

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
                                        width: indicatorWidth,
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
                                      children: activeTabs.map((data) {
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
                                            width: tabItemWidth,
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
                                                  discountPercent: e.data.discountPercent,
                                                  discountMax: e.data.discountMax,
                                                ),
                                              );
                                            case SummaryType.order:
                                              return GestureDetector(
                                                onTap: () {
                                                  context.push(
                                                    "/detail_product_order/${e.data.id}",
                                                  ).then((_) {
                                                    if (context.mounted) {
                                                      context.read<SummaryBloc>().add(SummaryStarted());
                                                    }
                                                  });
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
                                                  isRejected: e.data.isRejected,
                                                  rejectionReason: e.data.rejectionReason,
                                                  finance: state.role.toLowerCase() == "finance",
                                                  onPayPressed: state.role.toLowerCase() == "finance"
                                                      ? () {
                                                          showPayConfirmationModal(
                                                      context: context,
                                                      orderId: e.data.id ?? '',
                                                      productName: e.data.productName ?? '',
                                                      productCode: e.data.productCode ?? '',
                                                      imageProduct: e.data.imageProduct ?? '',
                                                      quantity: e.data.quantity ?? 1,
                                                      unitPrice: e.data.unitPrice ?? 0,
                                                      totalCost: e.data.totalCost ?? 0,
                                                      discountPercent: e.data.discountPercent,
                                                      discountMax: e.data.discountMax,
                                                      requestedBy: e.data.firstName ?? '',
                                                      orderDate: e.data.orderDate ?? '',
                                                      onConfirm: () {
                                                        _lastPaidOrder = {
                                                          'invoiceId': e.data.id ?? '',
                                                          'productName': e.data.productName ?? '',
                                                          'quantity': e.data.quantity ?? 1,
                                                          'amount': convertDollar.intToDollar(e.data.totalCost ?? 0),
                                                          'requestedBy': e.data.firstName ?? '',
                                                          'paymentType': 'Warehouse Order',
                                                        };
                                                        context.read<SummaryBloc>().add(
                                                          SummaryPayRequested(
                                                            e.data.id,
                                                            e.data.productId,
                                                            e.data.quantity,
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                : null,
                                                ),
                                              );
                                            case SummaryType.salesOrder:
                                              return GestureDetector(
                                                onTap: () {
                                                  context.push(
                                                    "/detail_sales_order/${e.data.id}",
                                                  ).then((_) {
                                                    if (context.mounted) {
                                                      context.read<SummaryBloc>().add(SummaryStarted());
                                                    }
                                                  });
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
                                                  discountPercent: e.data.discountPercent,
                                                  discountMax: e.data.discountMax,
                                                  isRejected: e.data.isRejected,
                                                  rejectionReason: e.data.rejectionReason,
                                                  finance: state.role.toLowerCase() == "finance",
                                                  onPayPressed: state.role.toLowerCase() == "finance"
                                                      ? () {
                                                          showPayConfirmationModal(
                                                      context: context,
                                                      orderId: e.data.id ?? '',
                                                      productName: e.data.productName ?? '',
                                                      productCode: e.data.productCode ?? '',
                                                      imageProduct: e.data.imageProduct ?? '',
                                                      quantity: e.data.quantity ?? 1,
                                                      unitPrice: e.data.unitPrice ?? 0,
                                                      totalCost: e.data.totalPrice ?? 0,
                                                      discountPercent: e.data.discountPercent,
                                                      discountMax: e.data.discountMax,
                                                      requestedBy: (e.data.companyName != null && e.data.companyName.toString().isNotEmpty)
                                                          ? e.data.companyName
                                                          : (e.data.firstName ?? ''),
                                                      orderDate: e.data.purchasedDate ?? '',
                                                      onConfirm: () {
                                                        _lastPaidOrder = {
                                                          'invoiceId': e.data.id ?? '',
                                                          'productName': e.data.productName ?? '',
                                                          'quantity': e.data.quantity ?? 1,
                                                          'amount': convertDollar.intToDollar(e.data.totalPrice ?? 0),
                                                          'requestedBy': (e.data.companyName != null && e.data.companyName.toString().isNotEmpty)
                                                              ? e.data.companyName
                                                              : (e.data.firstName ?? ''),
                                                          'paymentType': 'Sales Order',
                                                        };
                                                        context.read<SummaryBloc>().add(
                                                          SummaryPaySalesRequested(
                                                            e.data.id,
                                                            e.data.productId,
                                                            e.data.quantity,
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }
                                                : null,
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
                                            discountPercent: data.discountPercent,
                                            discountMax: data.discountMax,
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
                                            final orderId = data.id ?? '';
                                            if (orderId.isNotEmpty) {
                                              context.push(
                                                "/detail_product_order/$orderId",
                                              ).then((_) {
                                                    if (context.mounted) {
                                                  context.read<SummaryBloc>().add(SummaryStarted());
                                                }
                                              });
                                            }
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
                                            isRejected: data.isRejected,
                                            rejectionReason: data.rejectionReason,
                                            finance: state.role.toLowerCase() == "finance",
                                            onPayPressed: state.role.toLowerCase() == "finance"
                                                ? () {
                                                    showPayConfirmationModal(
                                                context: context,
                                                orderId: data.id ?? '',
                                                productName: data.productName,
                                                productCode: data.productCode,
                                                imageProduct: data.imageProduct,
                                                quantity: data.quantity,
                                                unitPrice: data.unitPrice,
                                                totalCost: data.totalCost,
                                                discountPercent: data.discountPercent,
                                                discountMax: data.discountMax,
                                                requestedBy: data.firstName,
                                                orderDate: data.orderDate,
                                                onConfirm: () {
                                                  _lastPaidOrder = {
                                                    'invoiceId': data.id ?? '',
                                                    'productName': data.productName,
                                                    'quantity': data.quantity,
                                                    'amount': convertDollar.intToDollar(data.totalCost),
                                                    'requestedBy': data.firstName,
                                                    'paymentType': 'Warehouse Order',
                                                  };
                                                  context.read<SummaryBloc>().add(
                                                    SummaryPayRequested(
                                                      data.id ?? '',
                                                      data.productId,
                                                      data.quantity,
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          : null,
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
                                              onTap: () {
                                                context.push(
                                                  "/detail_sales_order/${data.id}",
                                                ).then((_) {
                                                    if (context.mounted) {
                                                    context.read<SummaryBloc>().add(SummaryStarted());
                                                  }
                                                });
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
                                                discountPercent: data.discountPercent,
                                                discountMax: data.discountMax,
                                                isRejected: data.isRejected,
                                                rejectionReason: data.rejectionReason,
                                                finance: state.role.toLowerCase() == "finance",
                                                onPayPressed: state.role.toLowerCase() == "finance"
                                                    ? () {
                                                        showPayConfirmationModal(
                                                    context: context,
                                                    orderId: data.id ?? '',
                                                    productName: data.productName,
                                                    productCode: data.productCode,
                                                    imageProduct: data.imageProduct,
                                                    quantity: data.quantity,
                                                    unitPrice: data.unitPrice,
                                                    totalCost: data.totalPrice,
                                                    discountPercent: data.discountPercent,
                                                    discountMax: data.discountMax,
                                                    requestedBy: data.companyName.isNotEmpty
                                                        ? data.companyName
                                                        : data.firstName,
                                                    orderDate: data.purchasedDate,
                                                    onConfirm: () {
                                                      _lastPaidOrder = {
                                                        'invoiceId': data.id ?? '',
                                                        'productName': data.productName,
                                                        'quantity': data.quantity,
                                                        'amount': convertDollar.intToDollar(data.totalPrice),
                                                        'requestedBy': data.companyName.isNotEmpty
                                                            ? data.companyName
                                                            : data.firstName,
                                                        'paymentType': 'Sales Order',
                                                      };
                                                      context.read<SummaryBloc>().add(
                                                        SummaryPaySalesRequested(
                                                          data.id ?? '',
                                                          data.productId,
                                                          data.quantity,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              : null,
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
            "Belum Ada Data Tersedia",
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: AppFontWeight.bold,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              "Data transaksi atau produk belum tercatat di sistem saat ini.",
              style: GoogleFonts.inter(
                fontSize: 13.5.sp,
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
}
