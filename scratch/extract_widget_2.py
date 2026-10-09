import sys

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.read().splitlines()

# 1. Add Import
import_str = "import 'package:mierp_apps/core/widgets/dashboard/quick_add_card.dart';"
if import_str not in lines:
    for i, line in enumerate(lines):
        if line.startswith("import "):
            lines.insert(i, import_str)
            break

# 2. Re-read lines or just replace the block since line numbers changed by +1
# Find the exact string of the first Padding to start
start_idx = -1
for i, line in enumerate(lines):
    if 'buttonText: "View All Incoming Stock ➔",' in line:
        for j in range(i, len(lines)):
            if 'Text("Add New Unit")' in lines[j]:
                for k in range(j, i, -1):
                    if 'Padding(' in lines[k] and 'symmetric(horizontal: 14.h)' in lines[k+1]:
                        start_idx = k
                        break
                break
        break

end_idx = -1
if start_idx != -1:
    for i in range(start_idx, len(lines)):
        if 'Text("Add Product Order")' in lines[i]:
            # find end of this padding
            for j in range(i, len(lines)):
                if 'SizedBox(height: 22.h),' in lines[j] and 'tabs.map' in '\n'.join(lines[j:j+20]):
                    end_idx = j - 1
                    break
            break

if start_idx != -1 and end_idx != -1:
    new_buttons = """                    QuickAddCard(
                      title: "Add New Unit",
                      onTap: () {
                        context.push("/add_unit");
                      },
                    ),
                    SizedBox(height: 22.h),
                    QuickAddCard(
                      title: "Add Sales Order",
                      onTap: () {
                        context.push("/add_sales_order");
                      },
                    ),
                    SizedBox(height: 22.h),
                    QuickAddCard(
                      title: "Add Product Order",
                      onTap: () {
                        context.push("/add_product_order");
                      },
                    ),"""
    
    lines = lines[:start_idx] + new_buttons.splitlines() + lines[end_idx+1:]

with open(file_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))

print(f"Replaced {end_idx - start_idx + 1} lines with QuickAddCard.")
