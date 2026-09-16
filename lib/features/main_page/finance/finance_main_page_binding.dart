
import 'package:get/get.dart';
import 'package:mierp_apps/data/finance/dashboard_finance_repository.dart';
import 'package:mierp_apps/data/login/login_repository.dart';
import 'package:mierp_apps/data/transaction/services/transaction_services.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/features/dashboard/presentation/finance/dashboard_finance_view_model.dart';
import 'package:mierp_apps/features/main_page/finance/finance_main_page_view_model.dart';
import 'package:mierp_apps/features/profile/presentation/profile_view_model.dart';
import 'package:mierp_apps/state/item_store.dart';

class FinanceMainPageBinding extends Bindings {

  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(FinanceMainPageViewModel());
    Get.lazyPut(() => DashboardFinanceViewModel(DashboardFinanceRepository(), Get.find<ItemRepository>(), Get.find<ItemStore>(), Get.find<TransactionServices>()),);
    Get.lazyPut(() => ProfileViewModel(loginRepository: Get.find<LoginRepository>()),);
  }
}