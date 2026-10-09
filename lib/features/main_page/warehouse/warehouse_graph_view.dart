import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/dashboard/blanket_mattress_widget.dart';
import 'package:mierp_apps/features/dashboard/presentation/warehouse/bloc/dashboard_warehouse_bloc.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/core/models/all_summary.dart';

class WarehouseGraphView extends StatelessWidget {
  const WarehouseGraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardWarehouseBloc>()..add(DashboardWarehouseStarted()),
      child: Scaffold(
        backgroundColor: AppColors.softWhite,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Graph & Alerts",
            style: GoogleFonts.inter(
              color: AppColors.charcoal,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<DashboardWarehouseBloc, DashboardWarehouseState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: AppColors.blueGradient,
                  size: 40.w,
                ),
              );
            }

            // Calculate metric for Graph
            final int totalSales = state.listAllSummary
                .where((e) => e.summaryType == SummaryType.salesOrder)
                .length;
            final int totalPurchases = state.listAllSummary
                .where((e) => e.summaryType == SummaryType.order)
                .length;
            final int totalLowStock = state.totalLowStock;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    "Warehouse Metrics", 
                    Icons.bar_chart_rounded, 
                    const Color(0xFF3B82F6),
                  ),
                  SizedBox(height: 16.h),
                  _buildPieChart(
                    totalSales: totalSales,
                    totalPurchases: totalPurchases,
                    totalLowStock: totalLowStock,
                  ),
                  SizedBox(height: 20.h),
                  _buildLineChart(state.listAllSummary),
                  SizedBox(height: 32.h),
                  _buildSectionHeader(
                    "Alerts Preview", 
                    Icons.notifications_active_outlined, 
                    const Color(0xFFEF4444),
                  ),
                  SizedBox(height: 16.h),
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
                    items: (state.listProduct.toList()
                          ..sort(
                            (a, b) => a.quantity.compareTo(b.quantity),
                          ))
                        .take(2)
                        .map(
                          (e) => {
                            "title": e.productName,
                            "subtitle": "${e.category} • ${e.productCode}",
                            "badge": "${e.quantity} Left",
                            "image": e.imageProduct ?? "",
                          },
                        )
                        .toList(),
                    onTapButton: () {
                      context.push("/inventory_alerts/0");
                    },
                  ),
                  SizedBox(height: 20.h),
                  BlanketMattressWidget(
                    title: "Incoming Stock",
                    subtitle: "Track delivery progress",
                    count: state.totalUpcomingStock,
                    rightTitle: "In Transit",
                    rightSubtitle:
                        "${state.totalUpcomingStock} Order items coming",
                    progress: state.totalUpcomingStock > 0 ? 0.4 : 0.0,
                    themeColor: const Color(0xFF3B82F6),
                    themeBgColor: const Color(0xFFEFF6FF),
                    headerIcon: Icons.local_shipping_outlined,
                    buttonText: "View All Incoming Stock ➔",
                    items: (state.listOrder.toList()
                          ..sort((a, b) => (b.orderDate ?? "")
                              .compareTo(a.orderDate ?? "")))
                        .take(2)
                        .map(
                          (e) => {
                            "title": e.productName,
                            "subtitle": "Order #${(e.id != null && e.id!.length >= 5) ? e.id!.substring(0, 5) : e.id}",
                            "badge": "${e.quantity} Pcs",
                            "image": e.imageProduct,
                          },
                        )
                        .toList(),
                    onTapButton: () {
                      context.push("/inventory_alerts/1");
                    },
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPieChart({
    required int totalSales,
    required int totalPurchases,
    required int totalLowStock,
  }) {
    int totalAktivitas = totalSales + totalPurchases + totalLowStock;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.premiumDarkGradient,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.premiumDarkSolid.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100.w,
                height: 100.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100.w,
                      height: 100.w,
                      child: CircularProgressIndicator(
                        value: totalAktivitas > 0 ? 0.75 : 0, 
                        strokeWidth: 10.w,
                        color: AppColors.neonGreen,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "$totalAktivitas",
                          style: GoogleFonts.inter(
                            fontSize: 22.sp,
                            fontWeight: AppFontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          "Aktivitas",
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: AppFontWeight.medium,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.analytics_outlined, color: const Color(0xFFFACC15), size: 14.w),
                          SizedBox(width: 6.w),
                          Text(
                            "Overview Gudang",
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: AppFontWeight.semiBold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "$totalAktivitas Data",
                      style: GoogleFonts.inter(
                        fontSize: 22.sp,
                        fontWeight: AppFontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Progres tercatat 100%",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(child: _buildMetricPill("Keluar", totalSales, AppColors.vibrantOrange)),
              SizedBox(width: 8.w),
              Expanded(child: _buildMetricPill("Masuk", totalPurchases, AppColors.neonGreen)),
              SizedBox(width: 8.w),
              Expanded(child: _buildMetricPill("Low Stock", totalLowStock, const Color(0xFFEF4444))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMetricPill(String title, int value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: Colors.white70,
                    fontWeight: AppFontWeight.medium,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            "$value Item",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: AppFontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label, {Color textColor = const Color(0xFF334155)}) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: AppFontWeight.medium,
              color: textColor),
        ),
      ],
    );
  }

  Widget _buildLineChart(List<AllSummary> listAllSummary) {
    final now = DateTime.now();
    final Map<String, int> kelurPerDay = {};
    final Map<String, int> masukPerDay = {};

    for (int i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final dateStr =
          "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
      kelurPerDay[dateStr] = 0;
      masukPerDay[dateStr] = 0;
    }

    for (var summary in listAllSummary) {
      if (summary.createdOn.length >= 10) {
        String dStr = summary.createdOn.substring(0, 10);
        if (kelurPerDay.containsKey(dStr)) {
          if (summary.summaryType == SummaryType.salesOrder) {
            kelurPerDay[dStr] = kelurPerDay[dStr]! + 1;
          }
          if (summary.summaryType == SummaryType.order) {
            masukPerDay[dStr] = masukPerDay[dStr]! + 1;
          }
        }
      }
    }

    List<FlSpot> keluarSpots = [];
    List<FlSpot> masukSpots = [];
    List<String> labels = kelurPerDay.keys.toList();

    double maxY = 0;
    for (int i = 0; i < labels.length; i++) {
      double k = kelurPerDay[labels[i]]!.toDouble();
      double m = masukPerDay[labels[i]]!.toDouble();
      keluarSpots.add(FlSpot(i.toDouble(), k));
      masukSpots.add(FlSpot(i.toDouble(), m));
      if (k > maxY) maxY = k;
      if (m > maxY) maxY = m;
    }

    maxY = maxY == 0 ? 5 : maxY * 1.2;

    return Container(
      width: double.infinity,
      height: 250.h,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                "7 Days Trend",
                style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: AppFontWeight.semiBold,
                    color: const Color(0xFF334155)),
              ),
              Row(
                children: [
                  _buildLegend(AppColors.vibrantOrange, "Keluar"),
                  SizedBox(width: 8.w),
                  _buildLegend(AppColors.neonGreen, "Masuk"),
                ],
              )
            ],
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => const FlLine(
                      color: Color(0xFFF1F5F9), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx >= 0 && idx < labels.length) {
                          final dateStr = labels[idx];
                          final shortDate =
                              "${dateStr.substring(8, 10)}/${dateStr.substring(5, 7)}";
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(shortDate,
                                style: TextStyle(
                                    color: AppColors.coolGray,
                                    fontSize: 10.sp)),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        if (value % 1 != 0) return const SizedBox();
                        return Text(value.toInt().toString(),
                            style: const TextStyle(
                                color: AppColors.coolGray, fontSize: 10));
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: keluarSpots,
                    isCurved: true,
                    color: AppColors.vibrantOrange,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.vibrantOrange.withValues(alpha: 0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: masukSpots,
                    isCurved: true,
                    color: AppColors.neonGreen,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.neonGreen.withValues(alpha: 0.1),
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


  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: color, size: 18.w),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: AppFontWeight.bold,
            color: AppColors.charcoal,
          ),
        ),
      ],
    );
  }
}
