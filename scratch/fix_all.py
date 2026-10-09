import re

def fix_all():
    fp_fin = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"
    fp_war = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart"
    
    with open(fp_fin, "r", encoding="utf-8") as f: code = f.read()
    code = code.replace("import 'package:get/get.dart' as getx;", "import 'package:get/get.dart';\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:mierp_apps/features/dashboard/presentation/finance/bloc/dashboard_finance_bloc.dart';\nimport 'package:mierp_apps/core/di/injection_container.dart';")
    code = code.replace("financeVM.userName.value", "state.userName")
    code = code.replace("financeVM.totalBalance.value", "state.totalBalance")
    code = code.replace("financeVM.listAllSummary", "state.listAllSummary")
    code = code.replace("financeVM.", "state.")
    code = code.replace("state.getFilterData(data['collection']!);", "context.read<DashboardFinanceBloc>().add(DashboardFinanceTabChanged(data['collection']!));")
    
    # Fix the .value errors (since we replaced financeVM with state, now it's state.totalBalance.value which is wrong)
    code = code.replace("state.totalIncome.value", "state.totalIncome")
    code = code.replace("state.totalExpense.value", "state.totalExpense")
    code = code.replace("state.totalSalesOrder.value", "state.totalSalesOrder")
    code = code.replace("state.totalOrder.value", "state.totalOrder")
    code = code.replace("state.totalTax.value", "state.totalTax")
    code = code.replace("state.totalProfit.value", "state.totalProfit")
    code = code.replace("state.totalLoss.value", "state.totalLoss")
    code = code.replace("state.selectedTab.value", "state.selectedTab")
    code = code.replace("state.isLoading.value", "state.isLoading")
    
    # Remove any Obx left
    code = re.sub(r'Obx\(\(\)\s*\{\s*return\s*([\s\S]*?);\s*\}\)', r'\1', code)
    code = re.sub(r'Obx\(\n\s*\(\) =>\s*([\s\S]*?)\)(,\n|,\s|\n)', r'\1\2', code)
    code = re.sub(r'Obx\(\s*\(\) =>\s*([\s\S]*?)\)(,\n|,\s|\n)', r'\1\2', code)
    
    with open(fp_fin, "w", encoding="utf-8") as f: f.write(code)
    
    with open(fp_war, "r", encoding="utf-8") as f: code = f.read()
    code = code.replace("import 'package:get/get.dart' as getx;", "import 'package:get/get.dart';\nimport 'package:flutter_bloc/flutter_bloc.dart';\nimport 'package:mierp_apps/features/dashboard/presentation/warehouse/bloc/dashboard_warehouse_bloc.dart';\nimport 'package:mierp_apps/core/di/injection_container.dart';")
    
    with open(fp_war, "w", encoding="utf-8") as f: f.write(code)

fix_all()
print("Done")
