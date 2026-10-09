import re

def fix_view():
    fp_fin = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\finance\dashboard_finance_view.dart"
    
    with open(fp_fin, "r", encoding="utf-8") as f: code = f.read()
    
    # fix the extra `})`
    code = code.replace("                        );\n                      }\n                    }),\n                    SizedBox(height: 4.h),", "                        );\n                      }\n                    \n                    SizedBox(height: 4.h),")
    code = code.replace("                    }),\n                    SizedBox(height: 4.h),", "                    \n                    SizedBox(height: 4.h),")
    
    # fix the Get to Navigator
    code = code.replace('Get.snackbar("Success", state.successMessage);', 'ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage)));')
    code = code.replace('Get.snackbar("Failed", state.errorMessage);', 'ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));')
    code = re.sub(r'Get\.toNamed\((.*?)\);', r'Navigator.pushNamed(context, \1);', code)
    code = code.replace('Get.back()', 'Navigator.pop(context)')
    
    # fix missing identifier
    code = code.replace("                  ],\n                ),\n              ),\n            ),\n          ],\n        ),\n        state.isLoading", "                  ],\n                ),\n              ),\n            ],\n          ),\n        ),\n        state.isLoading")
    
    with open(fp_fin, "w", encoding="utf-8") as f: f.write(code)

    fp_war = r"d:\Project\Flutter\mierp\lib\features\dashboard\presentation\warehouse\dashboard_warehouse_view.dart"
    
    with open(fp_war, "r", encoding="utf-8") as f: code = f.read()
    code = code.replace('Get.snackbar("Success", state.successMessage);', 'ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage)));')
    code = code.replace('Get.snackbar("Failed", state.errorMessage);', 'ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));')
    code = re.sub(r'Get\.toNamed\((.*?)\);', r'Navigator.pushNamed(context, \1);', code)
    code = code.replace('Get.back()', 'Navigator.pop(context)')
    
    with open(fp_war, "w", encoding="utf-8") as f: f.write(code)

fix_view()
print("Done")
