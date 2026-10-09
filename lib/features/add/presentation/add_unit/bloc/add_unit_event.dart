import 'package:equatable/equatable.dart';
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
