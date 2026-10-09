import re

file_path = r"d:\Project\Flutter\mierp\lib\core\widgets\date_picker_widget.dart"
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

# Replace the onTap body inside DatePickerWidget
# Find onTap: () { ... }
old_ontap = """                onTap: () {
                  if(isShort){
                    if(feature == "sales_order"){
                      final addSalesOrderVM = Get.find<AddSalesOrderViewModel>();
                      addSalesOrderVM.showDate(context);
                    } else {
                      final addProductOrder = Get.find<AddProductOrderViewModel>();
                      addProductOrder.showDate(context);
                    }
                  } else {
                    final addUnitVM = Get.find<AddUnitViewModel>();
                    addUnitVM.showDate(context);
                  }
                },"""

new_ontap = """                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    final dateFormated = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                    controller.text = dateFormated;
                  }
                },"""

code = code.replace(old_ontap, new_ontap)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print("DatePickerWidget refactored")
