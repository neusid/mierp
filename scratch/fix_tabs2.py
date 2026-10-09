import re

file_path = 'lib/features/summary/presentation/summary_view.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

tabs_array = '''  final tabs = [
      {"title": "All Summary", "collection": "all_summary"},
      {"title": "Product", "collection": "products"},
      {"title": "Order", "collection": "orders"},
      {"title": "Sales Order", "collection": "sales_orders"},
    ];'''

code = re.sub(r'final tabs = \[[^\]]*\];', tabs_array, code, flags=re.DOTALL)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)
