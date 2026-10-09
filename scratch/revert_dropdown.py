import re

def rewrite():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        code = f.read()

    # The block to replace starts with:
    # Builder(
    #   builder: (context) {
    #     bool isEnabled =
    #         state.selectedTab != "products" &&
    #         state.selectedTab != "all_summary";
    #     return Row(
    # ... down to the matching } ),
    
    # Let's extract everything from line 162 to 273 exactly.
    lines = code.split('\n')
    
    # lines[161] to lines[272] (0-indexed for 162 to 273)
    # But just to be safe with line numbers, let's just use start/end markers.
    
    start_idx = -1
    for i, line in enumerate(lines):
        if "bool isEnabled =" in line and "state.selectedTab !=" in lines[i+1]:
            # This is inside the Builder!
            start_idx = i - 2 # Backtrack to Builder(
            break
            
    if start_idx == -1:
        print("Could not find start!")
        return

    # Find the end of this builder block
    # It ends right before `], )` and `SizedBox(height: 22.71.h),`
    end_idx = -1
    for i in range(start_idx, len(lines)):
        if "SizedBox(height: 22.71.h)," in lines[i]:
            end_idx = i - 2
            break
            
    if end_idx == -1:
        print("Could not find end!")
        return
        
    replacement = """                                Builder(
                                  builder: (context) {
                                    return Material(
                                      animateColor: true,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(5.w),
                                        child: Container(
                                          width: 30.03.w,
                                          height: 30.03.h,
                                          padding: EdgeInsets.all(6.w),
                                          child: SvgPicture.asset(
                                            "assets/icons/filter.svg",
                                            colorFilter: ColorFilter.mode(
                                              state.selectedTab !=
                                                          "products" &&
                                                      state.selectedTab !=
                                                          "all_summary"
                                                  ? AppColors.grayTitle
                                                  : Colors.grey,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                        onTap:
                                            state.selectedTab != "products" &&
                                                state.selectedTab !=
                                                    "all_summary"
                                            ? () => showBarModalBottomSheet(
                                                context: context,
                                                enableDrag: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadiusGeometry.circular(
                                                        10.w,
                                                      ),
                                                ),
                                                builder: (context) {
                                                  return Container(
                                                    width: double.infinity,
                                                    height: 150.h,
                                                    child: Column(
                                                      children: [
                                                        ListTile(
                                                          title: Center(
                                                            child: Text(
                                                              "Filter Card",
                                                              style: GoogleFonts.inter(
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight.normal,
                                                                color:
                                                                    AppColors.grayThin,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Builder(builder: (context) {
                                                          return ChipsChoice<
                                                            int
                                                          >.single(
                                                            value: state.tag,
                                                            choiceCheckmark: true,
                                                            onChanged: (value) =>
                                                                context.read<SummaryBloc>().add(SummaryFilterChanged(value)),
                                                            choiceItems:
                                                                C2Choice.listFrom<
                                                                  int,
                                                                  String
                                                                >(
                                                                  source: options,
                                                                  value:
                                                                      (i, v) => i,
                                                                  label:
                                                                      (i, v) => v,
                                                                ),
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                            : null,
                                      ),
                                    );
                                  }
                                ),"""
                                
    new_lines = lines[:start_idx] + replacement.split('\n') + lines[end_idx+1:]
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(new_lines))

rewrite()
