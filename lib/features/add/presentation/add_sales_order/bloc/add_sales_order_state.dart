import 'package:equatable/equatable.dart';
import 'package:mierp_apps/core/models/product.dart';

enum AddSalesOrderStatus { initial, loading, success, failure }

class AddSalesOrderState extends Equatable {
  final AddSalesOrderStatus status;
  final String errorMessage;
  final String successMessage;
  final List<Product?> listProduct;

  const AddSalesOrderState({
    this.status = AddSalesOrderStatus.initial,
    this.errorMessage = '',
    this.successMessage = '',
    this.listProduct = const [],
  });

  AddSalesOrderState copyWith({
    AddSalesOrderStatus? status,
    String? errorMessage,
    String? successMessage,
    List<Product?>? listProduct,
  }) {
    return AddSalesOrderState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      listProduct: listProduct ?? this.listProduct,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage, listProduct];
}
