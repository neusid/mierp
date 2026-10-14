import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/features/notification/data/models/notification_model.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_state.dart';

enum _NotificationFilter { all, unread, orders }

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  _NotificationFilter _selectedFilter = _NotificationFilter.all;

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().init();
  }

  String _formatTimeAgo(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inSeconds < 60) {
      return "Baru saja";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} mnt lalu";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} jam lalu";
    } else if (difference.inDays == 1) {
      return "Kemarin";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} hari lalu";
    } else {
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'order_approved':
        return Icons.verified_outlined;
      case 'order_rejected':
        return Icons.highlight_off_rounded;
      case 'new_sales_order':
        return Icons.receipt_long_outlined;
      case 'new_product_order':
        return Icons.inventory_2_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  String _getCategoryBadge(String type) {
    switch (type) {
      case 'order_approved':
        return "DISETUJUI";
      case 'order_rejected':
        return "DITOLAK";
      case 'new_sales_order':
        return "SALES ORDER";
      case 'new_product_order':
        return "PRODUCT ORDER";
      default:
        return "SISTEM";
    }
  }

  void _onNotificationTap(NotificationModel notif) {
    HapticFeedback.selectionClick();
    if (!notif.isRead) {
      context.read<NotificationCubit>().markAsRead(notif.id);
    }

    if (notif.orderId.isNotEmpty) {
      if (notif.orderType == 'sales_order') {
        context.push('/detail_sales_order/${notif.orderId}');
      } else if (notif.orderType == 'product_order') {
        context.push('/detail_product_order/${notif.orderId}');
      }
    }
  }

  List<NotificationModel> _filterNotifications(List<NotificationModel> list) {
    switch (_selectedFilter) {
      case _NotificationFilter.all:
        return list;
      case _NotificationFilter.unread:
        return list.where((n) => !n.isRead).toList();
      case _NotificationFilter.orders:
        return list
            .where((n) =>
                n.type == 'new_sales_order' ||
                n.type == 'new_product_order' ||
                n.type == 'order_approved' ||
                n.type == 'order_rejected')
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          final filteredList = _filterNotifications(state.notifications);

          return Column(
            children: [
              // 1. Signature Executive Header
              _buildExecutiveHeader(context, state),

              // 2. Filter Tabs
              _buildFilterTabs(state),

              // 3. Notification List or Empty State
              Expanded(
                child: state.isLoading && state.notifications.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.vividPurple,
                          strokeWidth: 2.5,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => context.read<NotificationCubit>().init(),
                        color: AppColors.vividPurple,
                        backgroundColor: Colors.white,
                        child: filteredList.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(height: 70.h),
                                  _buildEmptyState(),
                                ],
                              )
                            : ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 24.h),
                                itemCount: filteredList.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 10.h),
                                itemBuilder: (context, index) {
                                  final notif = filteredList[index];
                                  return _buildNotificationCard(notif, index);
                                },
                              ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // 1. SIGNATURE EXECUTIVE HEADER (OBSIDIAN & UNGU)
  // ==========================================
  Widget _buildExecutiveHeader(BuildContext context, NotificationState state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.premiumDarkGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Top-Right Geometric Transparent Circle
          Positioned(
            top: -45.h,
            right: -25.w,
            child: Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.02),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                  width: 1.w,
                ),
              ),
            ),
          ),
          // Bottom-Left Geometric Transparent Circle
          Positioned(
            bottom: -35.h,
            left: -20.w,
            child: Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.06),
                    Colors.white.withValues(alpha: 0.01),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1.w,
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
              child: Row(
                children: [
                  // Back button
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.pop();
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  // Title & Unread status pill
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Notifikasi",
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  width: 0.8.w,
                                ),
                              ),
                              child: Text(
                                state.unreadCount > 0
                                    ? "${state.unreadCount} Belum Dibaca"
                                    : "Semua Terbaca",
                                style: GoogleFonts.inter(
                                  fontSize: 10.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.95),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Mark All Read Button
                  if (state.unreadCount > 0)
                    InkWell(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        context.read<NotificationCubit>().markAllAsRead();
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 0.8.w,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.done_all_rounded,
                              color: Colors.white,
                              size: 16.w,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Tandai Dibaca",
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Quick Tools / Simulation trigger (Discreet & Executive)
                  SizedBox(width: 6.w),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showSimulationSheet(context);
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.all(7.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 17.w,
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

  // ==========================================
  // 2. FILTER TABS (SEMUA, BELUM DIBACA, TRANSAKSI)
  // ==========================================
  Widget _buildFilterTabs(NotificationState state) {
    final unreadTotal = state.unreadCount;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
      child: Row(
        children: [
          _buildFilterChip(
            label: "Semua",
            count: state.notifications.length,
            isSelected: _selectedFilter == _NotificationFilter.all,
            onTap: () => setState(() => _selectedFilter = _NotificationFilter.all),
          ),
          SizedBox(width: 8.w),
          _buildFilterChip(
            label: "Belum Dibaca",
            count: unreadTotal,
            isSelected: _selectedFilter == _NotificationFilter.unread,
            onTap: () => setState(() => _selectedFilter = _NotificationFilter.unread),
          ),
          SizedBox(width: 8.w),
          _buildFilterChip(
            label: "Transaksi",
            isSelected: _selectedFilter == _NotificationFilter.orders,
            onTap: () => setState(() => _selectedFilter = _NotificationFilter.orders),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    int? count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(10.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.premiumDarkGradient : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0),
              width: 1.w,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.premiumDarkSolid.withValues(alpha: 0.22),
                      blurRadius: 6.r,
                      offset: Offset(0, 2.h),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
              if (count != null && count > 0) ...[
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.22)
                        : AppColors.purpleTransparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "$count",
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.vividPurple,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 3. NOTIFICATION CARD (OBSIDIAN BLACK & UNGU)
  // ==========================================
  Widget _buildNotificationCard(NotificationModel notif, int index) {
    final isRead = notif.isRead;
    final icon = _getNotificationIcon(notif.type);
    final categoryBadge = _getCategoryBadge(notif.type);
    final timeStr = _formatTimeAgo(notif.createdAt);

    return Dismissible(
      key: ValueKey(notif.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.lightImpact();
        context.read<NotificationCubit>().deleteNotification(notif.id);
      },
      background: Container(
        margin: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hapus",
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 20.w,
            ),
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onNotificationTap(notif),
          borderRadius: BorderRadius.circular(16.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: isRead ? Colors.white : const Color(0xFFFBFAFF),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isRead
                    ? const Color(0xFFE2E8F0)
                    : AppColors.lavenderMist,
                width: isRead ? 1.w : 1.2.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: isRead
                      ? const Color(0xFF0F172A).withValues(alpha: 0.02)
                      : AppColors.premiumDarkSolid.withValues(alpha: 0.05),
                  blurRadius: 12.r,
                  offset: Offset(0, 3.h),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Squircle Icon Badge
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    gradient: isRead ? null : AppColors.premiumDarkGradient,
                    color: isRead ? const Color(0xFFF8FAFC) : null,
                    borderRadius: BorderRadius.circular(12.r),
                    border: isRead
                        ? Border.all(color: const Color(0xFFE2E8F0), width: 1.w)
                        : null,
                    boxShadow: isRead
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.premiumDarkSolid.withValues(alpha: 0.22),
                              blurRadius: 6.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: isRead ? const Color(0xFF475569) : Colors.white,
                      size: 20.w,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Category Pill & Relative Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 7.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.purpleTransparent,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: AppColors.lavenderMist,
                                width: 0.8.w,
                              ),
                            ),
                            child: Text(
                              categoryBadge,
                              style: GoogleFonts.inter(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.vividPurple,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                timeStr,
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: isRead
                                      ? FontWeight.w500
                                      : FontWeight.w600,
                                  color: isRead
                                      ? const Color(0xFF94A3B8)
                                      : AppColors.vividPurple,
                                ),
                              ),
                              if (!isRead) ...[
                                SizedBox(width: 6.w),
                                Container(
                                  width: 6.5.w,
                                  height: 6.5.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.vividPurple,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      // Title
                      Text(
                        notif.title,
                        style: GoogleFonts.inter(
                          fontSize: 13.5.sp,
                          fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3.h),
                      // Message
                      Text(
                        notif.message,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: const Color(0xFF64748B),
                          height: 1.35,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (notif.orderId.isNotEmpty) ...[
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: const Color(0xFF94A3B8),
                    size: 18.w,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 4. CLEAN EXECUTIVE EMPTY STATE
  // ==========================================
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 68.w,
              height: 68.w,
              decoration: BoxDecoration(
                gradient: AppColors.premiumDarkGradient,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.premiumDarkSolid.withValues(alpha: 0.22),
                    blurRadius: 14.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 32.w,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Belum Ada Notifikasi",
              style: GoogleFonts.inter(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "Pemberitahuan aktivitas pesanan, transaksi, dan verifikasi akun Anda akan ditampilkan secara realtime di sini.",
              style: GoogleFonts.inter(
                fontSize: 12.5.sp,
                color: const Color(0xFF64748B),
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 5. SIMULATION & TOOLS SHEET (OBSIDIAN & UNGU)
  // ==========================================
  void _showSimulationSheet(BuildContext parentContext) {
    final cubit = parentContext.read<NotificationCubit>();
    final activeRole = cubit.state.activeRole;
    final displayRole = activeRole.isEmpty ? 'FINANCE' : activeRole.toUpperCase();

    void executeTest(Future<bool> Function() testAction) async {
      Navigator.pop(parentContext);
      final ok = await testAction();
      if (!parentContext.mounted) return;

      if (!ok) {
        final err = cubit.state.errorMessage ?? "Gagal mengirim";
        CustomTopSnackbar.error(
          parentContext,
          "Gagal mengirim ke Firestore:\n$err",
          title: "Uji Coba Gagal",
        );
      }
    }

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 28.r,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.5.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 42.w,
                        height: 42.w,
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumDarkGradient,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.premiumDarkSolid.withValues(alpha: 0.22),
                              blurRadius: 8.r,
                              offset: Offset(0, 3.h),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.tune_rounded,
                            color: Colors.white,
                            size: 20.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Simulasi & Uji Notifikasi",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                                letterSpacing: -0.3,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Role aktif akun: $displayRole",
                              style: GoogleFonts.inter(
                                fontSize: 11.5.sp,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "PILIH SKENARIO PENGUJIAN",
                    style: GoogleFonts.inter(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF475569),
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildSimulationItem(
                    title: "Kirim ke Akun Saya ($displayRole)",
                    description: "Uji coba langsung ke role yang sedang aktif",
                    icon: Icons.person_outline_rounded,
                    onTap: () {
                      final target = activeRole.isNotEmpty ? activeRole : 'finance';
                      executeTest(
                        () => cubit.sendTestNotification(
                          role: target,
                          type: target == 'finance'
                              ? 'new_sales_order'
                              : 'order_approved',
                          title: 'Test Notifikasi ($displayRole)',
                          message:
                              'Notifikasi uji coba berhasil dikirim dan diverifikasi.',
                          orderId: 'SO-SELF',
                          orderType: 'sales_order',
                          productName: 'MiERP Item',
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8.h),
                  _buildSimulationItem(
                    title: "Sales Order Baru (Role Finance)",
                    description: "Simulasi pesanan masuk dari Warehouse",
                    icon: Icons.receipt_long_outlined,
                    onTap: () {
                      executeTest(
                        () => cubit.sendTestNotification(
                          role: 'finance',
                          type: 'new_sales_order',
                          title: 'Sales Order Baru #SO-8821',
                          message:
                              'Pesanan penjualan baru siap diproses & menunggu persetujuan.',
                          orderId: 'SO-8821',
                          orderType: 'sales_order',
                          productName: 'ASUS ROG Zephyrus',
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8.h),
                  _buildSimulationItem(
                    title: "Order Disetujui (Role Warehouse)",
                    description: "Simulasi persetujuan pembayaran oleh Finance",
                    icon: Icons.verified_outlined,
                    onTap: () {
                      executeTest(
                        () => cubit.sendTestNotification(
                          role: 'warehouse',
                          type: 'order_approved',
                          title: 'Order Disetujui & Lunas #SO-8821',
                          message:
                              'Pesanan telah diverifikasi dan ditandai lunas oleh Finance.',
                          orderId: 'SO-8821',
                          orderType: 'sales_order',
                          productName: 'ASUS ROG Zephyrus',
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8.h),
                  _buildSimulationItem(
                    title: "Instant Push Bar HP (Lokal)",
                    description: "Kirim notifikasi langsung ke tray status bar perangkat",
                    icon: Icons.notifications_active_outlined,
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      cubit.triggerLocalNotificationTest();
                    },
                  ),
                  SizedBox(height: 8.h),
                  _buildSimulationItem(
                    title: "Salin Token FCM Perangkat",
                    description: "Salin token untuk Firebase Console Cloud Messaging",
                    icon: Icons.content_copy_rounded,
                    onTap: () async {
                      Navigator.pop(bottomSheetContext);
                      try {
                        final token = await FirebaseMessaging.instance.getToken();
                        if (token != null && token.isNotEmpty) {
                          await Clipboard.setData(ClipboardData(text: token));
                          if (parentContext.mounted) {
                            CustomTopSnackbar.show(
                              parentContext,
                              "Token FCM berhasil disalin ke clipboard.",
                              isError: false,
                            );
                          }
                        }
                      } catch (e) {
                        if (parentContext.mounted) {
                          CustomTopSnackbar.show(
                            parentContext,
                            "Gagal mengambil token FCM: $e",
                            isError: true,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSimulationItem({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
          ),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.purpleTransparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(icon, color: AppColors.vividPurple, size: 18.w),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xFF94A3B8),
                size: 18.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
