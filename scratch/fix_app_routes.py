import re

file_path = r"d:\Project\Flutter\mierp\lib\core\routing\app_routes.dart"
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

# Remove old binding imports
code = re.sub(r"import 'package:mierp_apps/features/add/presentation/add_unit/add_unit_view_binding\.dart';\n", "", code)
code = re.sub(r"import 'package:mierp_apps/features/detail/presentation/detail_product_order/detail_product_order_binding\.dart';\n", "", code)
code = re.sub(r"import 'package:mierp_apps/features/detail/presentation/detail_sales_order/detail_sales_order_binding\.dart';\n", "", code)
code = re.sub(r"import 'package:mierp_apps/features/notification/presentation/notification_binding\.dart';\n", "", code)
code = re.sub(r"import 'package:mierp_apps/features/summary/presentation/summary_view_model\.dart';\n", "", code)

# Fix bindings blocks
code = re.sub(r"      binding: BindingsBuilder\(\(\) \{\s*Get\.put\(\s*SummaryViewModel\([\s\S]*?\),\s*\);\s*\}\),\n", "", code)
code = re.sub(r"      binding: AddUnitViewBinding\(\),\n", "", code)
code = re.sub(r"      binding: DetailProductOrderBinding\(\),\n", "", code)
code = re.sub(r"      binding: DetailSalesOrderBinding\(\),\n", "", code)
code = re.sub(r"      binding: NotificationBinding\(\),\n", "", code)

# Fix missing `id` parameter
code = code.replace("page: () => DetailProductOrderView(),", "page: () => DetailProductOrderView(id: Get.parameters['id'] ?? ''),")
code = code.replace("page: () => DetailSalesOrderView(),", "page: () => DetailSalesOrderView(id: Get.parameters['id'] ?? ''),")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print("app_routes.dart fixed")
