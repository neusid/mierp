import sys

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.read().splitlines()

# Low Stock Replacement
start_idx_low = -1
end_idx_low = -1

for i, line in enumerate(lines):
    if 'buttonText: "View All Low Stock Items ➔",' in line:
        start_idx_low = i + 1
        for j in range(i+1, len(lines)):
            if '],' in lines[j]:
                end_idx_low = j
                break
        break

if start_idx_low != -1 and end_idx_low != -1:
    new_low = """                            items: (state.listProduct.toList()..sort((a, b) => a.quantity.compareTo(b.quantity)))
                                .take(2)
                                .map((e) => {
                                      "title": e.productName,
                                      "subtitle": "${e.category} • ${e.productCode}",
                                      "badge": "${e.quantity} Left",
                                    })
                                .toList(),"""
    lines = lines[:start_idx_low] + new_low.splitlines() + lines[end_idx_low+1:]

# Incoming Stock Replacement
start_idx_inc = -1
end_idx_inc = -1

for i, line in enumerate(lines):
    if 'buttonText: "View All Incoming Stock ➔",' in line:
        start_idx_inc = i + 1
        for j in range(i+1, len(lines)):
            if '],' in lines[j]:
                end_idx_inc = j
                break
        break

if start_idx_inc != -1 and end_idx_inc != -1:
    new_inc = """                            items: state.listOrder
                                .where((e) => e.financeApproved == true)
                                .take(2)
                                .map((e) => {
                                      "title": e.productName,
                                      "subtitle": "Order • ${e.productCode}",
                                      "badge": "${e.quantity} Units",
                                    })
                                .toList(),"""
    lines = lines[:start_idx_inc] + new_inc.splitlines() + lines[end_idx_inc+1:]

with open(file_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))

print("Replaced items with live data.")
