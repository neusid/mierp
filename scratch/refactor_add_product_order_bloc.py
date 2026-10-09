import os

bloc_dir = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_product_order\bloc"

# 1. Update State
state_code = """import 'package:equatable/equatable.dart';
import 'package:mierp_apps/core/models/product.dart';

enum AddProductOrderStatus { initial, loading, success, failure }

class AddProductOrderState extends Equatable {
  final AddProductOrderStatus status;
  final String errorMessage;
  final String successMessage;
  final List<Product?> listProduct;

  const AddProductOrderState({
    this.status = AddProductOrderStatus.initial,
    this.errorMessage = '',
    this.successMessage = '',
    this.listProduct = const [],
  });

  AddProductOrderState copyWith({
    AddProductOrderStatus? status,
    String? errorMessage,
    String? successMessage,
    List<Product?>? listProduct,
  }) {
    return AddProductOrderState(
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
with open(os.path.join(bloc_dir, "add_product_order_state.dart"), 'w') as f:
    f.write(state_code)

# 2. Update Event
event_code = """import 'package:equatable/equatable.dart';
import 'package:mierp_apps/core/models/order.dart';

abstract class AddProductOrderEvent extends Equatable {
  const AddProductOrderEvent();

  @override
  List<Object> get props => [];
}

class AddProductOrderLoadProducts extends AddProductOrderEvent {}

class AddProductOrderSubmitted extends AddProductOrderEvent {
  final OrderProduct productOrder;

  const AddProductOrderSubmitted({required this.productOrder});

  @override
  List<Object> get props => [productOrder];
}
"""
with open(os.path.join(bloc_dir, "add_product_order_event.dart"), 'w') as f:
    f.write(event_code)

# 3. Update Bloc
bloc_code = """import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/add/presentation/add_product_order/bloc/add_product_order_event.dart';
import 'package:mierp_apps/features/add/presentation/add_product_order/bloc/add_product_order_state.dart';
import 'package:mierp_apps/data/warehouse/add/add_product_order_repository.dart';
import 'package:mierp_apps/data/warehouse/warehouse_repository.dart';

class AddProductOrderBloc extends Bloc<AddProductOrderEvent, AddProductOrderState> {
  final AddProductOrderRepository addProductOrderR = AddProductOrderRepository();
  final WarehouseRepository warehouseR = WarehouseRepository();

  AddProductOrderBloc() : super(const AddProductOrderState()) {
    on<AddProductOrderLoadProducts>(_onLoadProducts);
    on<AddProductOrderSubmitted>(_onSubmitted);
  }

  Future<void> _onLoadProducts(AddProductOrderLoadProducts event, Emitter<AddProductOrderState> emit) async {
    try {
      final products = await warehouseR.getBulkDataStock("products");
      emit(state.copyWith(listProduct: products));
    } catch (e) {
      emit(state.copyWith(
        status: AddProductOrderStatus.failure,
        errorMessage: 'Failed to load products: $e',
      ));
    }
  }

  Future<void> _onSubmitted(AddProductOrderSubmitted event, Emitter<AddProductOrderState> emit) async {
    emit(state.copyWith(status: AddProductOrderStatus.loading));
    try {
      await addProductOrderR.addProductOrderToFireStore(event.productOrder);
      emit(state.copyWith(
        status: AddProductOrderStatus.success,
        successMessage: 'Product Order created successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AddProductOrderStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
"""
with open(os.path.join(bloc_dir, "add_product_order_bloc.dart"), 'w') as f:
    f.write(bloc_code)

print("AddProductOrderBloc refactored to fetch list of products")
