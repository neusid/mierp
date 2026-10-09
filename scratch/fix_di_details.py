import re

file_path = r"d:\Project\Flutter\mierp\lib\core\di\injection_container.dart"
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

# Add imports
code = code.replace(
    "import 'package:mierp_apps/features/detail/presentation/detail_product/bloc/detail_product_bloc.dart';",
    "import 'package:mierp_apps/features/detail/presentation/detail_product/bloc/detail_product_bloc.dart';\nimport 'package:mierp_apps/features/detail/presentation/detail_sales_order/bloc/detail_sales_order_bloc.dart';\nimport 'package:mierp_apps/data/warehouse/detail/detail_sales_order_repository.dart';"
)

# Add sl.registerFactory for DetailSalesOrderBloc
code = code.replace(
    "  sl.registerFactory(() => DetailProductBloc(itemRepository: sl(), detailProductServices: sl()));",
    "  sl.registerFactory(() => DetailProductBloc(itemRepository: sl(), detailProductServices: sl()));\n  sl.registerFactory(() => DetailSalesOrderBloc(itemRepository: sl(), itemStore: sl(), transactionServices: sl(), detailSalesOrderRepository: sl(), userDataController: sl()));"
)

# Add sl.registerLazySingleton for DetailSalesOrderRepository
code = code.replace(
    "  sl.registerLazySingleton(() => DetailProductOrderRepository());",
    "  sl.registerLazySingleton(() => DetailProductOrderRepository());\n  sl.registerLazySingleton(() => DetailSalesOrderRepository());"
)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print("DI updated")
