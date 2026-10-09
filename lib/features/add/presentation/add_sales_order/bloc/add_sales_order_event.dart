import 'package:equatable/equatable.dart';
import 'package:mierp_apps/core/models/sales_order.dart';

abstract class AddSalesOrderEvent extends Equatable {
  const AddSalesOrderEvent();

  @override
  List<Object> get props => [];
}

class AddSalesOrderLoadProducts extends AddSalesOrderEvent {}

class AddSalesOrderSubmitted extends AddSalesOrderEvent {
  final SalesOrder salesOrder;

  const AddSalesOrderSubmitted({required this.salesOrder});

  @override
  List<Object> get props => [salesOrder];
}
