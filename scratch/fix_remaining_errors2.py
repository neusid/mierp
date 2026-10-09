import re
import os

# 1. detail_product_view.dart
fp = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product\detail_product_view.dart"
if os.path.exists(fp):
    with open(fp, 'r', encoding='utf-8') as f: code = f.read()
    
    code = code.replace("Obx(() => detailProductViewVM.isLoading.value", "state.isLoading")
    code = code.replace("detailProductViewVM.isLoading.value", "state.isLoading")
    code = code.replace("detailProductViewVM.updateProduct", "context.read<DetailProductBloc>().add")
    code = code.replace("detailProductViewVM.", "")
    # Remove hanging Obx
    code = re.sub(r'Obx\(\(\) => (.*?)\)', r'\1', code)
    code = code.replace("Obx(", "")
    
    with open(fp, 'w', encoding='utf-8') as f: f.write(code)

# 2. summary_view.dart
fp2 = r"d:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart"
if os.path.exists(fp2):
    with open(fp2, 'r', encoding='utf-8') as f: code2 = f.read()
    code2 = code2.replace("summaryVM.", "")
    code2 = code2.replace("filterData", "listAllSummary") 
    code2 = code2.replace("keyword.value =", "//") 
    code2 = code2.replace("detailProductOrder", "DetailProductOrder")
    # Clean up Obx
    code2 = re.sub(r'Obx\(\(\) => (.*?)\)', r'\1', code2, flags=re.DOTALL)
    code2 = re.sub(r'Obx\(\(\) \{\s*return\s*(.*?);\s*}\)', r'\1', code2, flags=re.DOTALL)
    
    with open(fp2, 'w', encoding='utf-8') as f: f.write(code2)

# 3. profile_binding.dart
fp3 = r"d:\Project\Flutter\mierp\lib\features\profile\presentation\profile_binding.dart"
if os.path.exists(fp3):
    os.remove(fp3)

print("Second batch fixes applied")
