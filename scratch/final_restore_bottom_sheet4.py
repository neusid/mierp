import os

def rewrite():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    start_idx = content.find('Builder(', 9000)
    end_idx = content.find('                                      ],', start_idx) + 120 # Just grab enough to find the end of Builder
    
    # Actually, we can just find 'Builder(' at 9000, and we know it ends at the `],` of the Row, then `);`, `},` `),`.
    # Let's find the closing of Builder:
    # return Row( ... ); }, ),
    # This is too hard with index. Let's just do a manual replacement in Python!
    
    # We will slice out the Builder block using python bracket matching!
    
    start_idx = content.find('                                Builder(', 8000)
    
    # Match the brackets
    stack = []
    end_idx = -1
    for i in range(start_idx, len(content)):
        if content[i] == '(':
            stack.append('(')
        elif content[i] == ')':
            stack.pop()
            if len(stack) == 0:
                end_idx = i + 1
                break
                
    if end_idx != -1:
        # Check if there is a comma after the closing parenthesis
        if content[end_idx] == ',':
            end_idx += 1
            
        print("Found Builder block from", start_idx, "to", end_idx)
        
        new_block = """                                Builder(
                                  builder: (context) {
                                    bool isEnabled = state.selectedTab != "products" && state.selectedTab != "all_summary";
                                    return Material(
                                      animateColor: true,
                                      borderRadius: BorderRadius.circular(100.w),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(100.w),
                                        onTap: isEnabled
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
                                        child: Padding(
                                          padding: EdgeInsets.all(6.w),
                                          child: SvgPicture.asset(
                                            "assets/images/filter.svg",
                                            width: 30.03.w,
                                            height: 30.03.w,
                                            colorFilter: ColorFilter.mode(
                                              isEnabled ? const Color(0xFF0F172A) : Colors.grey,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),"""
        
        content = content[:start_idx] + new_block + content[end_idx:]
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Updated successfully!")

rewrite()
