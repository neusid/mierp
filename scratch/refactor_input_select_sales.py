import re

file_path = r"d:\Project\Flutter\mierp\lib\core\widgets\add\add_sales_order\input_select_sales_order_widget.dart"
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

code = code.replace(
    "class InputSelectSalesOrderWidget extends StatelessWidget {\n  InputSelectSalesOrderWidget({super.key, required this.head, required this.placeholder, required this.necessary, required this.formKey});\n\n  final head, placeholder, necessary, formKey;",
    "class InputSelectSalesOrderWidget extends StatelessWidget {\n  InputSelectSalesOrderWidget({super.key, required this.head, required this.placeholder, required this.necessary, required this.formKey, required this.products, required this.value, required this.onChanged});\n\n  final head, placeholder, necessary, formKey;\n  final List<Product?> products;\n  final Product? value;\n  final Function(Product?) onChanged;"
)

code = code.replace("import 'package:mierp_apps/features/add/presentation/add_sales_order/add_sales_order_view_model.dart';", "")
code = code.replace("  final addSalesOrderVM = Get.put(AddSalesOrderViewModel());", "")

code = code.replace("                  value: addSalesOrderVM.selectedProduct.value,", "                  value: value,")

code = code.replace("""                  onChanged: (value) {
                    addSalesOrderVM.selectedProduct.value = value!;
                  },""", "                  onChanged: onChanged,")

code = code.replace("                  items: addSalesOrderVM.listProduct.value.map<DropdownMenuItem<Product>>(", "                  items: products.map<DropdownMenuItem<Product>>(")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print("Refactored InputSelectSalesOrderWidget")
