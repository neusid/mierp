import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uicons/uicons.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/features/admin/data/repositories/admin_staff_repository.dart';
import 'package:mierp_apps/features/admin/presentation/cubit/admin_staff_cubit.dart';
import 'package:mierp_apps/features/admin/presentation/dashboard/admin_dashboard_view.dart';
import 'package:mierp_apps/features/admin/presentation/staff/staff_management_view.dart';
import 'package:mierp_apps/features/main_page/finance/finance_graph_view.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_state.dart';
import 'package:mierp_apps/features/profile/presentation/profile_view.dart';
import 'package:mierp_apps/features/summary/presentation/summary_view.dart';

class AdminMainPageView extends StatefulWidget {
  const AdminMainPageView({super.key});

  @override
  State<AdminMainPageView> createState() => _AdminMainPageViewState();
}

class _AdminMainPageViewState extends State<AdminMainPageView> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminStaffCubit(
        repository: sl<AdminStaffRepository>(),
      ),
      child: BlocListener<NotificationCubit, NotificationState>(
        listenWhen: (prev, curr) => curr.latestIncomingNotification != null,
        listener: (context, state) {
          final incoming = state.latestIncomingNotification;
          if (incoming != null) {
            context.read<NotificationCubit>().clearLatestIncoming();
            CustomTopSnackbar.show(
              context,
              incoming.message,
              title: incoming.title,
              isError: incoming.type == 'order_rejected',
              isWarning: incoming.type == 'new_sales_order' ||
                  incoming.type == 'new_product_order',
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.bgColor,
          body: IndexedStack(
            index: _currentIndex,
            children: [
              AdminDashboardView(onTabChange: _onTabTapped),
              StaffManagementView(onBack: () => _onTabTapped(0)),
              SummaryView(onBack: () => _onTabTapped(0)),
              FinanceGraphView(),
              ProfileView(onBack: () => _onTabTapped(0)),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            height: 70.w,
            padding: EdgeInsets.only(
                left: 12.w, right: 12.w, top: 12.w, bottom: 6.w),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, "Dashboard", UIcons.solidStraight.apps, UIcons.regularStraight.apps),
                _buildNavItem(1, "Staf", UIcons.solidStraight.users, UIcons.regularStraight.users),
                _buildNavItem(2, "Gudang", UIcons.solidStraight.box, UIcons.regularStraight.box),
                _buildNavItem(3, "Finansial", UIcons.solidStraight.pie, UIcons.regularStraight.pie),
                _buildNavItem(4, "Profil", UIcons.solidStraight.user, UIcons.regularStraight.user),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData activeIcon, IconData inactiveIcon) {
    final isActive = _currentIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: () => _onTabTapped(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          clipBehavior: isActive ? Clip.hardEdge : Clip.none,
          width: isActive ? 110.w : 44.w,
          height: 40.w,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.premiumDarkGradient : null,
            color: isActive ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isActive ? activeIcon : inactiveIcon,
                size: isActive ? 18.w : 22.w,
                color: isActive ? Colors.white : AppColors.grayTitle,
              ),
              if (isActive) ...[
                SizedBox(width: 5.w),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: GoogleFonts.inter(
                        fontSize: 12.w,
                        fontWeight: AppFontWeight.semiBold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
