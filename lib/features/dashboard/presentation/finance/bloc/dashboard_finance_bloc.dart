import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/models/all_summary.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/data/finance/dashboard_finance_repository.dart';
import 'package:mierp_apps/data/transaction/services/transaction_services.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/utils/order_sort_utils.dart';

// --- EVENTS ---
abstract class DashboardFinanceEvent extends Equatable {
  const DashboardFinanceEvent();
  @override
  List<Object?> get props => [];
}

class DashboardFinanceStarted extends DashboardFinanceEvent {}

class DashboardFinanceTabChanged extends DashboardFinanceEvent {
  final String tab;
  const DashboardFinanceTabChanged(this.tab);
  @override
  List<Object?> get props => [tab];
}

class DashboardFinanceMessageCleared extends DashboardFinanceEvent {}

class DashboardFinanceStatsUpdated extends DashboardFinanceEvent {
  final int? productsItem;
  final int? settled;
  final int? accountPayables;
  final int? accountReceivables;
  final int? productTotal;
  final int? totalQty;
  final int? lowStock;
  final int? upComingStock;
  
  const DashboardFinanceStatsUpdated({
    this.productsItem,
    this.settled,
    this.accountPayables,
    this.accountReceivables,
    this.productTotal,
    this.totalQty,
    this.lowStock,
    this.upComingStock,
  });

  @override
  List<Object?> get props => [
    productsItem, settled, accountPayables, accountReceivables,
    productTotal, totalQty, lowStock, upComingStock
  ];
}

class DashboardFinancePayProductRequested extends DashboardFinanceEvent {
  final String docId;
  final String prodId;
  final int totalQty;
  const DashboardFinancePayProductRequested(this.docId, this.prodId, this.totalQty);
  @override
  List<Object?> get props => [docId, prodId, totalQty];
}

class DashboardFinancePaySalesRequested extends DashboardFinanceEvent {
  final String docId;
  final String prodId;
  final int totalQty;
  const DashboardFinancePaySalesRequested(this.docId, this.prodId, this.totalQty);
  @override
  List<Object?> get props => [docId, prodId, totalQty];
}

// --- STATE ---
class DashboardFinanceState extends Equatable {
  final String userName;
  final int productsItem;
  final int settled;
  final int accountPayables;
  final int accountReceivables;
  final int productTotal;
  final int totalQty;
  final int lowStock;
  final int upComingStock;
  
  final bool isLoading;
  final String successMessage;
  final String errorMessage;
  final String selectedTab;
  
  final List<Product> listProduct;
  final List<OrderProduct> listOrder;
  final List<SalesOrder> listSalesOrder;
  final List<AllSummary> listAllSummary;

  const DashboardFinanceState({
    this.userName = "",
    this.productsItem = 0,
    this.settled = 0,
    this.accountPayables = 0,
    this.accountReceivables = 0,
    this.productTotal = 0,
    this.totalQty = 0,
    this.lowStock = 0,
    this.upComingStock = 0,
    this.isLoading = false,
    this.successMessage = "",
    this.errorMessage = "",
    this.selectedTab = "all_summary",
    this.listProduct = const [],
    this.listOrder = const [],
    this.listSalesOrder = const [],
    this.listAllSummary = const [],
  });

  DashboardFinanceState copyWith({
    String? userName,
    int? productsItem,
    int? settled,
    int? accountPayables,
    int? accountReceivables,
    int? productTotal,
    int? totalQty,
    int? lowStock,
    int? upComingStock,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
    String? selectedTab,
    List<Product>? listProduct,
    List<OrderProduct>? listOrder,
    List<SalesOrder>? listSalesOrder,
    List<AllSummary>? listAllSummary,
  }) {
    return DashboardFinanceState(
      userName: userName ?? this.userName,
      productsItem: productsItem ?? this.productsItem,
      settled: settled ?? this.settled,
      accountPayables: accountPayables ?? this.accountPayables,
      accountReceivables: accountReceivables ?? this.accountReceivables,
      productTotal: productTotal ?? this.productTotal,
      totalQty: totalQty ?? this.totalQty,
      lowStock: lowStock ?? this.lowStock,
      upComingStock: upComingStock ?? this.upComingStock,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedTab: selectedTab ?? this.selectedTab,
      listProduct: listProduct ?? this.listProduct,
      listOrder: listOrder ?? this.listOrder,
      listSalesOrder: listSalesOrder ?? this.listSalesOrder,
      listAllSummary: listAllSummary ?? this.listAllSummary,
    );
  }

  @override
  List<Object?> get props => [
        userName, productsItem, settled, accountPayables, accountReceivables,
        productTotal, totalQty, lowStock, upComingStock, isLoading,
        successMessage, errorMessage, selectedTab, listProduct, listOrder,
        listSalesOrder, listAllSummary,
      ];
}

// --- BLOC ---
class DashboardFinanceBloc extends Bloc<DashboardFinanceEvent, DashboardFinanceState> {
  final DashboardFinanceRepository financeRepository;
  final UserDataController userDataController; 
  final TransactionServices transactionServices;
  
  StreamSubscription? _productsItemSub;
  StreamSubscription? _settledSub;
  StreamSubscription? _accountPayablesSub;
  StreamSubscription? _accountReceivablesSub;
  StreamSubscription? _productTotalSub;
  StreamSubscription? _totalQtySub;
  StreamSubscription? _lowStockSub;
  StreamSubscription? _upcomingStockSub;

  DashboardFinanceBloc({
    DashboardFinanceRepository? financeRepository,
    UserDataController? userDataController,
    TransactionServices? transactionServices,
  })  : financeRepository = financeRepository ?? sl<DashboardFinanceRepository>(),
        userDataController = userDataController ?? sl<UserDataController>(),
        transactionServices = transactionServices ?? sl<TransactionServices>(),
        super(const DashboardFinanceState()) {
    on<DashboardFinanceStarted>(_onStarted);
    on<DashboardFinanceStatsUpdated>(_onStatsUpdated);
    on<DashboardFinanceTabChanged>(_onTabChanged);
    on<DashboardFinancePayProductRequested>(_onPayRequested);
    on<DashboardFinancePaySalesRequested>(_onPaySalesRequested);
    on<DashboardFinanceMessageCleared>((event, emit) => emit(state.copyWith(successMessage: "", errorMessage: "")));
  }

  Future<void> _onStarted(DashboardFinanceStarted event, Emitter<DashboardFinanceState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: "", successMessage: ""));
    
    // Fetch User
    String name = "";
    try {
      final userModel = await userDataController.getDataUser();
      name = "${userModel.firstName} ${userModel.lastName}";
    } catch (_) {}

    // Fetch Bulk Data
    final products = (await financeRepository.getAllDataStock()).whereType<Product>().toList();
    final orders = await financeRepository.getAllDataOrder();
    final salesOrders = await financeRepository.getAllDataSalesOrder();

    // Sort: Pay Now priority
    orders.sort(OrderSortUtils.compareOrders);
    salesOrders.sort(OrderSortUtils.compareSalesOrders);
    products.sort((a, b) => OrderSortUtils.compareDatesDesc(a.createdOn, b.createdOn));

    // Combine for All Summary (Finance orders only)
    final combined = <AllSummary>[];
    combined.addAll(orders.map((e) => AllSummary(summaryType: SummaryType.order, data: e, createdOn: e.orderDate ?? '')));
    combined.addAll(salesOrders.map((e) => AllSummary(summaryType: SummaryType.salesOrder, data: e, createdOn: e.purchasedDate)));
    combined.sort(OrderSortUtils.compareSummaries);
    
    emit(state.copyWith(
      userName: name,
      listProduct: products,
      listOrder: orders,
      listSalesOrder: salesOrders,
      listAllSummary: combined,
      isLoading: false,
    ));

    // Backfill ledger mutations
    try {
      await financeRepository.syncAndBackfillExistingSettledOrders();
    } catch (_) {}

    // Listen to Streams
    _productsItemSub?.cancel();
    _productsItemSub = financeRepository.getNetCashBalanceStream().listen((val) {
      if (val != 0) {
        add(DashboardFinanceStatsUpdated(productsItem: val));
      } else {
        financeRepository.getProductItems().first.then((pVal) {
          add(DashboardFinanceStatsUpdated(productsItem: val != 0 ? val : pVal));
        });
      }
    });

    _settledSub?.cancel();
    _settledSub = financeRepository.getSettledItems().listen((val) => add(DashboardFinanceStatsUpdated(settled: val)));

    _accountPayablesSub?.cancel();
    _accountPayablesSub = financeRepository.getAccountPayables().listen((val) => add(DashboardFinanceStatsUpdated(accountPayables: val)));

    _accountReceivablesSub?.cancel();
    _accountReceivablesSub = financeRepository.getAccountReceivables().listen((val) => add(DashboardFinanceStatsUpdated(accountReceivables: val)));

    _productTotalSub?.cancel();
    _productTotalSub = financeRepository.getTotalProducts().listen((val) => add(DashboardFinanceStatsUpdated(productTotal: val)));

    _totalQtySub?.cancel();
    _totalQtySub = financeRepository.getTotalQty().listen((val) => add(DashboardFinanceStatsUpdated(totalQty: val)));

    _lowStockSub?.cancel();
    _lowStockSub = financeRepository.getLowStock().listen((val) => add(DashboardFinanceStatsUpdated(lowStock: val)));

    _upcomingStockSub?.cancel();
    _upcomingStockSub = financeRepository.getUpcomingStock().listen((val) => add(DashboardFinanceStatsUpdated(upComingStock: val)));
  }

  void _onStatsUpdated(DashboardFinanceStatsUpdated event, Emitter<DashboardFinanceState> emit) {
    emit(state.copyWith(
      productsItem: event.productsItem,
      settled: event.settled,
      accountPayables: event.accountPayables,
      accountReceivables: event.accountReceivables,
      productTotal: event.productTotal,
      totalQty: event.totalQty,
      lowStock: event.lowStock,
      upComingStock: event.upComingStock,
    ));
  }

  void _onTabChanged(DashboardFinanceTabChanged event, Emitter<DashboardFinanceState> emit) {
    emit(state.copyWith(selectedTab: event.tab, successMessage: "", errorMessage: ""));
  }

  Future<void> _onPayRequested(DashboardFinancePayProductRequested event, Emitter<DashboardFinanceState> emit) async {
    emit(state.copyWith(isLoading: true, successMessage: "", errorMessage: ""));
    try {
      await transactionServices.payProductOrderServices(event.docId, event.prodId, event.totalQty);
      emit(state.copyWith(isLoading: false, successMessage: "Invoice berhasil dilunasi!"));
      add(DashboardFinanceStarted());
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: "Gagal memproses pembayaran: ${e.toString()}"));
    }
  }

  Future<void> _onPaySalesRequested(DashboardFinancePaySalesRequested event, Emitter<DashboardFinanceState> emit) async {
    emit(state.copyWith(isLoading: true, successMessage: "", errorMessage: ""));
    try {
      await transactionServices.paySalesOrderServices(event.docId, event.prodId, event.totalQty);
      emit(state.copyWith(isLoading: false, successMessage: "Invoice penjualan berhasil dilunasi!"));
      add(DashboardFinanceStarted());
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: "Gagal memproses pembayaran: ${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    _productsItemSub?.cancel();
    _settledSub?.cancel();
    _accountPayablesSub?.cancel();
    _accountReceivablesSub?.cancel();
    _productTotalSub?.cancel();
    _totalQtySub?.cancel();
    _lowStockSub?.cancel();
    _upcomingStockSub?.cancel();
    return super.close();
  }
}
