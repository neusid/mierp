import re

view_path = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product_order\detail_product_order_view.dart"

with open(view_path, 'r', encoding='utf-8') as f:
    view_code = f.read()

view_code = re.sub(
    r"detailProductOrderVM\s*\.orderProducts\s*\.value!\s*\.financeApproved!",
    "state.orderProduct!.financeApproved!",
    view_code
)

view_code = re.sub(
    r"detailProductOrderVM\s*\.orderProducts!\s*\.value!\s*\.financeApproved!",
    "state.orderProduct!.financeApproved!",
    view_code
)

with open(view_path, 'w', encoding='utf-8') as f:
    f.write(view_code)

print("Fixed")
