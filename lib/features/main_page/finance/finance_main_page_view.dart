import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uicons/uicons.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/features/dashboard/presentation/finance/dashboard_finance_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/main_page/presentation/cubit/main_page_cubit.dart';
import 'package:mierp_apps/features/profile/presentation/profile_view.dart';
import 'package:mierp_apps/features/summary/presentation/summary_view.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/features/history/presentation/history_view.dart';
import 'package:mierp_apps/features/main_page/finance/finance_graph_view.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:mierp_apps/features/notification/presentation/cubit/notification_state.dart';

class FinanceMainPageView extends StatelessWidget {
  const FinanceMainPageView({super.key});

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
              const DashboardFinanceView(),
              SummaryView(onBack: () => context.read<MainPageCubit>().goToDashboard()),
              const FinanceGraphView(),
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
                  activeIcon: UIcons.solidRounded.apps,
                  inactiveIcon: UIcons.regularRounded.apps,
                ),
                _buildNavItem(
                  context,
                  label: "Approvals",
                  index: 1,
                  currentIndex: currentIndex,
                  activeIcon: UIcons.solidRounded.list_check,
                  inactiveIcon: UIcons.regularRounded.list_check,
                ),
                _buildNavItem(
                  context,
                  label: "Analytics",
                  index: 2,
                  currentIndex: currentIndex,
                  activeIcon: UIcons.solidRounded.pie,
                  inactiveIcon: UIcons.regularRounded.pie,
                ),
                _buildNavItem(
                  context,
                  label: "History",
                  index: 3,
                  currentIndex: currentIndex,
                  activeIcon: UIcons.solidRounded.time_past,
                  inactiveIcon: UIcons.regularRounded.time_past,
                ),
                _buildNavItem(
                  context,
                  label: "User",
                  index: 4,
                  currentIndex: currentIndex,
                  activeIcon: UIcons.solidRounded.user,
                  inactiveIcon: UIcons.regularRounded.user,
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
          width: isActive ? 116.w : 42.w,
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
                _buildNavIcon(iconPath, isActive),
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

  Widget _buildNavIcon(String iconPath, bool isActive) {
    final size = isActive ? 19.w : 22.w;
    final colorFilter = ColorFilter.mode(
      isActive ? Colors.white : AppColors.grayTitle,
      BlendMode.srcIn,
    );

    if (iconPath.contains("task-square")) {
      const taskSquareSvg = '''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9 22H15C20 22 22 20 22 15V9C22 4 20 2 15 2H9C4 2 2 4 2 9V15C2 20 4 22 9 22Z" stroke="#484C52" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M7.75 12L10.58 14.83L16.25 9.17" stroke="#484C52" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';
      return SvgPicture.string(
        taskSquareSvg,
        width: size,
        height: size,
        colorFilter: colorFilter,
      );
    }

    return SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      colorFilter: colorFilter,
    );
  }
}
