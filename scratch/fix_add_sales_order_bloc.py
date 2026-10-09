import os

event_file = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_sales_order\bloc\add_sales_order_event.dart"
with open(event_file, 'r') as f:
    code = f.read()

code = code.replace("class AddSalesOrderSubmitted extends AddSalesOrderEvent {\n  final OrderSales salesOrder;", "class AddSalesOrderSubmitted extends AddSalesOrderEvent {\n  final SalesOrder salesOrder;")
code = code.replace("import 'package:mierp_apps/core/models/order.dart';", "import 'package:mierp_apps/core/models/sales.dart';")

with open(event_file, 'w') as f:
    f.write(code)

print("Fixed event")
