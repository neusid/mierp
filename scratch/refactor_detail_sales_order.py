import os
import re

bloc_dir = r"d:\Project\Flutter\mierp\lib\features\detail\presentation\detail_sales_order\bloc"
os.makedirs(bloc_dir, exist_ok=True)

# create state
state_code = """import 'package:equatable/equatable.dart';
import 'package:mierp_apps/core/models/sales_order.dart';

enum DetailSalesOrderStatus { initial, loading, success, failure, deleteSuccess }

class DetailSalesOrderState extends Equatable {
  final DetailSalesOrderStatus status;
  final SalesOrder? salesOrder;
  final String errorMessage;
  final String successMessage;
  final String? role;

  const DetailSalesOrderState({
    this.status = DetailSalesOrderStatus.initial,
    this.salesOrder,
    this.errorMessage = '',
    this.successMessage = '',
    this.role,
  });

  DetailSalesOrderState copyWith({
    DetailSalesOrderStatus? status,
    SalesOrder? salesOrder,
    String? errorMessage,
    String? successMessage,
    String? role,
  }) {
    return DetailSalesOrderState(
      status: status ?? this.status,
      salesOrder: salesOrder ?? this.salesOrder,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [
        status,
        salesOrder,
        errorMessage,
        successMessage,
        role,
      ];
}
"""
with open(os.path.join(bloc_dir, "detail_sales_order_state.dart"), "w") as f:
    f.write(state_code)

# create event
event_code = """import 'package:equatable/equatable.dart';

abstract class DetailSalesOrderEvent extends Equatable {
  const DetailSalesOrderEvent();

  @override
  List<Object?> get props => [];
}

class DetailSalesOrderStarted extends DetailSalesOrderEvent {
  final String id;
  const DetailSalesOrderStarted(this.id);
  
  @override
  List<Object?> get props => [id];
}

class DetailSalesOrderPayRequested extends DetailSalesOrderEvent {
  final String docId;
  final String prodId;
  final int totalQty;

  const DetailSalesOrderPayRequested(this.docId, this.prodId, this.totalQty);

  @override
  List<Object?> get props => [docId, prodId, totalQty];
}

class DetailSalesOrderDeleteRequested extends DetailSalesOrderEvent {
  final String docId;
  const DetailSalesOrderDeleteRequested(this.docId);

  @override
  List<Object?> get props => [docId];
}

class DetailSalesOrderUpdated extends DetailSalesOrderEvent {
  final salesOrder;
  const DetailSalesOrderUpdated(this.salesOrder);
}
"""
with open(os.path.join(bloc_dir, "detail_sales_order_event.dart"), "w") as f:
    f.write(event_code)

# create bloc
bloc_code = """import 'dart:async';
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
  late StreamSubscription _salesOrderSubscription;

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
    on<DetailSalesOrderUpdated>(_onUpdated);

    _salesOrderSubscription = itemStore.salesOrders.listen((salesOrder) {
      add(DetailSalesOrderUpdated(salesOrder));
    });
  }

  Future<void> _onStarted(DetailSalesOrderStarted event, Emitter<DetailSalesOrderState> emit) async {
    emit(state.copyWith(status: DetailSalesOrderStatus.loading));
    try {
      final user = await userDataController.getDataUser();
      final role = user.role;
      emit(state.copyWith(role: role, status: DetailSalesOrderStatus.success));
      
      await itemRepository.getDetailDataSalesOrder(event.id);
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
      await itemRepository.getDetailDataSalesOrder(event.docId);
      await itemRepository.getBulkDataSalesOrder();
      
      emit(state.copyWith(
        status: DetailSalesOrderStatus.success,
        successMessage: "Success pay invoice",
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
    _salesOrderSubscription.cancel();
    itemStore.clearDetailProduct();
    return super.close();
  }
}
"""
with open(os.path.join(bloc_dir, "detail_sales_order_bloc.dart"), "w") as f:
    f.write(bloc_code)

print("BLoC created")
