import os

bloc_dir = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_product_order\bloc"
os.makedirs(bloc_dir, exist_ok=True)

# add_product_order_state.dart
state_code = """import 'package:equatable/equatable.dart';

enum AddProductOrderStatus { initial, loading, success, failure }

class AddProductOrderState extends Equatable {
  final AddProductOrderStatus status;
  final String errorMessage;
  final String successMessage;

  const AddProductOrderState({
    this.status = AddProductOrderStatus.initial,
    this.errorMessage = '',
    this.successMessage = '',
  });

  AddProductOrderState copyWith({
    AddProductOrderStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return AddProductOrderState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage];
}
"""
with open(os.path.join(bloc_dir, "add_product_order_state.dart"), 'w') as f:
    f.write(state_code)

# add_product_order_event.dart
event_code = """import 'package:equatable/equatable.dart';
import 'package:mierp_apps/core/models/product_order.dart';

abstract class AddProductOrderEvent extends Equatable {
  const AddProductOrderEvent();

  @override
  List<Object> get props => [];
}

class AddProductOrderSubmitted extends AddProductOrderEvent {
  final ProductOrder productOrder;

  const AddProductOrderSubmitted({required this.productOrder});

  @override
  List<Object> get props => [productOrder];
}
"""
with open(os.path.join(bloc_dir, "add_product_order_event.dart"), 'w') as f:
    f.write(event_code)

# add_product_order_bloc.dart
bloc_code = """import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/add/presentation/add_product_order/bloc/add_product_order_event.dart';
import 'package:mierp_apps/features/add/presentation/add_product_order/bloc/add_product_order_state.dart';
import 'package:mierp_apps/features/add/data/repositories/add_repository.dart';

class AddProductOrderBloc extends Bloc<AddProductOrderEvent, AddProductOrderState> {
  final AddRepository addRepository;

  AddProductOrderBloc({required this.addRepository}) : super(const AddProductOrderState()) {
    on<AddProductOrderSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(AddProductOrderSubmitted event, Emitter<AddProductOrderState> emit) async {
    emit(state.copyWith(status: AddProductOrderStatus.loading));
    try {
      final result = await addRepository.postAddProductOrder(event.productOrder);
      if (result) {
        emit(state.copyWith(
          status: AddProductOrderStatus.success,
          successMessage: 'Product Order created successfully',
        ));
      } else {
        emit(state.copyWith(
          status: AddProductOrderStatus.failure,
          errorMessage: 'Failed to create Product Order',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AddProductOrderStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
"""
with open(os.path.join(bloc_dir, "add_product_order_bloc.dart"), 'w') as f:
    f.write(bloc_code)

# Register in injection_container.dart
di_path = r"d:\Project\Flutter\mierp\lib\core\di\injection_container.dart"
with open(di_path, 'r', encoding='utf-8') as f:
    di_code = f.read()

import_statement = "import 'package:mierp_apps/features/add/presentation/add_product_order/bloc/add_product_order_bloc.dart';\n"
if "add_product_order_bloc.dart" not in di_code:
    di_code = import_statement + di_code

register_statement = "  sl.registerFactory(() => AddProductOrderBloc(addRepository: sl()));"
if register_statement not in di_code:
    di_code = di_code.replace("  // View Models", f"{register_statement}\n  // View Models")

with open(di_path, 'w', encoding='utf-8') as f:
    f.write(di_code)

print("AddProductOrder BLoC created and injected")
