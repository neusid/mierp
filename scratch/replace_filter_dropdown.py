import re

def rewrite_summary_row():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # The start of the Row
    # We want to replace from:
    # Container(
    #   width: 344.w,
    #   height: 45.29.h,
    #   child: Row(
    # up to the end of the Builder block.

    pattern = re.compile(
        r'Container\(\s*width:\s*344\.w,\s*height:\s*45\.29\.h,\s*child:\s*Row\(\s*mainAxisAlignment:\s*MainAxisAlignment\.spaceBetween,\s*children:\s*\['
        r'\s*Container\(\s*width:\s*303\.47\.w,\s*height:\s*45\.29\.h,[\s\S]*?Builder\(\s*builder:\s*\(\s*context\s*\)\s*\{[\s\S]*?return\s*Material\([\s\S]*?onTap:[\s\S]*?;\s*\}\s*:\s*null,[\s\S]*?\),[\s\S]*?\),[\s\S]*?\}\,\s*\),',
        re.MULTILINE
    )

    new_block = """Container(
                            width: 344.w,
                            height: 45.29.h,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 45.29.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.w),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 4.w),
                                          color: Color(0xFFE8E8E8),
                                          blurRadius: 20.w,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      initialValue: state.keyword,
                                      onChanged: (value) {
                                        context.read<SummaryBloc>().add(
                                          SummarySearchChanged(value),
                                        );
                                      },
                                      textAlignVertical: TextAlignVertical.center,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hint: Text(
                                          "Search anything...",
                                          style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.normal,
                                            color: AppColors.grayThin,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 18.03.w,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          size: 17.47.w,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                if (state.selectedTab != "products" && state.selectedTab != "all_summary") ...[
                                  SizedBox(width: 8.w),
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
                                  ),
                                ],"""

    match = pattern.search(content)
    if match:
        content = content[:match.start()] + new_block + content[match.end():]
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Updated correctly")
    else:
        print("Target not found. Looking closely.")

rewrite_summary_row()
