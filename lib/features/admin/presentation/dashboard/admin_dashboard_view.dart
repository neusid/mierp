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
        // Run migration check in background
        TenantService.migrateLegacyDataToAdmin(adminId);

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
    final isSuperAdmin = _currentUser?.isSuperAdmin ?? false;

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
                                Icons.shield_rounded,
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
                    // 2. USER INFO: ROLE PILL, COMPANY BADGE, GREETING, NAME
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Role Badge Pill
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.5.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7C3AED).withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(10.w),
                                  border: Border.all(
                                    color: const Color(0xFFA855F7).withValues(alpha: 0.4),
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
                                            color: const Color(0xFFA855F7).withValues(alpha: 0.7),
                                            blurRadius: 3.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      isSuperAdmin ? "SUPER ADMIN" : "ADMIN",
                                      style: GoogleFonts.inter(
                                        fontSize: 9.5.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFD8B4FE),
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 6.w),
                              // Company Badge
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.5.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.10),
                                    borderRadius: BorderRadius.circular(8.w),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.18),
                                      width: 0.8.w,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.business_rounded,
                                        size: 10.w,
                                        color: const Color(0xFFC084FC),
                                      ),
                                      SizedBox(width: 4.w),
                                      Flexible(
                                        child: Text(
                                          companyName.toUpperCase(),
                                          style: GoogleFonts.inter(
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFFE2E8F0),
                                            letterSpacing: 0.3,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            "Welcome Back,",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 11.5.sp,
                              color: const Color(0xFFCBD5E1),
                            ),
                          ),
                          Text(
                            adminName,
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
                              child: BlocSelector<NotificationCubit, NotificationState, bool>(
                                selector: (state) => state.unreadCount > 0,
                                builder: (context, hasUnread) {
                                  if (!hasUnread) return const SizedBox.shrink();
                                  return Container(
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

                  // 2x2 KPI Grid (Warehouse Remake Aesthetic)
                  Row(
                    children: [
                      Expanded(
                        child: _buildKpiCard(
                          title: "Staf Dibawahi",
                          subtitle: "Seluruh staf aktif\nFinance & Warehouse",
                          count: "$_staffCount",
                          unit: "Staf",
                          icon: Icons.groups_outlined,
                          iconColor: const Color(0xFF6366F1),
                          squircleBg: const Color(0xFFEEF2FF),
                          squircleBorder: const Color(0xFFC7D2FE),
                          pillText: "Active",
                          pillBgColor: const Color(0xFFEEF2FF),
                          pillBorderColor: const Color(0xFFC7D2FE),
                          pillColor: const Color(0xFF6366F1),
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
                          iconColor: const Color(0xFF7C3AED),
                          squircleBg: const Color(0xFFF5F3FF),
                          squircleBorder: const Color(0xFFDDD6FE),
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
                          iconColor: const Color(0xFF0D9488),
                          squircleBg: const Color(0xFFF0FDFA),
                          squircleBorder: const Color(0xFFCCFBF1),
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
                          icon: Icons.warning_amber_rounded,
                          iconColor: const Color(0xFFEF4444),
                          squircleBg: const Color(0xFFFEF2F2),
                          squircleBorder: const Color(0xFFFECDD3),
                          cardBorderColor: _lowStockCount > 0 ? const Color(0xFFFFE4E6) : null,
                          dividerColor: _lowStockCount > 0 ? const Color(0xFFFFF1F2) : null,
                          pillText: _lowStockCount > 0 ? "Alert" : "Safe",
                          pillBgColor: _lowStockCount > 0 ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
                          pillBorderColor: _lowStockCount > 0 ? const Color(0xFFFECDD3) : const Color(0xFFBBF7D0),
                          pillColor: _lowStockCount > 0 ? const Color(0xFFEF4444) : const Color(0xFF16A34A),
                          onTap: () => widget.onTabChange(2),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 22.h),

                  // Quick Actions
                  Text(
                    "Aksi Cepat Admin",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: AppFontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  _buildQuickActionTile(
                    icon: Icons.person_add_rounded,
                    iconColor: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFEFF6FF),
                    title: "Tambah Akun Staf Baru",
                    description: "Buatkan kredensial login Finance atau Warehouse",
                    onTap: () => widget.onTabChange(1),
                  ),
                  SizedBox(height: 10.h),
                  _buildQuickActionTile(
                    icon: Icons.warehouse_rounded,
                    iconColor: const Color(0xFFD97706),
                    bgColor: const Color(0xFFFFFBEB),
                    title: "Pantau Stok & Inventaris Gudang",
                    description: "Buka ringkasan produk, mutasi barang, dan restock",
                    onTap: () => widget.onTabChange(2),
                  ),
                  SizedBox(height: 10.h),
                  _buildQuickActionTile(
                    icon: Icons.pie_chart_rounded,
                    iconColor: const Color(0xFF059669),
                    bgColor: const Color(0xFFECFDF5),
                    title: "Pantau Arus Kas & Keuangan",
                    description: "Lihat ringkasan neraca kas masuk & pembayaran",
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

  Widget _buildQuickActionTile({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: iconColor, size: 22.w),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: AppFontWeight.semiBold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    description,
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: const Color(0xFF94A3B8), size: 22.w),
          ],
        ),
      ),
    );
  }
}
