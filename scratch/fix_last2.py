import re

fp = r"d:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()

code = code.replace("getx.Get.toNamed(\"/detail_product_order/${e!.data.id}\");", "getx.Get.toNamed(\"/detail_product_order/${data.id}\");")

# Fix data!.id ?? ""
code = code.replace("context.read<SummaryBloc>().add(SummaryPayRequested(data!.id, data.productId ?? \"\", data.quantity ?? 0)),", "context.read<SummaryBloc>().add(SummaryPayRequested(data!.id ?? \"\", data.productId, data.quantity)),")

with open(fp, "w", encoding="utf-8") as f: f.write(code)

print("Done")
