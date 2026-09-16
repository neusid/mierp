
import 'package:get/get.dart';
import 'package:mierp_apps/features/notification/presentation/notification_view_model.dart';

class NotificationBinding extends Bindings {

  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(NotificationViewModel());
  }
}