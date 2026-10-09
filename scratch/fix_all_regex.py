import re

# 1. SummaryView
fp = r"d:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = re.sub(r'state\.keyword\s*=\s*val;', 'context.read<SummaryBloc>().add(SummarySearchChanged(val));', code)
code = re.sub(r'summaryVM\.filterData\([^)]+\);', 'context.read<SummaryBloc>().add(SummaryFilterChanged(val.first));', code)
code = re.sub(r'summaryVM\.listProduct', 'state.filteredProducts', code)
code = re.sub(r'summaryVM\.listOrder', 'state.filteredOrders', code)
code = re.sub(r'summaryVM\.listSalesOrder', 'state.filteredSalesOrders', code)
code = re.sub(r'summaryVM\.listAllSummary', 'state.filteredSummaries', code)
code = re.sub(r'summaryVM\.detailSalesOrder\([^)]+\);', 'getx.Get.toNamed("/detail_sales_order/${data.id}");', code)
code = re.sub(r'summaryVM\.detailProductOrder\([^)]+\);', 'getx.Get.toNamed("/detail_product_order/${data.id}");', code)
code = re.sub(r"context\.read<SummaryBloc>\(\)\.add\(SummaryPayRequested\(data!\.id, data\.productId \?\? \"\", data\.quantity \?\? 0\)\),", 'context.read<SummaryBloc>().add(SummaryPayRequested(data!.id, data.productId ?? "", data.quantity ?? 0)),', code)
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 2. DetailProductView (fix brackets)
fp = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_product\detail_product_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = re.sub(r'          state\.isLoading \? Container.*?SizedBox\(\),\n        \],\n      \),\n      \);\n    \},\n    \),\n    \);\n  \}\n\}', 
              '          state.isLoading ? Container(color: Colors.black26, child: Center(child: LoadingAnimationWidget.stretchedDots(color: AppColors.softWhite, size: 70.w))) : SizedBox(),\n        ],\n      );\n    });\n  }\n}', code, flags=re.DOTALL)
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 3. AddUnitBloc
fp = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_unit\bloc\add_unit_bloc.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = re.sub(r'Product\(', 'const Product(', code)
with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 4. SplashBloc
fp = r"d:\Project\Flutter\mierp\lib\features\splash\presentation\bloc\splash_bloc.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()
code = re.sub(r'onboardingViewModel.*?;', 'true;', code)
with open(fp, "w", encoding="utf-8") as f: f.write(code)

print("Applied regex fixes!")
