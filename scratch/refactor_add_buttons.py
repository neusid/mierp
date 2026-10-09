import sys

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.read().splitlines()

# Find the start and end of the three buttons.
# They are located between `BlanketMattressWidget` and the Tabs section.
# Specifically, they start with `Padding(` after `SizedBox(height: 22.h)` at line 390.

start_idx = -1
end_idx = -1

for i, line in enumerate(lines):
    if 'buttonText: "View All Incoming Stock ➔",' in line:
        # Start looking from here
        for j in range(i, len(lines)):
            if 'Text("Add New Unit")' in lines[j]:
                # Found the first card, backtrack to its Padding
                for k in range(j, i, -1):
                    if 'Padding(' in lines[k] and 'padding: EdgeInsetsGeometry.symmetric(' in lines[k+1]:
                        start_idx = k
                        break
                break

for j in range(start_idx, len(lines)):
    if 'Text("Add Product Order")' in lines[j]:
        # Found the last card, find its end
        # The card ends when we hit a `SizedBox(height: 22.h),` followed by `Padding` of the tabs.
        # The tabs have `tabs.map((e) {`
        for k in range(j, len(lines)):
            if 'tabs.map((e) {' in lines[k]:
                # Backtrack to the SizedBox before it
                for m in range(k, j, -1):
                    if 'SizedBox(height: 22.h),' in lines[m]:
                        end_idx = m
                        break
                break
        break

if start_idx == -1 or end_idx == -1:
    print(f"Could not find indices: {start_idx}, {end_idx}")
    sys.exit(1)

new_buttons = """                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/add_unit");
                        },
                        child: Container(
                          width: double.infinity,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(12.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 20.w),
                              SizedBox(width: 8.w),
                              Text(
                                "Add New Unit",
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/add_sales_order");
                              },
                              child: Container(
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.w),
                                  border: Border.all(
                                    color: const Color(0xFF0F172A),
                                    width: 1.5.w,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: const Color(0xFF0F172A), size: 16.w),
                                    SizedBox(width: 6.w),
                                    Text(
                                      "Sales Order",
                                      style: GoogleFonts.inter(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/add_product_order");
                              },
                              child: Container(
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.w),
                                  border: Border.all(
                                    color: const Color(0xFF0F172A),
                                    width: 1.5.w,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: const Color(0xFF0F172A), size: 16.w),
                                    SizedBox(width: 6.w),
                                    Text(
                                      "Product Order",
                                      style: GoogleFonts.inter(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),"""

lines = lines[:start_idx] + new_buttons.splitlines() + lines[end_idx:]

with open(file_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))
