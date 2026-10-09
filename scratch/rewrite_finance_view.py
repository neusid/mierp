import re

file_path = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

# Remove GetX controller setup
code = re.sub(r'final financeVM = Get\.find<DashboardFinanceViewModel>\(\);\s*ever\(financeVM\.success,[\s\S]*?financeVM\.errorMessage\.value = "";\s*}\);', '', code)

# Wrap Scaffold body with BlocProvider and BlocConsumer
code = code.replace(
    'return Stack(',
    'return BlocProvider(\n      create: (context) => sl<DashboardFinanceBloc>()..add(DashboardFinanceLoadData()),\n      child: BlocConsumer<DashboardFinanceBloc, DashboardFinanceState>(\n        listener: (context, state) {\n          if (state.status == DashboardFinanceStatus.success) {\n            getx.Get.snackbar("Success", "Success pay invoice");\n          } else if (state.status == DashboardFinanceStatus.failure) {\n            getx.Get.snackbar("Failed", state.errorMessage);\n          }\n        },\n        builder: (context, state) {\n          return Stack('
)

# Close BlocProvider and BlocConsumer at the very end
code = code.replace(
    '    );\n  }\n}\n',
    '    );\n        },\n      ),\n    );\n  }\n}\n'
)

# Replace all `financeVM.totalRevenue.value` with `state.totalRevenue`
code = re.sub(r'financeVM\.totalRevenue\.value', 'state.totalRevenue', code)
code = re.sub(r'financeVM\.totalExpense\.value', 'state.totalExpense', code)
code = re.sub(r'financeVM\.listInvoice\.value', 'state.listInvoice', code)
code = re.sub(r'financeVM\.totalAmount\.value', 'state.totalAmount', code)
code = re.sub(r'financeVM\.totalAmountProduct\.value', 'state.totalAmountProduct', code)
code = re.sub(r'financeVM\.firstName\.value', 'state.firstName', code)
code = re.sub(r'financeVM\.role\.value', 'state.role', code)
code = re.sub(r'financeVM\.listFinanceDashboard\.value', 'state.listFinanceDashboard', code)
code = re.sub(r'financeVM\.payInvoice\((.*?)\)', r'context.read<DashboardFinanceBloc>().add(DashboardFinancePayInvoice(\1))', code)
code = re.sub(r'financeVM\.listInvoice\.length', 'state.listInvoice.length', code)
code = re.sub(r'financeVM\.listFinanceDashboard\.length', 'state.listFinanceDashboard.length', code)
code = re.sub(r'financeVM\.listInvoice\[(.*?)\]', r'state.listInvoice[\1]', code)
code = re.sub(r'financeVM\.listFinanceDashboard\[(.*?)\]', r'state.listFinanceDashboard[\1]', code)


# Remove Obx(...)
def remove_obx(text):
    # Find `Obx(() { return ...; })` or `Obx(() => ...)`
    # This is tricky with regex, so I will do string replacements for common patterns.
    # Often it's `Obx(() {\n return ...;\n})`
    pass

# Better to manually replace exact strings or use regex properly.
# Actually, I can just replace `Obx(() { return ` with `` and `});` with `` at the end, but it's nested.
code = re.sub(r'Obx\(\s*\(\)\s*\{', '', code)
code = re.sub(r'return (Column|Container|ListView|Text|Row|SliverToBoxAdapter|Padding)\(', r'\1(', code)

# Let me use a script that just removes Obx from the widget tree by parsing.
# Or simpler:
code = code.replace("body: Obx(() {", "body: Builder(builder: (context) {")
code = code.replace("child: Obx(() {", "child: Builder(builder: (context) {")
code = code.replace("slivers: [\n                Obx(() {", "slivers: [\n                Builder(builder: (context) {")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print("DashboardFinanceView rewritten")
