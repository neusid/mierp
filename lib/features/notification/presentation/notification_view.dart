import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';

class NotificationView extends StatelessWidget {
  NotificationView({super.key});

  final List<Map<String, dynamic>> dummyNotifications = [
    {
      "id": 1,
      "type": "order_approved",
      "title": "Sales Order Approved",
      "message": "Sales order #SO-2023-082 has been approved by Finance.",
      "time": "10 mins ago",
      "isRead": false,
      "icon": Icons.check_circle_outline,
      "color": const Color(0xFF16A34A),
      "bgColor": const Color(0xFFF0FDF4),
    },
    {
      "id": 2,
      "type": "stock_low",
      "title": "Low Stock Alert",
      "message": "Product 'Macbook Pro M2' is running low on stock (2 items left).",
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
      "message": "You received a new order #WO-092 from Jakarta Branch.",
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
      "message": "The MiERP system will be down for maintenance on Sunday 02:00 AM.",
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
      "message": "Payment of \$4,200 for Invoice #INV-882 has been confirmed.",
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
          Container(
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
                    fontWeight: AppFontWeight.semiBold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Mark all as read",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: AppFontWeight.medium,
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                ),
                SizedBox(width: 24.w),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              itemCount: dummyNotifications.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final notif = dummyNotifications[index];
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: notif["isRead"] ? Colors.white : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16.w),
                    border: Border.all(
                      color: notif["isRead"] ? const Color(0xFFF1F5F9) : const Color(0xFFE2E8F0),
                      width: 1.w,
                    ),
                    boxShadow: notif["isRead"] ? [] : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8.w,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: notif["bgColor"],
                          shape: BoxShape.circle,
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
                                      fontWeight: notif["isRead"] ? AppFontWeight.medium : AppFontWeight.semiBold,
                                      color: const Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  notif["time"],
                                  style: GoogleFonts.inter(
                                    fontSize: 10.sp,
                                    fontWeight: AppFontWeight.regular,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              notif["message"],
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: AppFontWeight.regular,
                                color: const Color(0xFF64748B),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
