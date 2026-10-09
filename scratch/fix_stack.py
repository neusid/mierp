import sys

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.read().splitlines()

# We know lines 42 and 43 are the rogue Stack
if "Stack(" in lines[41] and "children: [" in lines[42] and "Container(" in lines[43]:
    lines.pop(41)
    lines.pop(41) # because it shifted

with open(file_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))

print("Removed rogue Stack.")
