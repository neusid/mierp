import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/data/warehouse/warehouse_repository.dart';

part 'inventory_alerts_event.dart';
part 'inventory_alerts_state.dart';

class InventoryAlertsBloc extends Bloc<InventoryAlertsEvent, InventoryAlertsState> {
  final WarehouseRepository warehouseRepository;

  InventoryAlertsBloc({required this.warehouseRepository}) : super(const InventoryAlertsState()) {
    on<InventoryAlertsFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    InventoryAlertsFetchRequested event,
    Emitter<InventoryAlertsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final lowStock = await warehouseRepository.getLowStockProducts();
      final incomingStock = await warehouseRepository.getIncomingStockProducts();

      emit(state.copyWith(
        isLoading: false,
        lowStockProducts: lowStock,
        incomingStockProducts: incomingStock,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}
