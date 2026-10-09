import sys, re

file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

start_idx = content.find('showBarModalBottomSheet(')
idx2 = content.find('builder: (context) {', start_idx)
idx3 = content.find('SizedBox(height: 10.h),', idx2)
idx4 = content.find('},', idx3) + 2

target = content[idx2:idx4]
replacement = """builder: (context) {
                                                    return Container(
                                                      width: double.infinity,
                                                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            "Filter Data",
                                                            style: GoogleFonts.inter(
                                                              fontSize: 16.sp,
                                                              fontWeight: AppFontWeight.bold,
                                                              color: AppColors.grayTitle,
                                                            ),
                                                          ),
                                                          SizedBox(height: 20.h),
                                                          ...List.generate(options.length, (index) {
                                                            bool isSelected = state.tag == index;
                                                            return GestureDetector(
                                                              onTap: () {
                                                                context.read<SummaryBloc>().add(SummaryFilterChanged(index));
                                                                Navigator.pop(context);
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets.only(bottom: 12.h),
                                                                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
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
                                                                        fontSize: 15.sp,
                                                                        fontWeight: isSelected ? AppFontWeight.bold : AppFontWeight.medium,
                                                                        color: isSelected ? Colors.white : const Color(0xFF6B7280),
                                                                      ),
                                                                    ),
                                                                    if (isSelected)
                                                                      Icon(Icons.check, color: Colors.white, size: 20.w),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                          SizedBox(height: 10.h),
                                                        ],
                                                      ),
                                                    );
                                                  },"""

if start_idx != -1 and idx2 != -1:
    new_content = content.replace(target, replacement)
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print('Replaced successfully')
else:
    print('Indices not found')
