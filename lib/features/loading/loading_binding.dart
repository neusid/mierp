import 'package:get/get.dart';
import 'package:mierp_apps/features/loading/loading_view_model.dart';

class LoadingBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(LoadingViewModel());
  }
}