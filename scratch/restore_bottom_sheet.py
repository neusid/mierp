import re

def restore_filter():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # The existing block
    target = """                                if (state.selectedTab != "products" && state.selectedTab != "all_summary")
                                  SizedBox(width: 8.w),
                                if (state.selectedTab != "products" && state.selectedTab != "all_summary")
                                  Container(
                                    height: 45.29.h,
                                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3B82F6), // Primary Color
                                      borderRadius: BorderRadius.circular(20.w),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 4.w),
                                          color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                                          blurRadius: 10.w,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        value: state.tag,
                                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
                                        dropdownColor: Colors.white,
                                        borderRadius: BorderRadius.circular(12.r),
                                        items: options.asMap().entries.map((entry) {
                                          return DropdownMenuItem<int>(
                                            value: entry.key,
                                            child: Text(
                                              entry.value,
                                              style: GoogleFonts.inter(
                                                color: state.tag == entry.key ? const Color(0xFF3B82F6) : const Color(0xFF0F172A),
                                                fontWeight: state.tag == entry.key ? AppFontWeight.semiBold : AppFontWeight.medium,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        selectedItemBuilder: (BuildContext context) {
                                          return options.map<Widget>((String item) {
                                            return Center(
                                              child: Text(
                                                item,
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontWeight: AppFontWeight.semiBold,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            );
                                          }).toList();
                                        },
                                        onChanged: (val) {
                                          if (val != null) {
                                            context.read<SummaryBloc>().add(SummaryFilterChanged(val));
                                          }
                                        },
                                      ),
                                    ),
                                  ),"""

    new_block = """                                Builder(
                                  builder: (context) {
                                    return Material(
                                      animateColor: true,
                                      borderRadius: BorderRadius.circular(100.w),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(100.w),
                                        onTap:
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
                                                  : null,
                                        child: state.selectedTab != "products" && state.selectedTab != "all_summary"
                                            ? SvgPicture.asset(
                                                "assets/images/filter.svg",
                                                width: 30.03.w,
                                              )
                                            : SizedBox(),
                                      ),
                                    );
                                  },
                                ),"""

    if target in content:
        content = content.replace(target, new_block)
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Restored bottom sheet successfully!")
    else:
        print("Target not found. Doing regex fallback...")
        # fallback regex in case spacing differs
        # fallback skipped for safety, but we can do it if needed.

restore_filter()
