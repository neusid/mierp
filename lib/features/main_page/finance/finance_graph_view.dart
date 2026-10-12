import 'package:flutter/material.dart';
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
import 'package:mierp_apps/core/widgets/dashboard/blanket_mattress_widget.dart';
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

                  // 3. SECTION HEADER: FINANCIAL OBLIGATIONS & RECEIVABLES
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 16.w,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Financial Obligations & Receivables",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: AppFontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // 4. CARD 1: PENDING RECEIVABLES (Piutang Customer)
                  BlanketMattressWidget(
                    title: "Customer Receivables",
                    subtitle: "Pending Invoices",
                    count: pendingReceivables.length,
                    rightTitle: "Pending Amount",
                    rightSubtitle: convertDollar.intToDollar(totalReceivablesDue),
                    progress: state.listSalesOrder.isNotEmpty
                        ? (pendingReceivables.length / state.listSalesOrder.length).clamp(0.0, 1.0)
                        : 0.0,
                    themeColor: const Color(0xFF8B5CF6),
                    themeBgColor: const Color(0xFFF3E8FF),
                    headerIcon: Icons.receipt_long_rounded,
                    buttonText: "Lihat Semua Piutang ➔",
                    items: pendingReceivables.isNotEmpty
                        ? pendingReceivables
                            .take(2)
                            .map(
                              (e) => {
                                "title": e.companyName.isNotEmpty
                                    ? e.companyName
                                    : "Order #${(e.id != null && e.id!.length >= 5) ? e.id!.substring(0, 5) : e.id}",
                                "subtitle":
                                    "Order #${(e.id != null && e.id!.length >= 5) ? e.id!.substring(0, 5) : e.id} • ${e.productName}",
                                "badge": convertDollar.intToDollar(e.totalPrice),
                                "image": e.imageProduct,
                              },
                            )
                            .toList()
                        : [
                            {
                              "title": "Semua Piutang Lunas",
                              "subtitle": "Tidak ada tagihan tertunggak",
                              "badge": "Settled",
                              "image": "",
                            }
                          ],
                    onTapButton: () => context.push("/summary"),
                  ),
                  SizedBox(height: 20.h),

                  // 5. CARD 2: PENDING PAYABLES (Hutang Pengadaan / Supplier)
                  BlanketMattressWidget(
                    title: "Supplier Payables",
                    subtitle: "Pending POs",
                    count: pendingPayables.length,
                    rightTitle: "Amount Due",
                    rightSubtitle: convertDollar.intToDollar(totalPayablesDue),
                    progress: state.listOrder.isNotEmpty
                        ? (pendingPayables.length / state.listOrder.length).clamp(0.0, 1.0)
                        : 0.0,
                    themeColor: const Color(0xFF94A3B8),
                    themeBgColor: const Color(0xFFF1F5F9),
                    headerIcon: Icons.shopping_bag_outlined,
                    buttonText: "Bayar Tagihan Pengadaan ➔",
                    items: pendingPayables.isNotEmpty
                        ? pendingPayables
                            .take(2)
                            .map(
                              (e) => {
                                "title": e.productName.isNotEmpty
                                    ? e.productName
                                    : "PO #${(e.id != null && e.id!.length >= 5) ? e.id!.substring(0, 5) : e.id}",
                                "subtitle":
                                    "PO #${(e.id != null && e.id!.length >= 5) ? e.id!.substring(0, 5) : e.id} • ${e.quantity} Pcs",
                                "badge": convertDollar.intToDollar(e.totalCost),
                                "image": e.imageProduct,
                              },
                            )
                            .toList()
                        : [
                            {
                              "title": "Semua Tagihan Lunas",
                              "subtitle": "Tidak ada hutang pengadaan pending",
                              "badge": "Settled",
                              "image": "",
                            }
                          ],
                    onTapButton: () => context.push("/summary"),
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
                        color: Color(0xFFC084FC),
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
                            color: Color(0xFFC084FC),
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
