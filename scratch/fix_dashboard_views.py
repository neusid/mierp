import re

# 1. dashboard_warehouse_view.dart
fp = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()

# Fix warehouseVM properties
code = code.replace("warehouseVM.userName.value", "state.userName")
code = code.replace("warehouseVM.totalProducts.value", "state.totalProducts")
code = code.replace("warehouseVM.totalQty.value", "state.totalQty")
code = code.replace("warehouseVM.totalLowStock.value", "state.totalLowStock")
code = code.replace("warehouseVM.totalUpcomingStock.value", "state.totalUpcomingStock")
code = code.replace("warehouseVM.selectedTab.value", "state.selectedTab")
code = code.replace("warehouseVM.listAllSummary", "state.listAllSummary")
code = code.replace("warehouseVM.listProduct", "state.listProduct")
code = code.replace("warehouseVM.listOrder", "state.listOrder")
code = code.replace("warehouseVM.listSalesOrder", "state.listSalesOrder")
code = code.replace("warehouseVM.isLoading.value", "state.isLoading")
code = code.replace("warehouseVM.getFilterData(data['collection']!);", "context.read<DashboardWarehouseBloc>().add(DashboardWarehouseTabChanged(data['collection']!));")

# Fix getx
code = code.replace("getx.Get.toNamed", "getx.Get.toNamed")

# Fix Obx
code = re.sub(r'Obx\(\(\) => (.*?)\),?', r'\1,', code, flags=re.DOTALL)
code = re.sub(r'Obx\(\n\s*\(\) => (.*?)\),?', r'\1,', code, flags=re.DOTALL)
# some Obx are nested, might need multiple passes
for _ in range(3):
    code = re.sub(r'Obx\(\(\) => ([\s\S]*?)\)(,\n|,\s|\n)', r'\1\2', code)

with open(fp, "w", encoding="utf-8") as f: f.write(code)

# 2. dashboard_finance_view.dart
fp = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"
with open(fp, "r", encoding="utf-8") as f: code = f.read()

code = code.replace("financeVM.totalBalance.value", "state.totalBalance")
code = code.replace("financeVM.totalIncome.value", "state.totalIncome")
code = code.replace("financeVM.totalExpense.value", "state.totalExpense")
code = code.replace("financeVM.totalSalesOrder.value", "state.totalSalesOrder")
code = code.replace("financeVM.totalOrder.value", "state.totalOrder")
code = code.replace("financeVM.totalTax.value", "state.totalTax")
code = code.replace("financeVM.totalProfit.value", "state.totalProfit")
code = code.replace("financeVM.totalLoss.value", "state.totalLoss")

code = code.replace("financeVM.selectedTab.value", "state.selectedTab")
code = code.replace("financeVM.listAllSummary", "state.listAllSummary")
code = code.replace("financeVM.listProduct", "state.listProduct")
code = code.replace("financeVM.listOrder", "state.listOrder")
code = code.replace("financeVM.listSalesOrder", "state.listSalesOrder")
code = code.replace("financeVM.isLoading.value", "state.isLoading")
code = code.replace("financeVM.getFilterData(data['collection']!);", "context.read<DashboardFinanceBloc>().add(DashboardFinanceTabChanged(data['collection']!));")
code = code.replace("financeVM.requestPayInvoiceOrderProduct", "context.read<DashboardFinanceBloc>().add(DashboardFinancePayProductRequested")

for _ in range(3):
    code = re.sub(r'Obx\(\s*\(\)\s*=>\s*([\s\S]*?)\)(,\n|,\s|\n)', r'\1\2', code)
    
with open(fp, "w", encoding="utf-8") as f: f.write(code)

print("Done")
