import re

def replace_getx(fp):
    with open(fp, "r", encoding="utf-8") as f: code = f.read()
    
    # 1. Replace Get.snackbar("Success", state.successMessage)
    code = code.replace('Get.snackbar("Success", state.successMessage);', 'ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage)));')
    code = code.replace('Get.snackbar("Failed", state.errorMessage);', 'ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));')
    
    # 2. Replace Get.toNamed("/path")
    code = re.sub(r'Get\.toNamed\((.*?)\);', r'Navigator.pushNamed(context, \1);', code)
    
    # 3. Replace Get.back()
    code = code.replace('Get.back()', 'Navigator.pop(context)')
    
    with open(fp, "w", encoding="utf-8") as f: f.write(code)

fp_fin = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"
fp_war = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart"

replace_getx(fp_fin)
replace_getx(fp_war)

print("Done")
