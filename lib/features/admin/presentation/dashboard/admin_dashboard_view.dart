import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/core/services/tenant_service.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_state.dart';
import 'package:mierp_apps/core/widgets/dashboard/quick_add_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboardView extends StatefulWidget {
  final Function(int) onTabChange;

  const AdminDashboardView({super.key, required this.onTabChange});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  UserModel? _currentUser;
  int _staffCount = 0;
  int _productCount = 0;
  int _lowStockCount = 0;
  int _orderCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString("user");
      if (raw != null) {
        _currentUser = UserModel.fromJson(jsonDecode(raw));
      }

      final adminId = await TenantService.getActiveAdminId();
      if (adminId.isNotEmpty) {
        // Run migration check in background (restricted strictly to default Master Admin)
        TenantService.migrateLegacyDataToAdmin(adminId, adminEmail: _currentUser?.email);

        // Fetch counts scoped by admin_id
        final staffSnap = await FirebaseFirestore.instance
            .collection('users')
            .where('admin_id', isEqualTo: adminId)
            .get();

        final productSnap = await FirebaseFirestore.instance
            .collection('products')
            .where('admin_id', isEqualTo: adminId)
            .get();

        int lowStock = 0;
        for (final doc in productSnap.docs) {
          final q = num.tryParse(doc.data()['quantity']?.toString() ?? '0') ?? 0;
          if (q <= 5) lowStock++;
        }

        final orderSnap = await FirebaseFirestore.instance
            .collection('sales_orders')
            .where('admin_id', isEqualTo: adminId)
            .get();

        if (mounted) {
          setState(() {
            _staffCount = staffSnap.docs.where((d) {
              final r = d.data()['role']?.toString().toLowerCase();
              return r != 'admin' && r != 'superadmin' && r != 'super_admin';
            }).length;
            _productCount = productSnap.docs.length;
            _lowStockCount = lowStock;
            _orderCount = orderSnap.docs.length;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error loading admin dashboard metrics: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final companyName = _currentUser?.companyName?.isNotEmpty == true
        ? _currentUser!.companyName!
        : 'Organisasi Utama';
    final adminName = _currentUser?.firstName?.isNotEmpty == true
        ? _currentUser!.firstName!
        : 'Admin';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              toolbarHeight: 110.h,
              collapsedHeight: 110.h,
              pinned: true,
              floating: false,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
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
              ),
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. AVATAR SQUIRCLE (KOTAK, TINGGI IDENTIK DENGAN PT MIERP & NAMA USER)
                      AspectRatio(
                        aspectRatio: 1.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
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
                              size: 20.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // 2. USER INFO: ATAS PT MIERP, BAWAH NAMA USER
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              companyName.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFC084FC),
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              adminName,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.5.sp,
                                color: Colors.white,
                                letterSpacing: -0.3,
                                height: 1.1,
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
                          borderRadius: BorderRadius.circular(12.w),
                          child: Container(
                            width: 38.w,
                            height: 38.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12.w),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.16),
                                width: 1.w,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.notifications_none_rounded,
                                  color: Colors.white,
                                  size: 20.w,
                                ),
                                Positioned(
                                  top: 8.w,
                                  right: 8.w,
                                  child: BlocSelector<NotificationCubit, NotificationState, bool>(
                                    selector: (state) => state.unreadCount > 0,
                                    builder: (context, hasUnread) {
                                      if (!hasUnread) return const SizedBox.shrink();
                                      return Container(
                                        width: 7.w,
                                        height: 7.w,
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
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // KPI Section Title
                  Text(
                    "Ringkasan Operasional Terisolasi",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: AppFontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // 2x2 KPI Grid (Unified Corporate Slate)
                  Row(
                    children: [
                      Expanded(
                        child: _buildKpiCard(
                          title: "Staf Dibawahi",
                          subtitle: "Seluruh staf aktif\nFinance & Warehouse",
                          count: "$_staffCount",
                          unit: "Staf",
                          icon: Icons.people_outline_rounded,
                          iconColor: const Color(0xFF475569),
                          squircleBg: const Color(0xFFF8FAFC),
                          squircleBorder: const Color(0xFFE2E8F0),
                          onTap: () => widget.onTabChange(1), // Go to Staff tab
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildKpiCard(
                          title: "Katalog Produk",
                          subtitle: "Total jenis SKU\ndalam inventaris",
                          count: "$_productCount",
                          unit: "SKU",
                          icon: Icons.inventory_2_outlined,
                          iconColor: const Color(0xFF475569),
                          squircleBg: const Color(0xFFF8FAFC),
                          squircleBorder: const Color(0xFFE2E8F0),
                          onTap: () => widget.onTabChange(2), // Go to Warehouse tab
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildKpiCard(
                          title: "Transaksi Order",
                          subtitle: "Total pesanan penjualan\ntercatat di tenant",
                          count: "$_orderCount",
                          unit: "Orders",
                          icon: Icons.receipt_long_outlined,
                          iconColor: const Color(0xFF475569),
                          squircleBg: const Color(0xFFF8FAFC),
                          squircleBorder: const Color(0xFFE2E8F0),
                          onTap: () => widget.onTabChange(3), // Go to Finance tab
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildKpiCard(
                          title: "Peringatan Stok",
                          subtitle: "Stok menipis\nperlu restock (<= 5)",
                          count: "$_lowStockCount",
                          unit: "Items",
                          icon: Icons.notifications_none_rounded,
                          iconColor: const Color(0xFF475569),
                          squircleBg: const Color(0xFFF8FAFC),
                          squircleBorder: const Color(0xFFE2E8F0),
                          pillText: _lowStockCount > 0 ? "Alert" : "Safe",
                          pillBgColor: _lowStockCount > 0 ? const Color(0xFFFEF2F2) : const Color(0xFFF8FAFC),
                          pillBorderColor: _lowStockCount > 0 ? const Color(0xFFFECDD3) : const Color(0xFFE2E8F0),
                          pillColor: _lowStockCount > 0 ? const Color(0xFFEF4444) : const Color(0xFF64748B),
                          onTap: () => widget.onTabChange(2),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 22.h),

                  // Quick Actions (Corporate Slate Outlined Aesthetic)
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
                    title: "Add New Staff Account",
                    icon: Icons.person_add_outlined,
                    onTap: () async {
                      final created = await context.push<bool>('/add_staff');
                      if (created == true && mounted) {
                        _loadDashboardData();
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  QuickAddCard(
                    title: "Monitor Warehouse Inventory",
                    icon: Icons.inventory_2_outlined,
                    onTap: () => widget.onTabChange(2),
                  ),
                  SizedBox(height: 10.h),
                  QuickAddCard(
                    title: "Review Financial Transactions",
                    icon: Icons.receipt_long_outlined,
                    onTap: () => widget.onTabChange(3),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String subtitle,
    required String count,
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
                    fontSize: 14.sp,
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
                child: _isLoading
                    ? SizedBox(
                        height: 24.h,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: const CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    : RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: count,
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
