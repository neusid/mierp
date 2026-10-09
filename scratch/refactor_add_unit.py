import os
import re

bloc_dir = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_unit\bloc"
os.makedirs(bloc_dir, exist_ok=True)

# create state
state_code = """import 'package:equatable/equatable.dart';

enum AddUnitStatus { initial, loading, success, failure }

class AddUnitState extends Equatable {
  final AddUnitStatus status;
  final String errorMessage;
  final String successMessage;

  const AddUnitState({
    this.status = AddUnitStatus.initial,
    this.errorMessage = '',
    this.successMessage = '',
  });

  AddUnitState copyWith({
    AddUnitStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return AddUnitState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        successMessage,
      ];
}
"""
with open(os.path.join(bloc_dir, "add_unit_state.dart"), "w") as f:
    f.write(state_code)

# create event
event_code = """import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mierp_apps/core/models/product.dart';

abstract class AddUnitEvent extends Equatable {
  const AddUnitEvent();

  @override
  List<Object?> get props => [];
}

class AddUnitSubmitted extends AddUnitEvent {
  final Product product;
  final XFile? imageFile;

  const AddUnitSubmitted({required this.product, this.imageFile});

  @override
  List<Object?> get props => [product, imageFile];
}
"""
with open(os.path.join(bloc_dir, "add_unit_event.dart"), "w") as f:
    f.write(event_code)

# create bloc
bloc_code = """import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/data/warehouse/services/add_unit_services.dart';

import 'add_unit_event.dart';
import 'add_unit_state.dart';

class AddUnitBloc extends Bloc<AddUnitEvent, AddUnitState> {
  final AddUnitServices addUnitServices;

  AddUnitBloc({required this.addUnitServices}) : super(const AddUnitState()) {
    on<AddUnitSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(AddUnitSubmitted event, Emitter<AddUnitState> emit) async {
    emit(state.copyWith(status: AddUnitStatus.loading));
    try {
      String? imageUrl = "";

      if (event.imageFile != null) {
        imageUrl = await addUnitServices.postDataImage(event.imageFile!);
      }

      final product = Product(
        id: event.product.id,
        category: event.product.category,
        createdOn: event.product.createdOn,
        imageProduct: imageUrl,
        productName: event.product.productName,
        productCode: event.product.productCode,
        quantity: event.product.quantity,
        unitPrice: event.product.unitPrice,
      );

      await addUnitServices.postDataProduct(product);

      emit(state.copyWith(
        status: AddUnitStatus.success,
        successMessage: "Berhasil menambah produk!",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AddUnitStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
"""
with open(os.path.join(bloc_dir, "add_unit_bloc.dart"), "w") as f:
    f.write(bloc_code)

# Update injection_container.dart
injection_path = r"d:\Project\Flutter\mierp\lib\core\di\injection_container.dart"
with open(injection_path, 'r', encoding='utf-8') as f:
    injection_code = f.read()

import_statement = "import 'package:mierp_apps/features/add/presentation/add_unit/bloc/add_unit_bloc.dart';"
if import_statement not in injection_code:
    injection_code = injection_code.replace(
        "import 'package:mierp_apps/features/detail/presentation/detail_sales_order/bloc/detail_sales_order_bloc.dart';",
        "import 'package:mierp_apps/features/detail/presentation/detail_sales_order/bloc/detail_sales_order_bloc.dart';\n" + import_statement
    )

registration_statement = """  // Add Unit
  sl.registerFactory(() => AddUnitBloc(addUnitServices: sl()));
  sl.registerLazySingleton(() => AddUnitServices());"""
if "AddUnitBloc" not in injection_code:
    injection_code = injection_code.replace(
        "// AddUnit",
        registration_statement + "\n\n  // AddUnit"
    )

with open(injection_path, 'w', encoding='utf-8') as f:
    f.write(injection_code)

print("AddUnit BLoC created and injected")
