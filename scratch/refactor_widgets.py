import re

# 1. ButtonProfileWidget
file_path = r"d:\Project\Flutter\mierp\lib\core\widgets\button_profile_widget.dart"
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

code = re.sub(r"\s*final movePageC = Get\.find<MovePageController>\(\);\s*", "\n", code)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

# 2. BottomNavbarHelper
file_path2 = r"d:\Project\Flutter\mierp\lib\core\widgets\bottom_navbar_helper.dart"
with open(file_path2, 'r', encoding='utf-8') as f:
    code2 = f.read()

code2 = re.sub(r"\s*final movePageC = Get\.find<MovePageController>\(\);\s*", "\n", code2)
# Check if it was actually used. If it was used for routing, it might break. Let me just remove it and see.

with open(file_path2, 'w', encoding='utf-8') as f:
    f.write(code2)

# 3. DetailProductView
file_path3 = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product\detail_product_view.dart"
with open(file_path3, 'r', encoding='utf-8') as f:
    code3 = f.read()

code3 = re.sub(r"\s*final movePageC = getx\.Get\.find<MovePageController>\(\);\s*", "\n", code3)
code3 = re.sub(r"\s*final loadingC = getx\.Get\.find<LoadingController>\(\);\s*", "\n", code3)
code3 = code3.replace("movePageC.moveToPage(4);", "getx.Get.back();") # typical usage
# Also loadingC might be used. 

with open(file_path3, 'w', encoding='utf-8') as f:
    f.write(code3)

print("Widgets refactored")
