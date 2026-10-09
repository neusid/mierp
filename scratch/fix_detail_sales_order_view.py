import re

view_path = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_sales_order\detail_sales_order_view.dart"
with open(view_path, 'r', encoding='utf-8') as f:
    view_code = f.read()

# Replace all remaining `detailSalesOrderVM` occurrences
# 1. detailSalesOrderVM.salesOrder!.value!.financeApproved! or similar
view_code = re.sub(r"detailSalesOrderVM[\s\n]*\.salesOrder![\s\n]*\.value!", "state.salesOrder!", view_code)
view_code = re.sub(r"detailSalesOrderVM[\s\n]*\.salesOrder[\s\n]*\.value!", "state.salesOrder!", view_code)
view_code = re.sub(r"detailSalesOrderVM[\s\n]*\.salesOrder[\s\n]*\.value", "state.salesOrder", view_code)

# 2. Obx at the end
# The bottom part:
#           Obx(() {
#             return state.status == DetailSalesOrderStatus.loading
#                 ? Container(...)
#                 : SizedBox();
#           }),
# We just need to replace Obx with nothing, but wait! It was using detailSalesOrderVM.isLoading.value
# In my previous script, I might have replaced `detailSalesOrderVM.isLoading.value` but left `Obx(() { return ... })`.
# Let's see what is near line 728.
# Actually, I'll just use string replacement if `Obx(() {` is near the end.
# I'll just remove the whole bottom `state.status == ...` part and replace it properly.

# To be safe, I'll just replace Obx(() {
#   return state.status == DetailSalesOrderStatus.loading == true ? ...
# Or I can just write a regex.

# Let's fix line 728 Obx. Since I don't know the exact syntax around it, I'll replace `Obx(() {` that is followed by `state.status == DetailSalesOrderStatus.loading` with just the inner content.
obx_regex = r"Obx\(\(\)\s*\{\s*(return\s*)?(state\.status\s*==\s*DetailSalesOrderStatus\.loading[^\}]*?)\s*\}\s*\),?"
view_code = re.sub(obx_regex, r"\2", view_code)

# Fix equality_cannot_be_equality_operand `state.status == DetailSalesOrderStatus.loading == true`
view_code = view_code.replace("state.status == DetailSalesOrderStatus.loading == true", "state.status == DetailSalesOrderStatus.loading")
view_code = view_code.replace("state.status == DetailSalesOrderStatus.loading == true", "state.status == DetailSalesOrderStatus.loading")
view_code = view_code.replace("= state.status == DetailSalesOrderStatus.loading", "== DetailSalesOrderStatus.loading")

# If there's any remaining `detailSalesOrderVM`
view_code = re.sub(r"detailSalesOrderVM[\s\S]*?\.financeApproved!", "state.salesOrder!.financeApproved!", view_code)


with open(view_path, 'w', encoding='utf-8') as f:
    f.write(view_code)

print("Fixed detail sales order view")
