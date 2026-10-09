import re

def fix_values(fp):
    with open(fp, "r", encoding="utf-8") as f: code = f.read()
    
    code = re.sub(r'(state\.\w+)\.value', r'\1', code)
    
    with open(fp, "w", encoding="utf-8") as f: f.write(code)

fp_fin = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"

fix_values(fp_fin)
print("Done")
