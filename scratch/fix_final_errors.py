import re

# 1. bottom_navbar_helper.dart
fp = r"d:\Project\Flutter\mierp\lib\core\widgets\bottom_navbar_helper.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = code.replace("movePageC(context);", "// movePageC(context);")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 2. input_select_update_widget.dart
fp = r"d:\Project\Flutter\mierp\lib\core\widgets\detail\input_select_update_widget.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = code.replace("Get.back()", "Navigator.of(context).pop()")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 3. add_product_order_view.dart
fp = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_product_order\add_product_order_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = code.replace("addOrderProductBloc.add(AddProductOrderProductChanged(val.toString()));", "addOrderProductBloc.add(AddProductOrderProductChanged(val?.toString() ?? \"\"));")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 4. add_unit_bloc.dart
fp = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_unit\bloc\add_unit_bloc.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = code.replace("const Product(", "Product(")
code = code.replace("postDataconst", "postData")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 5. dashboard_finance_bloc.dart
fp = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\bloc\dashboard_finance_bloc.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = code.replace("List<Object?> get props => [", "List<Object> get props => [")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 6. dashboard_finance_view.dart
fp = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
if "import 'package:get/get.dart' as getx;" not in code:
    code = code.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:get/get.dart' as getx;")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 7. dashboard_warehouse_bloc.dart
fp = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\bloc\dashboard_warehouse_bloc.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = code.replace("List<Object?> get props => [inStock, lowStock, totalOrder, outOfStock];", "List<Object> get props => [inStock ?? 0, lowStock ?? 0, totalOrder ?? 0, outOfStock ?? 0];")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 8. dashboard_warehouse_view.dart
fp = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
if "import 'package:get/get.dart' as getx;" not in code:
    code = code.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:get/get.dart' as getx;")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 9. detail_product_view.dart
fp = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product\detail_product_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = re.sub(r'          state\.isLoading.*?\},', r'          state.isLoading ? Container(color: Colors.black26, child: Center(child: LoadingAnimationWidget.stretchedDots(color: AppColors.softWhite, size: 70.w))) : SizedBox(),\n        ],\n      );\n    },', code, flags=re.DOTALL)
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 10. summary_view.dart
fp = r"d:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = code.replace("state.keyword = value;", "context.read<SummaryBloc>().add(SummarySearchChanged(value));")
code = code.replace("context.read<SummaryBloc>().add(SummaryFilterChanged(value.first))", "context.read<SummaryBloc>().add(SummaryFilterChanged(value))")
code = code.replace("getx.Get.toNamed(\"/detail_product_order/${data.id}\");", "getx.Get.toNamed(\"/detail_product_order/${e!.data.id}\");")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

print("Errors fixed!")
