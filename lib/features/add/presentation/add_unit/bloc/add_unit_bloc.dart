import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/data/warehouse/services/add_unit_services.dart';

import 'add_unit_event.dart';
import 'add_unit_state.dart';
import 'package:mierp_apps/core/models/product.dart';

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
