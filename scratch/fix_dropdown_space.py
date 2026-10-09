import sys

content = open(r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart', 'r', encoding='utf-8').read()

target = """                                      child: PopupMenuButton<int>(
                                        enabled: state.selectedTab != "products" && state.selectedTab != "all_summary",
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.w),
                                        ),
                                        color: Colors.white,
                                        elevation: 8,
                                        offset: Offset(0, 40.h),
                                        onSelected: (value) {
                                          context.read<SummaryBloc>().add(SummaryFilterChanged(value));
                                        },
                                        itemBuilder: (context) {
                                          return List.generate(options.length, (index) {
                                            bool isSelected = state.tag == index;
                                            return PopupMenuItem<int>(
                                              value: index,
                                              padding: EdgeInsets.zero,
                                              height: 45.h,
                                              child: Container(
                                                width: 150.w,
                                                margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                                                decoration: BoxDecoration(
                                                  gradient: isSelected ? AppColors.premiumDarkGradient : null,
                                                  color: isSelected ? null : const Color(0xFFF9FAFB),
                                                  borderRadius: BorderRadius.circular(12.w),
                                                  border: isSelected ? null : Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      options[index],
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14.sp,
                                                        fontWeight: isSelected ? AppFontWeight.bold : AppFontWeight.medium,
                                                        color: isSelected ? Colors.white : const Color(0xFF6B7280),
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      Icon(Icons.check, color: Colors.white, size: 18.w),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                        },"""

replacement = """                                      child: PopupMenuButton<int>(
                                        enabled: state.selectedTab != "products" && state.selectedTab != "all_summary",
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.w),
                                        ),
                                        color: Colors.white,
                                        elevation: 8,
                                        offset: Offset(0, 40.h),
                                        constraints: BoxConstraints(
                                          minWidth: 150.w,
                                          maxWidth: 150.w,
                                        ),
                                        onSelected: (value) {
                                          context.read<SummaryBloc>().add(SummaryFilterChanged(value));
                                        },
                                        itemBuilder: (context) {
                                          return List.generate(options.length, (index) {
                                            bool isSelected = state.tag == index;
                                            return PopupMenuItem<int>(
                                              value: index,
                                              padding: EdgeInsets.zero,
                                              height: 45.h,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
                                                decoration: BoxDecoration(
                                                  gradient: isSelected ? AppColors.premiumDarkGradient : null,
                                                  color: isSelected ? null : const Color(0xFFF9FAFB),
                                                  borderRadius: BorderRadius.circular(10.w),
                                                  border: isSelected ? null : Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      options[index],
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14.sp,
                                                        fontWeight: isSelected ? AppFontWeight.bold : AppFontWeight.medium,
                                                        color: isSelected ? Colors.white : const Color(0xFF6B7280),
                                                      ),
                                                    ),
                                                    if (isSelected)
                                                      Icon(Icons.check, color: Colors.white, size: 18.w),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                        },"""

if target in content:
    new_content = content.replace(target, replacement)
    open(r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart', 'w', encoding='utf-8').write(new_content)
    print("Replaced dropdown bounds successfully")
else:
    print("Could not find target")
