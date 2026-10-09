part of 'inventory_alerts_bloc.dart';

class InventoryAlertsState {
  final bool isLoading;
  final List<Product> lowStockProducts;
  final List<OrderProduct> incomingStockProducts;
  final String? error;

  const InventoryAlertsState({
    this.isLoading = false,
    this.lowStockProducts = const [],
    this.incomingStockProducts = const [],
    this.error,
  });

  InventoryAlertsState copyWith({
    bool? isLoading,
    List<Product>? lowStockProducts,
    List<OrderProduct>? incomingStockProducts,
    String? error,
  }) {
    return InventoryAlertsState(
      isLoading: isLoading ?? this.isLoading,
      lowStockProducts: lowStockProducts ?? this.lowStockProducts,
      incomingStockProducts: incomingStockProducts ?? this.incomingStockProducts,
      error: error ?? this.error,
    );
  }
}
