import sys

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.splitlines()

# We need to find the end of the header Stack.
# It ends around line 170-200.
# Let's search for "SizedBox(height: 20.h),"
# There's a `SizedBox(height: 20.h),` right before `Container(padding: EdgeInsets.symmetric(horizontal: 24.w), child: Column(spacing: 10.w, children: [BlanketMattressWidget`

insert_idx = -1
for i, line in enumerate(lines):
    if "SizedBox(height: 20.h)," in line and "BlanketMattressWidget" in lines[i+4]:
        insert_idx = i
        break

if insert_idx == -1:
    print("Could not find insertion point!")
    sys.exit(1)

metrics_widget = """              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.w),
                          border: Border.all(
                            color: const Color(0xFFF1F5F9),
                            width: 1.5.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8.w,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3E8FF),
                                    borderRadius: BorderRadius.circular(8.w),
                                    border: Border.all(
                                      color: const Color(0xFFE9D5FF),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.inventory_2_outlined,
                                      color: const Color(0xFF7C3AED),
                                      size: 16.w,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    state.totalProducts.toString(),
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF334155),
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              "Total Products",
                              style: GoogleFonts.inter(
                                color: const Color(0xFF64748B),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.w),
                          border: Border.all(
                            color: const Color(0xFFF1F5F9),
                            width: 1.5.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8.w,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3E8FF),
                                    borderRadius: BorderRadius.circular(8.w),
                                    border: Border.all(
                                      color: const Color(0xFFE9D5FF),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.layers_rounded,
                                      color: const Color(0xFF7C3AED),
                                      size: 16.w,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    state.totalQty.toString(),
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF334155),
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              "Total Quantity",
                              style: GoogleFonts.inter(
                                color: const Color(0xFF64748B),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),"""

lines.insert(insert_idx, metrics_widget)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))
