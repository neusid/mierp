import 'package:flutter_bloc/flutter_bloc.dart';
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
