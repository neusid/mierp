import os

def remove_obx(code):
    while True:
        start_idx = code.find("Obx(() =>")
        if start_idx == -1:
            start_idx = code.find("Obx(")
            if start_idx != -1:
                # check if it's followed by () =>
                next_part = code[start_idx:start_idx+30]
                if "=>" not in next_part:
                    break
            else:
                break
                
        # Find the start of the body
        body_start = code.find("=>", start_idx) + 2
        while code[body_start].isspace():
            body_start += 1
            
        # Find the matching closing parenthesis for Obx(
        paren_count = 0
        end_idx = -1
        for i in range(start_idx + 3, len(code)):
            if code[i] == '(':
                paren_count += 1
            elif code[i] == ')':
                paren_count -= 1
                if paren_count == 0:
                    end_idx = i
                    break
                    
        if end_idx != -1:
            # Replace the Obx block with its body
            body = code[body_start:end_idx].strip()
            code = code[:start_idx] + body + code[end_idx+1:]
        else:
            break
            
    return code

def migrate_warehouse(fp):
    with open(fp, "r", encoding="utf-8") as f: code = f.read()
    
    if "import 'package:mierp_apps/features/dashboard/presentation/warehouse/bloc/dashboard_warehouse_bloc.dart';" not in code:
        code = code.replace("import 'package:get/get.dart';", "import 'package:get/get.dart';\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:mierp_apps/features/dashboard/presentation/warehouse/bloc/dashboard_warehouse_bloc.dart';\nimport 'package:mierp_apps/core/di/injection_container.dart';")
        
    code = code.replace("final warehouseVM = Get.find<DashboardWarehouseViewModel>();", "")
    
    code = code.replace("class DashboardWarehouseView extends StatelessWidget {\n  const DashboardWarehouseView({super.key});\n\n  @override\n  Widget build(BuildContext context) {", "class DashboardWarehouseView extends StatelessWidget {\n  DashboardWarehouseView({super.key});\n\n  final tabs = [\n    {\"title\": \"All Summary\", \"collection\": \"all_summary\"},\n    {\"title\": \"Order\", \"collection\": \"warehouse_order\"},\n    {\"title\": \"Sales Order\", \"collection\": \"sales_order\"},\n    {\"title\": \"Stock\", \"collection\": \"products\"},\n  ];\n\n  @override\n  Widget build(BuildContext context) {\n    return BlocProvider(\n      create: (context) => sl<DashboardWarehouseBloc>()..add(DashboardWarehouseStarted()),\n      child: BlocBuilder<DashboardWarehouseBloc, DashboardWarehouseState>(\n        builder: (context, state) {")
    
    # Close BlocBuilder
    code = code.replace("    return Stack(", "          return Stack(")
    if "      );\n    },\n    ),\n    );\n  }\n}" not in code:
        code = code.replace("      );\n  }\n}", "      );\n    },\n    ),\n    );\n  }\n}")
    
    code = remove_obx(code)
    
    # Replace variables
    replaces = [
        ("warehouseVM.userName.value", "state.userName"),
        ("warehouseVM.totalProducts.value", "state.totalProducts"),
        ("warehouseVM.totalQty.value", "state.totalQty"),
        ("warehouseVM.totalLowStock.value", "state.totalLowStock"),
        ("warehouseVM.totalUpcomingStock.value", "state.totalUpcomingStock"),
        ("warehouseVM.selectedTab.value", "state.selectedTab"),
        ("warehouseVM.listAllSummary", "state.listAllSummary"),
        ("warehouseVM.listProduct", "state.listProduct"),
        ("warehouseVM.listOrder", "state.listOrder"),
        ("warehouseVM.listSalesOrder", "state.listSalesOrder"),
        ("warehouseVM.isLoading.value", "state.isLoading"),
        ("warehouseVM.getFilterData(data['collection']!);", "context.read<DashboardWarehouseBloc>().add(DashboardWarehouseTabChanged(data['collection']!));")
    ]
    for old, new in replaces:
        code = code.replace(old, new)
        
    with open(fp, "w", encoding="utf-8") as f: f.write(code)

def migrate_finance(fp):
    with open(fp, "r", encoding="utf-8") as f: code = f.read()
    
    if "import 'package:mierp_apps/features/dashboard/presentation/finance/bloc/dashboard_finance_bloc.dart';" not in code:
        code = code.replace("import 'package:get/get.dart';", "import 'package:get/get.dart';\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:mierp_apps/features/dashboard/presentation/finance/bloc/dashboard_finance_bloc.dart';\nimport 'package:mierp_apps/core/di/injection_container.dart';")
        
    code = code.replace("final financeVM = Get.find<DashboardFinanceViewModel>();", "")
    code = code.replace("    ever(financeVM.success, (status) {\n      if (status == true) {\n        Get.snackbar(\"Success\", \"Success pay invoice\");\n        financeVM.success.value = false;\n      }\n    });\n\n    ever(financeVM.errorMessage, (msg) {\n      Get.snackbar(\"Failed\", msg);\n      financeVM.errorMessage.value = \"\";\n    });", "")
    
    code = code.replace("class DashboardFinanceView extends StatelessWidget {\n  const DashboardFinanceView({super.key});\n\n  @override\n  Widget build(BuildContext context) {", "class DashboardFinanceView extends StatelessWidget {\n  DashboardFinanceView({super.key});\n\n  final tabs = [\n    {\"title\": \"All Summary\", \"collection\": \"all_summary\"},\n    {\"title\": \"Order\", \"collection\": \"warehouse_order\"},\n    {\"title\": \"Sales Order\", \"collection\": \"sales_order\"},\n    {\"title\": \"Stock\", \"collection\": \"products\"},\n  ];\n\n  @override\n  Widget build(BuildContext context) {\n    return BlocProvider(\n      create: (context) => sl<DashboardFinanceBloc>()..add(DashboardFinanceStarted()),\n      child: BlocConsumer<DashboardFinanceBloc, DashboardFinanceState>(\n        listener: (context, state) {\n          if (state.successMessage.isNotEmpty) {\n            Get.snackbar(\"Success\", state.successMessage);\n          }\n          if (state.errorMessage.isNotEmpty) {\n            Get.snackbar(\"Failed\", state.errorMessage);\n          }\n        },\n        builder: (context, state) {")
    
    # Close BlocBuilder
    code = code.replace("    return Stack(", "          return Stack(")
    if "      );\n    },\n    ),\n    );\n  }\n}" not in code:
        code = code.replace("      );\n  }\n}", "      );\n    },\n    ),\n    );\n  }\n}")
    
    code = remove_obx(code)
    
    replaces = [
        ("financeVM.totalBalance.value", "state.totalBalance"),
        ("financeVM.totalIncome.value", "state.totalIncome"),
        ("financeVM.totalExpense.value", "state.totalExpense"),
        ("financeVM.totalSalesOrder.value", "state.totalSalesOrder"),
        ("financeVM.totalOrder.value", "state.totalOrder"),
        ("financeVM.totalTax.value", "state.totalTax"),
        ("financeVM.totalProfit.value", "state.totalProfit"),
        ("financeVM.totalLoss.value", "state.totalLoss"),
        ("financeVM.selectedTab.value", "state.selectedTab"),
        ("financeVM.listAllSummary", "state.listAllSummary"),
        ("financeVM.listProduct", "state.listProduct"),
        ("financeVM.listOrder", "state.listOrder"),
        ("financeVM.listSalesOrder", "state.listSalesOrder"),
        ("financeVM.isLoading.value", "state.isLoading"),
        ("financeVM.getFilterData(data['collection']!);", "context.read<DashboardFinanceBloc>().add(DashboardFinanceTabChanged(data['collection']!));"),
        ("financeVM\n                                                  .requestPayInvoiceOrderProduct(\n                                                    e!.data.id,\n                                                    e!.data.productId,\n                                                    e!.data.quantity,\n                                                  )", "context.read<DashboardFinanceBloc>().add(DashboardFinancePayProductRequested(e!.data.id, e!.data.productId ?? \"\", e!.data.quantity ?? 0))"),
        ("financeVM\n                                                  .requestPayInvoiceSalesOrder(\n                                                    e!.data.id,\n                                                  )", "context.read<DashboardFinanceBloc>().add(DashboardFinancePayProductRequested(e!.data.id, \"\", 0))")
    ]
    for old, new in replaces:
        code = code.replace(old, new)
        
    with open(fp, "w", encoding="utf-8") as f: f.write(code)

fp1 = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart"
fp2 = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"

migrate_warehouse(fp1)
migrate_finance(fp2)

print("Done")
