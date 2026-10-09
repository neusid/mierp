import re

def restore_dropdown():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find the Builder block that I just inserted
    pattern = re.compile(
        r'Builder\(\s*builder:\s*\(\s*context\s*\)\s*\{[\s\S]*?SvgPicture\.asset\([\s\S]*?width:\s*30\.03\.w,\s*\)[\s\S]*?:\s*SizedBox\(\),\s*\),\s*\);\s*\}\,\s*\),',
        re.MULTILINE
    )

    new_block = """Builder(
                                  builder: (context) {
                                    bool isEnabled = state.selectedTab != "products" && state.selectedTab != "all_summary";
                                    return Row(
                                      children: [
                                        SizedBox(width: 8.w),
                                        Container(
                                          height: 45.29.h,
                                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                                          decoration: BoxDecoration(
                                            color: isEnabled ? const Color(0xFF3B82F6) : Colors.grey.shade400,
                                            borderRadius: BorderRadius.circular(20.w),
                                            boxShadow: isEnabled ? [
                                              BoxShadow(
                                                offset: Offset(0, 4.w),
                                                color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                                                blurRadius: 10.w,
                                                spreadRadius: 0,
                                              ),
                                            ] : [],
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
                                              onChanged: isEnabled ? (val) {
                                                if (val != null) {
                                                  context.read<SummaryBloc>().add(SummaryFilterChanged(val));
                                                }
                                              } : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),"""

    match = pattern.search(content)
    if match:
        content = content[:match.start()] + new_block + content[match.end():]
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Restored dropdown successfully!")
    else:
        print("Regex didn't match. We need to look closer.")

restore_dropdown()
