import sys

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the getx.context.push typo
content = content.replace("getx.context.push", "context.push")
content = content.replace("getx.Get.toNamed", "context.push")

lines = content.splitlines()

# Extract QuickAddCard
start_idx = -1
end_idx = -1

for i, line in enumerate(lines):
    if 'Text("Add New Unit")' in line:
        for j in range(i, -1, -1):
            if 'Padding(' in lines[j] and 'EdgeInsetsGeometry.symmetric(horizontal: 14.h)' in lines[j+1]:
                start_idx = j
                break
        break

for i in range(start_idx, len(lines)):
    if 'Text("Add Product Order")' in lines[i]:
        # find end of padding
        # we can just count braces or just look for the SizedBox before tabs
        for j in range(i, len(lines)):
            if 'SizedBox(height: 22.h),' in lines[j] and 'tabs.map' in '\n'.join(lines[j:j+20]):
                end_idx = j - 1
                break
        break

if start_idx != -1 and end_idx != -1:
    new_buttons = """              QuickAddCard(
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
else:
    print(f"Failed to find buttons: {start_idx}, {end_idx}")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))

print("Applied final clean up.")
