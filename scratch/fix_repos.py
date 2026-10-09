import re

def fix_file(path):
    with open(path, 'r') as f:
        content = f.read()

    # Import foundation for debugPrint if not there
    if 'import \'package:flutter/foundation.dart\';' not in content:
        content = "import 'package:flutter/foundation.dart';\n" + content

    # Replace print with debugPrint
    content = content.replace('print(', 'debugPrint(')
    
    # Fix collection parameters
    content = re.sub(r'\(collection\)', '(String collection)', content)
    content = re.sub(r'\(collection,(\s*)searchKey\)', r'(String collection,\1String searchKey)', content)

    # Fix parseDate(value)
    content = re.sub(r'parseDate\(value\)', 'parseDate(dynamic value)', content)

    # Fix unused variable in streamTotalProducts
    content = re.sub(r'for\s*\(\s*var\s+data\s+in\s+event\.docs\s*\)\s*\{\s*total\s*\+=\s*1;\s*\}', 'total = event.docs.length;', content)
    
    # Fix event.docs -> total
    if 'int total = 0;\n        total = event.docs.length;' in content:
        content = content.replace('int total = 0;\n        total = event.docs.length;', 'int total = event.docs.length;')
    
    with open(path, 'w') as f:
        f.write(content)

fix_file('d:/Project/Flutter/mierp/lib/data/warehouse/warehouse_repository.dart')
fix_file('d:/Project/Flutter/mierp/lib/data/finance/dashboard_finance_repository.dart')
