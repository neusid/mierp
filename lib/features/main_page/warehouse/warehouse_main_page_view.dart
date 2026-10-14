import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/features/dashboard/presentation/warehouse/dashboard_warehouse_view.dart';
import 'package:mierp_apps/features/main_page/warehouse/warehouse_graph_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/main_page/presentation/cubit/main_page_cubit.dart';
import 'package:mierp_apps/features/profile/presentation/profile_view.dart';
import 'package:mierp_apps/features/summary/presentation/summary_view.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/features/history/presentation/history_view.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_state.dart';

class WarehouseMainPageView extends StatelessWidget {
  const WarehouseMainPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
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
      body: BlocBuilder<MainPageCubit, int>(
        builder: (context, currentIndex) {
          return IndexedStack(
            index: currentIndex,
            children: [
              const DashboardWarehouseView(),
              SummaryView(onBack: () => context.read<MainPageCubit>().goToDashboard()),
              WarehouseGraphView(),
              HistoryView(onBack: () => context.read<MainPageCubit>().goToDashboard()),
              ProfileView(onBack: () => context.read<MainPageCubit>().goToDashboard()),
            ],
          );
        }
      ),
      bottomNavigationBar: BlocBuilder<MainPageCubit, int>(
        builder: (context, currentIndex) {
          return BottomAppBar(
            height: 70.w,
            padding: EdgeInsets.only(
                left: 12.w, right: 12.w, top: 12.w, bottom: 6.w),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  context,
                  label: "Dashboard",
                  index: 0,
                  currentIndex: currentIndex,
                  activeIcon: Icons.grid_view_rounded,
                  inactiveIcon: Icons.grid_view_outlined,
                ),
                _buildNavItem(
                  context,
                  iconPath: "assets/icons/search-normal.svg",
                  label: "Search",
                  index: 1,
                  currentIndex: currentIndex,
                ),
                _buildNavItem(
                  context,
                  iconPath: "assets/icons/graph.svg",
                  label: "Graph",
                  index: 2,
                  currentIndex: currentIndex,
                ),
                _buildNavItem(
                  context,
                  iconPath: "assets/icons/clock.svg",
                  label: "History",
                  index: 3,
                  currentIndex: currentIndex,
                ),
                _buildNavItem(
                  context,
                  iconPath: "assets/icons/user.svg",
                  label: "User",
                  index: 4,
                  currentIndex: currentIndex,
                ),
              ],
            ),
          );
        }
      ),
    ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    String? iconPath,
    IconData? activeIcon,
    IconData? inactiveIcon,
    required String label,
    required int index,
    required int currentIndex,
  }) {
    bool isActive = index == currentIndex;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.w),
        onTap: () {
          context.read<MainPageCubit>().changeIndex(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          clipBehavior: isActive ? Clip.hardEdge : Clip.none,
          width: isActive ? 114.w : 44.w,
          height: 40.w,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.premiumDarkGradient : null,
            color: isActive ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(100.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (activeIcon != null && inactiveIcon != null)
                Icon(
                  isActive ? activeIcon : inactiveIcon,
                  size: isActive ? 18.w : 22.w,
                  color: isActive ? Colors.white : AppColors.grayTitle,
                )
              else if (iconPath != null)
                SvgPicture.asset(
                  iconPath,
                  width: isActive ? 19.w : 22.w,
                  height: isActive ? 19.w : 22.w,
                  colorFilter: ColorFilter.mode(
                      isActive ? Colors.white : AppColors.grayTitle, BlendMode.srcIn),
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
                      style: GoogleFonts.poppins(
                          fontSize: 11.5.w,
                          height: 1.2,
                          fontWeight: AppFontWeight.medium,
                          color: Colors.white),
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



