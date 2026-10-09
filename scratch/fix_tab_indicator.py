import re

file_path = 'lib/features/summary/presentation/summary_view.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

target = """                          Builder(
                            builder: (context) {
                              return Container(
                                width: 344.w,
                                height: 32.h,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: tabs.map((data) {
                                    return GestureDetector(
                                      onTap: () {
                                        context.read<SummaryBloc>().add(
                                          SummaryTabChanged(data["collection"]!),
                                        );
                                      },
                                      child: Container(
                                        width: 78.w,
                                        height: 30.h,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              data["title"] ?? "",
                                              style: GoogleFonts.manrope(
                                                fontSize: 13.sp,
                                                fontWeight:
                                                    AppFontWeight.medium,
                                                color: Colors.black,
                                              ),
                                            ),
                                            state.selectedTab != data["collection"]
                                                ? SizedBox()
                                                : Column(
                                                    children: [
                                                      SizedBox(height: 7.h),
                                                      Container(
                                                        height: 3.h,
                                                        color: AppColors
                                                            .electricBlue,
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),"""

replacement = """                          Builder(
                            builder: (context) {
                              int selectedIndex = tabs.indexWhere((t) => t["collection"] == state.selectedTab);
                              if (selectedIndex == -1) selectedIndex = 0;
                              
                              double alignmentX = -1.0;
                              if (selectedIndex == 1) alignmentX = -0.333;
                              if (selectedIndex == 2) alignmentX = 0.333;
                              if (selectedIndex == 3) alignmentX = 1.0;

                              return Container(
                                width: 344.w,
                                height: 32.h,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    AnimatedAlign(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeOutQuart,
                                      alignment: Alignment(alignmentX, 1.0),
                                      child: Container(
                                        width: 78.w,
                                        height: 3.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.electricBlue,
                                          borderRadius: BorderRadius.circular(1.5.h),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: tabs.map((data) {
                                        bool isSelected = state.selectedTab == data["collection"];
                                        return GestureDetector(
                                          onTap: () {
                                            context.read<SummaryBloc>().add(
                                              SummaryTabChanged(data["collection"]!),
                                            );
                                          },
                                          child: Container(
                                            width: 78.w,
                                            height: 30.h,
                                            color: Colors.transparent,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                AnimatedDefaultTextStyle(
                                                  duration: const Duration(milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 13.sp,
                                                    fontWeight: isSelected ? AppFontWeight.bold : AppFontWeight.medium,
                                                    color: isSelected ? AppColors.electricBlue : Colors.black,
                                                  ),
                                                  child: Text(data["title"] ?? ""),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),"""

if target in code:
    code = code.replace(target, replacement)
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(code)
    print("Success")
else:
    print("Target not found!")
