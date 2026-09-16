
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/data/auth_session/auth_session_repository.dart';

class AuthSession extends GetxController {

  final AuthSessionRepository authSessionRepository;
  AuthSession({required this.authSessionRepository});

  RxBool isLoggedIn = false.obs;
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    user.value = authSessionRepository.currentUser;
    isLoggedIn.value = authSessionRepository.currentUser != null;

    authSessionRepository.streamUser.listen(
      (event) {
        user.value = event;
        isLoggedIn.value = event != null;
      },
    );
  }
}