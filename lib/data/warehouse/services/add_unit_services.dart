import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/data/warehouse/add/add_unit_repository.dart';

class AddUnitServices extends GetxService {
  final AddUnitRepository addUnitRepository;
  AddUnitServices({required this.addUnitRepository});

  Future<String?> postDataImage(XFile image) async {
    try {
      // Pastikan di repository fungsi ini me-return String URL
      return await addUnitRepository.uploadImageToCloudinary(image);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postDataProduct(Product product) async {
    try {
      await addUnitRepository.addUnitToFirebase("products", product);
    } catch (e) {
      rethrow;
    }
  }
}
