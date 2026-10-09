import re

def fix_file(fp):
    with open(fp, "r", encoding="utf-8") as f: code = f.read()
    
    # Fix getx.getx
    code = code.replace("getx.getx.Get", "getx.Get")
    
    # Fix broken Obx replacement (size: 70.w,\n,)
    code = re.sub(r'size: 70\.w,\n\s*,', r'size: 70.w,\n                    )', code)
    
    # Fix end of file BlocBuilder closing
    code = re.sub(r'\};\n    \}\)\);\n  \}\n\}', r'      );\n    },\n    ),\n    );\n  }\n}', code)
    code = re.sub(r'\};\n    \}\)\)\);\n  \}\n\}', r'      );\n    },\n    ),\n    );\n  }\n}', code)
    code = re.sub(r'\s*\}\)\);\n  \}\n\}', r'\n      );\n    },\n    ),\n    );\n  }\n}', code)
    
    # In dashboard_finance_view, there's a typo in requestPayInvoiceOrderProduct
    code = code.replace("context.read<DashboardFinanceBloc>().add(DashboardFinancePayProductRequested", "context.read<DashboardFinanceBloc>().add(DashboardFinancePayProductRequested(e!.data.id, e!.data.productId ?? \"\", e!.data.quantity ?? 0))")
    
    with open(fp, "w", encoding="utf-8") as f: f.write(code)

fp1 = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart"
fp2 = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"

fix_file(fp1)
fix_file(fp2)

print("Done")
