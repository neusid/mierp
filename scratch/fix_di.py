import sys

file_path = r'd:\Project\Flutter\mierp\lib\core\di\injection_container.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.read().splitlines()

# Need to import:
# import 'package:mierp_apps/data/warehouse/services/add_unit_services.dart';
# import 'package:mierp_apps/data/warehouse/add/add_unit_repository.dart';
# AddUnitBloc is already imported on line 38.

import_str = """import 'package:mierp_apps/data/warehouse/services/add_unit_services.dart';
import 'package:mierp_apps/data/warehouse/add/add_unit_repository.dart';"""

# Add imports around line 39
lines.insert(39, import_str)

# Now find where to register the bloc, services, and repository.
# Let's find: sl.registerFactory(() => AddSalesOrderBloc());
# And insert sl.registerFactory(() => AddUnitBloc(addUnitServices: sl()));

for i, line in enumerate(lines):
    if 'sl.registerFactory(() => AddSalesOrderBloc());' in line:
        lines.insert(i, "  sl.registerFactory(() => AddUnitBloc(addUnitServices: sl()));")
        break

for i, line in enumerate(lines):
    if 'sl.registerLazySingleton(() => DetailSalesOrderRepository());' in line:
        lines.insert(i+1, "  sl.registerLazySingleton(() => AddUnitRepository());")
        lines.insert(i+2, "  sl.registerLazySingleton(() => AddUnitServices(addUnitRepository: sl()));")
        break

with open(file_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))

print("Registered AddUnitBloc, Services, and Repository.")
