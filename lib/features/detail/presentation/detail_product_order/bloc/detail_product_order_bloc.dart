import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/user_model.dart';
import 'package:mierp_apps/data/transaction/services/transaction_services.dart';
import 'package:mierp_apps/data/warehouse/detail/detail_product_order_repository.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';

// --- EVENTS ---
abstract class DetailProductOrderEvent extends Equatable {
  const DetailProductOrderEvent();
  @override
  List<Object> get props => [];
}

class DetailProductOrderStarted extends DetailProductOrderEvent {
  final String id;
  const DetailProductOrderStarted(this.id);
  @override
  List<Object> get props => [id];
}

class DetailProductOrderPayRequested extends DetailProductOrderEvent {
  final String docId;
  final String prodId;
  final int totalQty;
  const DetailProductOrderPayRequested(this.docId, this.prodId, this.totalQty);
  @override
  List<Object> get props => [docId, prodId, totalQty];
}

class DetailProductOrderDeleteRequested extends DetailProductOrderEvent {
  final String id;
  const DetailProductOrderDeleteRequested(this.id);
  @override
  List<Object> get props => [id];
}

// --- STATE ---
enum DetailProductOrderStatus { initial, loading, success, paySuccess, deleteSuccess, failure }

class DetailProductOrderState extends Equatable {
  final DetailProductOrderStatus status;
  final OrderProduct? orderProduct;
  final String? role;
  final String errorMessage;
  final String successMessage;

  const DetailProductOrderState({
    this.status = DetailProductOrderStatus.initial,
    this.orderProduct,
    this.role,
    this.errorMessage = '',
    this.successMessage = '',
  });

  DetailProductOrderState copyWith({
    DetailProductOrderStatus? status,
    OrderProduct? orderProduct,
    String? role,
    String? errorMessage,
    String? successMessage,
  }) {
    return DetailProductOrderState(
      status: status ?? this.status,
      orderProduct: orderProduct ?? this.orderProduct,
      role: role ?? this.role,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, orderProduct, role, errorMessage, successMessage];
}

// --- BLOC ---
class DetailProductOrderBloc extends Bloc<DetailProductOrderEvent, DetailProductOrderState> {
  final ItemRepository itemRepository;
  final TransactionServices transactionServices;
  final DetailProductOrderRepository detailProductOrderRepository;
  final UserDataController userDataController;

  DetailProductOrderBloc({
    required this.itemRepository,
    required this.transactionServices,
    required this.detailProductOrderRepository,
    required this.userDataController,
  }) : super(const DetailProductOrderState()) {
    on<DetailProductOrderStarted>(_onStarted);
    on<DetailProductOrderPayRequested>(_onPayRequested);
    on<DetailProductOrderDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onStarted(DetailProductOrderStarted event, Emitter<DetailProductOrderState> emit) async {
    emit(state.copyWith(status: DetailProductOrderStatus.loading));
    try {
      final orderProduct = await itemRepository.getDetailDataOrder(event.id);
      final UserModel user = await userDataController.getDataUser();
      emit(state.copyWith(
        status: DetailProductOrderStatus.success, 
        orderProduct: orderProduct,
        role: user.role,
      ));
    } catch (e) {
      emit(state.copyWith(status: DetailProductOrderStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onPayRequested(DetailProductOrderPayRequested event, Emitter<DetailProductOrderState> emit) async {
    emit(state.copyWith(status: DetailProductOrderStatus.loading));
    try {
      await transactionServices.payProductOrderServices(event.docId, event.prodId, event.totalQty);
      final orderProduct = await itemRepository.getDetailDataOrder(event.docId);
      emit(state.copyWith(
        status: DetailProductOrderStatus.paySuccess, 
        successMessage: "Payment success", 
        orderProduct: orderProduct
      ));
    } catch (e) {
      emit(state.copyWith(status: DetailProductOrderStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteRequested(DetailProductOrderDeleteRequested event, Emitter<DetailProductOrderState> emit) async {
    emit(state.copyWith(status: DetailProductOrderStatus.loading));
    try {
      await detailProductOrderRepository.deleteSingleProduct(event.id);
      await itemRepository.getBulkDataOrder();
      emit(state.copyWith(status: DetailProductOrderStatus.deleteSuccess, successMessage: "Delete success"));
    } catch (e) {
      emit(state.copyWith(status: DetailProductOrderStatus.failure, errorMessage: e.toString()));
    }
  }
}
