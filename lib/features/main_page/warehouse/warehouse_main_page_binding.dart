
import 'package:get/get.dart';
import 'package:mierp_apps/features/dashboard/presentation/warehouse/warehouse_view_model.dart';
import 'package:mierp_apps/features/main_page/warehouse/warehouse_main_page_view_model.dart';
import 'package:mierp_apps/features/profile/presentation/profile_view_model.dart';

class WarehouseMainPageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(WarehouseMainPageViewModel());
    Get.lazyPut(() => WarehouseViewModel(Get.find(), Get.find()),);
    Get.lazyPut(() => ProfileViewModel(loginRepository: Get.find()),);
  }
}
