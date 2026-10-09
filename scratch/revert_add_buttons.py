import sys

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.read().splitlines()

# Find the start and end of the new Obsidian buttons
start_idx = -1
end_idx = -1

for i, line in enumerate(lines):
    if 'buttonText: "View All Incoming Stock ➔",' in line:
        for j in range(i, len(lines)):
            if 'Text(' in lines[j] and '"Add New Unit"' in lines[j]:
                # Found the new card, backtrack to its Padding
                for k in range(j, i, -1):
                    if 'Padding(' in lines[k] and 'EdgeInsets.symmetric(horizontal: 24.w)' in lines[k+1]:
                        start_idx = k
                        break
                break

for j in range(start_idx, len(lines)):
    if 'Text(' in lines[j] and '"Product Order"' in lines[j]:
        # End of the new cards is after the Row closing and Padding closing
        for k in range(j, len(lines)):
            if 'SizedBox(height: 22.h),' in lines[k]:
                end_idx = k
                break
        break

if start_idx == -1 or end_idx == -1:
    print(f"Could not find indices: {start_idx}, {end_idx}")
    sys.exit(1)

old_buttons = """                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 14.h),
                      child: Container(
                        width: 345.w,
                        height: 49.h,
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 22.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowBox,
                              spreadRadius: -3.w,
                              offset: Offset(0, 4),
                              blurRadius: 21.w,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: Center(
                          child: Container(
                            width: 310.w,
                            height: 33.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Add New Unit"),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/add_unit");
                                  },
                                  child: Container(
                                    width: 36.w,
                                    height: 33.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.w),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF00B2FF),
                                          Color(0xFF7A00E6),
                                        ],
                                        transform: GradientRotation(-0.05.sw),
                                      ),
                                    ),
                                    child: Icon(Icons.add, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 22.h),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 14.h),
                      child: Container(
                        width: 345.w,
                        height: 49.h,
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 22.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowBox,
                              spreadRadius: -3.w,
                              offset: Offset(0, 4),
                              blurRadius: 21.w,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: Center(
                          child: Container(
                            width: 310.w,
                            height: 33.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Add Sales Order"),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/add_sales_order",
                                    );
                                  },
                                  child: Container(
                                    width: 36.w,
                                    height: 33.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.w),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF00B2FF),
                                          Color(0xFF7A00E6),
                                        ],
                                        transform: GradientRotation(-0.05.sw),
                                      ),
                                    ),
                                    child: Icon(Icons.add, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 22.h),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 14.h),
                      child: Container(
                        width: 345.w,
                        height: 49.h,
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 22.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowBox,
                              spreadRadius: -3.w,
                              offset: Offset(0, 4),
                              blurRadius: 21.w,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: Center(
                          child: Container(
                            width: 310.w,
                            height: 33.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Add Product Order"),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/add_product_order",
                                    );
                                  },
                                  child: Container(
                                    width: 36.w,
                                    height: 33.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.w),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF00B2FF),
                                          Color(0xFF7A00E6),
                                        ],
                                        transform: GradientRotation(-0.05.sw),
                                      ),
                                    ),
                                    child: Icon(Icons.add, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),"""

lines = lines[:start_idx] + old_buttons.splitlines() + lines[end_idx:]

with open(file_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))
