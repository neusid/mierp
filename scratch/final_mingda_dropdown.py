import re

def rewrite():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # The start of the Builder
    pattern = re.compile(
        r'Obx\(\(\)\s*\{\s*return\s*Material\([\s\S]*?onChanged:[\s\S]*?\}\),\s*\),\s*\),\s*\]\s*\)\s*;\s*\}\)\s*,\s*\}\s*\),\s*\),\s*\),\s*\],\s*\),\s*\),',
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isEnabled
                                            ? const Color(0xFF3B82F6)
                                            : Colors.grey.shade400,
                                        borderRadius: BorderRadius.circular(
                                          20.w,
                                        ),
                                        boxShadow: isEnabled
                                            ? [
                                                BoxShadow(
                                                  offset: Offset(0, 4.w),
                                                  color: const Color(
                                                    0xFF3B82F6,
                                                  ).withValues(alpha: 0.3),
                                                  blurRadius: 10.w,
                                                  spreadRadius: 0,
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<int>(
                                          value: state.tag,
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Colors.white,
                                          ),
                                          dropdownColor: Colors.white,
                                          borderRadius: BorderRadius.circular(12.r),
                                          items: options.asMap().entries.map(
                                            (entry) {
                                              return DropdownMenuItem<int>(
                                                value: entry.key,
                                                child: Text(
                                                  entry.value,
                                                  style: GoogleFonts.inter(
                                                    color:
                                                        state.tag == entry.key
                                                        ? const Color(0xFF3B82F6)
                                                        : const Color(0xFF0F172A),
                                                    fontWeight:
                                                        state.tag == entry.key
                                                        ? AppFontWeight.semiBold
                                                        : AppFontWeight.medium,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              );
                                            },
                                          ).toList(),
                                          selectedItemBuilder: (
                                            BuildContext context,
                                          ) {
                                            return options.map<Widget>((
                                              String item,
                                            ) {
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
                                          onChanged:
                                              isEnabled
                                                  ? (val) {
                                                    if (val != null) {
                                                      context
                                                          .read<SummaryBloc>()
                                                          .add(SummaryFilterChanged(val));
                                                    }
                                                  }
                                                  : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),"""

    match = pattern.search(content)
    if match:
        content = content[:match.start()] + new_block + content[match.end():]
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Updated successfully!")
    else:
        print("Could not find the block to replace!")
        print(content.find('showBarModalBottomSheet'))

rewrite()
