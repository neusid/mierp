import re

def rewrite():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # The existing block
    old_block_pattern = re.compile(
        r'onTap:\s*state\.selectedTab\s*!=\s*"products"\s*&&\s*state\.selectedTab\s*!=\s*"all_summary"\s*\?\s*\(\)\s*=>\s*showBarModalBottomSheet\(\s*'
        r'context:\s*context,\s*enableDrag:\s*true,\s*shape:\s*RoundedRectangleBorder\(\s*borderRadius:\s*BorderRadiusGeometry\.circular\(\s*10\.w,\s*\),\s*\),\s*'
        r'builder:\s*\(\s*context\s*\)\s*\{\s*return\s*Container\([\s\S]*?SizedBox\(height:\s*10\.h\),\s*\],\s*\),\s*\);\s*\}\,\s*\)\s*:\s*null,',
        re.MULTILINE
    )

    # I'll create a new elegant bottom sheet.
    new_block = """onTap:
                                              state.selectedTab != "products" &&
                                                      state.selectedTab != "all_summary"
                                                  ? () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled: true,
                                                        backgroundColor: Colors.transparent,
                                                        builder: (context) {
                                                          return Container(
                                                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 20.h, top: 12.h, left: 24.w, right: 24.w),
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                // Drag Handle
                                                                Center(
                                                                  child: Container(
                                                                    width: 40.w,
                                                                    height: 4.h,
                                                                    decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2.r)),
                                                                  ),
                                                                ),
                                                                SizedBox(height: 24.h),
                                                                // Header
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text("Filter Status", style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: AppFontWeight.bold, color: const Color(0xFF0F172A))),
                                                                    InkWell(
                                                                      onTap: () => context.pop(),
                                                                      borderRadius: BorderRadius.circular(20.r),
                                                                      child: Container(padding: EdgeInsets.all(4.w), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), shape: BoxShape.circle), child: Icon(Icons.close, size: 18.w, color: const Color(0xFF64748B))),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(height: 24.h),
                                                                // Custom Modern Chips
                                                                Wrap(
                                                                  spacing: 12.w,
                                                                  runSpacing: 12.h,
                                                                  children: List.generate(options.length, (index) {
                                                                    bool isSelected = state.tag == index;
                                                                    return GestureDetector(
                                                                      onTap: () {
                                                                        context.read<SummaryBloc>().add(SummaryFilterChanged(index));
                                                                        context.pop();
                                                                      },
                                                                      child: AnimatedContainer(
                                                                        duration: const Duration(milliseconds: 200),
                                                                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                                                                        decoration: BoxDecoration(
                                                                          color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
                                                                          borderRadius: BorderRadius.circular(12.r),
                                                                          border: Border.all(color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0), width: 1.5.w),
                                                                          boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF3B82F6).withValues(alpha: 0.2), blurRadius: 8.r, offset: const Offset(0, 4))] : [],
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [
                                                                            if (isSelected) ...[
                                                                              Icon(Icons.check_circle_rounded, color: Colors.white, size: 16.w),
                                                                              SizedBox(width: 8.w),
                                                                            ],
                                                                            Text(
                                                                              options[index],
                                                                              style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: isSelected ? AppFontWeight.semiBold : AppFontWeight.medium, color: isSelected ? Colors.white : const Color(0xFF64748B)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }),
                                                                ),
                                                                SizedBox(height: 12.h),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  : null,"""

    match = old_block_pattern.search(content)
    if match:
        content = content[:match.start()] + new_block + content[match.end():]
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Updated successfully!")
    else:
        print("Could not find the block to replace!")

rewrite()
