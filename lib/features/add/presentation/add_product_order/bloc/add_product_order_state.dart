import 'package:equatable/equatable.dart';
import 'package:mierp_apps/core/models/product.dart';

enum AddProductOrderStatus { initial, loading, success, failure }

class AddProductOrderState extends Equatable {
  final AddProductOrderStatus status;
  final String errorMessage;
  final String successMessage;
  final List<Product?> listProduct;

  const AddProductOrderState({
    this.status = AddProductOrderStatus.initial,
    this.errorMessage = '',
    this.successMessage = '',
    this.listProduct = const [],
  });

  AddProductOrderState copyWith({
    AddProductOrderStatus? status,
    String? errorMessage,
    String? successMessage,
    List<Product?>? listProduct,
  }) {
    return AddProductOrderState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      listProduct: listProduct ?? this.listProduct,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage, listProduct];
}
