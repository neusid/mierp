import 'package:flutter/material.dart';
import 'package:mierp_apps/features/profile/presentation/account_info/account_info_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/session/bloc/auth_bloc.dart';
import 'package:mierp_apps/core/session/bloc/auth_state.dart';

import 'package:mierp_apps/features/add/presentation/add_product_order/add_product_order_view.dart';
import 'package:mierp_apps/features/add/presentation/add_sales_order/add_sales_order_view.dart';
import 'package:mierp_apps/features/add/presentation/add_unit/add_unit_view.dart';
import 'package:mierp_apps/features/dashboard/presentation/finance/dashboard_finance_view.dart';
import 'package:mierp_apps/features/dashboard/presentation/warehouse/dashboard_warehouse_view.dart';
import 'package:mierp_apps/features/detail/presentation/detail_product/detail_product_view.dart';
import 'package:mierp_apps/features/detail/presentation/detail_product_order/detail_product_order_view.dart';
import 'package:mierp_apps/features/detail/presentation/detail_sales_order/detail_sales_order_view.dart';
import 'package:mierp_apps/features/forgot_password/presentation/bloc/forgot_password_bloc.dart';
import 'package:mierp_apps/features/forgot_password/presentation/forgot_password_view.dart';
import 'package:mierp_apps/features/inventory_alerts/presentation/inventory_alerts_view.dart';
import 'package:mierp_apps/features/inventory_alerts/presentation/bloc/inventory_alerts_bloc.dart';
import 'package:mierp_apps/features/loading/loading_view.dart';
import 'package:mierp_apps/features/login/presentation/bloc/login_bloc.dart';
import 'package:mierp_apps/features/login/presentation/login_view.dart';
import 'package:mierp_apps/features/admin/presentation/admin_main_page_view.dart';
import 'package:mierp_apps/features/admin/presentation/staff/add_staff_view.dart';
import 'package:mierp_apps/features/admin/presentation/cubit/admin_staff_cubit.dart';
import 'package:mierp_apps/features/admin/data/repositories/admin_staff_repository.dart';
import 'package:mierp_apps/features/main_page/finance/finance_main_page_view.dart';
import 'package:mierp_apps/features/main_page/presentation/cubit/main_page_cubit.dart';
import 'package:mierp_apps/features/main_page/warehouse/warehouse_main_page_view.dart';
import 'package:mierp_apps/features/notification/presentation/notification_view.dart';
import 'package:mierp_apps/features/onboarding/presentation/onboarding_view.dart';
import 'package:mierp_apps/features/register/presentation/bloc/register_bloc.dart';
import 'package:mierp_apps/features/register/presentation/register_view.dart';
import 'package:mierp_apps/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:mierp_apps/features/splash/presentation/splash_view.dart';
import 'package:mierp_apps/features/summary/presentation/summary_view.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mierp_apps/core/session/bloc/auth_event.dart';
import 'package:mierp_apps/features/payment/presentation/payment_success_view.dart';
import 'package:mierp_apps/core/routing/page_transitions.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

String? _loginGuard(BuildContext context, GoRouterState state) {
  final auth = sl<AuthBloc>();
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (auth.state is! AuthAuthenticated) {
    if (firebaseUser != null) {
      auth.add(AuthUserChanged(firebaseUser));
      return null;
    }
    return '/login';
  }
  return null;
}

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      pageBuilder: (context, state) => SmoothPageTransitions.fadeScale(
        key: state.pageKey,
        name: state.name,
        child: OnboardingView(),
      ),
    ),
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder: (context, state) => SmoothPageTransitions.fadeScale(
        key: state.pageKey,
        name: state.name,
        child: BlocProvider(
          create: (_) => sl<SplashBloc>(),
          child: const SplashView(),
        ),
      ),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) => SmoothPageTransitions.fadeScale(
        key: state.pageKey,
        name: state.name,
        child: BlocProvider(
          create: (_) => sl<LoginBloc>(),
          child: const LoginView(),
        ),
      ),
    ),
    GoRoute(
      path: '/loading',
      name: 'loading',
      pageBuilder: (context, state) => SmoothPageTransitions.fadeScale(
        key: state.pageKey,
        name: state.name,
        child: const LoadingView(),
      ),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      pageBuilder: (context, state) => SmoothPageTransitions.slideHorizontal(
        key: state.pageKey,
        name: state.name,
        child: BlocProvider(
          create: (_) => sl<RegisterBloc>(),
          child: const RegisterView(),
        ),
      ),
    ),
    GoRoute(
      path: '/forgot',
      name: 'forgot',
      pageBuilder: (context, state) => SmoothPageTransitions.slideHorizontal(
        key: state.pageKey,
        name: state.name,
        child: BlocProvider(
          create: (_) => sl<ForgotPasswordBloc>(),
          child: const ForgotPasswordView(),
        ),
      ),
    ),
    GoRoute(
      path: '/admin_main_page',
      name: 'admin_main_page',
      redirect: _loginGuard,
      pageBuilder: (context, state) => SmoothPageTransitions.fadeScale(
        key: state.pageKey,
        name: state.name,
        child: const AdminMainPageView(),
      ),
    ),
    GoRoute(
      path: '/finance_main_page',
      name: 'finance_main_page',
      redirect: _loginGuard,
      pageBuilder: (context, state) => SmoothPageTransitions.fadeScale(
        key: state.pageKey,
        name: state.name,
        child: BlocProvider(
          create: (_) => MainPageCubit(),
          child: const FinanceMainPageView(),
        ),
      ),
    ),
    GoRoute(
      path: '/warehouse_main_page',
      name: 'warehouse_main_page',
      redirect: _loginGuard,
      pageBuilder: (context, state) => SmoothPageTransitions.fadeScale(
        key: state.pageKey,
        name: state.name,
        child: BlocProvider(
          create: (_) => MainPageCubit(),
          child: const WarehouseMainPageView(),
        ),
      ),
    ),
    GoRoute(
      path: '/dashboard_warehouse',
      name: 'dashboard_warehouse',
      pageBuilder: (context, state) => SmoothPageTransitions.fadeScale(
        key: state.pageKey,
        name: state.name,
        child: DashboardWarehouseView(),
      ),
    ),
    GoRoute(
      path: '/dashboard_finance',
      name: 'dashboard_finance',
      pageBuilder: (context, state) => SmoothPageTransitions.fadeScale(
        key: state.pageKey,
        name: state.name,
        child: DashboardFinanceView(),
      ),
    ),
    GoRoute(
      path: '/summary',
      name: 'summary',
      pageBuilder: (context, state) => SmoothPageTransitions.slideHorizontal(
        key: state.pageKey,
        name: state.name,
        child: SummaryView(),
      ),
    ),
    GoRoute(
      path: '/add_unit',
      name: 'add_unit',
      pageBuilder: (context, state) => SmoothPageTransitions.slideHorizontal(
        key: state.pageKey,
        name: state.name,
        child: AddUnitView(),
      ),
    ),
    GoRoute(
      path: '/add_sales_order',
      name: 'add_sales_order',
      pageBuilder: (context, state) => SmoothPageTransitions.slideHorizontal(
        key: state.pageKey,
        name: state.name,
        child: AddSalesOrder(),
      ),
    ),
    GoRoute(
      path: '/add_product_order',
      name: 'add_product_order',
      pageBuilder: (context, state) => SmoothPageTransitions.slideHorizontal(
        key: state.pageKey,
        name: state.name,
        child: AddProductOrderView(),
      ),
    ),
    GoRoute(
      path: '/detail_product/:id',
      name: 'detail_product',
      pageBuilder: (context, state) => SmoothPageTransitions.slideHorizontal(
        key: state.pageKey,
        name: state.name,
        child: DetailProductView(id: state.pathParameters['id'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/detail_product_order/:id',
      name: 'detail_product_order',
      pageBuilder: (context, state) => SmoothPageTransitions.slideHorizontal(
        key: state.pageKey,
        name: state.name,
        child: DetailProductOrderView(id: state.pathParameters['id'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/detail_sales_order/:id',
      name: 'detail_sales_order',
      pageBuilder: (context, state) => SmoothPageTransitions.slideHorizontal(
        key: state.pageKey,
        name: state.name,
        child: DetailSalesOrderView(id: state.pathParameters['id'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/account_info',
      name: 'account_info',
      pageBuilder: (context, state) => SmoothPageTransitions.slideHorizontal(
        key: state.pageKey,
        name: state.name,
        child: const AccountInfoView(),
      ),
    ),
    GoRoute(
      path: '/notification',
      name: 'notification',
      pageBuilder: (context, state) => SmoothPageTransitions.slideHorizontal(
        key: state.pageKey,
        name: state.name,
        child: NotificationView(),
      ),
    ),
    GoRoute(
      path: '/inventory_alerts/:tabIndex',
      name: 'inventory_alerts',
      pageBuilder: (context, state) {
        final tabIndexStr = state.pathParameters['tabIndex'] ?? '0';
        final tabIndex = int.tryParse(tabIndexStr) ?? 0;
        return SmoothPageTransitions.slideHorizontal(
          key: state.pageKey,
          name: state.name,
          child: BlocProvider(
            create: (_) => sl<InventoryAlertsBloc>(),
            child: InventoryAlertsView(initialTabIndex: tabIndex),
          ),
        );
      },
    ),
    GoRoute(
      path: '/payment_success',
      name: 'payment_success',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return SmoothPageTransitions.modalSlideUp(
          key: state.pageKey,
          name: state.name,
          child: PaymentSuccessView(
            invoiceId: extra['invoiceId']?.toString() ?? '-',
            productName: extra['productName']?.toString() ?? 'Produk',
            quantity: extra['quantity'] as int? ?? 1,
            amount: extra['amount']?.toString() ?? '\$0',
            transactionDate: extra['transactionDate'] as DateTime? ?? DateTime.now(),
            paymentType: extra['paymentType']?.toString() ?? 'Warehouse Order',
            requestedBy: extra['requestedBy']?.toString(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/add_staff',
      name: 'add_staff',
      redirect: _loginGuard,
      pageBuilder: (context, state) => SmoothPageTransitions.slideHorizontal(
        key: state.pageKey,
        name: state.name,
        child: BlocProvider(
          create: (_) => AdminStaffCubit(repository: sl<AdminStaffRepository>()),
          child: const AddStaffView(),
        ),
      ),
    ),
  ],
);
