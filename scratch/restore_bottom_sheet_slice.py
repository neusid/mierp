import os

def slice_and_replace():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    start_index = -1
    end_index = -1
    
    for i, line in enumerate(lines):
        if 'if (state.selectedTab != "products" &&' in line and 'state.selectedTab != "all_summary"' in lines[i+1]:
            if start_index == -1:
                start_index = i
        
        if 'SummaryFilterChanged(val),' in line:
            # The end is a few lines after
            end_index = i + 6
            break
            
    if start_index != -1 and end_index != -1:
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
                                ),\n"""
                                
        new_content = ''.join(lines[:start_index]) + new_block + ''.join(lines[end_index:])
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print("Replaced successfully via exact slicing!")
    else:
        print(f"Could not find indices: start={start_index}, end={end_index}")

slice_and_replace()
