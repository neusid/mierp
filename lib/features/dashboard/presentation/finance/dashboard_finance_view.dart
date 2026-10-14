import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/dashboard/presentation/finance/bloc/dashboard_finance_bloc.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';

import 'package:mierp_apps/core/widgets/card_order.dart';
import 'package:mierp_apps/core/widgets/card_sales.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/core/widgets/modal_pay_confirmation.dart';
import 'package:mierp_apps/features/payment/presentation/payment_success_view.dart';
import 'package:mierp_apps/core/services/export_service.dart';
import 'package:mierp_apps/core/widgets/modal_export_sheet.dart';
import 'package:mierp_apps/features/main_page/presentation/cubit/main_page_cubit.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_state.dart';

class DashboardFinanceView extends StatefulWidget {
  const DashboardFinanceView({super.key});

  @override
  State<DashboardFinanceView> createState() => _DashboardFinanceViewState();
}

class _DashboardFinanceViewState extends State<DashboardFinanceView> {
  final convertDollar = ConvertDollar();
  Map<String, dynamic>? _lastPaidOrder;

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
            final orderInfo = _lastPaidOrder;
            _lastPaidOrder = null;
            final bloc = context.read<DashboardFinanceBloc>();
            bloc.add(DashboardFinanceMessageCleared());

            if (orderInfo != null) {
              PaymentSuccessView.open(
                context,
                invoiceId: orderInfo['invoiceId'] ?? '-',
                productName: orderInfo['productName'] ?? 'Order',
                quantity: orderInfo['quantity'] ?? 1,
                amount: orderInfo['amount'] ?? '\$0',
                requestedBy: orderInfo['requestedBy'],
                paymentType: orderInfo['paymentType'] ?? 'Warehouse Order',
              ).then((result) {
                if (mounted && result == true) {
                  bloc.add(DashboardFinanceStarted());
                }
              });
            } else {
              CustomTopSnackbar.success(context, state.successMessage);
            }
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
              elevation: 0,
              scrolledUnderElevation: 0,
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
                ),
                child: Stack(
                  children: [
                    // Top-Left Transparent Purple Gradient Circle
                    Positioned(
                      top: -30.h,
                      left: -20.w,
                      child: Container(
                        width: 140.w,
                        height: 140.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF9333EA).withValues(alpha: 0.22),
                              const Color(0xFF9333EA).withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Bottom-Right Transparent Indigo Gradient Circle
                    Positioned(
                      bottom: -20.h,
                      right: -20.w,
                      child: Container(
                        width: 130.w,
                        height: 130.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF6366F1).withValues(alpha: 0.18),
                              const Color(0xFF6366F1).withValues(alpha: 0.0),
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
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. AVATAR SQUIRCLE DIBESARKAN HINGGA TINGGINYA SERUPA DENGAN BLOK PROFIL
                      AspectRatio(
                        aspectRatio: 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B1566), Color(0xFF1E0B36)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.22),
                              width: 1.2.w,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person_rounded,
                              color: const Color(0xFFE9D5FF),
                              size: 32.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // 2. USER INFO: ROLE PILL (FINANCE DEPT), GREETING, NAMA USER
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFA855F7),
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
                            SizedBox(height: 2.h),
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
                      // 3. FROSTED SQUIRCLE NOTIFICATION BUTTON
                      Center(
                        child: InkWell(
                          onTap: () {
                            context.push('/notification');
                          },
                          borderRadius: BorderRadius.circular(13.w),
                          child: Container(
                            width: 42.w,
                            height: 42.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(13.w),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.14),
                                width: 1.2.w,
                              ),
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
                                  child: BlocSelector<NotificationCubit, NotificationState, bool>(
                                    selector: (state) => state.unreadCount > 0,
                                    builder: (context, hasUnread) {
                                      if (!hasUnread) return const SizedBox.shrink();
                                      return Container(
                                        width: 8.w,
                                        height: 8.w,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFEF4444),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6.w),
                                      ),
                                      child: Text(
                                        "USD",
                                        style: GoogleFonts.inter(
                                          fontSize: 9.w,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Icon(
                                      Icons.trending_up_rounded,
                                      color: const Color(0xFF34D399),
                                      size: 13.w,
                                    ),
                                    SizedBox(width: 2.w),
                                    Flexible(
                                      child: Text(
                                        "+12.4%",
                                        style: GoogleFonts.inter(
                                          fontSize: 10.w,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF34D399),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 6.w),
                              InkWell(
                                onTap: () {
                                  try {
                                    context.read<MainPageCubit>().changeIndex(1);
                                  } catch (_) {
                                    context.push("/summary");
                                  }
                                },
                                borderRadius: BorderRadius.circular(11.w),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
                                      fontSize: 9.5.w,
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
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Divider(
                            color: const Color(0xFFE2E8F0),
                            thickness: 1.2.w,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        InkWell(
                          onTap: () {
                            ModalExportSheet.show(
                              context,
                              reportTitle: "Laporan Finansial & Penjualan",
                              subtitle: "Ekspor daftar transaksi penjualan & status pelunasan",
                              onExport: (format) async {
                                await ExportService.exportSalesOrders(
                                  salesOrders: state.listSalesOrder,
                                  companyName: "MiERP Finance",
                                  format: format,
                                  context: context,
                                );
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E8FF),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: const Color(0xFFDDD6FE), width: 1.w),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.ios_share_rounded, size: 14.w, color: const Color(0xFF7C3AED)),
                                SizedBox(width: 4.w),
                                Text(
                                  "Export",
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF7C3AED),
                                  ),
                                ),
                              ],
                            ),
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
                    ),                    SizedBox(height: 18.h),
                    // 4. ACTIONABLE PENDING APPROVALS (FINANCE ACTION CENTER)
                    Builder(
                      builder: (context) {
                        final pendingOrders = state.listOrder
                            .where((e) => e.financeApproved != true && e.isRejected != true)
                            .toList();
                        final pendingSales = state.listSalesOrder
                            .where((e) => e.financeApproved != true && e.isRejected != true)
                            .toList();
                        final int totalPending = pendingOrders.length + pendingSales.length;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section Header
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: totalPending > 0
                                          ? const Color(0xFFF59E0B)
                                          : const Color(0xFF10B981),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (totalPending > 0
                                                  ? const Color(0xFFF59E0B)
                                                  : const Color(0xFF10B981))
                                              .withValues(alpha: 0.5),
                                          blurRadius: 4.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Pending Approvals",
                                    style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      color: const Color(0xFF0F172A),
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 7.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: totalPending > 0
                                          ? const Color(0xFFFEF3C7)
                                          : const Color(0xFFD1FAE5),
                                      borderRadius: BorderRadius.circular(10.w),
                                    ),
                                    child: Text(
                                      "$totalPending Tasks",
                                      style: GoogleFonts.inter(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        color: totalPending > 0
                                            ? const Color(0xFFD97706)
                                            : const Color(0xFF059669),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      try {
                                        context.read<MainPageCubit>().changeIndex(1);
                                      } catch (_) {
                                        context.push("/summary");
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "Lihat Semua",
                                          style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            color: const Color(0xFF7C3AED),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: const Color(0xFF7C3AED),
                                          size: 10.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 14.h),

                            // Items / Empty State
                            if (totalPending == 0)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 26.h, horizontal: 20.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.w),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.02),
                                      blurRadius: 10.w,
                                      offset: Offset(0, 4.w),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 44.w,
                                      height: 44.w,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFECFDF5),
                                      ),
                                      child: Icon(
                                        Icons.check_circle_outline_rounded,
                                        color: const Color(0xFF059669),
                                        size: 24.w,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      "Semua Tagihan Lunas",
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "Tidak ada pesanan atau tagihan yang menunggu persetujuan finance.",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5.sp,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Column(
                                spacing: 10.w,
                                children: [
                                  // Up to 2 pending product orders
                                  ...pendingOrders.take(2).map((data) {
                                    return GestureDetector(
                                      onTap: () {
                                        context.push(
                                          "/detail_product_order/${data.id}",
                                        ).then((_) {
                                          if (context.mounted) {
                                            context.read<DashboardFinanceBloc>().add(DashboardFinanceStarted());
                                          }
                                        });
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
                                        isRejected: data.isRejected,
                                        rejectionReason: data.rejectionReason,
                                        onPayPressed: () {
                                          showPayConfirmationModal(
                                            context: context,
                                            orderId: data.id ?? "",
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
                                                'invoiceId': data.id ?? "",
                                                'productName': data.productName,
                                                'quantity': data.quantity,
                                                'amount': convertDollar.intToDollar(data.totalCost),
                                                'requestedBy': data.firstName,
                                                'paymentType': 'Warehouse Order',
                                              };
                                              context.read<DashboardFinanceBloc>().add(
                                                DashboardFinancePayProductRequested(
                                                  data.id ?? "",
                                                  data.productId,
                                                  data.quantity,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                  // Up to 2 pending sales orders
                                  ...pendingSales.take(2).map((data) {
                                    return GestureDetector(
                                      onTap: () {
                                        context.push(
                                          "/detail_sales_order/${data.id}",
                                        ).then((_) {
                                          if (context.mounted) {
                                            context.read<DashboardFinanceBloc>().add(DashboardFinanceStarted());
                                          }
                                        });
                                      },
                                      child: CardSales(
                                        idBarang: data.productCode,
                                        namaBarang: data.productName,
                                        financeApproved: data.financeApproved,
                                        createdOn: data.purchasedDate,
                                        nameUser: data.firstName,
                                        quantity: data.quantity,
                                        unitPrice: data.unitPrice,
                                        lineTotal: data.totalPrice,
                                        nameCustomer: data.companyName,
                                        imageProduct: data.imageProduct,
                                        discountPercent: data.discountPercent,
                                        discountMax: data.discountMax,
                                        finance: true,
                                        isRejected: data.isRejected,
                                        rejectionReason: data.rejectionReason,
                                        onPayPressed: () {
                                          showPayConfirmationModal(
                                            context: context,
                                            orderId: data.id ?? "",
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
                                                'invoiceId': data.id ?? "",
                                                'productName': data.productName,
                                                'quantity': data.quantity,
                                                'amount': convertDollar.intToDollar(data.totalPrice),
                                                'requestedBy': data.companyName.isNotEmpty
                                                    ? data.companyName
                                                    : data.firstName,
                                                'paymentType': 'Sales Order',
                                              };
                                              context.read<DashboardFinanceBloc>().add(
                                                DashboardFinancePaySalesRequested(
                                                  data.id ?? "",
                                                  data.productId,
                                                  data.quantity,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                ],
                              ),
                          ],
                        );
                      },
                    ),
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
              onTap: () {
                context.read<DashboardFinanceBloc>().add(const DashboardFinanceTabChanged("orders"));
              },
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
              onTap: () {
                context.read<DashboardFinanceBloc>().add(const DashboardFinanceTabChanged("sales_orders"));
              },
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
              onTap: () {
                try {
                  context.read<MainPageCubit>().changeIndex(3);
                } catch (_) {}
              },
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
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
      ),
    );
  }
}

