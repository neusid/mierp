import re

def migrate_warehouse(fp):
    with open(fp, "r", encoding="utf-8") as f: code = f.read()
    
    # Imports
    if "import 'package:mierp_apps/features/dashboard/presentation/warehouse/bloc/dashboard_warehouse_bloc.dart';" not in code:
        code = code.replace("import 'package:get/get.dart';", "import 'package:get/get.dart';\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:mierp_apps/features/dashboard/presentation/warehouse/bloc/dashboard_warehouse_bloc.dart';\nimport 'package:mierp_apps/core/di/injection_container.dart';")
        
    code = code.replace("final warehouseVM = Get.find<DashboardWarehouseViewModel>();", "")
    
    code = re.sub(r'class DashboardWarehouseView extends StatelessWidget \{.*?\n  @override\n  Widget build\(BuildContext context\) \{', r'class DashboardWarehouseView extends StatelessWidget {\n  DashboardWarehouseView({super.key});\n\n  final tabs = [\n    {"title": "All Summary", "collection": "all_summary"},\n    {"title": "Order", "collection": "warehouse_order"},\n    {"title": "Sales Order", "collection": "sales_order"},\n    {"title": "Stock", "collection": "products"},\n  ];\n\n  @override\n  Widget build(BuildContext context) {\n    return BlocProvider(\n      create: (context) => sl<DashboardWarehouseBloc>()..add(DashboardWarehouseStarted()),\n      child: BlocBuilder<DashboardWarehouseBloc, DashboardWarehouseState>(\n        builder: (context, state) {', code, flags=re.DOTALL)
    
    # Close BlocBuilder
    code = re.sub(r'\};\n\}\n$', r'      );\n    },\n    ),\n    );\n  }\n}', code)
    
    # Remove Obx
    for _ in range(4):
        code = re.sub(r'Obx\(\s*\(\)\s*=>\s*([\s\S]*?)\)(,\n|,\s|\n)', r'\1\2', code)
    
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
    
    with open(fp, "w", encoding="utf-8") as f: f.write(code)

def migrate_finance(fp):
    with open(fp, "r", encoding="utf-8") as f: code = f.read()
    
    if "import 'package:mierp_apps/features/dashboard/presentation/finance/bloc/dashboard_finance_bloc.dart';" not in code:
        code = code.replace("import 'package:get/get.dart';", "import 'package:get/get.dart';\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:mierp_apps/features/dashboard/presentation/finance/bloc/dashboard_finance_bloc.dart';\nimport 'package:mierp_apps/core/di/injection_container.dart';")
        
    code = re.sub(r'class DashboardFinanceView extends StatelessWidget \{.*?\n  @override\n  Widget build\(BuildContext context\) \{', r'class DashboardFinanceView extends StatelessWidget {\n  DashboardFinanceView({super.key});\n\n  final tabs = [\n    {"title": "All Summary", "collection": "all_summary"},\n    {"title": "Order", "collection": "warehouse_order"},\n    {"title": "Sales Order", "collection": "sales_order"},\n    {"title": "Stock", "collection": "products"},\n  ];\n\n  @override\n  Widget build(BuildContext context) {\n    return BlocProvider(\n      create: (context) => sl<DashboardFinanceBloc>()..add(DashboardFinanceStarted()),\n      child: BlocConsumer<DashboardFinanceBloc, DashboardFinanceState>(\n        listener: (context, state) {\n          if (state.successMessage.isNotEmpty) {\n            Get.snackbar("Success", state.successMessage);\n          }\n          if (state.errorMessage.isNotEmpty) {\n            Get.snackbar("Failed", state.errorMessage);\n          }\n        },\n        builder: (context, state) {', code, flags=re.DOTALL)
    
    code = re.sub(r'\n\s*final financeVM = Get.find<DashboardFinanceViewModel>\(\);.*?\n\s*ever\(.*?\}\);\n\n\s*ever\(.*?\}\);', '', code, flags=re.DOTALL)
    
    # Close BlocBuilder
    code = re.sub(r'\};\n\}\n$', r'      );\n    },\n    ),\n    );\n  }\n}', code)
    
    for _ in range(4):
        code = re.sub(r'Obx\(\s*\(\)\s*=>\s*([\s\S]*?)\)(,\n|,\s|\n)', r'\1\2', code)
    
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
    code = code.replace("financeVM\n                                                  .requestPayInvoiceOrderProduct(\n                                                    e!.data.id,\n                                                    e!.data.productId,\n                                                    e!.data.quantity,\n                                                  )", "context.read<DashboardFinanceBloc>().add(DashboardFinancePayProductRequested(e!.data.id, e!.data.productId ?? \"\", e!.data.quantity ?? 0))")
    
    with open(fp, "w", encoding="utf-8") as f: f.write(code)

fp1 = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart"
fp2 = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"

migrate_warehouse(fp1)
migrate_finance(fp2)

print("Done")
