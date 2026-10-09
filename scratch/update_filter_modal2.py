import sys, re

content = open(r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart', 'r', encoding='utf-8').read()

start_idx = content.find('                                      child: InkWell(')
if start_idx != -1:
    idx2 = content.find('                                          child: SvgPicture.asset(', start_idx)
    idx3 = content.find('                                        ),', idx2)
    end_idx = content.find('                                      ),', idx3) + 40
    
    target = content[start_idx:end_idx]
    
    replacement = """                                      child: PopupMenuButton<int>(
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
                                        },
                                        child: Container(
                                          width: 30.03.w,
                                          height: 30.03.h,
                                          padding: EdgeInsets.all(6.w),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.w),
                                          ),
                                          child: SvgPicture.asset(
                                            "assets/icons/filter.svg",
                                            colorFilter: ColorFilter.mode(
                                              state.selectedTab != "products" && state.selectedTab != "all_summary"
                                                  ? AppColors.grayTitle
                                                  : Colors.grey,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),"""
    
    new_content = content.replace(target, replacement)
    open(r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart', 'w', encoding='utf-8').write(new_content)
    print('Replaced successfully')
else:
    print('Indices not found')
