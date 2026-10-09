import os

bloc_dir = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_sales_order\bloc"
os.makedirs(bloc_dir, exist_ok=True)

# 1. State
state_code = """import 'package:equatable/equatable.dart';
import 'package:mierp_apps/core/models/product.dart';

enum AddSalesOrderStatus { initial, loading, success, failure }

class AddSalesOrderState extends Equatable {
  final AddSalesOrderStatus status;
  final String errorMessage;
  final String successMessage;
  final List<Product?> listProduct;

  const AddSalesOrderState({
    this.status = AddSalesOrderStatus.initial,
    this.errorMessage = '',
    this.successMessage = '',
    this.listProduct = const [],
  });

  AddSalesOrderState copyWith({
    AddSalesOrderStatus? status,
    String? errorMessage,
    String? successMessage,
    List<Product?>? listProduct,
  }) {
    return AddSalesOrderState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      listProduct: listProduct ?? this.listProduct,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage, listProduct];
}
"""
with open(os.path.join(bloc_dir, "add_sales_order_state.dart"), 'w') as f:
    f.write(state_code)

# 2. Event
event_code = """import 'package:equatable/equatable.dart';
import 'package:mierp_apps/core/models/order.dart';

abstract class AddSalesOrderEvent extends Equatable {
  const AddSalesOrderEvent();

  @override
  List<Object> get props => [];
}

class AddSalesOrderLoadProducts extends AddSalesOrderEvent {}

class AddSalesOrderSubmitted extends AddSalesOrderEvent {
  final OrderSales salesOrder;

  const AddSalesOrderSubmitted({required this.salesOrder});

  @override
  List<Object> get props => [salesOrder];
}
"""
with open(os.path.join(bloc_dir, "add_sales_order_event.dart"), 'w') as f:
    f.write(event_code)

# 3. Bloc
bloc_code = """import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/add/presentation/add_sales_order/bloc/add_sales_order_event.dart';
import 'package:mierp_apps/features/add/presentation/add_sales_order/bloc/add_sales_order_state.dart';
import 'package:mierp_apps/data/warehouse/add/add_sales_order_repository.dart';
import 'package:mierp_apps/data/warehouse/warehouse_repository.dart';

class AddSalesOrderBloc extends Bloc<AddSalesOrderEvent, AddSalesOrderState> {
  final AddSalesOrderRepository addSalesOrderR = AddSalesOrderRepository();
  final WarehouseRepository warehouseR = WarehouseRepository();

  AddSalesOrderBloc() : super(const AddSalesOrderState()) {
    on<AddSalesOrderLoadProducts>(_onLoadProducts);
    on<AddSalesOrderSubmitted>(_onSubmitted);
  }

  Future<void> _onLoadProducts(AddSalesOrderLoadProducts event, Emitter<AddSalesOrderState> emit) async {
    try {
      final products = await warehouseR.getBulkDataStock("products");
      emit(state.copyWith(listProduct: products));
    } catch (e) {
      emit(state.copyWith(
        status: AddSalesOrderStatus.failure,
        errorMessage: 'Failed to load products: $e',
      ));
    }
  }

  Future<void> _onSubmitted(AddSalesOrderSubmitted event, Emitter<AddSalesOrderState> emit) async {
    emit(state.copyWith(status: AddSalesOrderStatus.loading));
    try {
      await addSalesOrderR.addSalesOrderToFireStore(event.salesOrder);
      emit(state.copyWith(
        status: AddSalesOrderStatus.success,
        successMessage: 'Sales Order created successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AddSalesOrderStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
"""
with open(os.path.join(bloc_dir, "add_sales_order_bloc.dart"), 'w') as f:
    f.write(bloc_code)

# Register in injection_container.dart
di_path = r"d:\Project\Flutter\mierp\lib\core\di\injection_container.dart"
with open(di_path, 'r', encoding='utf-8') as f:
    di_code = f.read()

import_statement = "import 'package:mierp_apps/features/add/presentation/add_sales_order/bloc/add_sales_order_bloc.dart';\n"
if "add_sales_order_bloc.dart" not in di_code:
    di_code = import_statement + di_code

register_statement = "  sl.registerFactory(() => AddSalesOrderBloc());"
if register_statement not in di_code:
    di_code = di_code.replace("  // BLoC", f"  // BLoC\n{register_statement}")

with open(di_path, 'w', encoding='utf-8') as f:
    f.write(di_code)

print("AddSalesOrderBloc created and registered")
