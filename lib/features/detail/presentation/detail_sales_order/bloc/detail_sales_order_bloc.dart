import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/data/transaction/services/transaction_services.dart';
import 'package:mierp_apps/data/warehouse/detail/detail_sales_order_repository.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/state/item_store.dart';

import 'detail_sales_order_event.dart';
import 'detail_sales_order_state.dart';

class DetailSalesOrderBloc extends Bloc<DetailSalesOrderEvent, DetailSalesOrderState> {
  final ItemRepository itemRepository;
  final ItemStore itemStore;
  final TransactionServices transactionServices;
  final DetailSalesOrderRepository detailSalesOrderRepository;
  final UserDataController userDataController;
  late VoidCallback _salesOrderListener;

  DetailSalesOrderBloc({
    required this.itemRepository,
    required this.itemStore,
    required this.transactionServices,
    required this.detailSalesOrderRepository,
    required this.userDataController,
  }) : super(const DetailSalesOrderState()) {
    on<DetailSalesOrderStarted>(_onStarted);
    on<DetailSalesOrderPayRequested>(_onPayRequested);
    on<DetailSalesOrderDeleteRequested>(_onDeleteRequested);
    on<DetailSalesOrderRejectRequested>(_onRejectRequested);
    on<DetailSalesOrderUpdated>(_onUpdated);

    _salesOrderListener = () {
      final salesOrder = itemStore.salesOrders.value;
      add(DetailSalesOrderUpdated(salesOrder));
    };
    itemStore.salesOrders.addListener(_salesOrderListener);
  }

  Future<void> _onStarted(DetailSalesOrderStarted event, Emitter<DetailSalesOrderState> emit) async {
    emit(state.copyWith(status: DetailSalesOrderStatus.loading));
    try {
      String? role;
      try {
        final user = await userDataController.getDataUser();
        role = user.role;
      } catch (_) {}

      final salesOrder = await itemRepository.getDetailDataSalesOrder(event.id);
      emit(state.copyWith(
        role: role,
        salesOrder: salesOrder,
        status: DetailSalesOrderStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DetailSalesOrderStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onUpdated(DetailSalesOrderUpdated event, Emitter<DetailSalesOrderState> emit) {
    emit(state.copyWith(
      salesOrder: event.salesOrder,
      status: DetailSalesOrderStatus.success,
    ));
  }

  Future<void> _onPayRequested(DetailSalesOrderPayRequested event, Emitter<DetailSalesOrderState> emit) async {
    emit(state.copyWith(status: DetailSalesOrderStatus.loading));
    try {
      await transactionServices.paySalesOrderServices(event.docId, event.prodId, event.totalQty);
      final salesOrder = await itemRepository.getDetailDataSalesOrder(event.docId);
      await itemRepository.getBulkDataSalesOrder();
      
      emit(state.copyWith(
        status: DetailSalesOrderStatus.success,
        salesOrder: salesOrder,
        successMessage: "Success pay invoice",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DetailSalesOrderStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRejectRequested(DetailSalesOrderRejectRequested event, Emitter<DetailSalesOrderState> emit) async {
    emit(state.copyWith(status: DetailSalesOrderStatus.loading));
    try {
      await transactionServices.rejectSalesOrderServices(event.docId, event.reason);
      final salesOrder = await itemRepository.getDetailDataSalesOrder(event.docId);
      await itemRepository.getBulkDataSalesOrder();
      
      emit(state.copyWith(
        status: DetailSalesOrderStatus.rejectSuccess,
        salesOrder: salesOrder,
        successMessage: "Tagihan sales order berhasil ditolak",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DetailSalesOrderStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteRequested(DetailSalesOrderDeleteRequested event, Emitter<DetailSalesOrderState> emit) async {
    emit(state.copyWith(status: DetailSalesOrderStatus.loading));
    try {
      await detailSalesOrderRepository.deleteSingleSalesOrder(event.docId);
      await itemRepository.getBulkDataSalesOrder();
      
      emit(state.copyWith(
        status: DetailSalesOrderStatus.deleteSuccess,
        successMessage: "Delete success",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DetailSalesOrderStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    itemStore.salesOrders.removeListener(_salesOrderListener);
    itemStore.clearDetailProduct();
    return super.close();
  }
}
