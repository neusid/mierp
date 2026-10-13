import 'package:equatable/equatable.dart';
import 'package:mierp_apps/core/models/sales_order.dart';

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

class DetailSalesOrderRejectRequested extends DetailSalesOrderEvent {
  final String docId;
  final String reason;
  const DetailSalesOrderRejectRequested(this.docId, this.reason);

  @override
  List<Object?> get props => [docId, reason];
}

class DetailSalesOrderUpdated extends DetailSalesOrderEvent {
  final SalesOrder? salesOrder;
  const DetailSalesOrderUpdated(this.salesOrder);

  @override
  List<Object?> get props => [salesOrder];
}
