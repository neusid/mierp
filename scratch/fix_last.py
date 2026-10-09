import re

fp = r"d:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()

# Fix options
code = code.replace("source: summaryVM\n                                                              .options\n                                                              .value,", "source: options,")
# Fix filterData
code = code.replace("summaryVM.filterData(\n                                                          value,\n                                                        )", "context.read<SummaryBloc>().add(SummaryFilterChanged(value.first))")
# Fix data!.title
code = code.replace("data!.title,", "data['title']!,")
code = code.replace("!data.isActive.value", "state.selectedTab != data['collection']")
# Fix e.data
code = code.replace("getx.Get.toNamed(\"/detail_product_order/${data.id}\");", "getx.Get.toNamed(\"/detail_product_order/${e!.data.id}\");")
# Fix onPayPressed
code = code.replace("summaryVM\n                                              .requestPayInvoiceOrderProduct(\n                                                e!.data.id,\n                                                e!.data.productId,\n                                                e!.data.quantity,\n                                              )", "context.read<SummaryBloc>().add(SummaryPayRequested(e!.data.id, e!.data.productId ?? \"\", e!.data.quantity ?? 0))")
code = code.replace("summaryVM\n                                                  .requestPayInvoiceSalesOrder(\n                                                    e!.data.id,\n                                                  )", "context.read<SummaryBloc>().add(SummaryPayRequested(e!.data.id, \"\", 0))")

with open(fp, "w", encoding="utf-8") as f: f.write(code)

print("Done")
