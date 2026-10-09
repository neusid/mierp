import 'package:equatable/equatable.dart';
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
