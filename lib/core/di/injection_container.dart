import 'package:mierp_apps/features/add/presentation/add_sales_order/bloc/add_sales_order_bloc.dart';
import 'package:mierp_apps/features/add/presentation/add_product_order/bloc/add_product_order_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mierp_apps/core/controller/user_data_controller.dart';
import 'package:mierp_apps/core/session/bloc/auth_bloc.dart';
import 'package:mierp_apps/data/auth_session/auth_session_repository.dart';
import 'package:mierp_apps/domain/credential/repository/credential_repository.dart';
import 'package:mierp_apps/features/login/data/repositories/login_repository_impl.dart';
import 'package:mierp_apps/features/login/domain/repositories/login_repository.dart';
import 'package:mierp_apps/features/login/domain/usecases/do_login.dart';
import 'package:mierp_apps/features/login/presentation/bloc/login_bloc.dart';
import 'package:mierp_apps/features/onboarding/presentation/onboarding_service.dart';
import 'package:mierp_apps/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:mierp_apps/data/login/login_repository.dart' as legacy_login;


import 'package:mierp_apps/features/register/data/repositories/register_repository_impl.dart';
import 'package:mierp_apps/features/register/domain/repositories/register_repository.dart';
import 'package:mierp_apps/features/register/domain/usecases/do_register.dart';
import 'package:mierp_apps/features/register/presentation/bloc/register_bloc.dart';

import 'package:mierp_apps/features/forgot_password/data/repositories/forgot_password_repository_impl.dart';
import 'package:mierp_apps/features/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:mierp_apps/features/forgot_password/domain/usecases/do_reset_password.dart';
import 'package:mierp_apps/features/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:mierp_apps/data/warehouse/warehouse_repository.dart';
import 'package:mierp_apps/features/dashboard/presentation/warehouse/bloc/dashboard_warehouse_bloc.dart';
import 'package:mierp_apps/data/finance/dashboard_finance_repository.dart';
import 'package:mierp_apps/data/warehouse/detail/detail_product_order_repository.dart';
import 'package:mierp_apps/features/dashboard/presentation/finance/bloc/dashboard_finance_bloc.dart';
import 'package:mierp_apps/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mierp_apps/features/summary/presentation/bloc/summary_bloc.dart';
import 'package:mierp_apps/features/detail/presentation/detail_product/bloc/detail_product_bloc.dart';
import 'package:mierp_apps/features/detail/presentation/detail_sales_order/bloc/detail_sales_order_bloc.dart';
import 'package:mierp_apps/data/warehouse/detail/detail_sales_order_repository.dart';
import 'package:mierp_apps/features/detail/presentation/detail_product_order/bloc/detail_product_order_bloc.dart';
import 'package:mierp_apps/features/detail/presentation/detail_sales_order/bloc/detail_sales_order_bloc.dart';
import 'package:mierp_apps/features/add/presentation/add_unit/bloc/add_unit_bloc.dart';

import 'package:mierp_apps/data/warehouse/services/add_unit_services.dart';
import 'package:mierp_apps/data/warehouse/add/add_unit_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mierp_apps/data/credential/credential_repository_impl.dart';
import 'package:mierp_apps/domain/item/repositories/item_repository.dart';
import 'package:mierp_apps/data/item/repositories/item_repository_impl.dart';
import 'package:mierp_apps/state/item_store.dart';
import 'package:mierp_apps/data/finance/services/detail_product_services.dart';
import 'package:mierp_apps/domain/transaction/repository/transaction_repository.dart';
import 'package:mierp_apps/data/transaction/transaction_repository_impl.dart';
import 'package:mierp_apps/data/transaction/services/transaction_services.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// --------------------------------------------------------------------------
  /// CORE & NETWORK FOUNDATION (Bridging from GetX)
  /// --------------------------------------------------------------------------
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  
  sl.registerLazySingleton<CredentialRepository>(() => CredentialRepositoryImpl());
  sl.registerLazySingleton(() => AuthSessionRepository(firebaseAuth: sl()));
  sl.registerLazySingleton(() => AuthBloc(authSessionRepository: sl()));
  sl.registerLazySingleton<OnboardingService>(() => OnboardingService());
  sl.registerLazySingleton(() => UserDataController()); 

  sl.registerLazySingleton(() => ItemStore());
  sl.registerLazySingleton<ItemRepository>(() => ItemStoreRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => DetailProductServices(itemRepository: sl()));
  sl.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(firestore: sl()));
  sl.registerLazySingleton<TransactionServices>(() => TransactionServices(itemRepository: sl(), itemStore: sl(), transactionRepository: sl()));
  
  /// --------------------------------------------------------------------------
  /// AUTHENTICATION FLOW (Splash & Login)
  /// --------------------------------------------------------------------------
  // BLoC
  sl.registerFactory(() => AddUnitBloc(addUnitServices: sl()));
  sl.registerFactory(() => AddSalesOrderBloc());
  sl.registerFactory(() => AddProductOrderBloc());
  sl.registerFactory(() => SplashBloc(
        authBloc: sl(),
        onboardingService: sl(),
      ));
      
  sl.registerFactory(() => LoginBloc(
        doLogin: sl(),
        doLoginWithGoogle: sl(),
        credentialRepository: sl(),
        userDataController: sl(),
      ));
  
  sl.registerFactory(() => RegisterBloc(doRegister: sl()));
  sl.registerFactory(() => ForgotPasswordBloc(doResetPassword: sl()));
  sl.registerFactory(() => DashboardWarehouseBloc(warehouseRepository: sl(), userDataController: sl()));
  sl.registerFactory(() => DashboardFinanceBloc(financeRepository: sl(), userDataController: sl()));
  sl.registerFactory(() => ProfileBloc(loginRepository: sl(), userDataController: sl()));
  sl.registerFactory(() => SummaryBloc(financeRepository: sl(), userDataController: sl()));
  sl.registerFactory(() => DetailProductBloc(itemRepository: sl(), detailProductServices: sl()));
  sl.registerFactory(() => DetailSalesOrderBloc(itemRepository: sl(), itemStore: sl(), transactionServices: sl(), detailSalesOrderRepository: sl(), userDataController: sl()));
  sl.registerFactory(() => DetailProductOrderBloc(itemRepository: sl(), transactionServices: sl(), detailProductOrderRepository: sl(), userDataController: sl()));
  
  // UseCases
  sl.registerLazySingleton(() => DoLogin(sl()));
  sl.registerLazySingleton(() => DoLoginWithGoogle(sl()));
  sl.registerLazySingleton(() => DoRegister(sl()));
  sl.registerLazySingleton(() => DoResetPassword(sl()));

  // Repository (Contracts & Implementations)
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl());
  sl.registerLazySingleton(() => legacy_login.LoginRepository());
  sl.registerLazySingleton<RegisterRepository>(() => RegisterRepositoryImpl());
  sl.registerLazySingleton<ForgotPasswordRepository>(() => ForgotPasswordRepositoryImpl());
  sl.registerLazySingleton(() => WarehouseRepository());
  sl.registerLazySingleton(() => DashboardFinanceRepository());
  sl.registerLazySingleton(() => DetailProductOrderRepository());
  sl.registerLazySingleton(() => DetailSalesOrderRepository());
  sl.registerLazySingleton(() => AddUnitRepository());
  sl.registerLazySingleton(() => AddUnitServices(addUnitRepository: sl()));
  
  /// --------------------------------------------------------------------------
  /// MAIN FEATURE FLOW (Dashboard & Transaksi)
  /// --------------------------------------------------------------------------
}