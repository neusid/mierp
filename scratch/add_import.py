import sys

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.read().splitlines()

import_stmt = "import 'package:mierp_apps/core/widgets/dashboard/quick_add_card.dart';"
if import_stmt not in lines:
    for i, line in enumerate(lines):
        if line.startswith('import '):
            lines.insert(i, import_stmt)
            break

with open(file_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))
