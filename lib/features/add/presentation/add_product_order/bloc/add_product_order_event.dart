import 'package:equatable/equatable.dart';
import 'package:mierp_apps/core/models/order.dart';

abstract class AddProductOrderEvent extends Equatable {
  const AddProductOrderEvent();

  @override
  List<Object> get props => [];
}

class AddProductOrderLoadProducts extends AddProductOrderEvent {}

class AddProductOrderSubmitted extends AddProductOrderEvent {
  final OrderProduct productOrder;

  const AddProductOrderSubmitted({required this.productOrder});

  @override
  List<Object> get props => [productOrder];
}
