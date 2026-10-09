import re

file_path = r"d:\Project\Flutter\mierp\lib\core\widgets\add\add_warehouse_order\input_select_product_order_widget.dart"
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

code = code.replace(
    "class InputSelectProductOrderWidget extends StatelessWidget {\n  InputSelectProductOrderWidget({super.key, required this.head, required this.placeholder, required this.necessary, required this.formKey});\n\n  final head, placeholder, necessary, formKey;",
    "class InputSelectProductOrderWidget extends StatelessWidget {\n  InputSelectProductOrderWidget({super.key, required this.head, required this.placeholder, required this.necessary, required this.formKey, required this.products, required this.value, required this.onChanged});\n\n  final head, placeholder, necessary, formKey;\n  final List<Product?> products;\n  final Product? value;\n  final Function(Product?) onChanged;"
)

code = code.replace("import 'package:mierp_apps/features/add/presentation/add_product_order/add_product_order_view_model.dart';", "")
code = code.replace("  final addProductOrderVM = Get.put(AddProductOrderViewModel());", "")

code = code.replace("                  value: addProductOrderVM.selectedProduct.value,", "                  value: value,")

code = code.replace("""                  onChanged: (value) {
                    addProductOrderVM.selectedProduct.value = value!;
                    print(value.id);
                  },""", "                  onChanged: onChanged,")

code = code.replace("                  items: addProductOrderVM.listProduct.value.map<DropdownMenuItem<Product>>(", "                  items: products.map<DropdownMenuItem<Product>>(")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print("Refactored InputSelectProductOrderWidget")
