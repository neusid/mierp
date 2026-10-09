import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/data/finance/services/detail_product_services.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';

// --- EVENTS ---
abstract class DetailProductEvent extends Equatable {
  const DetailProductEvent();
  @override
  List<Object> get props => [];
}

class DetailProductStarted extends DetailProductEvent {
  final String id;
  const DetailProductStarted(this.id);
  @override
  List<Object> get props => [id];
}

class DetailProductUpdateRequested extends DetailProductEvent {
  final Product product;
  const DetailProductUpdateRequested(this.product);
  @override
  List<Object> get props => [product];
}

class DetailProductDeleteRequested extends DetailProductEvent {
  final String id;
  const DetailProductDeleteRequested(this.id);
  @override
  List<Object> get props => [id];
}

// --- STATE ---
enum DetailProductStatus { initial, loading, success, deleteSuccess, failure }

class DetailProductState extends Equatable {
  bool get isLoading => status == DetailProductStatus.loading;
  final DetailProductStatus status;
  final Product? product;
  final String errorMessage;
  final String successMessage;

  const DetailProductState({
    this.status = DetailProductStatus.initial,
    this.product,
    this.errorMessage = '',
    this.successMessage = '',
  });

  DetailProductState copyWith({
    DetailProductStatus? status,
    Product? product,
    String? errorMessage,
    String? successMessage,
  }) {
    return DetailProductState(
      status: status ?? this.status,
      product: product ?? this.product,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, product, errorMessage, successMessage];
}

// --- BLOC ---
class DetailProductBloc extends Bloc<DetailProductEvent, DetailProductState> {
  final ItemRepository itemRepository;
  final DetailProductServices detailProductServices;

  DetailProductBloc({
    required this.itemRepository,
    required this.detailProductServices,
  }) : super(const DetailProductState()) {
    on<DetailProductStarted>(_onStarted);
    on<DetailProductUpdateRequested>(_onUpdateRequested);
    on<DetailProductDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onStarted(DetailProductStarted event, Emitter<DetailProductState> emit) async {
    emit(state.copyWith(status: DetailProductStatus.loading));
    try {
      final product = await itemRepository.getDetailDataStock(event.id);
      emit(state.copyWith(status: DetailProductStatus.success, product: product));
    } catch (e) {
      emit(state.copyWith(status: DetailProductStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateRequested(DetailProductUpdateRequested event, Emitter<DetailProductState> emit) async {
    emit(state.copyWith(status: DetailProductStatus.loading));
    try {
      await detailProductServices.updateDataProduct(event.product.id, event.product);
      emit(state.copyWith(status: DetailProductStatus.success, successMessage: "Update data success", product: event.product));
    } catch (e) {
      emit(state.copyWith(status: DetailProductStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteRequested(DetailProductDeleteRequested event, Emitter<DetailProductState> emit) async {
    emit(state.copyWith(status: DetailProductStatus.loading));
    try {
      await detailProductServices.deleteDataProduct(event.id);
      await itemRepository.getBulkDataStock();
      emit(state.copyWith(status: DetailProductStatus.deleteSuccess, successMessage: "Delete data success"));
    } catch (e) {
      emit(state.copyWith(status: DetailProductStatus.failure, errorMessage: e.toString()));
    }
  }
}
