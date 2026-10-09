import re

def fix_view():
    fp_fin = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"
    
    with open(fp_fin, "r", encoding="utf-8") as f: code = f.read()
    
    code = code.replace("                  ],\n                ),\n              ),\n            ],\n          ),\n        ),\n        state.isLoading", "                  ],\n                ),\n              ),\n            ),\n          ],\n        ),\n        state.isLoading")
    
    with open(fp_fin, "w", encoding="utf-8") as f: f.write(code)

fix_view()
print("Done")
