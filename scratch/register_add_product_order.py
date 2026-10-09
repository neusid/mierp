import re

di_path = r"d:\Project\Flutter\mierp\lib\core\di\injection_container.dart"
with open(di_path, 'r', encoding='utf-8') as f:
    di_code = f.read()

import_statement = "import 'package:mierp_apps/features/add/presentation/add_product_order/bloc/add_product_order_bloc.dart';\n"
if "add_product_order_bloc.dart" not in di_code:
    di_code = import_statement + di_code

register_statement = "  sl.registerFactory(() => AddProductOrderBloc());"
if register_statement not in di_code:
    di_code = di_code.replace("  // BLoC", f"  // BLoC\n{register_statement}")

with open(di_path, 'w', encoding='utf-8') as f:
    f.write(di_code)

print("AddProductOrderBloc registered")
