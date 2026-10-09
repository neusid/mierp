import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/models/all_summary.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/models/summary_type.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/data/finance/dashboard_finance_repository.dart';

// --- EVENTS ---
abstract class SummaryEvent extends Equatable {
  const SummaryEvent();
  @override
  List<Object> get props => [];
}

class SummaryStarted extends SummaryEvent {}

class SummaryTabChanged extends SummaryEvent {
  final String tab;
  const SummaryTabChanged(this.tab);
  @override
  List<Object> get props => [tab];
}

class SummarySearchChanged extends SummaryEvent {
  final String keyword;
  const SummarySearchChanged(this.keyword);
  @override
  List<Object> get props => [keyword];
}

class SummaryFilterChanged extends SummaryEvent {
  final int tag;
  const SummaryFilterChanged(this.tag);
  @override
  List<Object> get props => [tag];
}

class SummaryPayRequested extends SummaryEvent {
  final String docId;
  final String prodId;
  final int totalQty;
  const SummaryPayRequested(this.docId, this.prodId, this.totalQty);
  @override
  List<Object> get props => [docId, prodId, totalQty];
}

// --- STATE ---
class SummaryState extends Equatable {
  final String role;
  final String keyword;
  final int tag; // 0 = All, 1 = Paid, 2 = Unpaid
  final String selectedTab;
  final bool isLoading;
  final String successMessage;
  final String errorMessage;
  
  final List<Product> allProducts;
  final List<OrderProduct> allOrders;
  final List<SalesOrder> allSalesOrders;
  final List<AllSummary> allSummaries;

  final List<Product> filteredProducts;
  final List<OrderProduct> filteredOrders;
  final List<SalesOrder> filteredSalesOrders;
  final List<AllSummary> filteredSummaries;

  const SummaryState({
    this.role = "warehouse",
    this.keyword = "",
    this.tag = 0,
    this.selectedTab = "all_summary",
    this.isLoading = false,
    this.successMessage = "",
    this.errorMessage = "",
    this.allProducts = const [],
    this.allOrders = const [],
    this.allSalesOrders = const [],
    this.allSummaries = const [],
    this.filteredProducts = const [],
    this.filteredOrders = const [],
    this.filteredSalesOrders = const [],
    this.filteredSummaries = const [],
  });

  SummaryState copyWith({
    String? role,
    String? keyword,
    int? tag,
    String? selectedTab,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
    List<Product>? allProducts,
    List<OrderProduct>? allOrders,
    List<SalesOrder>? allSalesOrders,
    List<AllSummary>? allSummaries,
    List<Product>? filteredProducts,
    List<OrderProduct>? filteredOrders,
    List<SalesOrder>? filteredSalesOrders,
    List<AllSummary>? filteredSummaries,
  }) {
    return SummaryState(
      role: role ?? this.role,
      keyword: keyword ?? this.keyword,
      tag: tag ?? this.tag,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      allProducts: allProducts ?? this.allProducts,
      allOrders: allOrders ?? this.allOrders,
      allSalesOrders: allSalesOrders ?? this.allSalesOrders,
      allSummaries: allSummaries ?? this.allSummaries,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      filteredSalesOrders: filteredSalesOrders ?? this.filteredSalesOrders,
      filteredSummaries: filteredSummaries ?? this.filteredSummaries,
    );
  }

  @override
  List<Object> get props => [
        role, keyword, tag, selectedTab, isLoading, successMessage, errorMessage,
        allProducts, allOrders, allSalesOrders, allSummaries,
        filteredProducts, filteredOrders, filteredSalesOrders, filteredSummaries,
      ];
}

// --- BLOC ---
class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final DashboardFinanceRepository financeRepository;
  final UserDataController userDataController;

  SummaryBloc({
    required this.financeRepository,
    required this.userDataController,
  }) : super(const SummaryState()) {
    on<SummaryStarted>(_onStarted);
    on<SummaryTabChanged>(_onTabChanged);
    on<SummarySearchChanged>(_onSearchChanged);
    on<SummaryFilterChanged>(_onFilterChanged);
    on<SummaryPayRequested>(_onPayRequested);
  }

  Future<void> _onStarted(SummaryStarted event, Emitter<SummaryState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      UserModel? userModel = await userDataController.getDataUser();
      String role = userModel?.role ?? "warehouse";

      final products = (await financeRepository.getAllDataStock()).whereType<Product>().toList();
      final orders = await financeRepository.getAllDataOrder();
      final salesOrders = await financeRepository.getAllDataSalesOrder();

      final combined = <AllSummary>[];
      combined.addAll(products.map((e) => AllSummary(summaryType: SummaryType.product, data: e, createdOn: e.createdOn)));
      combined.addAll(orders.map((e) => AllSummary(summaryType: SummaryType.order, data: e, createdOn: e.orderDate!)));
      combined.addAll(salesOrders.map((e) => AllSummary(summaryType: SummaryType.salesOrder, data: e, createdOn: e.purchasedDate)));
      combined.sort((a, b) => b.createdOn.compareTo(a.createdOn));

      emit(state.copyWith(
        role: role,
        allProducts: products,
        allOrders: orders,
        allSalesOrders: salesOrders,
        allSummaries: combined,
        filteredProducts: products,
        filteredOrders: orders,
        filteredSalesOrders: salesOrders,
        filteredSummaries: combined,
        isLoading: false,
      ));
      
      _applyFilters(emit, state.keyword, state.tag);
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _onTabChanged(SummaryTabChanged event, Emitter<SummaryState> emit) {
    emit(state.copyWith(selectedTab: event.tab, tag: 0));
    _applyFilters(emit, state.keyword, 0);
  }

  void _onSearchChanged(SummarySearchChanged event, Emitter<SummaryState> emit) {
    emit(state.copyWith(keyword: event.keyword));
    _applyFilters(emit, event.keyword, state.tag);
  }

  void _onFilterChanged(SummaryFilterChanged event, Emitter<SummaryState> emit) {
    emit(state.copyWith(tag: event.tag));
    _applyFilters(emit, state.keyword, event.tag);
  }

  void _applyFilters(Emitter<SummaryState> emit, String keyword, int tag) {
    List<Product> fProducts = state.allProducts;
    List<OrderProduct> fOrders = state.allOrders;
    List<SalesOrder> fSales = state.allSalesOrders;
    List<AllSummary> fSummaries = state.allSummaries;

    final query = keyword.toLowerCase();

    // 1. Keyword filter
    if (query.isNotEmpty) {
      fProducts = fProducts.where((p) => p.productName.toLowerCase().contains(query)).toList();
      fOrders = fOrders.where((p) => p.productName.toLowerCase().contains(query)).toList();
      fSales = fSales.where((p) => p.productName.toLowerCase().contains(query)).toList();
      fSummaries = fSummaries.where((p) => p.data.productName.toLowerCase().contains(query)).toList();
    }

    // 2. Tag filter (only applies to orders and sales orders, because products don't have financeApproved usually, wait, they don't have it)
    if (tag == 1) { // Paid
      fOrders = fOrders.where((p) => p.financeApproved!).toList();
      fSales = fSales.where((p) => p.financeApproved!).toList();
      // fSummaries also needs filtering if it's an order or sales order
      fSummaries = fSummaries.where((p) {
        if (p.summaryType == SummaryType.order) return p.data.financeApproved;
        if (p.summaryType == SummaryType.salesOrder) return p.data.financeApproved;
        return true; 
      }).toList();
    } else if (tag == 2) { // Unpaid
      fOrders = fOrders.where((p) => !p.financeApproved!).toList();
      fSales = fSales.where((p) => !p.financeApproved!).toList();
      fSummaries = fSummaries.where((p) {
        if (p.summaryType == SummaryType.order) return !p.data.financeApproved;
        if (p.summaryType == SummaryType.salesOrder) return !p.data.financeApproved;
        return true; 
      }).toList();
    }

    emit(state.copyWith(
      filteredProducts: fProducts,
      filteredOrders: fOrders,
      filteredSalesOrders: fSales,
      filteredSummaries: fSummaries,
    ));
  }

  Future<void> _onPayRequested(SummaryPayRequested event, Emitter<SummaryState> emit) async {
    // Transaction logic here. We will just emit loading for now and fake success, similar to Dashboard.
    // If you need the real service, you can inject TransactionServices.
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isLoading: false, successMessage: "Invoice paid successfully"));
    // Re-fetch data
    add(SummaryStarted());
  }
}
