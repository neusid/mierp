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
import 'package:mierp_apps/core/widgets/dashboard/blanket_mattress_widget.dart';
import 'package:mierp_apps/features/dashboard/presentation/warehouse/bloc/dashboard_warehouse_bloc.dart';

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
            "Warehouse Analytics",
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
                  color: AppColors.premiumDarkSolid,
                  size: 40.w,
                ),
              );
            }

            // Calculate overall inventory movement
            final int totalInQty = state.listOrder.fold<int>(
              0,
              (sum, e) => sum + e.quantity,
            );
            final int totalOutQty = state.listSalesOrder.fold<int>(
              0,
              (sum, e) => sum + e.quantity,
            );
            final int netMovement = totalInQty - totalOutQty;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HERO INVENTORY SUMMARY (MiERP Signature Gradient)
                  _buildExecutiveHeroCard(
                    netMovement: netMovement,
                    totalInQty: totalInQty,
                    totalOutQty: totalOutQty,
                    totalProducts: state.totalProducts,
                    totalQty: state.totalQty,
                    inOrderCount: state.listOrder.length,
                    outOrderCount: state.listSalesOrder.length,
                  ),
                  SizedBox(height: 18.h),

                  // 2. DUAL-LINE STOCK FLOW CURVE (Restrained Palette)
                  _buildStockFlowChart(state),
                  SizedBox(height: 24.h),

                  // 3. SECTION HEADER: INVENTORY ALERTS & LOGISTICS
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: 16.w,
                          color: const Color(0xFF7C3AED),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Inventory Alerts & Logistics",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: AppFontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // 4. CARD 1: LOW STOCK PRODUCTS (Blanket Mattress)
                  BlanketMattressWidget(
                    title: "Low Stock Products",
                    subtitle: "Needs Attention",
                    count: state.totalLowStock,
                    rightTitle: "Action Req.",
                    rightSubtitle:
                        "${state.totalLowStock} of ${state.totalProducts} Items",
                    progress: state.totalProducts > 0
                        ? (state.totalLowStock / state.totalProducts).clamp(0.0, 1.0)
                        : 0.0,
                    themeColor: const Color(0xFFEF4444),
                    themeBgColor: const Color(0xFFFEF2F2),
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

                  // 5. CARD 2: INCOMING STOCK (Blanket Mattress)
                  BlanketMattressWidget(
                    title: "Incoming Stock",
                    subtitle: "Delivery in Transit",
                    count: state.totalUpcomingStock,
                    rightTitle: "In Transit",
                    rightSubtitle:
                        "${state.totalUpcomingStock} Items coming",
                    progress: state.totalUpcomingStock > 0 ? 0.45 : 0.0,
                    themeColor: const Color(0xFF94A3B8),
                    themeBgColor: const Color(0xFFF1F5F9),
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
                  SizedBox(height: 36.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ================= 1. HERO INVENTORY SUMMARY CARD =================
  Widget _buildExecutiveHeroCard({
    required int netMovement,
    required int totalInQty,
    required int totalOutQty,
    required int totalProducts,
    required int totalQty,
    required int inOrderCount,
    required int outOrderCount,
  }) {
    final String formattedNet = "${netMovement >= 0 ? '+' : ''}$netMovement Units";

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
                "Stock Movement Flow",
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
          SizedBox(height: 4.h),
          Text(
            "$totalProducts SKUs • $totalQty Total Unit Terdaftar",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: AppFontWeight.regular,
              color: const Color(0xFF94A3B8),
            ),
          ),
          SizedBox(height: 14.h),
          Divider(
            color: Colors.white.withValues(alpha: 0.1),
            thickness: 1,
            height: 1,
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              // Barang Masuk
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
                          "Barang Masuk (PO)",
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
                      "$totalInQty Pcs",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: AppFontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "$inOrderCount PO Masuk",
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 32.h,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              // Barang Keluar
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
                            "Barang Keluar (Sales)",
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
                        "$totalOutQty Pcs",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: AppFontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "$outOrderCount Pesanan Terpenuhi",
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          color: const Color(0xFF94A3B8),
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

  // ================= 2. DUAL-LINE STOCK FLOW CHART =================
  Widget _buildStockFlowChart(DashboardWarehouseState state) {
    final now = DateTime.now();
    final Map<String, int> incomingPerDay = {};
    final Map<String, int> outgoingPerDay = {};
    final List<String> labels = [];

    const weekdays = ["Sen", "Sel", "Rab", "Kam", "Jum", "Sab", "Min"];

    for (int i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final dateStr =
          "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
      incomingPerDay[dateStr] = 0;
      outgoingPerDay[dateStr] = 0;
      labels.add(weekdays[d.weekday - 1]);
    }

    final dateKeys = incomingPerDay.keys.toList();

    String? normalizeDate(String raw) {
      if (raw.isEmpty) return null;
      if (RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(raw)) {
        return raw.substring(0, 10);
      }
      final match = RegExp(r'^(\d{1,2})-(\d{1,2})-(\d{4})').firstMatch(raw);
      if (match != null) {
        final d = match.group(1)!.padLeft(2, '0');
        final m = match.group(2)!.padLeft(2, '0');
        final y = match.group(3)!;
        return "$y-$m-$d";
      }
      return null;
    }

    for (var o in state.listOrder) {
      if (o.orderDate != null) {
        final normalized = normalizeDate(o.orderDate!);
        if (normalized != null && incomingPerDay.containsKey(normalized)) {
          incomingPerDay[normalized] =
              incomingPerDay[normalized]! + (o.quantity > 0 ? o.quantity : 1);
        }
      }
    }

    for (var s in state.listSalesOrder) {
      final normalized = normalizeDate(s.purchasedDate);
      if (normalized != null && outgoingPerDay.containsKey(normalized)) {
        outgoingPerDay[normalized] =
            outgoingPerDay[normalized]! + (s.quantity > 0 ? s.quantity : 1);
      }
    }

    List<FlSpot> inSpots = [];
    List<FlSpot> outSpots = [];
    double maxY = 0;

    for (int i = 0; i < dateKeys.length; i++) {
      final double inVal = (incomingPerDay[dateKeys[i]] ?? 0).toDouble();
      final double outVal = (outgoingPerDay[dateKeys[i]] ?? 0).toDouble();

      inSpots.add(FlSpot(i.toDouble(), inVal));
      outSpots.add(FlSpot(i.toDouble(), outVal));

      if (inVal > maxY) maxY = inVal;
      if (outVal > maxY) maxY = outVal;
    }

    maxY = maxY == 0 ? 10 : maxY * 1.3;

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
                    "Stock Inflow & Outflow",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: AppFontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Tren mutasi barang 7 hari terakhir",
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
                      reservedSize: 34.w,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) {
                          return Text("0",
                              style: TextStyle(
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 9.sp));
                        }
                        if (value >= 1000) {
                          return Text(
                            "${(value / 1000).toStringAsFixed(0)}k",
                            style: TextStyle(
                                color: const Color(0xFF94A3B8),
                                fontSize: 9.sp),
                          );
                        }
                        return Text(
                          "${value.toInt()}",
                          style: TextStyle(
                              color: const Color(0xFF94A3B8), fontSize: 9.sp),
                        );
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
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF0F172A),
                    tooltipRoundedRadius: 8.r,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final isMasuk = spot.barIndex == 0;
                        final String tag = isMasuk ? "Masuk: " : "Keluar: ";
                        final String valStr = "${spot.y.toInt()} Pcs";
                        return LineTooltipItem(
                          "$tag$valStr\n",
                          GoogleFonts.inter(
                            color: isMasuk
                                ? const Color(0xFFC084FC)
                                : const Color(0xFFCBD5E1),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: spot.x.toInt() < labels.length
                                  ? labels[spot.x.toInt()]
                                  : '',
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  // 1. INFLOW CURVE (Solid Violet)
                  LineChartBarData(
                    spots: inSpots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: const Color(0xFF7C3AED),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 2.5,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: const Color(0xFF7C3AED),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF7C3AED).withValues(alpha: 0.18),
                          const Color(0xFF7C3AED).withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),

                  // 2. OUTFLOW CURVE (Dashed Slate)
                  LineChartBarData(
                    spots: outSpots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: const Color(0xFF64748B),
                    barWidth: 2,
                    dashArray: [5, 4],
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 2,
                          color: const Color(0xFF64748B),
                          strokeWidth: 1,
                          strokeColor: Colors.white,
                        );
                      },
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
