import re

file_path = r"d:\Project\Flutter\mierp\lib\core\widgets\add\add_unit\input_selected_add_unit_widget.dart"

with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

# Make it accept `value` and `onChanged`
code = code.replace(
    "class InputSelectAddUnitWidget extends StatelessWidget {\n  InputSelectAddUnitWidget({super.key, required this.head, required this.placeholder, required this.necessary, required this.formKey});\n\n  final head, placeholder, necessary, formKey;",
    "class InputSelectAddUnitWidget extends StatelessWidget {\n  InputSelectAddUnitWidget({super.key, required this.head, required this.placeholder, required this.necessary, required this.formKey, required this.value, required this.onChanged});\n\n  final head, placeholder, necessary, formKey;\n  final String value;\n  final Function(String?) onChanged;"
)

code = code.replace("import 'package:mierp_apps/features/add/presentation/add_unit/add_unit_view_model.dart';", "")
code = code.replace("  final addUnitVM = Get.find<AddUnitViewModel>();", "")

code = code.replace("                  value: addUnitVM.categoryProductC.value,", "                  value: value,")

code = code.replace("""                  onChanged: (value) {
                    addUnitVM.categoryProductC.value = value!;
                  },""", "                  onChanged: onChanged,")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print("Refactored InputSelectAddUnitWidget")
