import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';
import 'package:mierp_apps/features/main_page/presentation/cubit/main_page_cubit.dart';
import 'package:mierp_apps/features/dashboard/presentation/finance/bloc/dashboard_finance_bloc.dart';

class FinanceGraphView extends StatelessWidget {
  const FinanceGraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardFinanceBloc>()..add(DashboardFinanceStarted()),
      child: Scaffold(
        backgroundColor: AppColors.softWhite,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Financial Analytics",
            style: GoogleFonts.inter(
              color: AppColors.charcoal,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<DashboardFinanceBloc, DashboardFinanceState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: AppColors.premiumDarkSolid,
                  size: 40.w,
                ),
              );
            }

            final convertDollar = ConvertDollar();

            // Calculate overall cash position
            final int totalInflow = state.listSalesOrder.fold<int>(
              0,
              (sum, e) => sum + e.totalPrice,
            );
            final int totalOutflow = state.listOrder.fold<int>(
              0,
              (sum, e) => sum + e.totalCost,
            );
            final int netCash = totalInflow - totalOutflow;

            // Pending obligations
            final pendingReceivables = state.listSalesOrder
                .where((e) => e.financeApproved != true)
                .toList();
            final int totalReceivablesDue = pendingReceivables.fold<int>(
              0,
              (sum, e) => sum + e.totalPrice,
            );

            final pendingPayables = state.listOrder
                .where((e) => e.financeApproved != true)
                .toList();
            final int totalPayablesDue = pendingPayables.fold<int>(
              0,
              (sum, e) => sum + e.totalCost,
            );

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HERO FINANCIAL SUMMARY (MiERP Signature Gradient)
                  _buildExecutiveHeroCard(
                    netCash: netCash,
                    totalInflow: totalInflow,
                    totalOutflow: totalOutflow,
                    convertDollar: convertDollar,
                  ),
                  SizedBox(height: 18.h),

                  // 2. DUAL-LINE CASH FLOW CURVE (Restrained Palette)
                  _buildCashFlowChart(state),
                  SizedBox(height: 24.h),

                  // 3. SECTION HEADER: LIQUIDITY & SETTLEMENT RATIOS
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                        ),
                        child: Icon(
                          Icons.pie_chart_outline_rounded,
                          size: 16.w,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Liquidity & Obligation Analysis",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: AppFontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // 4. SYMMETRICAL 50/50 RATIO CARDS: RECEIVABLES vs PAYABLES
                  Row(
                    children: [
                      // Card 1: Receivables Due
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.w),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10.w,
                                offset: Offset(0, 4.w),
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
                                    "Receivables",
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: AppFontWeight.medium,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF475569),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                convertDollar.intToDollar(totalReceivablesDue),
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  fontWeight: AppFontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "${pendingReceivables.length} invoices pending",
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: AppFontWeight.medium,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.w),
                                child: LinearProgressIndicator(
                                  value: state.listSalesOrder.isNotEmpty
                                      ? (1.0 - (pendingReceivables.length / state.listSalesOrder.length)).clamp(0.05, 1.0)
                                      : 0.05,
                                  minHeight: 5.h,
                                  backgroundColor: const Color(0xFFF1F5F9),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF475569)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // Card 2: Payables Due
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.w),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10.w,
                                offset: Offset(0, 4.w),
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
                                    "Payables",
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: AppFontWeight.medium,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF94A3B8),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                convertDollar.intToDollar(totalPayablesDue),
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  fontWeight: AppFontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "${pendingPayables.length} POs pending",
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: AppFontWeight.medium,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.w),
                                child: LinearProgressIndicator(
                                  value: state.listOrder.isNotEmpty
                                      ? (1.0 - (pendingPayables.length / state.listOrder.length)).clamp(0.05, 1.0)
                                      : 0.05,
                                  minHeight: 5.h,
                                  backgroundColor: const Color(0xFFF1F5F9),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF94A3B8)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // 5. PROJECTED NET CASH GAP & APPROVAL SHORTCUT CARD
                  Builder(
                    builder: (context) {
                      final bool isSurplus = (totalReceivablesDue - totalPayablesDue) >= 0;
                      final int netGap = totalReceivablesDue - totalPayablesDue;

                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(18.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.w),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10.w,
                              offset: Offset(0, 4.w),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tier 1: Header Row (Title & Status Badge - No Ellipsis)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Projected Settlement Gap",
                                    style: GoogleFonts.inter(
                                      fontSize: 13.sp,
                                      fontWeight: AppFontWeight.semiBold,
                                      color: const Color(0xFF475569),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.5.h),
                                  decoration: BoxDecoration(
                                    color: isSurplus ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                                    borderRadius: BorderRadius.circular(20.w),
                                    border: Border.all(
                                      color: isSurplus ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isSurplus ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                                        size: 13.w,
                                        color: isSurplus ? const Color(0xFF166534) : const Color(0xFF991B1B),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        isSurplus ? "Surplus Kas" : "Defisit Kas",
                                        style: GoogleFonts.inter(
                                          fontSize: 10.5.sp,
                                          fontWeight: FontWeight.w700,
                                          color: isSurplus ? const Color(0xFF166534) : const Color(0xFF991B1B),
                                          letterSpacing: 0.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),

                            // Tier 2: Large Bold Amount & Subtitle Explanation
                            Text(
                              isSurplus
                                  ? "+${convertDollar.intToDollar(netGap)}"
                                  : "-${convertDollar.intToDollar(netGap.abs())}",
                              style: GoogleFonts.inter(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                                letterSpacing: -0.6,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Estimasi selisih kas antara piutang dan hutang jatuh tempo",
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: AppFontWeight.medium,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Tier 3: Full-Width Solid Button CTA
                            InkWell(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                try {
                                  context.read<MainPageCubit>().changeIndex(1);
                                } catch (_) {
                                  context.push("/summary");
                                }
                              },
                              borderRadius: BorderRadius.circular(12.w),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  gradient: AppColors.premiumDarkGradient,
                                  borderRadius: BorderRadius.circular(12.w),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0F172A).withValues(alpha: 0.15),
                                      offset: Offset(0, 3.h),
                                      blurRadius: 8.w,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.task_alt_rounded,
                                      size: 16.w,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      "Buka Menu Approvals",
                                      style: GoogleFonts.inter(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: -0.1,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 15.w,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 36.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ================= 1. HERO FINANCIAL SUMMARY CARD =================
  Widget _buildExecutiveHeroCard({
    required int netCash,
    required int totalInflow,
    required int totalOutflow,
    required ConvertDollar convertDollar,
  }) {
    final bool isPositive = netCash >= 0;
    final String formattedNet = "${isPositive ? '+' : '-'}${convertDollar.intToDollar(netCash.abs())}";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        gradient: AppColors.premiumDarkGradient,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.premiumDarkSolid.withValues(alpha: 0.25),
            blurRadius: 16.w,
            offset: Offset(0, 6.w),
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
                "Net Cash Position",
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: AppFontWeight.medium,
                  color: const Color(0xFFCBD5E1),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5.w,
                      height: 5.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE2E8F0),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "7 Days Flow",
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: AppFontWeight.semiBold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            formattedNet,
            style: GoogleFonts.inter(
              fontSize: 26.sp,
              fontWeight: AppFontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 16.h),
          Divider(
            color: Colors.white.withValues(alpha: 0.1),
            thickness: 1,
            height: 1,
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              // Uang Masuk
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 7.w,
                          height: 7.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE2E8F0),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "Uang Masuk (Sales)",
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: AppFontWeight.medium,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      convertDollar.intToDollar(totalInflow),
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: AppFontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 28.h,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              // Uang Keluar
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 7.w,
                            height: 7.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF94A3B8),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "Uang Keluar (Order)",
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: AppFontWeight.medium,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        convertDollar.intToDollar(totalOutflow),
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: AppFontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= 2. DUAL-LINE CASH FLOW CHART =================
  Widget _buildCashFlowChart(DashboardFinanceState state) {
    final now = DateTime.now();
    final Map<String, int> salesPerDay = {};
    final Map<String, int> ordersPerDay = {};
    final List<String> labels = [];

    const weekdays = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];

    for (int i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final dateStr =
          "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
      salesPerDay[dateStr] = 0;
      ordersPerDay[dateStr] = 0;
      labels.add(weekdays[d.weekday - 1]);
    }

    final dateKeys = salesPerDay.keys.toList();

    for (var s in state.listSalesOrder) {
      if (s.purchasedDate.length >= 10) {
        final dStr = s.purchasedDate.substring(0, 10);
        if (salesPerDay.containsKey(dStr)) {
          salesPerDay[dStr] = salesPerDay[dStr]! + s.totalPrice;
        }
      }
    }

    for (var o in state.listOrder) {
      if (o.orderDate != null && o.orderDate!.length >= 10) {
        final dStr = o.orderDate!.substring(0, 10);
        if (ordersPerDay.containsKey(dStr)) {
          ordersPerDay[dStr] = ordersPerDay[dStr]! + o.totalCost;
        }
      }
    }

    List<FlSpot> inflowSpots = [];
    List<FlSpot> outflowSpots = [];
    double maxY = 0;

    for (int i = 0; i < dateKeys.length; i++) {
      final double inVal = (salesPerDay[dateKeys[i]] ?? 0).toDouble();
      final double outVal = (ordersPerDay[dateKeys[i]] ?? 0).toDouble();

      inflowSpots.add(FlSpot(i.toDouble(), inVal));
      outflowSpots.add(FlSpot(i.toDouble(), outVal));

      if (inVal > maxY) maxY = inVal;
      if (outVal > maxY) maxY = outVal;
    }

    maxY = maxY == 0 ? 5000 : maxY * 1.25;

    return Container(
      width: double.infinity,
      height: 240.h,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10.w,
            offset: Offset(0, 3.w),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cash Inflow & Outflow",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: AppFontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Tren perputaran kas 7 hari terakhir",
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: AppFontWeight.regular,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildLegend(const Color(0xFF7C3AED), "Masuk", false),
                  SizedBox(width: 10.w),
                  _buildLegend(const Color(0xFF64748B), "Keluar", true),
                ],
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: Color(0xFFF8FAFC),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx >= 0 && idx < labels.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 6.h),
                            child: Text(
                              labels[idx],
                              style: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42.w,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) {
                          return Text(r"$0", style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 9.sp));
                        }
                        if (value >= 1000000) {
                          return Text(
                            "\$${(value / 1000000).toStringAsFixed(1)}M",
                            style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 9.sp),
                          );
                        }
                        if (value >= 1000) {
                          return Text(
                            "\$${(value / 1000).toStringAsFixed(0)}k",
                            style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 9.sp),
                          );
                        }
                        return Text(
                          "\$${value.toInt()}",
                          style: TextStyle(color: const Color(0xFF94A3B8), fontSize: 9.sp),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: maxY,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF000000),
                    tooltipRoundedRadius: 8.r,
                    tooltipPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                    tooltipBorder: const BorderSide(color: Color(0xFF334155), width: 1.0),
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final isMasuk = spot.barIndex == 0;
                        final String tag = isMasuk ? "Masuk: " : "Keluar: ";
                        final String valStr = ConvertDollar().intToDollar(spot.y.toInt());
                        return LineTooltipItem(
                          "$tag$valStr\n",
                          GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: spot.x.toInt() < labels.length
                                  ? labels[spot.x.toInt()]
                                  : '',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  // Uang Masuk (Violet solid)
                  LineChartBarData(
                    spots: inflowSpots,
                    isCurved: true,
                    color: const Color(0xFF7C3AED),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF7C3AED).withValues(alpha: 0.15),
                          const Color(0xFF7C3AED).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Uang Keluar (Slate dashed)
                  LineChartBarData(
                    spots: outflowSpots,
                    isCurved: true,
                    color: const Color(0xFF64748B),
                    dashArray: [5, 4],
                    barWidth: 2.0,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF64748B).withValues(alpha: 0.08),
                          const Color(0xFF64748B).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildLegend(Color color, String label, bool isDashed) {
    return Row(
      children: [
        if (isDashed)
          SizedBox(
            width: 12.w,
            child: Row(
              children: [
                Container(width: 4.w, height: 2.h, color: color),
                SizedBox(width: 2.w),
                Container(width: 4.w, height: 2.h, color: color),
              ],
            ),
          )
        else
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        SizedBox(width: 5.w),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: AppFontWeight.medium,
            color: const Color(0xFF475569),
          ),
        ),
      ],
    );
  }
}
