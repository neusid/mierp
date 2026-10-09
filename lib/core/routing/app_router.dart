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

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

String? _loginGuard(BuildContext context, GoRouterState state) {
  final auth = sl<AuthBloc>();
  if (auth.state is! AuthAuthenticated) {
    return '/login';
  }
  return null;
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => OnboardingView(),
    ),
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<SplashBloc>(),
        child: const SplashView(),
      ),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<LoginBloc>(),
        child: const LoginView(),
      ),
    ),
    GoRoute(
      path: '/loading',
      name: 'loading',
      builder: (context, state) => const LoadingView(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<RegisterBloc>(),
        child: const RegisterView(),
      ),
    ),
    GoRoute(
      path: '/forgot',
      name: 'forgot',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ForgotPasswordBloc>(),
        child: const ForgotPasswordView(),
      ),
    ),
    GoRoute(
      path: '/finance_main_page',
      name: 'finance_main_page',
      redirect: _loginGuard,
      builder: (context, state) => BlocProvider(
        create: (_) => MainPageCubit(),
        child: const FinanceMainPageView(),
      ),
    ),
    GoRoute(
      path: '/warehouse_main_page',
      name: 'warehouse_main_page',
      redirect: _loginGuard,
      builder: (context, state) => BlocProvider(
        create: (_) => MainPageCubit(),
        child: const WarehouseMainPageView(),
      ),
    ),
    GoRoute(
      path: '/dashboard_warehouse',
      name: 'dashboard_warehouse',
      builder: (context, state) => DashboardWarehouseView(),
    ),
    GoRoute(
      path: '/dashboard_finance',
      name: 'dashboard_finance',
      builder: (context, state) => DashboardFinanceView(),
    ),
    GoRoute(
      path: '/summary',
      name: 'summary',
      builder: (context, state) => SummaryView(),
    ),
    GoRoute(
      path: '/add_unit',
      name: 'add_unit',
      builder: (context, state) => AddUnitView(),
    ),
    GoRoute(
      path: '/add_sales_order',
      name: 'add_sales_order',
      builder: (context, state) => AddSalesOrder(),
    ),
    GoRoute(
      path: '/add_product_order',
      name: 'add_product_order',
      builder: (context, state) => AddProductOrderView(),
    ),
    GoRoute(
      path: '/detail_product/:id',
      name: 'detail_product',
      builder: (context, state) => DetailProductView(id: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/detail_product_order/:id',
      name: 'detail_product_order',
      builder: (context, state) => DetailProductOrderView(id: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/detail_sales_order/:id',
      name: 'detail_sales_order',
      builder: (context, state) => DetailSalesOrderView(id: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/account_info',
      name: 'account_info',
      builder: (context, state) => const AccountInfoView(),
    ),
    GoRoute(
      path: '/notification',
      name: 'notification',
      builder: (context, state) => NotificationView(),
    ),
    GoRoute(
      path: '/inventory_alerts/:tabIndex',
      name: 'inventory_alerts',
      builder: (context, state) {
        final tabIndexStr = state.pathParameters['tabIndex'] ?? '0';
        final tabIndex = int.tryParse(tabIndexStr) ?? 0;
        return BlocProvider(
          create: (_) => sl<InventoryAlertsBloc>(),
          child: InventoryAlertsView(initialTabIndex: tabIndex),
        );
      },
    ),
  ],
);
