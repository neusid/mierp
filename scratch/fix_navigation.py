import sys
import re

file_path = r'd:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace Navigator.pushNamed(context, ...) with context.push(...)
# It can be single line or multiline.
# Let's use a regex that matches `Navigator.pushNamed(\s*context,\s*([^)]+)\s*)`
pattern = r'Navigator\.pushNamed\(\s*context,\s*([^)]+)\s*\)'
new_content = re.sub(pattern, r'context.push(\1)', content)

# ensure go_router is imported
if 'package:go_router/go_router.dart' not in new_content:
    # insert after the first import
    new_content = new_content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:go_router/go_router.dart';")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(new_content)

print("Replaced instances.")
