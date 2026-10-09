import re

file_path = r'd:\Project\Flutter\mierp\lib\features\add\presentation\add_unit\add_unit_view.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Add controllers
content = re.sub(
    r'final unitPriceC = TextEditingController\(\);',
    r'final unitPriceC = TextEditingController();\n  final discountPercentC = TextEditingController();\n  final discountMaxC = TextEditingController();',
    content
)

# 2. Add to _resetForm
content = re.sub(
    r'unitPriceC\.clear\(\);',
    r'unitPriceC.clear();\n    discountPercentC.clear();\n    discountMaxC.clear();',
    content
)

# 3. Add to dispose
content = re.sub(
    r'unitPriceC\.dispose\(\);',
    r'unitPriceC.dispose();\n    discountPercentC.dispose();\n    discountMaxC.dispose();',
    content
)

# 4. Add to _submitData
content = re.sub(
    r'unitPrice: int\.tryParse\(unitPriceC\.text\) \?\? 0,',
    r'unitPrice: int.tryParse(unitPriceC.text) ?? 0,\n        discountPercent: int.tryParse(discountPercentC.text),\n        discountMax: int.tryParse(discountMaxC.text),',
    content
)

# 5. Add to UI
ui_to_add = """                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InputShortWidget(
                                      head: "Discount (%)",
                                      controller: discountPercentC,
                                      placeholder: "40",
                                      necessary: false,
                                      formKey: formKey,
                                    ),
                                    InputShortWidget(
                                      head: "Max Discount",
                                      controller: discountMaxC,
                                      placeholder: "200000",
                                      necessary: false,
                                      formKey: formKey,
                                    ),
                                  ],
                                ),
"""

content = re.sub(
    r'(InputShortWidget\(\s*head: "Unit Price"[^\)]+\),\s*],\s*\),)',
    r'\1\n' + ui_to_add,
    content
)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("add_unit_view.dart updated.")
