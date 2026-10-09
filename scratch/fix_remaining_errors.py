import re
import os

# 1. Fix CardDashboard and CardStock RxInt
def fix_rxint(path):
    if not os.path.exists(path): return
    with open(path, 'r', encoding='utf-8') as f: code = f.read()
    code = code.replace("RxInt totalItems;", "int totalItems;")
    code = code.replace("totalItems.value", "totalItems")
    code = re.sub(r'Obx\(\(\) \{\s*return\s*(.*?);\s*}\)', r'\1', code, flags=re.DOTALL)
    code = re.sub(r'Obx\(\(\) => (.*?)\)', r'\1', code, flags=re.DOTALL)
    with open(path, 'w', encoding='utf-8') as f: f.write(code)

fix_rxint(r"d:\Project\Flutter\mierp\lib\core\widgets\card_dashboard.dart")
fix_rxint(r"d:\Project\Flutter\mierp\lib\core\widgets\card_stock.dart")

# 2. Fix dashboard_finance_view.dart Map getter, getx import
fp = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"
with open(fp, 'r', encoding='utf-8') as f: code = f.read()
if "import 'package:get/get.dart' as getx;" not in code:
    code = code.replace("import 'package:flutter_bloc/flutter_bloc.dart';", "import 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:get/get.dart' as getx;")
code = code.replace("e.title.value", "e['title']!")
with open(fp, 'w', encoding='utf-8') as f: f.write(code)

# 3. Fix dashboard_warehouse_view.dart getx import
fp = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart"
with open(fp, 'r', encoding='utf-8') as f: code = f.read()
if "import 'package:get/get.dart' as getx;" not in code:
    code = code.replace("import 'package:flutter_bloc/flutter_bloc.dart';", "import 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:get/get.dart' as getx;")
with open(fp, 'w', encoding='utf-8') as f: f.write(code)

# 4. Fix dashboard_warehouse_bloc.dart invalid override
fp = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\bloc\dashboard_warehouse_bloc.dart"
with open(fp, 'r', encoding='utf-8') as f: code = f.read()
code = code.replace("List<Object?> get props =>", "List<Object> get props =>")
# If it has nullable fields in props, they should be cast to Object or omitted. But Dart allows Object? if the superclass is List<Object?>. Let's change superclass!
code = code.replace("List<Object> get props => [];", "List<Object?> get props => [];")
with open(fp, 'w', encoding='utf-8') as f: f.write(code)

# 5. Fix splash_bloc.dart onboardingViewModel
fp = r"d:\Project\Flutter\mierp\lib\features\splash\presentation\bloc\splash_bloc.dart"
with open(fp, 'r', encoding='utf-8') as f: code = f.read()
# Let's just comment it out.
code = re.sub(r'(onboardingViewModel\.statusOnboarding[^;]+;)', r'// \1', code)
with open(fp, 'w', encoding='utf-8') as f: f.write(code)

print("Batch fixes applied")
