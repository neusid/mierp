import sys

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.read().splitlines()

# We want to replace everything from line 178 to 212 inclusive.
# Let's dynamically find it to be safe.
start_idx = -1
for i, line in enumerate(lines):
    if "child: Stack(" in line:
        pass
    if "                  ]," in line and "                )," in lines[i+1] and "              )," in lines[i+2]:
        if "                              \"All product types available in inventory\"," in lines[i+3]:
            start_idx = i+3
            break

end_idx = -1
for i in range(start_idx, len(lines)):
    if 'SizedBox(height: 22.h),' in lines[i]:
        if 'QuickAddCard' in '\n'.join(lines[i+1:i+10]) or 'Padding' in '\n'.join(lines[i+1:i+10]):
            end_idx = i - 1
            break

if start_idx != -1 and end_idx != -1:
    content = """              SizedBox(height: 20.h),
              Padding(
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
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  spacing: 16.h,
                  children: [
                    BlanketMattressWidget(
                      title: "Low Stock Products",
                      subtitle: "Needs immediate attention",
                      themeBgColor: const Color(0xFFFFF1F2),
                      headerIcon: Icons.warning_amber_rounded,
                      buttonText: "View All Low Stock ➔",
                      items: (state.listProduct.toList()..sort((a, b) => a.quantity.compareTo(b.quantity)))
                          .take(2)
                          .map((e) => {
                                "title": e.productName,
                                "subtitle": "${e.category} • ${e.productCode}",
                                "badge": "${e.quantity} Left",
                              })
                          .toList(),
                    ),
                    BlanketMattressWidget(
                      title: "Incoming Stock",
                      subtitle: "Expected today",
                      themeBgColor: const Color(0xFFEEF2FF),
                      headerIcon: Icons.local_shipping_outlined,
                      buttonText: "View All Incoming Stock ➔",
                      items: state.listOrder
                          .where((e) => e.financeApproved == true)
                          .take(2)
                          .map((e) => {
                                "title": e.productName,
                                "subtitle": "Order • ${e.productCode}",
                                "badge": "${e.quantity} Units",
                              })
                          .toList(),
                    ),
                  ],
                ),
              ),"""
    lines = lines[:start_idx] + content.splitlines() + lines[end_idx+1:]
    
    # ensure BlanketMattressWidget is imported
    if "import 'package:mierp_apps/core/widgets/dashboard/blanket_mattress_widget.dart';" not in lines:
        lines.insert(5, "import 'package:mierp_apps/core/widgets/dashboard/blanket_mattress_widget.dart';")

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    print(f"Replaced {end_idx - start_idx + 1} lines with TopMetrics and BlanketMattressWidget.")
else:
    print(f"Indices not found: start_idx={start_idx}, end_idx={end_idx}")
