import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/data/finance/dashboard_finance_repository.dart';
import 'package:mierp_apps/features/main_page/presentation/cubit/main_page_cubit.dart';

enum TransactionFlow {
  inflow,  // Uang Masuk (Sales Order / Penjualan)
  outflow, // Uang Keluar (Product Order / Pembelian)
}

class BankMutationItem {
  final String id;
  final String referenceId;
  final String referenceType;
  final TransactionFlow flow;
  final String partyName;
  final String productName;
  final int quantity;
  final int unitPrice;
  final int? discountPercent;
  final int? discountMax;
  final int amount;
  final DateTime date;
  final String? imageProduct;
  final dynamic raw;

  BankMutationItem({
    required this.id,
    required this.referenceId,
    required this.referenceType,
    required this.flow,
    required this.partyName,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.discountPercent,
    this.discountMax,
    required this.amount,
    required this.date,
    this.imageProduct,
    required this.raw,
  });
}

class HistoryView extends StatefulWidget {
  final VoidCallback? onBack;
  const HistoryView({super.key, this.onBack});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final convertDollar = ConvertDollar();
  bool _isLoading = true;
  String _errorMessage = "";
  int _selectedFilterIndex = 0; // 0 = Semua, 1 = Uang Masuk, 2 = Uang Keluar

  String? _selectedPeriod; // null = Semua Periode
  List<String> _availablePeriods = [];
  List<BankMutationItem> _allMutations = [];

  @override
  void initState() {
    super.initState();
    _loadHistoryData();
  }

  Future<void> _loadHistoryData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final repo = sl<DashboardFinanceRepository>();

      // 1. Automatic idempotent backfill of existing approved orders
      try {
        await repo.syncAndBackfillExistingSettledOrders();
      } catch (e) {
        debugPrint("Notice: backfill skipped: $e");
      }

      // 2. Fetch distinct available periods (e.g. 2026-10, 2026-09)
      List<String> periods = [];
      try {
        periods = await repo.getAvailableMutationPeriods();
      } catch (_) {}

      // 3. Query financial_mutations directly by period
      List<Map<String, dynamic>> rawMutations = [];
      try {
        rawMutations = await repo.getFinancialMutations(period: _selectedPeriod);
      } catch (_) {}

      final List<BankMutationItem> items = [];
      if (rawMutations.isNotEmpty) {
        for (var m in rawMutations) {
          final approvedDateStr = m['approved_date']?.toString() ?? '';
          final dt = DateTime.tryParse(approvedDateStr) ?? 
              (m['timestamp'] is Timestamp ? (m['timestamp'] as Timestamp).toDate() : DateTime.now());

          items.add(
            BankMutationItem(
              id: m['id']?.toString() ?? '',
              referenceId: m['reference_id']?.toString() ?? (m['id']?.toString() ?? ''),
              referenceType: m['reference_type']?.toString() ?? 'sales_order',
              flow: (m['flow']?.toString() == 'inflow') ? TransactionFlow.inflow : TransactionFlow.outflow,
              partyName: m['party_name']?.toString() ?? '',
              productName: m['product_name']?.toString() ?? '',
              quantity: (m['quantity'] as num?)?.toInt() ?? 1,
              unitPrice: (m['unit_price'] as num?)?.toInt() ?? 0,
              discountPercent: (m['discount_percent'] as num?)?.toInt(),
              discountMax: (m['discount_max'] as num?)?.toInt(),
              amount: (m['amount'] as num?)?.toInt() ?? 0,
              date: dt,
              imageProduct: m['image_product']?.toString(),
              raw: m,
            ),
          );
        }
      } else {
        // Fallback: Read directly from warehouse_orders and sales_orders
        final allOrders = await repo.getAllDataOrder();
        final allSales = await repo.getAllDataSalesOrder();

        final paidOrders = allOrders.where((e) => e.financeApproved == true);
        final paidSales = allSales.where((e) => e.financeApproved == true);

        final Set<String> gatheredPeriods = {};

        for (var o in paidOrders) {
          final dt = o.financeApprovedDate ?? DateTime.tryParse(o.orderDate ?? '') ?? DateTime.now();
          final periodStr = "${dt.year}-${dt.month.toString().padLeft(2, '0')}";
          gatheredPeriods.add(periodStr);

          if (_selectedPeriod != null && _selectedPeriod != periodStr) continue;

          items.add(
            BankMutationItem(
              id: "mut_po_${o.id}",
              referenceId: o.id ?? "",
              referenceType: 'product_order',
              flow: TransactionFlow.outflow,
              partyName: (o.firstName.isNotEmpty) ? o.firstName : "Pengadaan Unit",
              productName: o.productName,
              quantity: o.quantity,
              unitPrice: o.unitPrice,
              discountPercent: o.discountPercent,
              discountMax: o.discountMax,
              amount: o.totalCost,
              date: dt,
              imageProduct: o.imageProduct,
              raw: o,
            ),
          );
        }

        for (var s in paidSales) {
          final dt = DateTime.tryParse(s.financeApprovedDate ?? '') ?? DateTime.tryParse(s.purchasedDate) ?? DateTime.now();
          final periodStr = "${dt.year}-${dt.month.toString().padLeft(2, '0')}";
          gatheredPeriods.add(periodStr);

          if (_selectedPeriod != null && _selectedPeriod != periodStr) continue;

          items.add(
            BankMutationItem(
              id: "mut_so_${s.id}",
              referenceId: s.id ?? "",
              referenceType: 'sales_order',
              flow: TransactionFlow.inflow,
              partyName: s.companyName.isNotEmpty ? s.companyName : (s.firstName.isNotEmpty ? s.firstName : "Customer"),
              productName: s.productName,
              quantity: s.quantity,
              unitPrice: s.unitPrice,
              discountPercent: s.discountPercent,
              discountMax: s.discountMax,
              amount: s.totalPrice,
              date: dt,
              imageProduct: s.imageProduct,
              raw: s,
            ),
          );
        }

        final sortedPeriods = gatheredPeriods.toList()..sort((a, b) => b.compareTo(a));
        periods = sortedPeriods;
      }

      items.sort((a, b) => b.date.compareTo(a.date));

      if (mounted) {
        setState(() {
          _allMutations = items;
          _availablePeriods = periods;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  int get _totalInflow {
    return _allMutations
        .where((e) => e.flow == TransactionFlow.inflow)
        .fold(0, (total, item) => total + item.amount);
  }

  int get _totalOutflow {
    return _allMutations
        .where((e) => e.flow == TransactionFlow.outflow)
        .fold(0, (total, item) => total + item.amount);
  }

  int get _netCashflow => _totalInflow - _totalOutflow;

  List<BankMutationItem> get _filteredMutations {
    if (_selectedFilterIndex == 1) {
      return _allMutations.where((e) => e.flow == TransactionFlow.inflow).toList();
    } else if (_selectedFilterIndex == 2) {
      return _allMutations.where((e) => e.flow == TransactionFlow.outflow).toList();
    }
    return _allMutations;
  }

  Map<DateTime, List<BankMutationItem>> get _groupedMutations {
    final Map<DateTime, List<BankMutationItem>> map = {};
    for (var item in _filteredMutations) {
      final dateKey = DateTime(item.date.year, item.date.month, item.date.day);
      if (!map.containsKey(dateKey)) {
        map[dateKey] = [];
      }
      map[dateKey]!.add(item);
    }
    return map;
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else if (context.canPop()) {
      context.pop();
    } else {
      try {
        context.read<MainPageCubit>().goToDashboard();
      } catch (_) {}
    }
  }

  String _formatPeriodLabel(String period) {
    final parts = period.split("-");
    if (parts.length == 2) {
      final year = parts[0];
      final monthNum = int.tryParse(parts[1]) ?? 1;
      const months = [
        "Januari", "Februari", "Maret", "April", "Mei", "Juni",
        "Juli", "Agustus", "September", "Oktober", "November", "Desember"
      ];
      if (monthNum >= 1 && monthNum <= 12) {
        return "${months[monthNum - 1]} $year";
      }
    }
    return period;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(date.year, date.month, date.day);

    const months = [
      "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
      "Jul", "Agu", "Sep", "Okt", "Nov", "Des"
    ];

    if (itemDate == today) {
      return "Hari Ini • ${date.day} ${months[date.month - 1]} ${date.year}";
    } else if (itemDate == yesterday) {
      return "Kemarin • ${date.day} ${months[date.month - 1]} ${date.year}";
    } else {
      const days = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];
      final dayName = days[date.weekday - 1];
      return "$dayName, ${date.day} ${months[date.month - 1]} ${date.year}";
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return "$hour:$minute WIB";
  }

  String _formatReceiptDateTime(DateTime date) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
      "Jul", "Agu", "Sep", "Okt", "Nov", "Des"
    ];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return "$day $month $year, $hour:$minute WIB";
  }

  // ===========================================================================
  // 📅 MONTH SELECTOR MODAL BOTTOM SHEET
  // ===========================================================================
  void _showMonthSelectorModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 30.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.w),
              topRight: Radius.circular(24.w),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(10.w),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pilih Periode Mutasi",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  InkWell(
                    onTap: () => context.pop(),
                    child: Icon(Icons.close_rounded, color: const Color(0xFF64748B), size: 22.w),
                  ),
                ],
              ),
              SizedBox(height: 14.h),

              // Option: Semua Bulan
              _buildMonthOptionTile(
                title: "Semua Periode (All Time)",
                isSelected: _selectedPeriod == null,
                onTap: () {
                  context.pop();
                  if (_selectedPeriod != null) {
                    setState(() => _selectedPeriod = null);
                    _loadHistoryData();
                  }
                },
              ),

              // Dynamic List of Available Periods
              ..._availablePeriods.map((p) {
                final isSel = _selectedPeriod == p;
                return _buildMonthOptionTile(
                  title: _formatPeriodLabel(p),
                  isSelected: isSel,
                  onTap: () {
                    context.pop();
                    if (_selectedPeriod != p) {
                      setState(() => _selectedPeriod = p);
                      _loadHistoryData();
                    }
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthOptionTile({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF5F3FF) : Colors.white,
              borderRadius: BorderRadius.circular(12.w),
              border: Border.all(
                color: isSelected ? AppColors.premiumDarkSolid : const Color(0xFFE2E8F0),
                width: 1.2.w,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 16.w,
                      color: isSelected ? AppColors.premiumDarkSolid : const Color(0xFF64748B),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.premiumDarkSolid : const Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: AppColors.premiumDarkSolid, size: 18.w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedMutations;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. APP BAR HEADER WITH MONTH SELECTOR
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                leadingWidth: 68.w,
                leading: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: InkWell(
                      onTap: _handleBack,
                      borderRadius: BorderRadius.circular(12.w),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: const Color(0xFF0F172A), size: 20.w),
                      ),
                    ),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  "Mutasi Rekening",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: _loadHistoryData,
                    icon: Icon(Icons.refresh_rounded, color: AppColors.premiumDarkSolid, size: 22.w),
                    tooltip: "Muat Ulang Mutasi",
                  ),
                  SizedBox(width: 8.w),
                ],
              ),

              // 2. HERO SETTLED SUMMARY BANNER (MiERP SIGNATURE)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumDarkGradient,
                      borderRadius: BorderRadius.circular(22.w),
                      border: Border.all(
                        color: const Color(0xFFA855F7).withValues(alpha: 0.35),
                        width: 1.2.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.premiumDarkSolid.withValues(alpha: 0.32),
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
                              "Arus Kas Bersih (Net Cashflow)",
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
                                    "Settled / Lunas",
                                    style: GoogleFonts.inter(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF34D399),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              _netCashflow >= 0 ? "+" : "-",
                              style: GoogleFonts.inter(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                                color: _netCashflow >= 0 ? const Color(0xFF34D399) : const Color(0xFFF87171),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              convertDollar.intToDollar(_netCashflow.abs()),
                              style: GoogleFonts.inter(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.6,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14.w),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 1.w,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Inflow Box
                              Row(
                                children: [
                                  Container(
                                    width: 28.w,
                                    height: 28.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(Icons.call_received_rounded, color: const Color(0xFF34D399), size: 16.w),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Uang Masuk",
                                        style: GoogleFonts.inter(fontSize: 10.sp, color: const Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "+ ${convertDollar.intToDollar(_totalInflow)}",
                                        style: GoogleFonts.inter(fontSize: 12.5.sp, color: const Color(0xFF34D399), fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                width: 1.w,
                                height: 26.h,
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                              // Outflow Box
                              Row(
                                children: [
                                  Container(
                                    width: 28.w,
                                    height: 28.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(Icons.call_made_rounded, color: const Color(0xFFF87171), size: 16.w),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Uang Keluar",
                                        style: GoogleFonts.inter(fontSize: 10.sp, color: const Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "- ${convertDollar.intToDollar(_totalOutflow)}",
                                        style: GoogleFonts.inter(fontSize: 12.5.sp, color: const Color(0xFFF87171), fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. CONTROL BAR TERPADU (PERIODE BULAN & FILTER FLOW)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Baris 1: Judul Daftar Mutasi + Tombol Periode Bulan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Daftar Mutasi",
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                          ),
                          InkWell(
                            onTap: _showMonthSelectorModal,
                            borderRadius: BorderRadius.circular(10.w),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.w),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 1.w,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    offset: Offset(0, 2.w),
                                    blurRadius: 4.w,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_month_rounded,
                                    color: AppColors.premiumDarkSolid,
                                    size: 14.w,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    _selectedPeriod == null ? "Semua Periode" : _formatPeriodLabel(_selectedPeriod!),
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: const Color(0xFF64748B),
                                    size: 16.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Baris 2: Filter Segmented Chips (Semua, Masuk, Keluar)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _buildFilterChip("Semua (${_allMutations.length})", 0),
                            SizedBox(width: 8.w),
                            _buildFilterChip(
                              "Uang Masuk (${_allMutations.where((e) => e.flow == TransactionFlow.inflow).length})", 
                              1,
                            ),
                            SizedBox(width: 8.w),
                            _buildFilterChip(
                              "Uang Keluar (${_allMutations.where((e) => e.flow == TransactionFlow.outflow).length})", 
                              2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 4. TRANSACTION MUTATION LIST (BANK STATEMENT LEDGER STYLE)
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 32.h),
                sliver: _buildMutationLedgerSliver(grouped),
              ),
            ],
          ),

          if (_isLoading)
            Container(
              color: Colors.black12,
              child: Center(
                child: LoadingAnimationWidget.stretchedDots(
                  color: AppColors.premiumDarkSolid,
                  size: 55.w,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.w),
          gradient: isSelected ? AppColors.premiumDarkGradient : null,
          color: isSelected ? null : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.premiumDarkSolid : const Color(0xFFE2E8F0),
            width: 1.2.w,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.premiumDarkSolid.withValues(alpha: 0.3),
                offset: const Offset(0, 3),
                blurRadius: 8.w,
              ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildMutationLedgerSliver(Map<DateTime, List<BankMutationItem>> grouped) {
    if (_errorMessage.isNotEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.error_outline_rounded, color: const Color(0xFFEF4444), size: 40.w),
                SizedBox(height: 10.h),
                Text(
                  "Gagal memuat mutasi: $_errorMessage",
                  style: GoogleFonts.inter(fontSize: 12.sp, color: const Color(0xFF64748B)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (grouped.isEmpty && !_isLoading) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60.h),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: AppColors.premiumDarkSolid.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.premiumDarkSolid.withValues(alpha: 0.18),
                      width: 1.w,
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.receipt_long_rounded, color: AppColors.premiumDarkSolid, size: 28.w),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  "Belum Ada Mutasi Transaksi",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _selectedPeriod == null 
                      ? "Semua transaksi lunas akan tercatat rapi di buku mutasi ini"
                      : "Tidak ada transaksi pada periode ${_formatPeriodLabel(_selectedPeriod!)}",
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    color: const Color(0xFF64748B),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final sliverItems = <Widget>[];

    grouped.forEach((date, items) {
      // 1. Date Group Header
      sliverItems.add(
        Padding(
          padding: EdgeInsets.only(top: 14.h, bottom: 8.h),
          child: Row(
            children: [
              Container(
                width: 7.w,
                height: 7.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF94A3B8),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                _formatDateHeader(date),
                style: GoogleFonts.inter(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF475569),
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              Text(
                "${items.length} transaksi",
                style: GoogleFonts.inter(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      );

      // 2. Ledger Tiles in this date
      for (var item in items) {
        sliverItems.add(
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildBankLedgerTile(item),
          ),
        );
      }
    });

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => sliverItems[index],
        childCount: sliverItems.length,
      ),
    );
  }

  Widget _buildBankLedgerTile(BankMutationItem item) {
    final isInflow = item.flow == TransactionFlow.inflow;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showDigitalReceiptModal(context, item),
        borderRadius: BorderRadius.circular(16.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.w),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                offset: Offset(0, 3.w),
                blurRadius: 8.w,
              ),
            ],
          ),
          child: Row(
            children: [
              // 1. DIRECTION CASHFLOW CIRCULAR ICON
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: isInflow ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isInflow ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
                    width: 1.2.w,
                  ),
                ),
                child: Center(
                  child: Icon(
                    isInflow ? Icons.call_received_rounded : Icons.call_made_rounded,
                    color: isInflow ? const Color(0xFF059669) : const Color(0xFFDC2626),
                    size: 20.w,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // 2. COUNTERPARTY & TRANSACTION INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.partyName,
                      style: GoogleFonts.inter(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "${item.productName} • ${item.quantity} pcs",
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          _formatTime(item.date),
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: isInflow ? const Color(0xFFECFDF5) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                          child: Text(
                            isInflow ? "Sales / Masuk" : "Order / Keluar",
                            style: GoogleFonts.inter(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                              color: isInflow ? const Color(0xFF059669) : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              // 3. NOMINAL & SETTLED BADGE
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${isInflow ? '+' : '-'} ${convertDollar.intToDollar(item.amount)}",
                    style: GoogleFonts.inter(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w800,
                      color: isInflow ? const Color(0xFF059669) : const Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(6.w),
                      border: Border.all(color: const Color(0xFFBBF7D0), width: 1.w),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, color: const Color(0xFF16A34A), size: 10.w),
                        SizedBox(width: 3.w),
                        Text(
                          "Lunas",
                          style: GoogleFonts.inter(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 4.w),
              Icon(Icons.chevron_right_rounded, color: const Color(0xFFCBD5E1), size: 18.w),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 🧾 FINTECH DIGITAL RECEIPT MODAL (BUKTI MUTASI RESMI)
  // ===========================================================================
  void _showDigitalReceiptModal(BuildContext context, BankMutationItem item) {
    final isInflow = item.flow == TransactionFlow.inflow;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.90,
            ),
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(26.w),
                topRight: Radius.circular(26.w),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFA7F3D0), width: 2.w),
                    ),
                    child: Center(
                      child: Icon(Icons.check_circle_rounded, color: const Color(0xFF059669), size: 32.w),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Text(
                    "Transaksi Berhasil Diverifikasi",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF059669),
                    ),
                  ),
                  SizedBox(height: 6.h),

                  Text(
                    "${isInflow ? '+' : '-'} ${convertDollar.intToDollar(item.amount)}",
                    style: GoogleFonts.inter(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w800,
                      color: isInflow ? const Color(0xFF059669) : const Color(0xFF0F172A),
                      letterSpacing: -0.6,
                    ),
                  ),
                  SizedBox(height: 18.h),

                  // =======================================================
                  // GRUP 1: INFORMASI TRANSAKSI
                  // =======================================================
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.w),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          offset: Offset(0, 2.w),
                          blurRadius: 6.w,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildReceiptRow(
                          label: "No. Referensi",
                          value: item.referenceId.length > 14
                              ? "${item.referenceId.substring(0, 14)}..."
                              : item.referenceId,
                          trailing: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: item.referenceId));
                              CustomTopSnackbar.success(
                                context,
                                "ID Referensi berhasil disalin!",
                                title: "Berhasil",
                              );
                            },
                            borderRadius: BorderRadius.circular(6.w),
                            child: Container(
                              padding: EdgeInsets.all(5.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6.w),
                              ),
                              child: Icon(Icons.copy_rounded, color: const Color(0xFF64748B), size: 14.w),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Divider(height: 1.h, thickness: 1.w, color: const Color(0xFFF1F5F9)),
                        ),
                        _buildReceiptRow(
                          label: "Waktu Transaksi",
                          value: _formatReceiptDateTime(item.date),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Divider(height: 1.h, thickness: 1.w, color: const Color(0xFFF1F5F9)),
                        ),
                        _buildReceiptRow(
                          label: "Jenis Mutasi",
                          value: "",
                          customValueWidget: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: isInflow ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(8.w),
                              border: Border.all(
                                color: isInflow ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isInflow ? Icons.call_received_rounded : Icons.call_made_rounded,
                                  size: 13.w,
                                  color: isInflow ? const Color(0xFF059669) : const Color(0xFFDC2626),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  isInflow ? "Uang Masuk (SO)" : "Uang Keluar (PO)",
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: isInflow ? const Color(0xFF059669) : const Color(0xFFDC2626),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // =======================================================
                  // GRUP 2: RINCIAN PESANAN & TOTAL TAGIHAN
                  // =======================================================
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.w),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          offset: Offset(0, 2.w),
                          blurRadius: 6.w,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildReceiptRow(
                          label: isInflow ? "Nama Customer" : "Pihak Pemohon",
                          value: item.partyName,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Divider(height: 1.h, thickness: 1.w, color: const Color(0xFFF1F5F9)),
                        ),
                        _buildReceiptRow(
                          label: "Rincian Barang",
                          value: "${item.productName} (${item.quantity}x)",
                        ),
                        if (item.discountPercent != null && item.discountPercent! > 0) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Divider(height: 1.h, thickness: 1.w, color: const Color(0xFFF1F5F9)),
                          ),
                          _buildReceiptRow(
                            label: "Diskon Terpasang",
                            value: "${item.discountPercent}%",
                            valueColor: const Color(0xFF059669),
                          ),
                        ],
                        SizedBox(height: 14.h),

                        // STRIP TOTAL TAGIHAN BERLATAR KONTRAS
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12.w),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Tagihan",
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              Text(
                                convertDollar.intToDollar(item.amount),
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0F172A),
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        context.pop();
                        final refId = item.referenceId.isNotEmpty ? item.referenceId : item.id;
                        if (item.referenceType == 'sales_order' || isInflow) {
                          context.push("/detail_sales_order/$refId");
                        } else {
                          context.push("/detail_product_order/$refId");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.w)),
                        elevation: 0,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumDarkGradient,
                          borderRadius: BorderRadius.circular(14.w),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.visibility_outlined, color: Colors.white, size: 18.w),
                              SizedBox(width: 8.w),
                              Text(
                                "Lihat Detail Pesanan Penuh",
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      "Tutup Bukti Mutasi",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceiptRow({
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
    Widget? trailing,
    Widget? customValueWidget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(width: 12.w),
        if (customValueWidget != null)
          customValueWidget
        else
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12.5.sp,
                      fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                      color: valueColor ?? (isBold ? const Color(0xFF0F172A) : const Color(0xFF1E293B)),
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: 6.w),
                  trailing,
                ],
              ],
            ),
          ),
      ],
    );
  }
}
