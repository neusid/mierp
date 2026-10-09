import 'package:flutter_bloc/flutter_bloc.dart';
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
