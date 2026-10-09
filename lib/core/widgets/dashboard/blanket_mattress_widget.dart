import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';

class BlanketMattressWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final int count;
  final String rightTitle;
  final String rightSubtitle;
  final double progress;
  final Color themeColor;
  final Color themeBgColor;
  final IconData headerIcon;
  final List<Map<String, String>> items;
  final String buttonText;
  final VoidCallback? onTapButton;

  const BlanketMattressWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.rightTitle,
    required this.rightSubtitle,
    required this.progress,
    required this.themeColor,
    required this.themeBgColor,
    required this.headerIcon,
    required this.items,
    required this.buttonText,
    this.onTapButton,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // THE MATTRESS (Bottom Layer)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 30.h), // Push down so blanket overlaps
            padding: EdgeInsets.only(
              top: 60.h,
              left: 16.w,
              right: 16.w,
              bottom: 8.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5.w),
            ),
            child: Column(
              children: [
                ...items.map((item) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: (item['image'] != null && item['image']!.isNotEmpty)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.network(
                                    item['image']!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.inventory_2_outlined,
                                          color: const Color(0xFF64748B),
                                          size: 20.w,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.inventory_2_outlined,
                                    color: const Color(0xFF64748B),
                                    size: 20.w,
                                  ),
                                ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: AppFontWeight.semiBold,
                                  color: const Color(0xFF334155),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                item['subtitle'] ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: AppFontWeight.medium,
                                  color: const Color(0xFF64748B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: themeBgColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: themeBgColor.withValues(alpha: 0.8),
                            ),
                          ),
                          child: Text(
                            item['badge'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 9.sp,
                              fontWeight: AppFontWeight.bold,
                              color: themeColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                // View All Button
                GestureDetector(
                  onTap: onTapButton,
                  child: Container(
                    width: double.infinity,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        buttonText,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: AppFontWeight.semiBold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // THE BLANKET (Top Layer)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 34.w,
                    height: 34.w,
                    decoration: BoxDecoration(
                      color: themeBgColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(headerIcon, color: themeColor, size: 20.w),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          count.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 24.sp,
                            fontWeight: AppFontWeight.semiBold,
                            letterSpacing: -0.5,
                            color: const Color(0xFF334155),
                            height: 1.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: AppFontWeight.medium,
                            color: const Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        rightTitle,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: AppFontWeight.semiBold,
                          color: const Color(0xFF334155),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Container(
                            width: 64.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: 64.w * progress,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    color: themeColor,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            rightSubtitle,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: AppFontWeight.bold,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
