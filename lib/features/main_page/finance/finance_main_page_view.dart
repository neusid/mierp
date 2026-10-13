import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/features/dashboard/presentation/finance/dashboard_finance_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/features/main_page/presentation/cubit/main_page_cubit.dart';
import 'package:mierp_apps/features/profile/presentation/profile_view.dart';
import 'package:mierp_apps/features/summary/presentation/summary_view.dart';
import 'package:mierp_apps/features/history/presentation/history_view.dart';
import 'package:mierp_apps/features/main_page/finance/finance_graph_view.dart';

class FinanceMainPageView extends StatelessWidget {
  const FinanceMainPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                _buildNavItem(context, "assets/icons/home-2.svg", "Home", 0, currentIndex),
                _buildNavItem(context, "assets/icons/task-square.svg", "Approvals", 1, currentIndex),
                _buildNavItem(context, "assets/icons/graph.svg", "Analytics", 2, currentIndex),
                _buildNavItem(context, "assets/icons/clock.svg", "History", 3, currentIndex),
                _buildNavItem(context, "assets/icons/user.svg", "User", 4, currentIndex),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String iconPath, String label, int index, int currentIndex) {
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
