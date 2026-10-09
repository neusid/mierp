import re

# 1. dashboard_finance_bloc.dart
fp = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\bloc\dashboard_finance_bloc.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = re.sub(r'List<Object.*?> get props => \[.*?\n.*?\n.*?\n.*?\n.*?\n.*?\];', 
              'List<Object> get props => [totalBalance ?? 0, totalIncome ?? 0, totalExpense ?? 0, totalSalesOrder ?? 0, totalOrder ?? 0, totalTax ?? 0, totalProfit ?? 0, totalLoss ?? 0];', code, flags=re.DOTALL)
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 2. dashboard_warehouse_bloc.dart
fp = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\bloc\dashboard_warehouse_bloc.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = re.sub(r'List<Object.*?> get props => \[.*?\n.*?\];', 
              'List<Object> get props => [inStock ?? 0, lowStock ?? 0, totalOrder ?? 0, outOfStock ?? 0];', code, flags=re.DOTALL)
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 3. detail_product_view.dart (Just append properly)
fp = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product\detail_product_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = re.sub(r'          state\.isLoading.*', r'          state.isLoading ? Container(color: Colors.black26, child: Center(child: LoadingAnimationWidget.stretchedDots(color: AppColors.softWhite, size: 70.w))) : SizedBox(),\n        ],\n      );\n    });\n  }\n}', code, flags=re.DOTALL)
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 4. summary_view.dart (e!.data.id -> data.id)
fp = r"d:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = code.replace("getx.Get.toNamed(\"/detail_product_order/${e!.data.id}\");", "getx.Get.toNamed(\"/detail_product_order/${data.id}\");")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 5. dashboard_finance_view.dart and warehouse (getx)
fp = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = code.replace("import 'package:get/get.dart' as getx;", "import 'package:get/get.dart';")
code = code.replace("getx.Get.toNamed", "Get.toNamed")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

fp = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = code.replace("import 'package:get/get.dart' as getx;", "import 'package:get/get.dart';")
code = code.replace("getx.Get.toNamed", "Get.toNamed")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 6. input_select_update_widget.dart
fp = r"d:\Project\Flutter\mierp\lib\core\widgets\detail\input_select_update_widget.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = code.replace("Get.back()", "Navigator.of(context).pop()")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 7. add_unit_bloc.dart
fp = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_unit\bloc\add_unit_bloc.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = code.replace("Product(", "const Product(")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 8. bottom_navbar_helper.dart
fp = r"d:\Project\Flutter\mierp\lib\core\widgets\bottom_navbar_helper.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
if "movePageC(" in code and "// movePageC" not in code:
    code = code.replace("movePageC(", "// movePageC(")
with open(fp, "w", encoding="utf-8") as f: f.write(code)

print("Done")
