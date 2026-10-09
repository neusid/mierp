import re

def fix_remaining(fp):
    with open(fp, "r", encoding="utf-8") as f: code = f.read()
    
    # 1. getx.getx.Get -> Get
    code = code.replace("getx.getx.Get.toNamed", "Get.toNamed")
    code = code.replace("getx.Get.toNamed", "Get.toNamed")
    code = code.replace("getx.Get.back", "Get.back")
    
    # 2. Obx(() { return ...; }) -> ...
    code = re.sub(r'Obx\(\(\)\s*\{\s*return\s*([\s\S]*?);\s*\}\)', r'\1', code)
    code = re.sub(r'Obx\(\s*\(\)\s*=>\s*([\s\S]*?)\)(,\n|,\s|\n)', r'\1\2', code)
    
    # 3. financeVM things missed
    code = code.replace("financeVM.userName.value", "state.userName")
    
    with open(fp, "w", encoding="utf-8") as f: f.write(code)

fp1 = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart"
fp2 = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"
fp3 = r"d:\Project\Flutter\mierp\lib\core\widgets\detail\input_select_update_widget.dart"

fix_remaining(fp1)
fix_remaining(fp2)

with open(fp3, "r", encoding="utf-8") as f: code = f.read()
code = code.replace("Get.back(", "Navigator.pop(context")
with open(fp3, "w", encoding="utf-8") as f: f.write(code)

print("Done")
