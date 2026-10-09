import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/models/all_summary.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/data/warehouse/warehouse_repository.dart';

// --- EVENTS ---
abstract class DashboardWarehouseEvent extends Equatable {
  const DashboardWarehouseEvent();
  @override
  List<Object> get props => [];
}

class DashboardWarehouseStarted extends DashboardWarehouseEvent {}

class DashboardWarehouseTabChanged extends DashboardWarehouseEvent {
  final String tab;
  const DashboardWarehouseTabChanged(this.tab);
  @override
  List<Object> get props => [tab];
}

class DashboardWarehouseStatsUpdated extends DashboardWarehouseEvent {
  final int? totalProducts;
  final int? totalQty;
  final int? totalLowStock;
  final int? totalUpcomingStock;
  
  const DashboardWarehouseStatsUpdated({
    this.totalProducts,
    this.totalQty,
    this.totalLowStock,
    this.totalUpcomingStock,
  });

  @override
  List<Object> get props => [totalProducts ?? 0, totalQty ?? 0, totalLowStock ?? 0, totalUpcomingStock ?? 0];
}

// --- STATE ---
class DashboardWarehouseState extends Equatable {
  final String userName;
  final int totalProducts;
  final int totalQty;
  final int totalLowStock;
  final int totalUpcomingStock;
  final bool isLoading;
  final String selectedTab;
  final List<Product> listProduct;
  final List<OrderProduct> listOrder;
  final List<SalesOrder> listSalesOrder;
  final List<AllSummary> listAllSummary;

  const DashboardWarehouseState({
    this.userName = "",
    this.totalProducts = 0,
    this.totalQty = 0,
    this.totalLowStock = 0,
    this.totalUpcomingStock = 0,
    this.isLoading = false,
    this.selectedTab = "all_summary",
    this.listProduct = const [],
    this.listOrder = const [],
    this.listSalesOrder = const [],
    this.listAllSummary = const [],
  });

  DashboardWarehouseState copyWith({
    String? userName,
    int? totalProducts,
    int? totalQty,
    int? totalLowStock,
    int? totalUpcomingStock,
    bool? isLoading,
    String? selectedTab,
    List<Product>? listProduct,
    List<OrderProduct>? listOrder,
    List<SalesOrder>? listSalesOrder,
    List<AllSummary>? listAllSummary,
  }) {
    return DashboardWarehouseState(
      userName: userName ?? this.userName,
      totalProducts: totalProducts ?? this.totalProducts,
      totalQty: totalQty ?? this.totalQty,
      totalLowStock: totalLowStock ?? this.totalLowStock,
      totalUpcomingStock: totalUpcomingStock ?? this.totalUpcomingStock,
      isLoading: isLoading ?? this.isLoading,
      selectedTab: selectedTab ?? this.selectedTab,
      listProduct: listProduct ?? this.listProduct,
      listOrder: listOrder ?? this.listOrder,
      listSalesOrder: listSalesOrder ?? this.listSalesOrder,
      listAllSummary: listAllSummary ?? this.listAllSummary,
    );
  }

  @override
  List<Object> get props => [
        userName,
        totalProducts,
        totalQty,
        totalLowStock,
        totalUpcomingStock,
        isLoading,
        selectedTab,
        listProduct,
        listOrder,
        listSalesOrder,
        listAllSummary,
      ];
}

// --- BLOC ---
class DashboardWarehouseBloc extends Bloc<DashboardWarehouseEvent, DashboardWarehouseState> {
  final WarehouseRepository warehouseRepository;
  final UserDataController userDataController; // temporary for backward compat user data fetching
  
  StreamSubscription? _totalProductsSub;
  StreamSubscription? _totalQtySub;
  StreamSubscription? _lowStockSub;
  StreamSubscription? _upcomingStockSub;

  DashboardWarehouseBloc({
    required this.warehouseRepository,
    required this.userDataController,
  }) : super(const DashboardWarehouseState()) {
    on<DashboardWarehouseStarted>(_onStarted);
    on<DashboardWarehouseStatsUpdated>(_onStatsUpdated);
    on<DashboardWarehouseTabChanged>(_onTabChanged);
  }

  Future<void> _onStarted(DashboardWarehouseStarted event, Emitter<DashboardWarehouseState> emit) async {
    emit(state.copyWith(isLoading: true));
    
    // Fetch User
    String name = "";
    try {
      final userModel = await userDataController.getDataUser();
      if (userModel != null) {
        name = "${userModel.firstName} ${userModel.lastName}";
      }
    } catch (_) {}

    // Fetch Bulk Data
    final products = (await warehouseRepository.getBulkDataStock("products")).whereType<Product>().toList();
    final orders = await warehouseRepository.getBulkDataOrder("warehouse_orders");
    final salesOrders = await warehouseRepository.getBulkDataSalesOrder("sales_orders");

    // Combine for All Summary
    final combined = <AllSummary>[];
    combined.addAll(products.map((e) => AllSummary(summaryType: SummaryType.product, data: e, createdOn: e.createdOn)));
    combined.addAll(orders.map((e) => AllSummary(summaryType: SummaryType.order, data: e, createdOn: e.orderDate!)));
    combined.addAll(salesOrders.map((e) => AllSummary(summaryType: SummaryType.salesOrder, data: e, createdOn: e.purchasedDate)));
    combined.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    
    emit(state.copyWith(
      userName: name,
      listProduct: products..sort((a, b) => b.createdOn.compareTo(a.createdOn)),
      listOrder: orders..sort((a, b) => b.orderDate!.compareTo(a.orderDate!)),
      listSalesOrder: salesOrders..sort((a, b) => b.purchasedDate.compareTo(a.purchasedDate)),
      listAllSummary: combined,
      isLoading: false,
    ));

    // Listen to Streams
    _totalProductsSub?.cancel();
    _totalProductsSub = warehouseRepository.streamTotalProducts().listen((total) {
      add(DashboardWarehouseStatsUpdated(totalProducts: total));
    });

    _totalQtySub?.cancel();
    _totalQtySub = warehouseRepository.streamGetQtyProduct().listen((total) {
      add(DashboardWarehouseStatsUpdated(totalQty: total));
    });

    _lowStockSub?.cancel();
    _lowStockSub = warehouseRepository.streamGetLowStock().listen((total) {
      add(DashboardWarehouseStatsUpdated(totalLowStock: total));
    });

    _upcomingStockSub?.cancel();
    _upcomingStockSub = warehouseRepository.streamGetUpcomingStock().listen((total) {
      add(DashboardWarehouseStatsUpdated(totalUpcomingStock: total));
    });
  }

  void _onStatsUpdated(DashboardWarehouseStatsUpdated event, Emitter<DashboardWarehouseState> emit) {
    emit(state.copyWith(
      totalProducts: event.totalProducts,
      totalQty: event.totalQty,
      totalLowStock: event.totalLowStock,
      totalUpcomingStock: event.totalUpcomingStock,
    ));
  }

  void _onTabChanged(DashboardWarehouseTabChanged event, Emitter<DashboardWarehouseState> emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  @override
  Future<void> close() {
    _totalProductsSub?.cancel();
    _totalQtySub?.cancel();
    _lowStockSub?.cancel();
    _upcomingStockSub?.cancel();
    return super.close();
  }
}
