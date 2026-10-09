import re

app_routes_path = r"d:\Project\Flutter\mierp\lib\core\routing\app_routes.dart"
with open(app_routes_path, 'r', encoding='utf-8') as f:
    routes_code = f.read()

# Remove DetailSalesOrderBinding import
routes_code = re.sub(r"import 'package:mierp_apps/features/detail/presentation/detail_sales_order/detail_sales_order_binding\.dart';\n", "", routes_code)

# Replace the GetPage for detail_sales_order
route_regex = r"GetPage\(\s*name:\s*'/detail_sales_order',\s*page:\s*\(\)\s*=>\s*DetailSalesOrderView\(\),\s*binding:\s*DetailSalesOrderBinding\(\),\s*\)"
new_route = "GetPage(name: '/detail_sales_order/:id', page: () => DetailSalesOrderView(id: getx.Get.parameters['id']!))"
routes_code = re.sub(route_regex, new_route, routes_code)

with open(app_routes_path, 'w', encoding='utf-8') as f:
    f.write(routes_code)

print("Updated app routes")
