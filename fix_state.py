import re
file_path = 'lib/features/summary/presentation/summary_view.dart'
with open(file_path, 'r', encoding='utf-8') as f: code = f.read()

code = re.sub(r'state\.keyword = (.*?);', r'context.read<SummaryBloc>().add(SummarySearchChanged(\1));', code)
code = re.sub(r'state\.options', 'options', code)
code = re.sub(r'state\.filterData\((.*?)\)', r'context.read<SummaryBloc>().add(SummaryFilterChanged(\1))', code)
code = re.sub(r'state\.tabs', 'tabs', code)
code = re.sub(r'state\.changeTab\((.*?)\)', r'context.read<SummaryBloc>().add(SummaryTabChanged(\1))', code)
code = re.sub(r'state\.detailProductOrder\((.*?)\)', r"Get.toNamed('/detail_product_order/' + str(\1))", code)
code = re.sub(r'state\.detailSalesOrder\((.*?)\)', r"Get.toNamed('/detail_sales_order/' + str(\1))", code)
code = re.sub(r'data!\.id', r"data.id ?? ''", code)

options_str = "final options = ['All', 'Paid', 'Unpaid'];"
tabs_str = """    final tabs = [
      {"name": "All", "value": "all_summary"},
      {"name": "Supply", "value": "products"},
      {"name": "Demand", "value": "orders"},
      {"name": "Income", "value": "sales_orders"},
    ];"""

if 'final options =' in code and 'final tabs =' not in code:
    code = re.sub(r'final options = \[.*?\];', options_str + '\n' + tabs_str, code)

with open(file_path, 'w', encoding='utf-8') as f: f.write(code)
