import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/dashboard/presentation/warehouse/bloc/dashboard_warehouse_bloc.dart';
import 'package:mierp_apps/core/di/injection_container.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/widgets/card_stock.dart';
import 'package:mierp_apps/core/widgets/dashboard/quick_add_card.dart';
import 'package:mierp_apps/core/services/export_service.dart';
import 'package:mierp_apps/core/widgets/modal_export_sheet.dart';
import 'package:mierp_apps/features/main_page/presentation/cubit/main_page_cubit.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_state.dart';

class DashboardWarehouseView extends StatelessWidget {
  const DashboardWarehouseView({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
    final formattedDate = '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';

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
                          colors: [Color(0xFF2E1052), AppColors.gray],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60.w),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 56.h,
                            left: 24.w,
                            right: 20.w,
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Gudang Pusat",
                                          style: GoogleFonts.inter(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFFC084FC),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          "Good Morning,",
                                          style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFFE0E7FF),
                                          ),
                                        ),
                                        Text(
                                          state.userName.isNotEmpty
                                              ? state.userName
                                              : "Admin",
                                          style: GoogleFonts.inter(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: -0.4,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          formattedDate,
                                          style: GoogleFonts.inter(
                                            fontSize: 10.5.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFFE0E7FF),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        context.push('/notification');
                                      },
                                      child: Container(
                                        width: 42.w,
                                        height: 42.w,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.08,
                                          ),
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
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    // ROW 1: INVENTORY OVERVIEW METRICS (PRODUCT & TOTAL QTY - REMAKE)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildWarehouseMetricCard(
                              title: "Product",
                              subtitle: "All registered products\nin active inventory",
                              value: state.totalProducts.toString(),
                              icon: Icons.inventory_2_outlined,
                              iconColor: const Color(0xFF7C3AED),
                              squircleBg: const Color(0xFFF5F3FF),
                              squircleBorder: const Color(0xFFDDD6FE),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildWarehouseMetricCard(
                              title: "Total Qty",
                              subtitle: "Total combined units\navailable in stock",
                              value: state.totalQty.toString(),
                              unit: "items",
                              icon: Icons.layers_outlined,
                              iconColor: const Color(0xFF0D9488),
                              squircleBg: const Color(0xFFF0FDFA),
                              squircleBorder: const Color(0xFFCCFBF1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // ROW 2: INTERACTIVE ALERT METRICS (LOW STOCK & UPCOMING - REMAKE)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildWarehouseMetricCard(
                              title: "Low Stock",
                              subtitle: "All stock items that\nare low inventory",
                              value: state.totalLowStock.toString(),
                              unit: "Items",
                              icon: Icons.warning_amber_rounded,
                              iconColor: const Color(0xFFEF4444),
                              squircleBg: const Color(0xFFFEF2F2),
                              squircleBorder: const Color(0xFFFECDD3),
                              cardBorderColor: const Color(0xFFFFE4E6),
                              dividerColor: const Color(0xFFFFF1F2),
                              pillText: "Now",
                              pillBgColor: const Color(0xFFFEF2F2),
                              pillBorderColor: const Color(0xFFFECDD3),
                              pillColor: const Color(0xFFEF4444),
                              onTap: () => context.push("/inventory_alerts/0"),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildWarehouseMetricCard(
                              title: "Upcoming",
                              subtitle: "All scheduled items\nfor incoming restock",
                              value: state.totalUpcomingStock.toString(),
                              unit: "Items",
                              icon: Icons.calendar_month_outlined,
                              iconColor: const Color(0xFF4F46E5),
                              squircleBg: const Color(0xFFEEF2FF),
                              squircleBorder: const Color(0xFFC7D2FE),
                              pillText: "Now",
                              pillBgColor: const Color(0xFFEEF2FF),
                              pillBorderColor: const Color(0xFFC7D2FE),
                              pillColor: const Color(0xFF4F46E5),
                              onTap: () => context.push("/inventory_alerts/1"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // QUICK ACTIONS (NAVIGATION BAR 6 STYLE WITH MIERP GRADIENT)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Quick Actions",
                                style: GoogleFonts.inter(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E293B),
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              const Expanded(
                                child: Divider(color: Color(0xFFF1F5F9), thickness: 1.2),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          QuickAddCard(
                            title: "Add Product Order",
                            onTap: () => context.push("/add_product_order"),
                          ),
                          SizedBox(height: 10.h),
                          QuickAddCard(
                            title: "Add New Unit",
                            onTap: () => context.push("/add_unit"),
                          ),
                          SizedBox(height: 10.h),
                          QuickAddCard(
                            title: "Add Sales Order",
                            onTap: () => context.push("/add_sales_order"),
                          ),
                          SizedBox(height: 10.h),
                          QuickAddCard(
                            title: "Export Laporan Stok Gudang",
                            icon: Icons.ios_share_rounded,
                            onTap: () {
                              ModalExportSheet.show(
                                context,
                                reportTitle: "Laporan Stok & Valuasi",
                                subtitle: "Unduh atau bagikan inventaris & nilai aset gudang",
                                onExport: (format) async {
                                  await ExportService.exportProducts(
                                    products: state.listProduct,
                                    companyName: "MiERP Warehouse",
                                    format: format,
                                    context: context,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                    // INVENTORY ATTENTION / LOW STOCK FEED
                    Builder(
                      builder: (context) {
                        final lowStockItems = state.listProduct
                            .where((p) => p.quantity <= 10)
                            .toList();
                        final int totalLow = lowStockItems.length;

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Section Header
                              Row(
                                children: [
                                  Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: totalLow > 0
                                          ? const Color(0xFFD97706)
                                          : const Color(0xFF10B981),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (totalLow > 0
                                                  ? const Color(0xFFD97706)
                                                  : const Color(0xFF10B981))
                                              .withValues(alpha: 0.5),
                                          blurRadius: 4.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Stok Perlu Perhatian",
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      color: const Color(0xFF0F172A),
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 7.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: totalLow > 0
                                          ? const Color(0xFFFEF3C7)
                                          : const Color(0xFFD1FAE5),
                                      borderRadius: BorderRadius.circular(10.w),
                                    ),
                                    child: Text(
                                      "$totalLow Kritis",
                                      style: GoogleFonts.inter(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        color: totalLow > 0
                                            ? const Color(0xFFB45309)
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
                                          "Lihat Gudang",
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
                              SizedBox(height: 12.h),

                              // Content Items or Clean Empty State
                              if (totalLow == 0)
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 26.h, horizontal: 20.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.w),
                                    border: Border.all(
                                        color: const Color(0xFFF1F5F9),
                                        width: 1.5.w),
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
                                        "Ketersediaan Stok Aman",
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "Seluruh unit inventaris berada di atas batas minimum stok.",
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
                                    ...lowStockItems.take(3).map((product) {
                                      return GestureDetector(
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
                                          lineTotal: product.unitPrice * product.quantity,
                                          type: product.category,
                                          image: product.imageProduct,
                                          createdOn: product.createdOn,
                                          discountPercent: product.discountPercent,
                                          discountMax: product.discountMax,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
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

  Widget _buildWarehouseMetricCard({
    required String title,
    required String subtitle,
    required String value,
    String? unit,
    required IconData icon,
    required Color iconColor,
    required Color squircleBg,
    required Color squircleBorder,
    Color? cardBorderColor,
    Color? dividerColor,
    String? pillText,
    Color? pillBgColor,
    Color? pillBorderColor,
    Color? pillColor,
    VoidCallback? onTap,
  }) {
    final cardContent = Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.w),
        border: Border.all(
          color: cardBorderColor ?? const Color(0xFFF1F5F9),
          width: 1.2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12.w,
            offset: Offset(0, 4.h),
          ),
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
            blurRadius: 4.w,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Header Row (Title + Symmetrical Squircle Icon 32x32)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF334155),
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: squircleBg,
                  borderRadius: BorderRadius.circular(10.w),
                  border: Border.all(color: squircleBorder, width: 1.w),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 17.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          // 2. Contextual 2-Line Subtitle
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          // 3. Subtle Hairline Divider
          Divider(
            color: dividerColor ?? const Color(0xFFF1F5F9),
            height: 1.w,
            thickness: 1.w,
          ),
          SizedBox(height: 10.h),
          // 4. Bottom Metric Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: value,
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                      letterSpacing: -0.4,
                    ),
                    children: unit != null
                        ? [
                            TextSpan(
                              text: " $unit",
                              style: GoogleFonts.inter(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                                letterSpacing: 0,
                              ),
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
              if (pillText != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: pillBgColor,
                    borderRadius: BorderRadius.circular(10.w),
                    border: pillBorderColor != null
                        ? Border.all(color: pillBorderColor, width: 0.8.w)
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5.w,
                        height: 5.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: pillColor,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        pillText,
                        style: GoogleFonts.inter(
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w600,
                          color: pillColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    if (onTap == null) {
      return cardContent;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.w),
      child: cardContent,
    );
  }

}
