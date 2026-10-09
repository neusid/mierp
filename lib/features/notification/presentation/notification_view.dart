import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final List<Map<String, dynamic>> dummyNotifications = [
    {
      "id": 1,
      "type": "order_approved",
      "title": "Sales Order Approved",
      "message": "Sales order #SO-2023-082 has been approved by Finance Team. Ready for dispatch.",
      "time": "10 mins ago",
      "isRead": false,
      "icon": Icons.check_circle_outline,
      "color": const Color(0xFF16A34A),
      "bgColor": const Color(0xFFF0FDF4),
    },
    {
      "id": 2,
      "type": "stock_low",
      "title": "Critical Stock Alert",
      "message": "Product 'Macbook Pro M2' is running critically low (2 items left). Restock immediately.",
      "time": "2 hours ago",
      "isRead": false,
      "icon": Icons.warning_amber_rounded,
      "color": const Color(0xFFEF4444),
      "bgColor": const Color(0xFFFEF2F2),
    },
    {
      "id": 3,
      "type": "new_order",
      "title": "New Warehouse Order",
      "message": "You received a new order #WO-092 from Jakarta Branch. Please process the items.",
      "time": "Yesterday",
      "isRead": true,
      "icon": Icons.inventory_2_outlined,
      "color": const Color(0xFF3B82F6),
      "bgColor": const Color(0xFFEFF6FF),
    },
    {
      "id": 4,
      "type": "system",
      "title": "System Maintenance",
      "message": "The MiERP system will be down for scheduled maintenance on Sunday 02:00 AM.",
      "time": "2 days ago",
      "isRead": true,
      "icon": Icons.info_outline,
      "color": const Color(0xFF64748B),
      "bgColor": const Color(0xFFF1F5F9),
    },
    {
      "id": 5,
      "type": "payment",
      "title": "Payment Received",
      "message": "Payment of \$4,200 for Invoice #INV-882 has been confirmed by the bank.",
      "time": "3 days ago",
      "isRead": true,
      "icon": Icons.payments_outlined,
      "color": const Color(0xFF7C3AED),
      "bgColor": const Color(0xFFF3E8FF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: dummyNotifications.isEmpty 
            ? _buildEmptyState()
            : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              itemCount: dummyNotifications.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final notif = dummyNotifications[index];
                final isRead = notif["isRead"] as bool;

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 400 + (index * 100)), // Staggered delay
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
                    key: ValueKey(notif["id"]),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        dummyNotifications.removeAt(index);
                      });
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
                      onTap: () {
                        HapticFeedback.selectionClick();
                        if (!isRead) {
                          setState(() {
                            notif["isRead"] = true;
                          });
                        }
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: isRead ? Colors.white : Colors.white,
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
                                color: const Color(0xFF3B82F6), // Electric Blue
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
                                          color: notif["bgColor"],
                                          borderRadius: BorderRadius.circular(12.w),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            notif["icon"],
                                            color: notif["color"],
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
                                                    notif["title"],
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
                                                  notif["time"],
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
                                              notif["message"],
                                              style: GoogleFonts.inter(
                                                fontSize: 13.sp,
                                                fontWeight: AppFontWeight.regular,
                                                color: const Color(0xFF64748B),
                                                height: 1.4,
                                              ),
                                              maxLines: 2,
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
          // If you want to use the JPG version, comment the SvgPicture below and uncomment this Image widget:
          // Image.asset(
          //   'assets/images/mailbox_empty.jpg',
          //   width: 220.w,
          //   fit: BoxFit.contain,
          // ),
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
              "Your notification will appear here once you've received them.",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: AppFontWeight.medium,
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 60.h),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16.h, bottom: 16.h),
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF1F5F9),
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
          Spacer(),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                for (var notif in dummyNotifications) {
                  notif["isRead"] = true;
                }
              });
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
}
