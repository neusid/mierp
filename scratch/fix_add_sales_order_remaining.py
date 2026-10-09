import re

# 1. Fix add_sales_order_view.dart
view_path = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_sales_order\add_sales_order_view.dart"
with open(view_path, 'r', encoding='utf-8') as f:
    view_code = f.read()

view_code = view_code.replace("import 'package:mierp_apps/core/models/sales.dart';", "import 'package:mierp_apps/core/models/sales_order.dart';")
with open(view_path, 'w', encoding='utf-8') as f:
    f.write(view_code)

# 2. Fix add_sales_order_event.dart
event_path = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_sales_order\bloc\add_sales_order_event.dart"
with open(event_path, 'r', encoding='utf-8') as f:
    event_code = f.read()

event_code = event_code.replace("import 'package:mierp_apps/core/models/sales.dart';", "import 'package:mierp_apps/core/models/sales_order.dart';")
with open(event_path, 'w', encoding='utf-8') as f:
    f.write(event_code)

# 3. Fix input_select_sales_order_widget.dart
widget_path = r"d:\Project\Flutter\mierp\lib\core\widgets\add\add_sales_order\input_select_sales_order_widget.dart"
with open(widget_path, 'r', encoding='utf-8') as f:
    widget_code = f.read()

# I missed replacing `addSalesOrderVM.selectedProduct.value = value!;` which might have a print statement.
old_onchanged = """                  onChanged: (value) {
                    addSalesOrderVM.selectedProduct.value = value!;
                    print(value.id);
                  },"""
if old_onchanged in widget_code:
    widget_code = widget_code.replace(old_onchanged, "                  onChanged: onChanged,")
else:
    # Just remove any remaining `addSalesOrderVM`
    widget_code = re.sub(r"addSalesOrderVM\.[\s\S]*?;", "", widget_code)
    
with open(widget_path, 'w', encoding='utf-8') as f:
    f.write(widget_code)

print("Fixed remaining AddSalesOrder errors")
