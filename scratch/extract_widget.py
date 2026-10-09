import sys

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.read().splitlines()

# 1. Insert import
import_stmt = "import 'package:mierp_apps/core/widgets/dashboard/quick_add_card.dart';"
if import_stmt not in lines:
    for i, line in enumerate(lines):
        if line.startswith('import '):
            lines.insert(i, import_stmt)
            break

# 2. Find start of first button and end of third button
start_idx = -1
end_idx = -1

for i, line in enumerate(lines):
    if 'buttonText: "View All Incoming Stock ➔",' in line:
        for j in range(i, len(lines)):
            if 'Text("Add New Unit")' in lines[j]:
                # backtrack to Padding
                for k in range(j, i, -1):
                    if 'Padding(' in lines[k] and 'EdgeInsetsGeometry.symmetric(horizontal: 14.h)' in lines[k+1]:
                        start_idx = k
                        break
                break

for i in range(start_idx, len(lines)):
    if 'Text("Add Product Order")' in lines[i]:
        # go forward to the end of this Padding
        # This padding block ends with `),` and is followed by `SizedBox(height: 22.h)` for the tab selector.
        open_brackets = 0
        found_padding = False
        for j in range(start_idx, len(lines)):
            if 'Text("Add Product Order")' in lines[j]:
                # find the padding for this specific one
                # Backtrack to its Padding
                for k in range(j, start_idx, -1):
                    if 'Padding(' in lines[k]:
                        # now parse forward to find its end
                        open_brackets = 0
                        for m in range(k, len(lines)):
                            if 'Padding(' in lines[m]:
                                open_brackets += 1
                            if '(' in lines[m] and 'Padding(' not in lines[m]:
                                open_brackets += lines[m].count('(')
                            if ')' in lines[m]:
                                open_brackets -= lines[m].count(')')
                            if open_brackets == 0:
                                end_idx = m
                                break
                        break
                break
        break

if start_idx != -1 and end_idx != -1:
    new_buttons = """                    QuickAddCard(
                      title: "Add New Unit",
                      onTap: () => context.push("/add_unit"),
                    ),
                    SizedBox(height: 22.h),
                    QuickAddCard(
                      title: "Add Sales Order",
                      onTap: () => context.push("/add_sales_order"),
                    ),
                    SizedBox(height: 22.h),
                    QuickAddCard(
                      title: "Add Product Order",
                      onTap: () => context.push("/add_product_order"),
                    ),"""
    
    # Actually, calculating bracket matching in Python with formatting can be flaky if formatting has multiple parentheses.
    # Let me just use string replacement or find the SizedBox(height: 22.h) right before Tabs
    pass

with open(r'd:\Project\Flutter\mierp\scratch\extract_widget.py', 'w') as f:
    f.write('pass')
