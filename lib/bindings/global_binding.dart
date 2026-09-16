import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mierp_apps/core/session/auth_session.dart';

import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/core/controller/move_page_controller.dart';
import 'package:mierp_apps/data/auth_session/auth_session_repository.dart';
import 'package:mierp_apps/data/credential/credential_repository_impl.dart';
import 'package:mierp_apps/data/finance/services/detail_product_services.dart';
import 'package:mierp_apps/data/login/login_repository.dart';
import 'package:mierp_apps/data/transaction/services/transaction_services.dart';
import 'package:mierp_apps/data/transaction/transaction_repository_impl.dart';
import 'package:mierp_apps/domain/credential/repository/credential_repository.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/data/item/repositories/item_repository_impl.dart';
import 'package:mierp_apps/domain/transaction/repository/transaction_repository.dart';
import 'package:mierp_apps/features/onboarding/presentation/onboarding_view_model.dart';
import 'package:mierp_apps/features/splash/presentation/splash_view_model.dart';
import 'package:mierp_apps/state/item_store.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.put(LoadingController(), permanent: true);

    Get.put(FirebaseFirestore.instance);
    Get.put(FirebaseAuth.instance);

    Get.put(AuthSessionRepository(firebaseAuth: Get.find()));
    Get.put(AuthSession(authSessionRepository: Get.find()),permanent: true);

    Get.put<CredentialRepository>(CredentialRepositoryImpl());

    Get.put(LoginRepository());

    Get.put(OnboardingViewModel());
    Get.lazyPut(()=>SplashViewModel(authSession: Get.find<AuthSession>(), onboardingViewModel: Get.find<OnboardingViewModel>()));

    Get.lazyPut(()=>MovePageController(),fenix: true);

    Get.put(ItemStore(), permanent: true);
    Get.put<ItemRepository>(ItemStoreRepositoryImpl(Get.find<FirebaseFirestore>(),Get.find<ItemStore>()));

    Get.put(DetailProductServices(itemRepository: Get.find<ItemRepository>()));
    Get.put<TransactionRepository>(TransactionRepositoryImpl(firestore: Get.find()));
    Get.put<TransactionServices>(TransactionServices(itemRepository: Get.find<ItemRepository>(), itemStore: Get.find<ItemStore>(), transactionRepository: Get.find<TransactionRepository>()));
  }
}