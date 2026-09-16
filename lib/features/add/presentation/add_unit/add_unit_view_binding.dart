
import 'package:get/get.dart';
import 'package:mierp_apps/data/warehouse/add/add_unit_repository.dart';
import 'package:mierp_apps/data/warehouse/services/add_unit_services.dart';
import 'package:mierp_apps/features/add/presentation/add_unit/add_unit_view_model.dart';

class  AddUnitViewBinding extends Bindings{

  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.put(AddUnitRepository());
    Get.put(AddUnitServices(addUnitRepository: Get.find<AddUnitRepository>()));
    Get.put(AddUnitViewModel(addUnitServices: Get.find<AddUnitServices>()));
  }
}