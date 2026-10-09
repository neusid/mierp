import re

file_path = 'lib/features/summary/presentation/summary_view.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

target = """                                            Text(
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
                                                  ),"""

replacement = """                                            AnimatedDefaultTextStyle(
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              style: GoogleFonts.manrope(
                                                fontSize: 13.sp,
                                                fontWeight: state.selectedTab == data["collection"] 
                                                    ? AppFontWeight.bold 
                                                    : AppFontWeight.medium,
                                                color: state.selectedTab == data["collection"] 
                                                    ? AppColors.electricBlue 
                                                    : Colors.black,
                                              ),
                                              child: Text(data["title"] ?? ""),
                                            ),
                                            SizedBox(height: 7.h),
                                            AnimatedContainer(
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.easeOutQuart,
                                              height: 3.h,
                                              width: state.selectedTab == data["collection"] ? 78.w : 0,
                                              decoration: BoxDecoration(
                                                color: AppColors.electricBlue,
                                                borderRadius: BorderRadius.circular(1.5.h),
                                              ),
                                            ),"""

new_code = code.replace(target, replacement)

# Now let's animate the builder content
# The Builder wraps the `if (state.selectedTab == ...)`
target_builder = """                    Builder(
                      builder: (context) {
                        if (state.selectedTab == "all_summary") {"""

replacement_builder = """                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeOutQuart,
                      switchOutCurve: Curves.easeInQuart,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.02, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Builder(
                        key: ValueKey<String>(state.selectedTab),
                        builder: (context) {
                          if (state.selectedTab == "all_summary") {"""

new_code = new_code.replace(target_builder, replacement_builder)

# Replace the closing parenthesis for the new AnimatedSwitcher
# The Builder closes before `},` or something, let's just find the closing Builder.
# Actually, the Builder closing is at the very end of the Column
target_builder_close = """                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          );
                        }
                      },
                    ),"""

replacement_builder_close = """                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          );
                        }
                      },
                    ),
                    ),"""

new_code = new_code.replace(target_builder_close, replacement_builder_close)


with open(file_path, 'w', encoding='utf-8') as f:
    f.write(new_code)
