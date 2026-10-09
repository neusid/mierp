import re

file_path = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_product_order\add_product_order_view.dart"
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

import_statement = "import 'package:mierp_apps/core/models/product.dart';\n"
if "import 'package:mierp_apps/core/models/product.dart';" not in code:
    code = code.replace("import 'package:mierp_apps/core/models/order.dart';", "import 'package:mierp_apps/core/models/order.dart';\n" + import_statement)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print("Import added")
