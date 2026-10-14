import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/core/services/tenant_service.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
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

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            children: [
              // Header Card
              Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2E1052),
                      Color(0xFF1E0B36),
                      AppColors.gray,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E1052).withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Company Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: const Color(0xFFC084FC).withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.business_rounded,
                                  size: 13.w, color: const Color(0xFFC084FC)),
                              SizedBox(width: 6.w),
                              Text(
                                companyName.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  fontSize: 11.sp,
                                  fontWeight: AppFontWeight.bold,
                                  color: const Color(0xFFE9D5FF),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bell Notification button
                        IconButton(
                          icon: const Icon(Icons.notifications_rounded,
                              color: Colors.white),
                          onPressed: () => context.push('/notification'),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      "Selamat Datang, $adminName 👋",
                      style: GoogleFonts.outfit(
                        fontSize: 20.sp,
                        fontWeight: AppFontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Pusat Komando & Pengawasan MiERP Multi-Tenant",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

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

              // 2x2 KPI Grid
              Row(
                children: [
                  Expanded(
                    child: _buildKpiCard(
                      title: "Staf Dibawahi",
                      count: "$_staffCount",
                      subtitle: "Finance & Warehouse",
                      icon: Icons.groups_rounded,
                      color: const Color(0xFF6366F1),
                      bg: const Color(0xFFEEF2FF),
                      onTap: () => widget.onTabChange(1), // Go to Staff tab
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildKpiCard(
                      title: "Katalog Produk",
                      count: "$_productCount",
                      subtitle: "Total jenis SKU",
                      icon: Icons.inventory_2_rounded,
                      color: const Color(0xFF2563EB),
                      bg: const Color(0xFFEFF6FF),
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
                      count: "$_orderCount",
                      subtitle: "Total Sales Orders",
                      icon: Icons.receipt_long_rounded,
                      color: const Color(0xFF059669),
                      bg: const Color(0xFFECFDF5),
                      onTap: () => widget.onTabChange(3), // Go to Finance tab
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildKpiCard(
                      title: "Peringatan Stok",
                      count: "$_lowStockCount",
                      subtitle: "Stok menipis (<= 5)",
                      icon: Icons.warning_amber_rounded,
                      color: const Color(0xFFDC2626),
                      bg: const Color(0xFFFEF2F2),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String count,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, color: color, size: 20.w),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 12.w, color: const Color(0xFFCBD5E1)),
              ],
            ),
            SizedBox(height: 12.h),
            _isLoading
                ? SizedBox(
                    height: 26.h,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    count,
                    style: GoogleFonts.outfit(
                      fontSize: 24.sp,
                      fontWeight: AppFontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: AppFontWeight.semiBold,
                color: const Color(0xFF334155),
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                fontSize: 11.sp,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
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
