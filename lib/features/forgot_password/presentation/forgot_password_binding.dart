import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/data/forgot_password/forgot_password_repository.dart';
import 'package:mierp_apps/features/forgot_password/presentation/forgot_password_view_model.dart';

class ForgotPasswordBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(ForgotPasswordRepository(Get.find<FirebaseAuth>()));
    Get.put(ForgotPasswordViewModel(forgotPasswordRepository: Get.find<ForgotPasswordRepository>()));
  }
}