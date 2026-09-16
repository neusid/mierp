import 'package:get/get.dart';
import 'package:mierp_apps/features/register/presentation/register_view_model.dart';

class RegisterBinding extends Bindings {

  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(RegisterViewModel());
  }
}