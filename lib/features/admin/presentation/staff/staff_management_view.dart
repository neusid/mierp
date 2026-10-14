import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:mierp_apps/features/admin/presentation/cubit/admin_staff_cubit.dart';
import 'package:mierp_apps/features/admin/presentation/cubit/admin_staff_state.dart';

class StaffManagementView extends StatefulWidget {
  final VoidCallback? onBack;

  const StaffManagementView({super.key, this.onBack});

  @override
  State<StaffManagementView> createState() => _StaffManagementViewState();
}

class _StaffManagementViewState extends State<StaffManagementView> {
  String _selectedFilter = 'all'; // 'all' | 'finance' | 'warehouse'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AdminStaffCubit>().loadStaffList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation(UserModel staff) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          "Hapus Akun Staf?",
          style: GoogleFonts.outfit(fontWeight: AppFontWeight.bold, fontSize: 18.sp),
        ),
        content: Text(
          "Apakah Anda yakin ingin menghapus akses ${staff.firstName} ${staff.lastName} (${staff.email})?",
          style: GoogleFonts.outfit(fontSize: 14.sp, color: const Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Batal",
              style: GoogleFonts.outfit(color: const Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AdminStaffCubit>().deleteStaff(staff.uid ?? '');
              CustomTopSnackbar.show(
                context,
                "Akses akun ${staff.firstName} telah dicabut.",
                title: "Staf Dihapus",
                isError: true,
              );
            },
            child: Text("Hapus", style: GoogleFonts.outfit(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: Container(
        height: 46.h,
        decoration: BoxDecoration(
          gradient: AppColors.premiumDarkGradient,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E1052).withValues(alpha: 0.35),
              blurRadius: 10.w,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              final created = await context.push<bool>('/add_staff');
              if (created == true && context.mounted) {
                context.read<AdminStaffCubit>().loadStaffList();
              }
            },
            borderRadius: BorderRadius.circular(24.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add_outlined, color: Colors.white, size: 18.w),
                  SizedBox(width: 8.w),
                  Text(
                    "Tambah Staf",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  if (widget.onBack != null) ...[
                    InkWell(
                      onTap: widget.onBack,
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16.w,
                          color: const Color(0xFF334155),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manajemen Staf",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: AppFontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          "Kelola akun tim Finance & Warehouse",
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content body
            Expanded(
              child: BlocConsumer<AdminStaffCubit, AdminStaffState>(
                listener: (context, state) {
                  if (state is AdminStaffLoaded && state.successMessage != null) {
                    CustomTopSnackbar.success(
                      context,
                      state.successMessage!,
                      title: "Berhasil",
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AdminStaffLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is AdminStaffFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline_rounded,
                              size: 48.w, color: const Color(0xFFEF4444)),
                          SizedBox(height: 12.h),
                          Text("Gagal memuat staf: ${state.message}"),
                          SizedBox(height: 12.h),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<AdminStaffCubit>().loadStaffList(),
                            child: const Text("Coba Lagi"),
                          ),
                        ],
                      ),
                    );
                  }

                  final staffList = (state is AdminStaffLoaded) ? state.staffList : <UserModel>[];
                  final financeCount = (state is AdminStaffLoaded) ? state.financeCount : 0;
                  final warehouseCount = (state is AdminStaffLoaded) ? state.warehouseCount : 0;

                  // Filter & search
                  final filtered = staffList.where((s) {
                    final roleMatch = _selectedFilter == 'all' ||
                        s.role?.toLowerCase() == _selectedFilter;
                    final queryMatch = _searchQuery.isEmpty ||
                        ("${s.firstName} ${s.lastName} ${s.email}")
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                    return roleMatch && queryMatch;
                  }).toList();

                  return RefreshIndicator(
                    onRefresh: () => context.read<AdminStaffCubit>().loadStaffList(),
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 80.h),
                      children: [
                        // KPI Metrics Summary Card (Informational)
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricTile(
                                label: "Total Staf",
                                count: staffList.length,
                                icon: Icons.people_outline_rounded,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _buildMetricTile(
                                label: "Finance",
                                count: financeCount,
                                icon: Icons.account_balance_wallet_outlined,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _buildMetricTile(
                                label: "Warehouse",
                                count: warehouseCount,
                                icon: Icons.warehouse_outlined,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Search Bar
                        Container(
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 2.h),
                                color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                                blurRadius: 8.w,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => setState(() => _searchQuery = val),
                            textAlignVertical: TextAlignVertical.center,
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF0F172A),
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Cari nama atau email staf...",
                              hintStyle: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF94A3B8),
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: const Color(0xFF94A3B8),
                                size: 20.w,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear_rounded,
                                        size: 18.w,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 12.h,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Filter Chips
                        Row(
                          children: [
                            _buildFilterChip('all', 'Semua (${staffList.length})'),
                            SizedBox(width: 8.w),
                            _buildFilterChip('finance', 'Finance ($financeCount)'),
                            SizedBox(width: 8.w),
                            _buildFilterChip('warehouse', 'Warehouse ($warehouseCount)'),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Staff List or Empty State
                        if (filtered.isEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Icon(
                                  _searchQuery.isNotEmpty
                                      ? Icons.person_search_rounded
                                      : Icons.people_outline_rounded,
                                  size: 52.w,
                                  color: const Color(0xFFCBD5E1),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? "Tidak ada staf yang cocok"
                                      : "Belum ada akun staf",
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: AppFontWeight.semiBold,
                                    color: const Color(0xFF475569),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? "Periksa kembali ejaan nama atau filter yang dipilih"
                                      : "Gunakan tombol 'Tambah Staf' di pojok kanan bawah untuk membuat akun baru",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        else
                          ...filtered.map((staff) => _buildStaffCard(staff)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required int count,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 8.w,
            offset: Offset(0, 2.h),
          ),
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.01),
            blurRadius: 3.w,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Symmetrical Squircle Icon (Unified Corporate Slate)
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(9.r),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
            ),
            child: Center(
              child: Icon(
                icon,
                color: const Color(0xFF475569),
                size: 17.w,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Metric Count (Tabular Figures, Slate-800)
          Text(
            "$count",
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.5,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          SizedBox(height: 2.h),
          // Metric Label (Slate-500)
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
              letterSpacing: -0.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedFilter == key;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = key),
      borderRadius: BorderRadius.circular(20.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.premiumDarkGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12.sp,
            fontWeight: isSelected ? AppFontWeight.semiBold : AppFontWeight.medium,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildStaffCard(UserModel staff) {
    final isFinance = staff.role?.toLowerCase() == 'finance';
    final roleColor = isFinance ? const Color(0xFF4F46E5) : const Color(0xFF0D9488);
    final roleBg = isFinance ? const Color(0xFFEEF2FF) : const Color(0xFFF0FDFA);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 22.r,
            backgroundColor: roleBg,
            child: Text(
              (staff.firstName?.isNotEmpty == true)
                  ? staff.firstName![0].toUpperCase()
                  : 'S',
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: AppFontWeight.bold,
                color: roleColor,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // User details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "${staff.firstName ?? ''} ${staff.lastName ?? ''}".trim(),
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: AppFontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Solid Gojek-style role badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: roleColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        (staff.role ?? 'STAFF').toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 10.sp,
                          fontWeight: AppFontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  staff.email ?? '-',
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Options button
          IconButton(
            icon: Icon(Icons.delete_outline_rounded,
                color: const Color(0xFFEF4444), size: 20.w),
            onPressed: () => _showDeleteConfirmation(staff),
          ),
        ],
      ),
    );
  }
}
