import re

fp = r"d:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()

# Obx replacements
code = code.replace("Obx(() {", "Builder(builder: (context) {")

# summaryVM replacements
code = code.replace("summaryVM.filterData(val.first);", "context.read<SummaryBloc>().add(SummaryFilterChanged(val.first));")
code = code.replace("summaryVM.tabs", "tabs")
code = code.replace("summaryVM.changeTab(data);", "context.read<SummaryBloc>().add(SummaryTabChanged(data['collection']!));")
code = code.replace("summaryVM.detailProductOrder(e.data!.id);", "getx.Get.toNamed(\"/detail_product_order/${e.data!.id}\");")
code = code.replace("summaryVM.detailProductOrder(data.id);", "getx.Get.toNamed(\"/detail_product_order/${data.id}\");")
code = code.replace("summaryVM.role", "state.role")

# Pay invoice calls
code = code.replace("summaryVM.requestPayInvoiceOrderProduct(\n                                            data.id,\n                                          );", "context.read<SummaryBloc>().add(SummaryPayInvoiceRequested(data.id));")
code = code.replace("summaryVM.requestPayInvoiceSalesOrder(\n                                            data.id,\n                                          );", "context.read<SummaryBloc>().add(SummaryPayInvoiceRequested(data.id));")

code = code.replace("state.keyword = val;", "context.read<SummaryBloc>().add(SummarySearchChanged(val));")

# Obx around Loading at the end
old_loading = """          Obx(
            () => state.isLoading
                ? Container(
                    color: Colors.black26,
                    child: Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: AppColors.softWhite,
                        size: 70.w,
                      ),
                    ),
                  )
                : SizedBox(),
          ),"""
new_loading = """          state.isLoading
                ? Container(
                    color: Colors.black26,
                    child: Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: AppColors.softWhite,
                        size: 70.w,
                      ),
                    ),
                  )
                : SizedBox(),"""
code = code.replace(old_loading, new_loading)

# Clean up bottom braces since earlier analyze showed expected } ; ) errors
# Let's fix the bottom part completely
code = re.sub(r'          state\.isLoading.*?: SizedBox\(\),\n        \],\n      \);\n    \}\)\);\n  \}\n\}', 
              r'          state.isLoading ? Container(color: Colors.black26, child: Center(child: LoadingAnimationWidget.stretchedDots(color: AppColors.softWhite, size: 70.w,))) : SizedBox(),\n        ],\n      );\n    });\n  }\n}', code, flags=re.DOTALL)

with open(fp, "w", encoding="utf-8") as f: f.write(code)

print("Summary fixed!")
