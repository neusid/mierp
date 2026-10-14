import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/features/notification/data/models/notification_model.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_state.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    super.initState();
    // Ensure cubit is initialized
    context.read<NotificationCubit>().init();
  }

  String _formatTimeAgo(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inSeconds < 60) {
      return "Baru saja";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} mins ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return "${dt.day}/${dt.month}/${dt.year}";
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'order_approved':
        return Icons.check_circle_outline_rounded;
      case 'order_rejected':
        return Icons.cancel_outlined;
      case 'new_sales_order':
        return Icons.point_of_sale_rounded;
      case 'new_product_order':
        return Icons.inventory_2_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case 'order_approved':
        return const Color(0xFF16A34A);
      case 'order_rejected':
        return const Color(0xFFEF4444);
      case 'new_sales_order':
        return const Color(0xFF3B82F6);
      case 'new_product_order':
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getBgColor(String type) {
    switch (type) {
      case 'order_approved':
        return const Color(0xFFF0FDF4);
      case 'order_rejected':
        return const Color(0xFFFEF2F2);
      case 'new_sales_order':
        return const Color(0xFFEFF6FF);
      case 'new_product_order':
        return const Color(0xFFFEF3C7);
      default:
        return const Color(0xFFF1F5F9);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state.isLoading && state.notifications.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return RefreshIndicator(
                  onRefresh: () => context.read<NotificationCubit>().init(),
                  color: const Color(0xFF3B82F6),
                  child: state.notifications.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 60.h),
                            _buildEmptyState(),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                          itemCount: state.notifications.length,
                          separatorBuilder: (context, index) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                    final notif = state.notifications[index];
                    final isRead = notif.isRead;
                    final icon = _getIcon(notif.type);
                    final color = _getColor(notif.type);
                    final bgColor = _getBgColor(notif.type);
                    final timeStr = _formatTimeAgo(notif.createdAt);

                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 500)),
                      curve: Curves.easeOutQuart,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: Dismissible(
                        key: ValueKey(notif.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          HapticFeedback.lightImpact();
                          context.read<NotificationCubit>().deleteNotification(notif.id);
                        },
                        background: Container(
                          margin: EdgeInsets.symmetric(vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(16.w),
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 24.w),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                            size: 24.w,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () => _onNotificationTap(notif),
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.w),
                              border: Border.all(
                                color: isRead ? const Color(0xFFF1F5F9) : const Color(0xFFE2E8F0),
                                width: 1.w,
                              ),
                              boxShadow: isRead
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.04),
                                        blurRadius: 20.w,
                                        offset: Offset(0, 8.h),
                                      ),
                                    ],
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Unread left accent line
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: isRead ? 0 : 4.w,
                                    color: color,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.w),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Icon container
                                          Container(
                                            width: 44.w,
                                            height: 44.w,
                                            decoration: BoxDecoration(
                                              color: bgColor,
                                              borderRadius: BorderRadius.circular(12.w),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                icon,
                                                color: color,
                                                size: 20.w,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 16.w),
                                          // Text content
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        notif.title,
                                                        style: GoogleFonts.inter(
                                                          fontSize: 14.sp,
                                                          fontWeight: isRead ? AppFontWeight.medium : AppFontWeight.bold,
                                                          color: const Color(0xFF0F172A),
                                                          letterSpacing: -0.3,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Text(
                                                      timeStr,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 11.sp,
                                                        fontWeight: AppFontWeight.medium,
                                                        color: isRead ? const Color(0xFF94A3B8) : const Color(0xFF3B82F6),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 6.h),
                                                Text(
                                                  notif.message,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13.sp,
                                                    fontWeight: AppFontWeight.regular,
                                                    color: const Color(0xFF64748B),
                                                    height: 1.4,
                                                  ),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
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
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/mailbox_empty.svg',
            width: 220.w,
          ),
          SizedBox(height: 24.h),
          Text(
            "No notifications yet",
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: AppFontWeight.bold,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              "Your notifications will appear here once you've received them.",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: AppFontWeight.medium,
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            onPressed: () => _showTestTriggerSheet(context),
            icon: Icon(Icons.science_outlined, size: 18.w),
            label: Text(
              "Kirim Test Notifikasi",
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E293B),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.w),
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16.h, bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4.h),
            blurRadius: 14.w,
            spreadRadius: 0,
            color: Colors.black.withValues(alpha: 0.03),
          )
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 24.w),
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              context.pop();
            },
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF1F5F9),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16.w,
                color: const Color(0xFF334155),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            "Notifications",
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: AppFontWeight.bold,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          // Test trigger button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _showTestTriggerSheet(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20.w),
                border:
                    Border.all(color: const Color(0xFFCBD5E1), width: 1.w),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.science_outlined,
                    size: 14.w,
                    color: const Color(0xFF475569),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Test",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: AppFontWeight.semiBold,
                      color: const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context.read<NotificationCubit>().markAllAsRead();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Text(
                "Mark all read",
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: AppFontWeight.semiBold,
                  color: const Color(0xFF3B82F6),
                ),
              ),
            ),
          ),
          SizedBox(width: 24.w),
        ],
      ),
    );
  }

  void _showTestTriggerSheet(BuildContext parentContext) {
    final cubit = parentContext.read<NotificationCubit>();
    final activeRole = cubit.state.activeRole;
    final displayRole = activeRole.isEmpty ? 'FINANCE' : activeRole.toUpperCase();

    void executeTest(Future<bool> Function() testAction, String roleLabel) async {
      Navigator.pop(parentContext);

      final ok = await testAction();
      if (!parentContext.mounted) return;

      if (!ok) {
        final err = cubit.state.errorMessage ?? "Permission Denied";
        CustomTopSnackbar.error(
          parentContext,
          "Gagal mengirim ke Firestore:\n$err\n\nPastikan Rules sudah di-publish!",
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.w)),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: Icon(
                      Icons.science_rounded,
                      color: const Color(0xFF3B82F6),
                      size: 20.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Uji Coba Trigger Notifikasi",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: AppFontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          "Pilih skenario simulasi notifikasi (Role aktif: $displayRole)",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: AppFontWeight.regular,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              // Opsi 1: Kirim ke akun sendiri (Pasti diterima di device ini)
              _buildTriggerItem(
                icon: Icons.person_pin_rounded,
                iconColor: const Color(0xFF2563EB),
                bgColor: const Color(0xFFDBEAFE),
                title: "Kirim ke Akun Saya ($displayRole) ⭐",
                description: "Pasti langsung masuk di HP ini karena sesuai role akun Anda",
                onTap: () {
                  final target = activeRole.isNotEmpty ? activeRole : 'finance';
                  executeTest(
                    () => cubit.sendTestNotification(
                      role: target,
                      type: target == 'finance' ? 'new_sales_order' : 'order_approved',
                      title: 'Test Notifikasi Akun ($displayRole)',
                      message: 'Notifikasi uji coba berhasil dikirim dan diterima secara realtime!',
                      orderId: 'SO-SELF',
                      orderType: 'sales_order',
                      productName: 'MiERP Testing Item',
                    ),
                    target,
                  );
                },
              ),
              SizedBox(height: 10.h),
              _buildTriggerItem(
                icon: Icons.point_of_sale_rounded,
                iconColor: const Color(0xFF3B82F6),
                bgColor: const Color(0xFFEFF6FF),
                title: "Sales Order Baru (Role Finance)",
                description: "Warehouse membuat sales order baru",
                onTap: () {
                  executeTest(
                    () => cubit.sendTestNotification(
                      role: 'finance',
                      type: 'new_sales_order',
                      title: 'Sales Order Baru #SO-8821',
                      message:
                          'Pesanan penjualan untuk ASUS ROG Zephyrus siap diproses.',
                      orderId: 'SO-8821',
                      orderType: 'sales_order',
                      productName: 'ASUS ROG Zephyrus',
                    ),
                    'finance',
                  );
                },
              ),
              SizedBox(height: 10.h),
              _buildTriggerItem(
                icon: Icons.inventory_2_outlined,
                iconColor: const Color(0xFFD97706),
                bgColor: const Color(0xFFFEF3C7),
                title: "Product Order Baru (Role Finance)",
                description: "Warehouse membuat pesanan produk baru",
                onTap: () {
                  executeTest(
                    () => cubit.sendTestNotification(
                      role: 'finance',
                      type: 'new_product_order',
                      title: 'Product Order Baru #WO-3301',
                      message:
                          'Pesanan produk untuk Monitor LG 27 Inch siap diproses.',
                      orderId: 'WO-3301',
                      orderType: 'product_order',
                      productName: 'Monitor LG 27 Inch',
                    ),
                    'finance',
                  );
                },
              ),
              SizedBox(height: 10.h),
              _buildTriggerItem(
                icon: Icons.check_circle_outline_rounded,
                iconColor: const Color(0xFF16A34A),
                bgColor: const Color(0xFFF0FDF4),
                title: "Order Disetujui (Role Warehouse)",
                description: "Finance menyetujui & menandai lunas",
                onTap: () {
                  executeTest(
                    () => cubit.sendTestNotification(
                      role: 'warehouse',
                      type: 'order_approved',
                      title: 'Order Disetujui & Lunas #SO-8821',
                      message:
                          'Pesanan penjualan telah diverifikasi dan lunas oleh Finance.',
                      orderId: 'SO-8821',
                      orderType: 'sales_order',
                      productName: 'ASUS ROG Zephyrus',
                    ),
                    'warehouse',
                  );
                },
              ),
              SizedBox(height: 10.h),
              _buildTriggerItem(
                icon: Icons.cancel_outlined,
                iconColor: const Color(0xFFEF4444),
                bgColor: const Color(0xFFFEF2F2),
                title: "Order Ditolak (Role Warehouse)",
                description: "Finance menolak order dengan alasan",
                onTap: () {
                  executeTest(
                    () => cubit.sendTestNotification(
                      role: 'warehouse',
                      type: 'order_rejected',
                      title: 'Order Ditolak #SO-8821',
                      message:
                          'Pesanan ditolak oleh Finance: Bukti transfer tidak terbaca.',
                      orderId: 'SO-8821',
                      orderType: 'sales_order',
                      productName: 'ASUS ROG Zephyrus',
                    ),
                    'warehouse',
                  );
                },
              ),
              SizedBox(height: 10.h),
              _buildTriggerItem(
                icon: Icons.notifications_active_rounded,
                iconColor: const Color(0xFF7C3AED),
                bgColor: const Color(0xFFF5F3FF),
                title: "Instant Push Bar HP (Lokal)",
                description: "Tembak langsung ke status bar HP saat ini juga",
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  cubit.triggerLocalNotificationTest();
                },
              ),
              SizedBox(height: 10.h),
              _buildTriggerItem(
                icon: Icons.copy_rounded,
                iconColor: const Color(0xFF0D9488),
                bgColor: const Color(0xFFF0FDFA),
                title: "Salin Token FCM Perangkat Ini 📋",
                description:
                    "Gunakan untuk tombol 'Send test message' di Firebase Console",
                onTap: () async {
                  Navigator.pop(bottomSheetContext);
                  try {
                    final token = await FirebaseMessaging.instance.getToken();
                    if (token != null && token.isNotEmpty) {
                      await Clipboard.setData(ClipboardData(text: token));
                      if (parentContext.mounted) {
                        CustomTopSnackbar.success(
                          parentContext,
                          "Token FCM berhasil disalin ke clipboard! Tempelkan pada 'Send test message' di Firebase Console.",
                          title: "Token Disalin 📋",
                        );
                      }
                    }
                  } catch (e) {
                    if (parentContext.mounted) {
                      CustomTopSnackbar.error(
                        parentContext,
                        "Gagal mengambil token: $e",
                        title: "Token Gagal Diambil",
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTriggerItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(14.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14.w),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 18.w),
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
                      fontWeight: AppFontWeight.semiBold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: AppFontWeight.regular,
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
    );
  }
}
